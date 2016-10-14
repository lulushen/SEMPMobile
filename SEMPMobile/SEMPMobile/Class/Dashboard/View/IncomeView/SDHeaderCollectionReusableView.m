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

        self.tuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, self.frame.size.height)];
        self.tuImageView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.tuImageView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tuImageView.frame), CGRectGetMinY(self.tuImageView.frame), 200, CGRectGetHeight(self.tuImageView.frame))];
        self.titleLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.titleLabel];
    
    }
    return self;
}
@end
