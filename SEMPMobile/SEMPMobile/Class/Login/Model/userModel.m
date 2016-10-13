//
//  userModel.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "userModel.h"

@implementation userModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_message forKey:@"message"];
    [aCoder encodeObject:_user_token forKey:@"user_token"];
    [aCoder encodeObject:_resdata forKey:@"resdata"];
    [aCoder encodeInteger:_status forKey:@"status"];
    
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        _message = [aDecoder decodeObjectForKey:@"message"];
        _user_token = [aDecoder decodeObjectForKey:@"user_token"];
        _resdata = [aDecoder decodeObjectForKey:@"resdata"];
        _status = [aDecoder decodeIntegerForKey:@"status"];
        
    }
    
    
    return self;
}
@end
