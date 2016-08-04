//
//  BaseNavigationController.h
//  TabberTest
//
//  Created by 王子通 on 16/3/24.
//  Copyright © 2016年 WZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

+ (void)createCompletelyTransparentNavigationBar:(UIViewController *)sender;
/**
 *  自定义导航栏按钮 返回按钮 或者其他按钮
 */
- (void)createCustomNavigationBackOrOtherButton;
@end
