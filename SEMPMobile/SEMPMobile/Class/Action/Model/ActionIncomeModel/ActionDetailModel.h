//
//  ActionDetailModel.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/26.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionDetailModel : NSObject
@property (nonatomic , copy) NSString *  createtime;
@property (nonatomic , copy) NSMutableArray * deatil;
@property (nonatomic , copy) NSString * responsiblePerson;
@property (nonatomic , copy) NSMutableArray * index;
@property (nonatomic , copy) NSString * createuser;
@property (nonatomic , copy) NSString * taskinfo;
@property (nonatomic , copy) NSMutableArray * assistPeople;
@property (nonatomic , copy) NSString * priority;
@property (nonatomic , copy) NSString * deadtime;

@end
