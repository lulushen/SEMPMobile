//
//  ActionTopView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/17.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionTopView.h"

@implementation ActionTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self p_setupView];
        
    }
    return self;
}
- (void)p_setupView
{
    _weiWanChengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _yiXiaDaButton = [[UIButton alloc] init];
    _daiChuliButton = [[UIButton alloc] init];
    _allActionButton = [[UIButton alloc] init];
    
    _weiWanChengButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _yiXiaDaButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _daiChuliButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _allActionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];

    _weiWanChengButton.layer.masksToBounds = YES;
    _weiWanChengButton.layer.cornerRadius = 5;
    _yiXiaDaButton.layer.masksToBounds = YES;
    _yiXiaDaButton.layer.cornerRadius = 5;
    _daiChuliButton.layer.masksToBounds = YES;
    _daiChuliButton.layer.cornerRadius = 5;
    _allActionButton.layer.masksToBounds = YES;
    _allActionButton.layer.cornerRadius = 5;
    
    [_weiWanChengButton setTitle:@"未完成" forState:UIControlStateNormal];
    [_weiWanChengButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [_yiXiaDaButton setTitle:@"已下达" forState:UIControlStateNormal];
    [_yiXiaDaButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   
    [_daiChuliButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   
    [_allActionButton setTitle:@"全部任务" forState:UIControlStateNormal];
    _allActionButton.backgroundColor = ActionButtonColor;
    
    [_allActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self addSubview:_weiWanChengButton];
    [self addSubview:_yiXiaDaButton];
    [self addSubview:_daiChuliButton];
    [self addSubview:_allActionButton];
    
    
}
-(void)layoutSubviews
{
   
    _weiWanChengButton.frame = CGRectMake(20*KWidth6scale, 10*KHeight6scale, (self.frame.size.width-40*KWidth6scale)/4.0, self.frame.size.height- 10*KHeight6scale);
    _yiXiaDaButton.frame = CGRectMake(CGRectGetMaxX(_weiWanChengButton.frame), CGRectGetMinY(_weiWanChengButton.frame), CGRectGetWidth(_weiWanChengButton.frame), CGRectGetHeight(_weiWanChengButton.frame));
    _daiChuliButton.frame = CGRectMake(CGRectGetMaxX(_yiXiaDaButton.frame), CGRectGetMinY(_yiXiaDaButton.frame), CGRectGetWidth(_yiXiaDaButton.frame), CGRectGetHeight(_yiXiaDaButton.frame));
    _allActionButton.frame = CGRectMake(CGRectGetMaxX(_daiChuliButton.frame), CGRectGetMinY(_daiChuliButton.frame), CGRectGetWidth(_daiChuliButton.frame), CGRectGetHeight(_daiChuliButton.frame));
//    _daiChuliLabel.frame = CGRectMake(CGRectGetWidth(_daiChuliButton.frame) - CGRectGetWidth(_daiChuliButton.frame)/4.0, 0, CGRectGetWidth(_daiChuliButton.frame)/4.0, CGRectGetHeight(_daiChuliButton.frame));
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
