//
//  DefaultD_resModel.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/24.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DefaultD_resModel.h"

@implementation DefaultD_resModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_d_res_parentid forKey:@"d_res_parentid"];
    [aCoder encodeObject:_d_res_id forKey:@"d_res_id"];
    [aCoder encodeObject:_d_res_rootid forKey:@"d_res_rootid"];
    [aCoder encodeObject:_d_res_pkid forKey:@"d_res_pkid"];
    [aCoder encodeObject:_d_res_flname forKey:@"d_res_flname"];
    [aCoder encodeObject:_d_res_clname forKey:@"d_res_clname"];
    [aCoder encodeObject:_user forKey:@"user"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        _d_res_parentid = [aDecoder decodeObjectForKey:@"d_res_parentid"];
        _d_res_id = [aDecoder decodeObjectForKey:@"d_res_id"];
        _d_res_rootid = [aDecoder decodeObjectForKey:@"d_res_rootid"];
        _d_res_pkid = [aDecoder decodeObjectForKey:@"d_res_pkid"];
        _d_res_flname = [aDecoder decodeObjectForKey:@"d_res_flname"];
        _d_res_clname = [aDecoder decodeObjectForKey:@"d_res_clname"];
        _user = [aDecoder decodeObjectForKey:@"user"];

    }
    return self;
}


@end