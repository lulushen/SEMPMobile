//
//  InfoModel.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject


@property (nonatomic , strong)NSString *text;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *time;
@property (nonatomic , strong)NSString *send_user;
@property (nonatomic , strong)NSString *help_user;
@property (nonatomic , strong)NSString *create_user;
@property (nonatomic , strong)NSString *receive_user;
@property (nonatomic , strong)NSString *message_id;
@property (nonatomic , assign)Boolean readflag;

@end
