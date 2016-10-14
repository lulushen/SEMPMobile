//
//  userModel.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userModel : NSObject

@property (nonatomic , copy) NSString * message;

@property (nonatomic , assign) NSInteger status;

@property (nonatomic , copy) NSString * user_token;

@property (nonatomic , copy) NSMutableDictionary * resdata;


@end
