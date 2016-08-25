//
//  AddActionTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AddActionTableViewCell.h"

@implementation AddActionTableViewCell

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
    
    _imageActionView = [[UIImageView alloc] init];
    _actionTitleLabel = [[UILabel alloc] init];
    _addButton = [[UIButton alloc] init];
    _actionAddView = [[UIView alloc] init];
    
//    _imageActionView.backgroundColor = [UIColor orangeColor];
//    _actionTitleLabel.backgroundColor = [UIColor redColor];
//    _addButton.backgroundColor = [UIColor grayColor];
//    _actionAddView.backgroundColor = [UIColor blueColor];
    [_addButton setImage:[UIImage imageNamed:@"addAction.png"] forState:UIControlStateNormal];
    _actionTitleLabel.textColor = [UIColor grayColor];
    _actionTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_actionTitleLabel sizeToFit];
    [self.contentView addSubview:_imageActionView];
    [self.contentView addSubview:_actionTitleLabel];
    [self.contentView addSubview:_addButton];
    [self.contentView addSubview:_actionAddView];
    
    
}

- (void)layoutSubviews{
    
    
    [super layoutSubviews];
    _imageActionView.frame = CGRectMake(20*KWidth6scale, 15*KHeight6scale, 20*KWidth6scale,20*KHeight6scale);
    _actionTitleLabel.frame = CGRectMake(CGRectGetMaxX(_imageActionView.frame)+10*KWidth6scale, CGRectGetMinY(_imageActionView.frame), CGRectGetWidth(_imageActionView.frame)*3, CGRectGetHeight(_imageActionView.frame));
   
    _actionAddView.frame = CGRectMake(CGRectGetMinX(_actionTitleLabel.frame), CGRectGetMaxY(_actionTitleLabel.frame)+10*KHeight6scale, CGRectGetWidth(self.contentView.frame)-CGRectGetMinX(_actionTitleLabel.frame)*2, CGRectGetHeight(_actionTitleLabel.frame));
    
    _addButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame)-CGRectGetMinX(_actionTitleLabel.frame), CGRectGetMidY(self.contentView.frame)-12.5*KHeight6scale, 25*KWidth6scale, 25*KHeight6scale);
    
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
