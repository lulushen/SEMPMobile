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
    [aCoder encodeObject:_defaultunit forKey:@"defaultunit"];
    [aCoder encodeObject:_bgcolor forKey:@"bgcolor"];
    [aCoder encodeInteger:_size_x forKey:@"size_x"];
    [aCoder encodeInteger:_size_y forKey:@"size_y"];
    [aCoder encodeObject:_chart_type forKey:@"chart_type"];
    [aCoder encodeObject:_defaultname forKey:@"defaultname"];
    [aCoder encodeObject:_contrastval forKey:@"contrastval"];
    [aCoder encodeObject:_contrastunit forKey:@"contrastunit"];
    [aCoder encodeObject:_data forKey:@"data"];
    [aCoder encodeObject:_analysis_dimension forKey:@"analysis_dimension"];
    [aCoder encodeInteger:_chart_end_time forKey:@"chart_end_time"];
    [aCoder encodeInteger:_chart_range forKey:@"chart_range"];
    [aCoder encodeObject:_defaulttype forKey:@"defaulttype"];
    [aCoder encodeObject:_defaultval forKey:@"defaultval"];
    [aCoder encodeObject:_contrasttype forKey:@"contrasttype"];
    [aCoder encodeObject:_contrastname forKey:@"contrastname"];


    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _Did = [aDecoder decodeObjectForKey:@"Did"];
        _unit = [aDecoder decodeObjectForKey:@"unit"];
        _color = [aDecoder decodeObjectForKey:@"color"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _defaultunit = [aDecoder decodeObjectForKey:@"vdefaultunit"];
        _bgcolor = [aDecoder decodeObjectForKey:@"bgcolor"];
        _size_x = [aDecoder decodeIntegerForKey:@"size_x"];
        _size_y = [aDecoder decodeIntegerForKey:@"size_y"];
        _chart_type = [aDecoder decodeObjectForKey:@"chart_type"];
        _defaultname = [aDecoder decodeObjectForKey:@"defaultname"];
        _contrastval = [aDecoder decodeObjectForKey:@"contrastval"];
        _contrastunit = [aDecoder decodeObjectForKey:@"contrastunit"];
        _data = [aDecoder decodeObjectForKey:@"data"];
        _analysis_dimension = [aDecoder decodeObjectForKey:@"analysis_dimension"];
        _chart_end_time = [aDecoder decodeIntegerForKey:@"chart_end_time"];
        _chart_range = [aDecoder decodeIntegerForKey:@"chart_range"];
        _defaulttype = [aDecoder decodeObjectForKey:@"defaulttype"];
        _defaultval = [aDecoder decodeObjectForKey:@"defaultval"];
        _contrasttype = [aDecoder decodeObjectForKey:@"contrasttype"];
        _contrastname = [aDecoder decodeObjectForKey:@"contrastname"];
        
    }
    
    
    return self;
}
@end
