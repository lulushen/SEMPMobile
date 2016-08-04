//
//  DashBoardModel.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DashBoardModel.h"

@implementation DashBoardModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.Did = value;
    }
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_Did forKey:@"Did"];
    [aCoder encodeObject:_unit forKey:@"unit"];
    [aCoder encodeObject:_color forKey:@"color"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_midval forKey:@"midval"];
    [aCoder encodeObject:_bgcolor forKey:@"bgcolor"];
    [aCoder encodeInteger:_size_x forKey:@"size_x"];
    [aCoder encodeInteger:_size_y forKey:@"size_y"];
    [aCoder encodeObject:_char_type forKey:@"char_type"];
    [aCoder encodeObject:_bottomtitle forKey:@"bottomtitle"];
    [aCoder encodeObject:_bottomval forKey:@"bottomval"];
    [aCoder encodeObject:_bottomunit forKey:@"bottomunit"];
    [aCoder encodeObject:_data forKey:@"data"];
    
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _Did = [aDecoder decodeObjectForKey:@"Did"];
        _unit = [aDecoder decodeObjectForKey:@"unit"];
        _color = [aDecoder decodeObjectForKey:@"color"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _midval = [aDecoder decodeObjectForKey:@"midval"];
        _bgcolor = [aDecoder decodeObjectForKey:@"bgcolor"];
        _size_x = [aDecoder decodeIntegerForKey:@"size_x"];
        _size_y = [aDecoder decodeIntegerForKey:@"size_y"];
        _char_type = [aDecoder decodeObjectForKey:@"char_type"];
        _bottomtitle = [aDecoder decodeObjectForKey:@"bottomtitle"];
        _bottomval = [aDecoder decodeObjectForKey:@"bottomval"];
        _bottomunit = [aDecoder decodeObjectForKey:@"bottomunit"];
        _data = [aDecoder decodeObjectForKey:@"data"];

    }
    
    
    return self;
}
@end
