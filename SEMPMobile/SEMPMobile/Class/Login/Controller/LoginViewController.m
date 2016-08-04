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

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login.png"]];
    [self  makeButton];
}
// 创建登录按钮控件的方法
- (void)makeButton{
    
    // 用户登录按钮
    self.userButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    self.userButton.frame = CGRectMake(Main_Screen_Width/2-100*KWidth6scale, Main_Screen_Height/2-70*KHeight6scale, 200*KWidth6scale, 40*KHeight6scale);
//    self.userButton.backgroundColor = [UIColor whiteColor];
    [self.userButton addTarget:self action:@selector(userButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.userButton];
    
    // 游客登录按钮
    self.demoButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    self.demoButton.frame = CGRectMake(CGRectGetMinX(self.userButton.frame), CGRectGetMaxY(self.userButton.frame)+50*KHeight6scale, CGRectGetWidth(self.userButton.frame), CGRectGetHeight(self.userButton.frame));
//    self.demoButton.backgroundColor = [UIColor whiteColor];
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
    
    TabBarControllerConfig *tabBarConfig = [[TabBarControllerConfig alloc]init];
    
    [self presentViewController:tabBarConfig.tabBarController animated:YES completion:nil];
    
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
