//
//  IncomeDashModel.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/18.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeDashModel : NSObject
@property (nonatomic , copy) NSString * defaultval;
@property (nonatomic , copy) NSString * defaultunit;
@property (nonatomic , copy) NSString * defaultname;
@property (nonatomic , copy) NSString * bgcolor;
@property (nonatomic , copy) NSString * color;
@property (nonatomic , copy) NSString * otherval;
@property (nonatomic , copy) NSString * otherunit;
@property (nonatomic , copy) NSString * othername;
@property (nonatomic , copy) NSString * contrastval;
@property (nonatomic , copy) NSString * contrastunit;
@property (nonatomic , copy) NSString * contrastname;
@property (nonatomic , copy) NSMutableDictionary * defaultVal;
@property (nonatomic , copy) NSMutableDictionary * contrastVal;
@property (nonatomic , copy) NSString * charttype;

@end
