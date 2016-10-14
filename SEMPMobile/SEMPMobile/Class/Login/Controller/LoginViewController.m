//
//  LoginViewController.m
//  DatacvgProject
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarControllerConfig.h"
#import "SDUserLoginViewController.h"

@interface LoginViewController ()
{
    UIImageView * imageView;
}
@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    imageView.image = [UIImage imageNamed:@"login"];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    [self  makeButton];
}
// 创建登录按钮控件的方法
- (void)makeButton{
    
    // 用户登录按钮
    self.userButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    self.userButton.frame = CGRectMake(Main_Screen_Width/2-100*KWidth6scale, Main_Screen_Height/2-70*KHeight6scale, 200*KWidth6scale, 40*KHeight6scale);
    [self.userButton addTarget:self action:@selector(userButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:self.userButton];
    
    // 游客登录按钮
    self.demoButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    self.demoButton.frame = CGRectMake(CGRectGetMinX(self.userButton.frame), CGRectGetMaxY(self.userButton.frame)+50*KHeight6scale, CGRectGetWidth(self.userButton.frame), CGRectGetHeight(self.userButton.frame));
    [self.demoButton addTarget:self action:@selector(demoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:self.demoButton];
    
}
/**
 *  用户登录实现方法
 */
- (void)userButtonClick:(UIButton *)button
{
    
    SDUserLoginViewController * UserLoginView = [[SDUserLoginViewController alloc] init];
    
    [self presentViewController:UserLoginView animated:YES completion:nil];
    
}
/**
 *   游客用户登录实现方法
 */
- (void)demoButtonClick:(UIButton *)button
{
    
    [self LoginSucceed];
    
}
/**
 *  登录成功后跳转页面的方法
 */
- (void)LoginSucceed{
    
    TabBarControllerConfig *tabBarConfig = [[TabBarControllerConfig alloc]init];
    
    [self presentViewController:tabBarConfig.tabBarController animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.view removeFromSuperview];
}
-(void)dealloc
{
    NSLog(@"loginDealloc");
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
