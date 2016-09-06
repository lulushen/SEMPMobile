//
//  ActionIncomeViewController.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "RootViewController.h"

@interface ActionIncomeViewController : RootViewController
//任务的id
@property (nonatomic, strong) NSString * taskIDString;
//任务状态
@property (nonatomic , strong) NSString * task_stateString;
//loginUser
@property (nonatomic , strong) NSString * loginUserString;
@property (nonatomic , strong) NSString * creat_userString;

@property (nonatomic , strong) NSString * titleString;
@end
