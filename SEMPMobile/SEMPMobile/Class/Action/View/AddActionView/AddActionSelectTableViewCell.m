//
//  AddActionSelectTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/24.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AddActionSelectTableViewCell.h"

@implementation AddActionSelectTableViewCell
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
    _selectButton = [[UIButton alloc] init];
    _titleLabel = [[UILabel alloc] init];
//    _selectButton.backgroundColor = [UIColor orangeColor];
//    _titleLabel.backgroundColor = [UIColor redColor];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textColor = [UIColor grayColor];
    [_selectButton setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_selectButton];
    [self.contentView addSubview:_titleLabel];
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _selectButton.frame = CGRectMake(20*KWidth6scale, 5*KHeight6scale, CGRectGetHeight(self.contentView.frame)-5* KHeight6scale, CGRectGetHeight(self.contentView.frame)-5* KHeight6scale);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_selectButton.frame)+5*KWidth6scale, CGRectGetMinY(_selectButton.frame), CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(_selectButton.frame) - 40*KWidth6scale, CGRectGetHeight(_selectButton.frame));
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
