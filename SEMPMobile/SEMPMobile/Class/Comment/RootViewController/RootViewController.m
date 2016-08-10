//
//  RootViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "RootViewController.h"
#import "RealReachability.h"
#import "UIViewController+HUD.h"

@interface RootViewController ()

@end

@interface RootViewController ()
{
    int _originY;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 设置导航栏的颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:38/255 green:38/255 blue:39/255 alpha:1];
    // 设置半透明状态（yes） 不透明状态 （no）
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    // 设置导航栏上面字体的颜色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    _originY = Main_Screen_Height - BottomBarHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加网络监测通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kRealReachabilityChangedNotification object:nil];
    // ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 网络改变 处理事件
- (void)networkChanged:(NSNotification *)notification
{
    NSLog(@"hehe");
    RealReachability *reachability =(RealReachability *) notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged: currentStatus:%@, previouStatus:%@",@(status),@(previousStatus));
    if (status == RealStatusNotReachable) {
        [self showHudInView:self.view showHint:@"断网了,请检查网络"];
    }
    if (status == RealStatusViaWiFi) {
        [self showHudInView:self.view showHint:@"切换到了WIFI"];
    }
    if (status == RealStatusViaWWAN) {
        [self showHudInView:self.view showHint:@"切换到了局域网"];
    }
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    if (status == RealStatusViaWWAN) {
        if (accessType == WWANType2G) {
            NSLog(@"2G网络");
        }else if (accessType == WWANType3G){
            NSLog(@"3G网络");
        }else if (accessType == WWANType4G){
            NSLog(@"4G网络");
        }else{
            NSLog(@"IOS6 无法识别");
        }
    }
    
}

#pragma mark - 显示TabBar
- (void)showTabBar {
    
    if (_originY == fabs(self.tabBarController.tabBar.frame.origin.y)){
        
        NSLog(@"不需要再显示");
        return ;
    }
    NSLog(@"走了 显示的代码");
    for (UIView *v in [self.tabBarController.view subviews]) {
        NSLog(@"--sub  class--:%@",NSStringFromClass([v class]));
        if ([v isKindOfClass:[UITabBar class]]) {
            [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                
                CGRect frame = v.frame;
                frame.origin.y -= 49.0f;
                v.frame = frame;
            } completion:nil];
        }
        else {
            
            [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                CGRect frame = v.frame;
                frame.size.height -= 49.0f;
                v.frame = frame;
            } completion:nil];
        }
    }
    NSLog(@"--current H hsow--:%f",self.view.frame.size.height);
    return;
}

#pragma mark - 隐藏TabbBar
- (void)hideTabbar {
    
    //    if (_originY + BottomBarHeight == fabs(self.tabBarController.tabBar.frame.origin.y)) {
    //        NSLog(@"不需要再隐藏");
    //        return ;
    //    }
    
    
    NSLog(@"走了 隐藏的代码");
    for (UIView *v in [self.tabBarController.view subviews]) {
        if ([v isKindOfClass:[UITabBar class]]) {
            [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                
                CGRect frame = v.frame;
                frame.origin.y += 49.0f;
                v.frame = frame;
                NSLog(@"tabBar originY: %f", frame.origin.y);
            } completion:nil];
        }
        else {
            [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                
                CGRect frame = v.frame;
                frame.size.height += 49.0f;
                v.frame = frame;
                
            } completion:nil];
        }
    }
    NSLog(@"--current H hide--:%f",self.view.frame.size.height);
    return;
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