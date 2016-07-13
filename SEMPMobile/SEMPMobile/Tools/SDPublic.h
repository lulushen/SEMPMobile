//
//  SDPublic.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/13.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDPublic : NSObject
//导航栏的frame
@property (nonatomic , assign) NSNumber* rectStatus;

+ (id) sharedInstance; 
@end
