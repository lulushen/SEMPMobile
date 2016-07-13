//
//  SDPublic.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/13.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDPublic.h"

@implementation SDPublic
static SDPublic * _sharedInstance;
//方法实现
+ (id) sharedInstance {
    @synchronized ([SDPublic class]) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[SDPublic alloc] init];
        }
    }
    return _sharedInstance;
}
@end
