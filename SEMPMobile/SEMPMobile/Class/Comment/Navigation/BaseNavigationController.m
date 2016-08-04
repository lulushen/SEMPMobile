//
//  BaseNavigationController.m
//  TabberTest
//
//  Created by 王子通 on 16/3/24.
//  Copyright © 2016年 WZT. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.navigationBar.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//全透明，一般在viewWillAppear
+ (void)createCompletelyTransparentNavigationBar:(UIViewController *)sender
{
    [sender.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                    forBarMetrics:UIBarMetricsDefault];
    sender.navigationController.navigationBar.shadowImage = [UIImage new];
    sender.navigationController.navigationBar.translucent = YES;
    sender.navigationController.view.backgroundColor = [UIColor clearColor];
    sender.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

//恢复成默认，一般在viewWillDisappear
+ (void)createDefaultNavigationBar:(UIViewController *)sender
{
    [sender.navigationController.navigationBar setBackgroundImage:nil
                                                    forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 自定义导航栏按钮 返回按钮 或者其他按钮
- (void)createCustomNavigationBackOrOtherButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 32, 32);
    [backBtn addTarget:self action:@selector(navCustomBackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"fanhuijiantou"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBackCustomImg"] style:UIBarButtonItemStyleBordered target:self action:@selector(navCustomBackButtonPressed)];
    //解决自定义了leftBarbuttonItem左滑返回手势失效了的问题
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)navCustomBackButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
