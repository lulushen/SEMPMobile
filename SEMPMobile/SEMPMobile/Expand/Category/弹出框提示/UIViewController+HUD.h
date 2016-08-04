//
//  UIViewController+HUD.h
//  SYCRealEstatePlatform
//
//  Created by 王子通 on 16/3/27.
//  Copyright © 2016年 WZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHudInView:(UIView *)view showHint:(NSString *)hint;

/**
 *  带文字的菊花
 */
- (void)ShowIndeterminateModeWithLabel;
/**
 *  隐藏带文字的菊花
 */
- (void)hideIndeterminateModeLabel;


@end
