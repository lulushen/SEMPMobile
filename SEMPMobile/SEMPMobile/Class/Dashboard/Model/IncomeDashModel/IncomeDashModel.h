//
//  IncomeDashModel.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/18.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeDashModel : NSObject
@property (nonatomic,copy) NSString * charttype;
@property (nonatomic,copy) NSString * color;
@property (nonatomic,copy) NSString * midval;
@property (nonatomic,copy) NSString * unit;
@property (nonatomic,copy) NSString * threshold_flag;
@property (nonatomic,copy) NSString * bottomval;
@property (nonatomic,copy) NSString * bottomunit;
@property (nonatomic,copy) NSMutableDictionary * defaultVal;
@property (nonatomic,copy) NSMutableDictionary * contrastVal;


@end
