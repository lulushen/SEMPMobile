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


//{
//    "commit_time" = "";
//    "create_user_name" = mobile;
//    "task_state" = 3;
//    "task_text" = "\U5173\U4e8e\U8fd9\U4e24\U4e2a\U6307\U6807\U7684\U6d4b\U8bd5";
//    "update_time" = "2016-08-22 14:42:17";
//    "update_user" = datacvg;
//    "update_user_name" = datacvg;
//}
@end
