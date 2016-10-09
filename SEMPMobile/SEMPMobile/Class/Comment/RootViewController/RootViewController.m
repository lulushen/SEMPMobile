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

@interface RootViewController ()<YXCustomActionSheetDelegate>


@end

@interface RootViewController ()
{
    int _originY;
    UIImage * shareImage;
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
    self.navigationController.navigationBar.barTintColor = NavigationColor;
    // 设置半透明状态（yes） 不透明状态 （no）
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    // 设置导航栏上面字体的颜色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    _originY = Main_Screen_Height - BottomBarHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //添加网络监测通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kRealReachabilityChangedNotification object:nil];
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
    RealReachability *reachability =(RealReachability *) notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
//    NSLog(@"networkChanged: currentStatus:%@, previouStatus:%@",@(status),@(previousStatus));
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
    for (UIView *v in [self.tabBarController.view subviews]) {
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
static int ScreenshotIndex = 0;

-(void)ScreenShot{
    
    //这里因为我需要全屏接图所以直接改了，宏定义iPadWithd为1024，iPadHeight为768，
    //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);     //设置截屏大小
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(Main_Screen_Width, KViewHeight), YES, 0);     //设置截屏大小
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    //    CGRect rect = CGRectMake(166, 211, 426, 320);//这里可以设置想要截图的区域
    CGRect rect = CGRectMake(0, NavgationHeight, Main_Screen_Height * 2, (Main_Screen_Height)*2);
    //这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    shareImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    //    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    
    NSData *imageViewData = UIImagePNGRepresentation(shareImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= [NSString stringWithFormat:@"screenShow_%d.png",ScreenshotIndex];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    NSLog(@"截屏路径打印: %@", savedImagePath);
    //这里我将路径设置为一个全局String，这里做的不好，我自己是为了用而已，希望大家别这么写
//    [self SetPickPath:savedImagePath];
    
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    CGImageRelease(imageRefRect);
    ScreenshotIndex++;
    
    
    for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray) {
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        NSLog(@"--%@",snsPlatform.displayName);
    }
    YXCustomActionSheet *cusSheet = [[YXCustomActionSheet alloc] init];
    cusSheet.delegate = self;
    NSArray *contentArray = @[@{@"name":@"微信",@"icon":@"wechat.png"},
                              @{@"name":@"QQ",@"icon":@"qq.png"},
                              @{@"name":@"短信",@"icon":@"message.png"},
                              @{@"name":@"邮箱",@"icon":@"email.png"},
                              //                              @{@"name":@"朋友圈",@"icon":@"sns_icon_8"},
                              //                              @{@"name":@"QQ ",@"icon":@"sns_icon_4"},
                              //                              @{@"name":@"微信",@"icon":@"sns_icon_7"},
                              ];
    
    [cusSheet showInView:[UIApplication sharedApplication].keyWindow contentArray:contentArray];
    

    
}
#pragma mark - YXCustomActionSheetDelegate

- (void) customActionSheetButtonClick:(YXActionSheetButton *)btn
{
    
    NSLog(@"第%li个按钮被点击了",(long)btn.tag);
    NSString * shareType ;
    if (btn.tag == 0) {
        
        shareType = UMShareToWechatSession;
    }else if (btn.tag == 1) {
        
        shareType = UMShareToQQ;
    }else if (btn.tag == 2) {
        
        shareType = UMShareToSms;
    }else if (btn.tag == 3) {
        
        shareType = UMShareToEmail;
    }
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareType] content:@"qw" image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
            
            [MBProgressHUD showSuccess:@"分享成功"];
        }else{
            [MBProgressHUD showSuccess:@"分享失败"];
            
        }
    }];
    
    
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
