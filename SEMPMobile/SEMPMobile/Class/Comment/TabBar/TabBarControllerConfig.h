//
//  TabBarControllerConfig.h
//  TabberTest
//
//  Created by 王子通 on 16/3/23.
//  Copyright © 2016年 WZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"

@interface TabBarControllerConfig : NSObject

@property(nonatomic, strong, readonly)CYLTabBarController *tabBarController;


/** cell 间距*/
UIKIT_EXTERN CGFloat const ZTCellMargin;
UIKIT_EXTERN NSString *const SAHD;
@end
