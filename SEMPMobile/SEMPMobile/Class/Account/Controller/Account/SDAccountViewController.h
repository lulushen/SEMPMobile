//
//  SDAccountViewController.h
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "RootViewController.h"
#import "Singleton.h"
@interface SDAccountViewController : RootViewController
// 用户名
@property (nonatomic , strong) UILabel * userLabel;
// 职位
@property (nonatomic , strong) UILabel * orgLabel;

@end
