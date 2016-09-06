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

@property (nonatomic,copy) NSString * bgcolor;

@property (nonatomic,copy) NSString * color;

@property (nonatomic,assign) NSInteger size_x;

@property (nonatomic,assign) NSInteger  size_y;

@property (nonatomic,copy) NSString * chart_type;

@property (nonatomic,copy) NSData * data;

@property (nonatomic,assign) NSInteger  chart_end_time;

@property (nonatomic,assign) NSInteger  chart_range;

@property (nonatomic,copy) NSString * defaulttype;

@property (nonatomic,copy) NSString * defaultval;

@property (nonatomic,copy) NSString * defaultname;

@property (nonatomic , copy)NSString *contrastval;

@property (nonatomic , copy)NSString *contrasttype;

@property (nonatomic , copy)NSString *contrastname;

@property (nonatomic , copy)NSString * defaultunit;

@property (nonatomic , copy)NSString * contrastunit;

@property (nonatomic , copy)NSString * analysis_dimension;


@end
