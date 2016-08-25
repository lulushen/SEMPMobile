//
//  ActionIncomeTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionIncomeTableViewCell.h"

@implementation ActionIncomeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell选中后不变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self makeView];
    }
    return self;
}
- (void)makeView
{
    
    _imageIncomeActionView = [[UIImageView alloc] init];
    _actionIncomeTitleLabel = [[UILabel alloc] init];
    _actionIncomeView = [[UIView alloc] init];
    
//        _imageIncomeActionView.backgroundColor = [UIColor orangeColor];
//        _actionIncomeTitleLabel.backgroundColor = [UIColor redColor];
//        _actionIncomeView.backgroundColor = [UIColor blueColor];
    _actionIncomeTitleLabel.textColor = [UIColor grayColor];
    _actionIncomeTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_actionIncomeTitleLabel sizeToFit];
    [self.contentView addSubview:_imageIncomeActionView];
    [self.contentView addSubview:_actionIncomeTitleLabel];
    [self.contentView addSubview:_actionIncomeView];
    
    
}

- (void)layoutSubviews{
    
    
    [super layoutSubviews];
    _imageIncomeActionView.frame = CGRectMake(20*KWidth6scale, 20*KHeight6scale, 20*KWidth6scale,20*KHeight6scale);
    _actionIncomeTitleLabel.frame = CGRectMake(CGRectGetMaxX(_imageIncomeActionView.frame)+10*KWidth6scale, CGRectGetMinY(_imageIncomeActionView.frame), CGRectGetWidth(_imageIncomeActionView.frame)*4, CGRectGetHeight(_imageIncomeActionView.frame));
    _actionIncomeView.frame = CGRectMake(CGRectGetMaxX(_actionIncomeTitleLabel.frame), CGRectGetMinY(_actionIncomeTitleLabel.frame), CGRectGetWidth(self.contentView.frame)-CGRectGetMinX(_actionIncomeTitleLabel.frame)*3, CGRectGetHeight(_actionIncomeTitleLabel.frame));
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
