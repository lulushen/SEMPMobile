//
//  UIView+HUD.h
//  SYCRealEstatePlatform
//
//  Created by 王子通 on 16/3/27.
//  Copyright © 2016年 WZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;
@end
