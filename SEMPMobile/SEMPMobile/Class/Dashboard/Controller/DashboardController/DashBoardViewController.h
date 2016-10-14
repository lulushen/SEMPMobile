//
//  DashBoardViewController.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/15.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "RootViewController.h"
#import "userModel.h"
#import "DashBoardModel.h"



@interface DashBoardViewController : RootViewController
// 指标model的数组
@property (nonatomic , strong) NSMutableArray * DashModelArray;

@end
