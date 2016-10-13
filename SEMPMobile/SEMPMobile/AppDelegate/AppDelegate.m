//
//  AppDelegate.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AppDelegate.h"
//#import "TabBarControllerConfig.h"
#import "LoginViewController.h"
#import <IQKeyboardManager.h>
#import "RealReachability.h"
#import <MLTransition.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
//#import "UMessage.h"
//#import "UserNotifications.h"
#import "CLLockVC.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AppDelegate ()
{
    UIViewController * LockVC;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //开启网络监测
    [GLobalRealReachability startNotifier];
    
    //监控键盘
    IQKeyboardManager * manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    manager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyWindow];
    
    //    TabBarControllerConfig *tabBarConfig = [[TabBarControllerConfig alloc]init];
    //
    //    self.window.rootViewController = tabBarConfig.tabBarController;
    // 设置根视图
    LoginViewController * LoginView = [[LoginViewController alloc] init];
    self.window.rootViewController = LoginView;
#pragma --share--------------
    // UM分享 57a94f6167e58ef44b0005f9
    //    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    //    [UMSocialData setAppKey:@"57a94f6167e58ef44b0005f9"];
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:@"57a94f6167e58ef44b0005f9"];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxdc1e388c3822c80b" appSecret:@"a393c1527aaccb95f3a4c88d6d1455f6" url:@"http://www.umeng.com/social"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //    //设置支持没有客户端情况下使用SSO授权
    //    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    //设置QQ分享纯图片，默认分享图文消息
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
    //设置微信好友分享纯图片
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;
    //设置微信朋友圈分享纯图片
    
    
    
    
    
    
    // Let the device know we want to receive push notifications  让设备知道我们要接收推送通知
    //    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
    //     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    // iOS8之后和之前应区别对待
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIUserNotificationTypeSound];
    }
    return YES;
}
/**
 设置系统回调使用
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}
/**
 *  当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反。
 *
 *   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
 */

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSString * lockTypeString = [[NSUserDefaults standardUserDefaults] valueForKey:@"SettingLockType"];
    if ([lockTypeString isEqualToString:@"PIN"]) {
        
        
    }else if ([lockTypeString isEqualToString:@"ShouShi"]){
        
        // 手势验证密码
        BOOL hasPwd = [CLLockVC hasPwd];
        
        if(!hasPwd){
            
            NSLog(@"你还没有设置密码，请先设置密码");
        }else {
            
            //获取当前屏幕中present出来的viewcontroller [self appRootViewController]
            [CLLockVC showVerifyLockVCInVC:[self appRootViewController] forgetPwdBlock:^{
                NSLog(@"忘记密码");
            } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                NSLog(@"密码正确");
                [lockVC dismiss:1.0f];
                
            }];
        }
        NSLog(@"123");
        
    }else if ([lockTypeString isEqualToString:@"ZhiWen"]){
        
        [self TouchIDPassWord];
        
    }else{
        
        
    }
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or notyet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//2个methods （用来handle register remote notification with device token和register error的events）
/**
 *  如果用户同意，苹果会根据应用的 bundleID 和 手机UDID 生成 deviceToken,然后调用 application 的 didregister 方法返回 devicetoken,程序应该把 devicetoken 发给应用的服务器,服务器有义务将其存储(如果允许多点登录,可能存多个 devicetoken)。deviceToken也是会变的： ”If the user restores backup data to a new device or computer, or reinstalls the operating system, the device token changes“，因此应每次都发给服务器(provider)
 
 */
// 用户同意后，会调用此程序，获取系统的deviceToken，应把deviceToken传给服务器保存，此函数会在程序每次启动时调用(前提是用户允许通知)
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken = %@",deviceToken);
    NSLog(@"My token is: %@", deviceToken);
    
}
// 注册失败调用
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"远程通知注册失败：%@",error);
}
/**
 *  这个函数存在的意义在于：当用户在设置中关闭了通知时，程序启动时会调用此函数，我们可以获取用户的设置
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

/**
 *  获取当前屏幕中present出来的viewcontroller。
 */
- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
/**
 获取当前屏幕显示的viewcontroller
 */
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
- (void)TouchIDPassWord{
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    //创建LAContext
    LAContext *context = [LAContext new];
    
    //这个属性是设置指纹输入失败之后的弹出框的选项
    context.localizedFallbackTitle = @"忘记密码";
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"支持指纹识别");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按home键指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"验证成功 刷新主界面");
            }else{
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
    }else{
        NSLog(@"不支持指纹识别");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}
@end
