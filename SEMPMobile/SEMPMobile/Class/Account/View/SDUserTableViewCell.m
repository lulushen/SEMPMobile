//
//  SDUserTableViewCell.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDUserTableViewCell.h"

@implementation SDUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        [self makeCell];
    }
    return self;
}
- (void)makeCell
{
    _image = [[UIImageView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_image];
    [self.contentView addSubview:_titleLabel];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _image.frame = CGRectMake(20*KWidth6scale, CGRectGetMidY(self.contentView.frame)-10, 20, 20);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_image.frame)+20*KWidth6scale, CGRectGetMinY(_image.frame), 100, CGRectGetHeight(_image.frame));
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
