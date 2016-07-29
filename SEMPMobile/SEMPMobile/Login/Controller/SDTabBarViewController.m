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
    // 设置tabbar 选中时背景色
    [[UITabBar appearance] setTintColor:[UIColor orangeColor]];
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];

    // 调用设置tabbar方法
    [self makeTabBar];
    // Do any additional setup after loading the view.
}

- (void)makeTabBar{
    
    // 指标
    SDDashboardViewController * DashboardView = [[SDDashboardViewController alloc] init];
    UINavigationController * DashNC = [[UINavigationController alloc] initWithRootViewController:DashboardView];

   
    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    DashNC.navigationBar.titleTextAttributes = dict;
   
    // 设置导航栏的颜色
    DashboardView.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    // 设置半透明状态（yes） 不透明状态 （no）
    DashboardView.navigationController.navigationBar.translucent = NO;
    
    DashboardView.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    // 设置导航栏上面字体的颜色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    DashboardView.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"指标" image:[UIImage imageNamed:@"iconfont-biji.png"] tag:100];
    // 设置消息数量
    DashboardView.tabBarItem.badgeValue = @"10";
    
    // 报表
    SDReportViewController * ReportView = [[SDReportViewController alloc] init];
    UINavigationController * ReportNC = [[UINavigationController alloc] initWithRootViewController:ReportView];
    ReportView.navigationItem.title = @"Report Center";
    ReportNC.navigationBar.titleTextAttributes = dict;
//    [ReportView.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    ReportView.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    ReportView.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    ReportView.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"报表" image:[UIImage imageNamed:@"iconfont-biji.png"] tag:101];
    
    // 行动
    SDActionViewController * ActionView= [[SDActionViewController alloc] init];
    UINavigationController * ActionNC = [[UINavigationController alloc] initWithRootViewController:ActionView];
    ActionView.navigationItem.title = @"Action";
    ActionNC.navigationBar.titleTextAttributes = dict;
    ActionView.navigationController.navigationBar.translucent = NO;

//    [ActionView.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    ActionView.navigationController.navigationBar.barTintColor = [UIColor orangeColor];

    ActionView.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"行动" image:[UIImage imageNamed:@"iconfont-biji.png"] tag:102];
    
    // 用户
    SDAccountViewController * AccountView = [[SDAccountViewController alloc] init];
    UINavigationController * AccountNC = [[UINavigationController alloc] initWithRootViewController:AccountView];
    AccountView.navigationItem.title = @"Account";
    AccountNC.navigationBar.titleTextAttributes = dict;
//    [AccountView.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    AccountView.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    AccountView.navigationController.navigationBar.translucent = NO;

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
