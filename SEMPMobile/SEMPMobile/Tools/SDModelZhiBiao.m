//
//  SDModelZhiBiao.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/28.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDModelZhiBiao.h"

@implementation SDModelZhiBiao

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.Did = value;
    }
}
@end
