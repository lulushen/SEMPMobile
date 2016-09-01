//
//  ActionModel.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/22.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionModel : NSObject

@property (nonatomic , copy) NSString *  task_state;
@property (nonatomic , copy) NSString * task_priority;
@property (nonatomic , copy) NSString * create_time;
@property (nonatomic , copy) NSString * task_id;
@property (nonatomic , copy) NSString * task_deadline;
@property (nonatomic , copy) NSString * task_type;
@property (nonatomic , copy) NSString * task_title;
@property (nonatomic , copy) NSString * create_user;
@property (nonatomic , copy) NSString * loginUser;
@property (nonatomic , copy) NSString * responsible_person;


@end
