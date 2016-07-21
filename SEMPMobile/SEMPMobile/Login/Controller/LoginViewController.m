//
//  LoginViewController.m
//  DatacvgProject
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "LoginViewController.h"
#import "SDTabBarViewController.h"
#import "SDUserLoginViewController.h"




@interface LoginViewController ()

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults * currentUser = [NSUserDefaults standardUserDefaults];
    NSString * islogin = [currentUser objectForKey:@"LoginSuc"];
    NSLog(@"-==-=-=-=-=-=-=-=-=-kkkokoko:%@",islogin);
    if ([islogin isEqualToString:@"SUC-1001"]) {
        [self LoginSucceed];

    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userLogin.png"]];
    [self  makeButton];
    NSLog(@"------width:%f",Kwidth);
    NSLog(@"-------height:%f",Kheight);
    NSLog(@"-------bili:%f",KWidth6scale);
    NSLog(@"-------bili:%f",KHeight6scale);

    // Do any additional setup after loading the view.
}
// 创建登录按钮控件的方法
- (void)makeButton{
    
    // 用户登录按钮
    self.userButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    self.userButton.frame = CGRectMake(Kwidth/2-50*KWidth6scale, Kheight/2-100*KHeight6scale, 100*KWidth6scale, 100*KHeight6scale);
    self.userButton.backgroundColor = [UIColor whiteColor];
    [self.userButton addTarget:self action:@selector(userButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.userButton];
    
    // 游客登录按钮
    self.demoButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    self.demoButton.frame = CGRectMake(CGRectGetMinX(self.userButton.frame), CGRectGetMaxY(self.userButton.frame)+10*KHeight6scale, 100*KWidth6scale, 100*KHeight6scale);
    self.demoButton.backgroundColor = [UIColor whiteColor];
    [self.demoButton addTarget:self action:@selector(demoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.demoButton];
    
}
// 用户登录实现方法
- (void)userButtonClick:(UIButton *)button
{
    
    SDUserLoginViewController * UserLoginView = [[SDUserLoginViewController alloc] init];
    [self presentViewController:UserLoginView animated:YES completion:nil];
   
}
// 游客用户登录实现方法
- (void)demoButtonClick:(UIButton *)button
{
    
   
     [self LoginSucceed];
    
}
// 登录成功后跳转页面的方法
- (void)LoginSucceed{
    
    SDTabBarViewController * TabBarView = [[SDTabBarViewController alloc] init];
    
    [self presentViewController:TabBarView animated:YES completion:nil];
    
//    [self.navigationController pushViewController:TabBarView animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
