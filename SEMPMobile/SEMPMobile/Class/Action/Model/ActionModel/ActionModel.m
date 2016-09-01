//
//  ActionModel.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/22.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionModel.h"

@implementation ActionModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    if ([key isEqualToString:@"id"]) {
//        
//       
//    }
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_task_state forKey:@"task_state"];
    [aCoder encodeObject:_task_priority forKey:@"task_priority"];
    
    [aCoder encodeObject:_create_time forKey:@"create_time"];
    [aCoder encodeObject:_task_id forKey:@"task_id"];
    [aCoder encodeObject:_task_deadline forKey:@"task_deadline"];
    [aCoder encodeObject:_task_type forKey:@"task_type"];
    [aCoder encodeObject:_task_title forKey:@"task_title"];
    [aCoder encodeObject:_create_user forKey:@"create_user"];
    [aCoder encodeObject:_loginUser forKey:@"loginUser"];
    [aCoder encodeObject:_responsible_person forKey:@"responsible_person"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        _create_time = [aDecoder decodeObjectForKey:@"create_time"];
        _task_state = [aDecoder decodeObjectForKey:@"task_state"];
        _task_priority= [aDecoder decodeObjectForKey:@"task_priority"];
        _task_id = [aDecoder decodeObjectForKey:@"task_id"];
        _task_deadline = [aDecoder decodeObjectForKey:@"task_deadline"];
        _task_type = [aDecoder decodeObjectForKey:@"task_type"];
        _task_title = [aDecoder decodeObjectForKey:@"task_title"];
        _create_user = [aDecoder decodeObjectForKey:@"create_user"];
        _loginUser = [aDecoder decodeObjectForKey:@"loginUser"];

        _responsible_person = [aDecoder decodeObjectForKey:@"responsible_person"];

    }
    
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
