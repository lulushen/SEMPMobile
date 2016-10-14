//
//  AddViewController.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "RootViewController.h"

@interface AddViewController : RootViewController
//我的指标数组
@property (nonatomic , strong)NSMutableArray * dashLabelArray;
//推荐指标数组
@property (nonatomic , strong)NSMutableArray * dashAllArray;
// 指标界面进入添加界面时的指标数组，为了比较在添加界面的指标数组是否发生变化
@property (nonatomic , strong)NSMutableArray * firstDashArray;

@end
