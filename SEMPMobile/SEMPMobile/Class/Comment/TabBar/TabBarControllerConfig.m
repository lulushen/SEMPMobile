//
//  TabBarControllerConfig.m
//  TabberTest
//
//  Created by 王子通 on 16/3/23.
//  Copyright © 2016年 WZT. All rights reserved.
//

#import "TabBarControllerConfig.h"
#import <UIKit/UIKit.h>

CGFloat const ZTCellMargin = 44.0;

@interface TabBarControllerConfig()

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation TabBarControllerConfig

/**
 *  懒加载 tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController
{
    if (_tabBarController == nil) {
        NSArray *vcNameArray = @[@"DashBoardViewController",@"AttractionViewController",@"ShoppingCentreViewController",@"SDAccountViewController"];
        NSMutableArray *navArray =[NSMutableArray arrayWithCapacity:0];
        for (NSString *vcName in vcNameArray) {
            [navArray addObject:[self produceNavControllerWithClassName:vcName]];
        }
        //配置属性
        
        CYLTabBarController *tabBarController = [[CYLTabBarController alloc]init];
        [self customizeTabBarForController:tabBarController];
        
        [tabBarController setViewControllers:navArray];
        
        // 更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
  //#warning IF YOU NEED CUSTOMIZE TABBAR APPEARANCE, REMOVE THE COMMENT '//'
        //  [[self class] customizeTabBarAppearance:tabBarController];
        
        _tabBarController = tabBarController;
    }
    
    return _tabBarController;
}

- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController
{
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"",
                            CYLTabBarItemImage : @"dash_normal",
                            CYLTabBarItemSelectedImage : @"dash_highlight",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"",
                            CYLTabBarItemImage : @"report_normal",
                            CYLTabBarItemSelectedImage : @"report_highlight",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"",
                            CYLTabBarItemImage : @"action_normal",
                            CYLTabBarItemSelectedImage : @"action_highlight",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"",
                            CYLTabBarItemImage : @"account_normal",
                            CYLTabBarItemSelectedImage : @"account_highlight",
                            };
    NSArray *tabBarItemsAttributes = @[ dict1, dict2, dict3, dict4 ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;

}

- (UINavigationController *)produceNavControllerWithClassName:(NSString *)className
{
    Class someClass = NSClassFromString(className);
    id obj = [[someClass alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:obj];
    
    return nav;
}
#pragma mark - 更多TabBar自定义设置
/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
+ (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    NSUInteger allItemsInTabBarCount = [CYLTabBarController allItemsInTabBarCount];
    [[UITabBar appearance] setSelectionIndicatorImage:[self imageFromColor:[UIColor yellowColor] forSize:CGSizeMake([UIScreen mainScreen].bounds.size.width / allItemsInTabBarCount, 49.f) withCornerRadius:15]];
    
    // set the bar background color
    // 设置背景图片
    // UITabBar *tabBarAppearance = [UITabBar appearance];
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background_ios7"]];
}

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    return image;
}

@end
