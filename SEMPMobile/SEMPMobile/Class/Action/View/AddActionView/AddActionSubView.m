//
//  AddActionSubView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/5.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AddActionSubView.h"

@implementation AddActionSubView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self p_makeDateview];
        
    }
    return self;
}
- (void)p_makeDateview
{
    
    _imageActionView = [[UIImageView alloc] init];
    _actionTitleLabel = [[UILabel alloc] init];
    _addButton = [[UIButton alloc] init];
    _actionAddView = [[UIView alloc] init];
    _lineLabel = [[UILabel alloc] init];
    [_addButton setImage:[UIImage imageNamed:@"addAction.png"] forState:UIControlStateNormal];
    _actionTitleLabel.textColor = [UIColor grayColor];
    _actionTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_actionTitleLabel sizeToFit];
    [self addSubview:_imageActionView];
    [self addSubview:_actionTitleLabel];
    [self addSubview:_addButton];
    [self addSubview:_actionAddView];
    [self addSubview:_lineLabel];
    _lineLabel.backgroundColor = DEFAULT_BGCOLOR;

}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _imageActionView.frame = CGRectMake(20*KWidth6scale, 15*KHeight6scale, 20*KWidth6scale,20*KHeight6scale);
    _actionTitleLabel.frame = CGRectMake(CGRectGetMaxX(_imageActionView.frame)+10*KWidth6scale, CGRectGetMinY(_imageActionView.frame), CGRectGetWidth(_imageActionView.frame)*3, CGRectGetHeight(_imageActionView.frame));
    
    _actionAddView.frame = CGRectMake(CGRectGetMinX(_actionTitleLabel.frame), CGRectGetMaxY(_actionTitleLabel.frame)+10*KHeight6scale, CGRectGetWidth(self.frame)-CGRectGetMinX(_actionTitleLabel.frame)*2, CGRectGetHeight(_actionTitleLabel.frame));
    
    _addButton.frame = CGRectMake(CGRectGetMaxX(self.frame)-CGRectGetMinX(_actionTitleLabel.frame), CGRectGetMaxY(_actionTitleLabel.frame), 25*KWidth6scale, 25*KHeight6scale);
    _lineLabel.frame = CGRectMake(10*KWidth6scale, self.frame.size.height-1, self.frame.size.width-20*KWidth6scale, 1);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
