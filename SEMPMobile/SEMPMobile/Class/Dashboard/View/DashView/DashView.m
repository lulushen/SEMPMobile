//
//  DashView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DashView.h"

@implementation DashView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
        
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
    [_labelMidval setTextAlignment:NSTextAlignmentRight];
    [_labelunit setTextAlignment:NSTextAlignmentRight];
    
   
    _labelMidval.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_labelTitle];
    [self addSubview:_labelMidval];
    [self addSubview:_labelBottomtilte];
    [self addSubview:_labelBottomval];
    [self addSubview:_label];
    [self addSubview:_labelunit];
    _labelMidval.font = [UIFont systemFontOfSize:30];
    _labelBottomtilte.font = [UIFont systemFontOfSize:13];
    _labelBottomval.font = [UIFont systemFontOfSize:13];
    _labelTitle.font = [UIFont systemFontOfSize:15];

//    _labelunit.backgroundColor = [UIColor redColor];
//    _labelBottomval.backgroundColor = [UIColor  blackColor];
//    _labelBottomtilte.backgroundColor = [UIColor blueColor];
//    _label.backgroundColor = [UIColor whiteColor];
//    _labelMidval.backgroundColor = [UIColor cyanColor];
//    _labelTitle.backgroundColor = [UIColor grayColor];

    
}

- (void)layoutSubviews{
    
    _labelTitle.frame = CGRectMake(10, 10, self.frame.size.width-20, 20);

    _labelunit.frame = CGRectMake(CGRectGetMinX(_labelTitle.frame), CGRectGetHeight(self.frame)-30, CGRectGetWidth(_labelTitle.frame),  20);
    _labelBottomtilte.frame = CGRectMake(CGRectGetMinX(_labelTitle.frame), CGRectGetMinY(_labelunit.frame)-20, CGRectGetWidth(_labelTitle.frame)/3.0,20);
    _labelBottomval.frame = CGRectMake(CGRectGetMaxX(_labelBottomtilte.frame), CGRectGetMinY(_labelBottomtilte.frame), CGRectGetWidth(_labelBottomtilte.frame), CGRectGetHeight(_labelBottomtilte.frame));
    _label.frame = CGRectMake(CGRectGetMaxX(_labelBottomval.frame), CGRectGetMinY(_labelBottomtilte.frame), CGRectGetWidth(_labelBottomtilte.frame), CGRectGetHeight(_labelBottomtilte.frame));
    _labelMidval.frame = CGRectMake(10, CGRectGetMaxY(_labelTitle.frame), CGRectGetWidth(_labelTitle.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(_labelTitle.frame) - CGRectGetHeight(_labelBottomtilte.frame) - CGRectGetHeight(_labelunit.frame));

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
