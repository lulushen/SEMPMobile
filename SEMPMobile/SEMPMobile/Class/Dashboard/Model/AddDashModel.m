//
//  AddDashModel.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AddDashModel.h"

@implementation AddDashModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.AddId = value;
    }
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_AddId forKey:@"AddId"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_type forKey:@"type"];
    
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        _AddId = [aDecoder decodeObjectForKey:@"AddId"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _type = [aDecoder decodeObjectForKey:@"type"];
        
    }
    
    
    return self;
}

@end
