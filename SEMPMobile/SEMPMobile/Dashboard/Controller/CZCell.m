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
//        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//        self.numberLabel.backgroundColor = [UIColor yellowColor];
//        [self addSubview:self.numberLabel];
//
        [self makeLabel];
    }
    return self;
}
- (void)makeLabel{
    
//    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//    self.numberLabel.backgroundColor = [UIColor yellowColor];
//    [self addSubview:self.numberLabel];
}
@end
