//
//  DashBoardViewController.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "RootViewController.h"
#import "DashBoardModel.h"

@interface DashBoardViewController : RootViewController

@property (nonatomic , strong) UIScrollView * scrollview;

@property (nonatomic , strong) UIView * viewDash;

@property (nonatomic , strong) NSMutableArray * DashModelArray;

@property (nonatomic , strong) NSMutableArray * viewDashArray;

@property (nonatomic , strong) NSMutableArray *DashArray;

@property (nonatomic , strong) UIButton * moreButton;
@end
