//
//  SDTabBarViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDTabBarViewController.h"
#import "SDDashboardViewController.h"
#import "SDReportViewController.h"
#import "SDActionViewController.h"
#import "SDAccountViewController.h"

@interface SDTabBarViewController ()

@end

@implementation SDTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    // 调用设置tabbar方法
    [self makeTabBar];
    // Do any additional setup after loading the view.
}

- (void)makeTabBar{
    
    // 指标
    SDDashboardViewController * DashboardView = [[SDDashboardViewController alloc] init];
    UINavigationController * DashNC = [[UINavigationController alloc] initWithRootViewController:DashboardView];
//    DashboardView.navigationItem.title = @"Dashboard";
//    DashboardView.navigationItem.titleView;
    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    DashNC.navigationBar.titleTextAttributes = dict;
//    [DashboardView.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    DashboardView.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    DashboardView.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"指标" image:[UIImage imageNamed:@"iconfont-biji.png"] tag:100];
    DashboardView.tabBarItem.badgeValue = @"10";
    
    // 报表
    SDReportViewController * ReportView = [[SDReportViewController alloc] init];
    UINavigationController * ReportNC = [[UINavigationController alloc] initWithRootViewController:ReportView];
    ReportView.navigationItem.title = @"Report Center";
    ReportNC.navigationBar.titleTextAttributes = dict;
    [ReportView.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    ReportView.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"报表" image:[UIImage imageNamed:@"iconfont-biji.png"] tag:101];
    
    // 行动
    SDActionViewController * ActionView= [[SDActionViewController alloc] init];
    UINavigationController * ActionNC = [[UINavigationController alloc] initWithRootViewController:ActionView];
    ActionView.navigationItem.title = @"Action";
    ActionNC.navigationBar.titleTextAttributes = dict;
    [ActionView.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    ActionView.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"行动" image:[UIImage imageNamed:@"iconfont-biji.png"] tag:102];
    
    // 用户
    SDAccountViewController * AccountView = [[SDAccountViewController alloc] init];
    UINavigationController * AccountNC = [[UINavigationController alloc] initWithRootViewController:AccountView];
    AccountView.navigationItem.title = @"Account";
    AccountNC.navigationBar.titleTextAttributes = dict;
    [AccountView.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    AccountView.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"个人" image:[UIImage imageNamed:@"iconfont-biji.png"] tag:103];
    
    
    self.viewControllers = @[DashNC,ReportNC,ActionNC,AccountNC];
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
