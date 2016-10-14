//
//  Singleton.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/29.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
// tabBar的四个item数组
@property (nonatomic , strong)NSMutableArray * itemArray;

+(instancetype)shareSingleHandle;

@end
