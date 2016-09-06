//
//  ActionIncomeSubView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/5.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionIncomeSubView.h"

@implementation ActionIncomeSubView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeView];
        
    }
    return self;
}
- (void)makeView
{
    
    
    _imageIncomeActionView = [[UIImageView alloc] init];
    _actionFuBuTitleLabel = [[UILabel alloc] init];
    _actionFuBuPersonLabel = [[UILabel alloc] init];
    _chuangJianDataTitleLabel = [[UILabel alloc] init];
    _jieZhiDataTitleLabel = [[UILabel alloc] init];
    _chuangJianDataStringLabel = [[UILabel alloc] init];
    _jieZhiDataStringButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionStatuLabel = [[UILabel alloc] init];
    
    _oneButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    _twoButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    
    _taskEditView = [[UIView alloc] init];
    _lineLabel = [[UILabel alloc] init];
    //    _imageIncomeActionView.backgroundColor = [UIColor orangeColor];
    //    _actionFuBuTitleLabel.backgroundColor = [UIColor orangeColor];
    //    _actionFuBuPersonLabel.backgroundColor = [UIColor orangeColor];
    //    _chuangJianDataTitleLabel.backgroundColor = [UIColor orangeColor];
    //    _jieZhiDataTitleLabel.backgroundColor = [UIColor orangeColor];
    //    _chuangJianDataStringLabel.backgroundColor = [UIColor orangeColor];
    //    _jieZhiDataStringLabel.backgroundColor = [UIColor orangeColor];
    //    _oneButton.backgroundColor = [UIColor orangeColor];
    
    
    _actionFuBuTitleLabel.textColor = [UIColor grayColor];
    _actionFuBuTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    _actionFuBuPersonLabel.textColor = [UIColor grayColor];
    _actionFuBuPersonLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [self addSubview:_imageIncomeActionView];
    [self addSubview:_actionFuBuTitleLabel];
    [self addSubview:_actionFuBuPersonLabel];
    [self addSubview:_chuangJianDataTitleLabel];
    [self addSubview:_jieZhiDataTitleLabel];
    [self addSubview:_chuangJianDataStringLabel];
    [self addSubview:_jieZhiDataStringButton];
    [self addSubview:_oneButton];
    [self addSubview:_twoButton];
    [self addSubview:_actionStatuLabel];
    
    //    [self.contentView addSubview:_taskEditView];
    [self addSubview:_lineLabel];
    
    _actionStatuLabel.layer.masksToBounds = YES;
    _actionStatuLabel.layer.cornerRadius = 2.0;
    _actionStatuLabel.textColor = [UIColor whiteColor];
    _actionStatuLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _actionStatuLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _chuangJianDataTitleLabel.text = @"创建日期 ：" ;
    _chuangJianDataTitleLabel.textColor = [UIColor grayColor];
    _chuangJianDataTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    //    _chuangJianDataStringLabel.text = @"2016-07-01" ;
    _chuangJianDataStringLabel.textAlignment = NSTextAlignmentLeft;
    _chuangJianDataStringLabel.textColor = [UIColor grayColor];
    _chuangJianDataStringLabel.font = [UIFont systemFontOfSize:12.0f];
    _jieZhiDataTitleLabel.text = @"截止日期 ：" ;
    _jieZhiDataTitleLabel.textColor = [UIColor grayColor];
    _jieZhiDataTitleLabel.font = [UIFont systemFontOfSize:12.0f];
  
    [_jieZhiDataStringButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_jieZhiDataStringButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_jieZhiDataStringButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_oneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_twoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _oneButton.layer.masksToBounds = YES;
    _oneButton.layer.borderWidth = 1;
    _oneButton.layer.cornerRadius = 3;
    _oneButton.layer.borderColor = [UIColor grayColor].CGColor;
    _twoButton.layer.masksToBounds = YES;
    _twoButton.layer.borderWidth = 1;
    _twoButton.layer.cornerRadius = 3;
    _twoButton.layer.borderColor = [UIColor grayColor].CGColor;
    _lineLabel.backgroundColor = DEFAULT_BGCOLOR;
//    _jieZhiDataStringButton.layer.borderWidth = 1;
    _jieZhiDataStringButton.layer.cornerRadius = 3;
}

- (void)layoutSubviews{
    
    
    [super layoutSubviews];
    
    CGRect rectActionFuBuPersonLabel = [_actionFuBuPersonLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-60, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_actionFuBuPersonLabel.font} context:nil];
    CGRect rectOneButton = [_oneButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-60, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_oneButton.titleLabel.font} context:nil];
    
    CGRect rectTwoButton = [_twoButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-60, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_twoButton.titleLabel.font} context:nil];
    
    _imageIncomeActionView.frame = CGRectMake(20*KWidth6scale, 40*KHeight6scale, 20*KWidth6scale,20*KHeight6scale);
    _actionFuBuTitleLabel.frame = CGRectMake(CGRectGetMaxX(_imageIncomeActionView.frame)+10*KWidth6scale, CGRectGetMinY(_imageIncomeActionView.frame), CGRectGetWidth(_imageIncomeActionView.frame)*4, CGRectGetHeight(_imageIncomeActionView.frame));
    _actionFuBuPersonLabel.frame = CGRectMake(CGRectGetMaxX(_actionFuBuTitleLabel.frame), CGRectGetMinY(_actionFuBuTitleLabel.frame),rectActionFuBuPersonLabel.size.width, CGRectGetHeight(_actionFuBuTitleLabel.frame));
    _actionStatuLabel.frame = CGRectMake(CGRectGetMaxX(_actionFuBuPersonLabel.frame) + 20*KWidth6scale, CGRectGetMinY(_actionFuBuPersonLabel.frame), CGRectGetHeight(_actionFuBuPersonLabel.frame),  CGRectGetHeight(_actionFuBuPersonLabel.frame));
    
    _chuangJianDataTitleLabel.frame = CGRectMake(CGRectGetMinX(_actionFuBuTitleLabel.frame), CGRectGetMaxY(_actionFuBuTitleLabel.frame) + 10*KHeight6scale, CGRectGetWidth(_actionFuBuTitleLabel.frame)-10*KWidth6scale, CGRectGetHeight(_actionFuBuTitleLabel.frame));
    
    _chuangJianDataStringLabel.frame = CGRectMake(CGRectGetMaxX(_chuangJianDataTitleLabel.frame), CGRectGetMinY(_chuangJianDataTitleLabel.frame), CGRectGetWidth(_chuangJianDataTitleLabel.frame), CGRectGetHeight(_chuangJianDataTitleLabel.frame));
    
    _jieZhiDataTitleLabel.frame = CGRectMake(CGRectGetMinX(_chuangJianDataTitleLabel.frame), CGRectGetMaxY(_chuangJianDataTitleLabel.frame), CGRectGetWidth(_chuangJianDataTitleLabel.frame), CGRectGetHeight(_chuangJianDataTitleLabel.frame));
    
    _jieZhiDataStringButton.frame = CGRectMake(CGRectGetMinX(_chuangJianDataStringLabel.frame), CGRectGetMaxY(_chuangJianDataStringLabel.frame), CGRectGetWidth(_chuangJianDataStringLabel.frame)+10*KWidth6scale, CGRectGetHeight(_chuangJianDataStringLabel.frame));
    
    _twoButton.frame = CGRectMake(Main_Screen_Width-rectTwoButton.size.width -20*KWidth6scale, 10*KHeight6scale, rectTwoButton.size.width+10*KWidth6scale, 25*KHeight6scale);
    
    _oneButton.frame = CGRectMake(CGRectGetMinX(_twoButton.frame)-20*KWidth6scale-rectOneButton.size.width, CGRectGetMinY(_twoButton.frame), rectOneButton.size.width+10*KWidth6scale, CGRectGetHeight(_twoButton.frame));
    
    _taskEditView.frame = CGRectMake(30*KWidth6scale, CGRectGetMaxY(_jieZhiDataTitleLabel.frame)+10*KHeight6scale, CGRectGetWidth(self.frame)-CGRectGetMinX(_jieZhiDataTitleLabel.frame), 25*KWidth6scale);
    _lineLabel.frame = CGRectMake(10*KWidth6scale, CGRectGetMaxY(self.frame)-1, CGRectGetWidth(self.frame)-20*KWidth6scale, 1);
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
