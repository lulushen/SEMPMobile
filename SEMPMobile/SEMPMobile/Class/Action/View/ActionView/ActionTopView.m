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
    _yiXiaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _yiJieShouButton = [[UIButton alloc] init];
    _daiJieShouButton = [[UIButton alloc] init];
    _allActionButton = [[UIButton alloc] init];
    
    _yiXiaButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _yiJieShouButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _daiJieShouButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _allActionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];

    _yiXiaButton.layer.masksToBounds = YES;
    _yiXiaButton.layer.cornerRadius = 5;
    _yiJieShouButton.layer.masksToBounds = YES;
    _yiJieShouButton.layer.cornerRadius = 5;
    _daiJieShouButton.layer.masksToBounds = YES;
    _daiJieShouButton.layer.cornerRadius = 5;
    _allActionButton.layer.masksToBounds = YES;
    _allActionButton.layer.cornerRadius = 5;
    
    [_yiXiaButton setTitle:@"已下达" forState:UIControlStateNormal];
    [_yiXiaButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [_yiJieShouButton setTitle:@"已接收" forState:UIControlStateNormal];
    [_yiJieShouButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   
    [_daiJieShouButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   
    [_allActionButton setTitle:@"全部任务" forState:UIControlStateNormal];
    _allActionButton.backgroundColor = ActionButtonColor;
    
    [_allActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self addSubview:_yiXiaButton];
    [self addSubview:_yiJieShouButton];
    [self addSubview:_daiJieShouButton];
    [self addSubview:_allActionButton];
    
    
}
-(void)layoutSubviews
{
   
    _yiXiaButton.frame = CGRectMake(20*KWidth6scale, 10*KHeight6scale, (self.frame.size.width-40*KWidth6scale)/4.0, self.frame.size.height- 10*KHeight6scale);
    _yiJieShouButton.frame = CGRectMake(CGRectGetMaxX(_yiXiaButton.frame), CGRectGetMinY(_yiXiaButton.frame), CGRectGetWidth(_yiXiaButton.frame), CGRectGetHeight(_yiXiaButton.frame));
    _daiJieShouButton.frame = CGRectMake(CGRectGetMaxX(_yiJieShouButton.frame), CGRectGetMinY(_yiJieShouButton.frame), CGRectGetWidth(_yiJieShouButton.frame), CGRectGetHeight(_yiJieShouButton.frame));
    _allActionButton.frame = CGRectMake(CGRectGetMaxX(_daiJieShouButton.frame), CGRectGetMinY(_daiJieShouButton.frame), CGRectGetWidth(_daiJieShouButton.frame), CGRectGetHeight(_daiJieShouButton.frame));
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
