//
//  SDHeaderCollectionReusableView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/18.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDHeaderCollectionReusableView.h"

@implementation SDHeaderCollectionReusableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * label12 = [[UILabel alloc] initWithFrame:self.frame];
        label12.backgroundColor = [UIColor redColor];
    }
    return self;
}
@end
