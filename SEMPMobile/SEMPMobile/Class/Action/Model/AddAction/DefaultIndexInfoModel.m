//
//  DefaultIndexInfoModel.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/24.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DefaultIndexInfoModel.h"

@implementation DefaultIndexInfoModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.indexId = value;
    }
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_indexId forKey:@"indexId"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_chart_type forKey:@"chart_type"];
    [aCoder encodeObject:_index_root_id forKey:@"index_root_id"];
    [aCoder encodeObject:_index_id forKey:@"index_id"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        _indexId = [aDecoder decodeObjectForKey:@"indexId"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _chart_type = [aDecoder decodeObjectForKey:@"chart_type"];
        _index_root_id = [aDecoder decodeObjectForKey:@"index_root_id"];
        _index_id = [aDecoder decodeObjectForKey:@"index_id"];
        
    }
    return self;
}

@end
