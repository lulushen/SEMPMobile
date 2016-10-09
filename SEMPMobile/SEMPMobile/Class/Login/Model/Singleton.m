//
//  Singleton.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/29.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+(instancetype)shareSingleHandle
{
    
    static dispatch_once_t onecToken;
    
    static Singleton * single = nil;
    
    dispatch_once(&onecToken, ^{
        
        single = [[Singleton alloc] init];
    });
    
    return single;
    
}
-(instancetype)init
{
    
    if (self = [super init]) {
        self.itemArray = [NSMutableArray array];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
