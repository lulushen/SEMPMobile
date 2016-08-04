//
//  DashTopView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DashTopView.h"

@implementation DashTopView
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
    _labelimage = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 35, 35)];
    
    _labelimage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhibiao.png"]];
    
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labelimage.frame), CGRectGetMinY(_labelimage.frame)+10, CGRectGetWidth(_labelimage.frame) * 3, CGRectGetHeight(_labelimage.frame))];
    
    _labelTitle.text = @"指标看板";
    
    [self addSubview:_labelimage];
    
    [self addSubview:_labelTitle];
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.moreButton.frame = CGRectMake(Main_Screen_Width - 80, CGRectGetMinY(_labelTitle.frame)+5, 60, CGRectGetHeight(_labelTitle.frame)/2);
    
    [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.moreButton setTitle:@"more" forState:UIControlStateNormal];
    
    self.moreButton.layer.borderWidth = 1;
    
    self.moreButton.layer.cornerRadius = 5;
    
    self.moreButton.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [self addSubview:self.moreButton];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
