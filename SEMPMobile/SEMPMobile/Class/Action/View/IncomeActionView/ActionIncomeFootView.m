//
//  ActionIncomeFootView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionIncomeFootView.h"

@implementation ActionIncomeFootView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
              
        [self p_makeFootview];
        
    }
    return self;
}
-(void)p_makeFootview
{
    
    _titleActionLabel  = [[UILabel alloc] init];
    _titleActionLabel.frame = CGRectMake(10*KWidth6scale, 10*KHeight6scale, 100*KWidth6scale, 30*KHeight6scale);
    _titleActionLabel.text = @"任务详情记录";
    _titleActionLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_titleActionLabel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
