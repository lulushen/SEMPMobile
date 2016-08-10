//
//  DashBoardModel.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashBoardModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString * Did;

@property (nonatomic,copy) NSString * title;

@property (nonatomic,copy) NSString * unit;

@property (nonatomic,copy) NSString * midval;

@property (nonatomic,copy) NSString * bgcolor;

@property (nonatomic,copy) NSString * color;

@property (nonatomic,assign) NSInteger size_x;

@property (nonatomic,assign) NSInteger  size_y;

@property (nonatomic,copy) NSString * chart_type;

@property (nonatomic,copy) NSString * bottomtitle;

@property (nonatomic,copy) NSString * bottomval;

@property (nonatomic,copy) NSString * bottomunit;

@property (nonatomic,copy) NSData * data;

@property (nonatomic,copy) NSString * threshold_flag;

@property (nonatomic,copy) NSString * analysis_dimension;

@property (nonatomic,assign) NSInteger  chart_end_time;

@property (nonatomic,assign) NSInteger  chart_range;

@property (nonatomic,copy) NSString * chart_top_title;

@property (nonatomic,copy) NSString * defaulttype;


@end
