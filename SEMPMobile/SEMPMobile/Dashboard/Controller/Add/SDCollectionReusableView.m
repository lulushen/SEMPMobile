//
//  SDCollectionReusableView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/20.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDCollectionReusableView.h"

@implementation SDCollectionReusableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Kwidth, self.frame.size.height )];
//        self.titleLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

@end
