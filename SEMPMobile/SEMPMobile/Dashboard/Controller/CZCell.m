//
//  CZCell.m
//  自定义流水布局
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 cz.cn. All rights reserved.
//

#import "CZCell.h"

@implementation CZCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.backgroundColor = [UIColor cyanColor];

        [self.contentView addSubview:self.numberLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    self.numberLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    

    
}

@end
