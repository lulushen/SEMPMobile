//
//  SDDashboardViewController.h
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CZFlowLayout.h"
#import "SDAddViewController.h"
#import "SDModelZhiBiao.h"



@interface SDDashboardViewController : UIViewController <ChuanzhiDelegate>
@property (nonatomic , strong) UIScrollView * scrollview;

@property (nonatomic , strong) UIView * viewmove;

@property (nonatomic , strong) NSMutableArray * arrayZhiBiao;

@property (nonatomic , strong) NSMutableArray * nowArray;

@property (nonatomic , strong) NSMutableArray * buttonArray;

@property (nonatomic , strong) NSMutableArray * wanzhengbuttonArray;

@property (nonatomic , strong) UIButton * moreButton;
@end
