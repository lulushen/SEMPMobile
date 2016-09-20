//
//  DashBoardCollectionViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/12.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DashBoardCollectionViewCell.h"

@implementation DashBoardCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES; //设置为yes，就可以使用圆角
        self.layer.cornerRadius= 3; //设置它的圆角大小
        [self p_setupView];
       
    }
    return self;
}

- (void)p_setupView
{
    _labelTitle = [[UILabel alloc] init];
    _labelunit = [[UILabel alloc] init];
    _labelBottomtilte = [[UILabel alloc] init];
    _labelBottomval= [[UILabel alloc] init];
    _label = [[UILabel alloc] init];
    _labelMidval = [[UILabel alloc] init];
    _midvalView =[[UIView alloc] init];
    
    [_labelMidval setTextAlignment:NSTextAlignmentRight];
    [_labelunit setTextAlignment:NSTextAlignmentRight];
    
    _labelMidval.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_labelTitle];
    
    _labelMidval.font = [UIFont boldSystemFontOfSize:30];
    _labelBottomtilte.font = [UIFont boldSystemFontOfSize:12];
    _labelBottomval.font = [UIFont boldSystemFontOfSize:12];
    _labelTitle.font = [UIFont boldSystemFontOfSize:15];
   
//    _labelunit.backgroundColor = [UIColor redColor];
//    _labelBottomval.backgroundColor = [UIColor  blackColor];
//    _labelBottomtilte.backgroundColor = [UIColor blueColor];
//    _label.backgroundColor = [UIColor whiteColor];
//    
//    _midvalView.backgroundColor = [UIColor cyanColor];
//    _labelTitle.backgroundColor = [UIColor grayColor];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _labelTitle.frame = CGRectMake(10*KWidth6scale, 10*KHeight6scale, self.frame.size.width-20*KWidth6scale, 20*KHeight6scale);
    _labelunit.frame = CGRectMake(CGRectGetMinX(_labelTitle.frame), CGRectGetHeight(self.frame)-30*KHeight6scale, CGRectGetWidth(_labelTitle.frame),  20*KHeight6scale);
    _labelBottomtilte.frame = CGRectMake(CGRectGetMinX(_labelTitle.frame), CGRectGetMinY(_labelunit.frame)-20*KHeight6scale, CGRectGetWidth(_labelTitle.frame)/3.0,20*KHeight6scale);
    _labelBottomval.frame = CGRectMake(CGRectGetMaxX(_labelBottomtilte.frame), CGRectGetMinY(_labelBottomtilte.frame), CGRectGetWidth(_labelBottomtilte.frame), CGRectGetHeight(_labelBottomtilte.frame));
    _label.frame = CGRectMake(CGRectGetMaxX(_labelBottomval.frame), CGRectGetMinY(_labelBottomtilte.frame), CGRectGetWidth(_labelBottomtilte.frame), CGRectGetHeight(_labelBottomtilte.frame));
    _labelMidval.frame = CGRectMake(10*KWidth6scale, CGRectGetMaxY(_labelTitle.frame), CGRectGetWidth(_labelTitle.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(_labelTitle.frame) - CGRectGetHeight(_labelBottomtilte.frame) - CGRectGetHeight(_labelunit.frame));
     _midvalView.frame = CGRectMake(10*KWidth6scale, CGRectGetMaxY(_labelTitle.frame), CGRectGetWidth(_labelTitle.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(_labelTitle.frame) - CGRectGetHeight(_labelBottomtilte.frame));
    
}

- (void)setTextColor:(UIColor *)color
{
    [_labelTitle setTextColor:color];
    [_labelMidval setTextColor:color];
    [_labelBottomval setTextColor:color];
    [_labelBottomtilte setTextColor:color];
    [_labelunit setTextColor:color];
}
@end
