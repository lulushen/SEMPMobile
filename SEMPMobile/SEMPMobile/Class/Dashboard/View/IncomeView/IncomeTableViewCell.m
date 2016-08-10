//
//  IncomeTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "IncomeTableViewCell.h"

@implementation IncomeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellAccessoryNone;
        self.backgroundColor = DEFAULT_BGCOLOR;
     
        [self makeCell];
    }
    return self;
}
- (void)makeCell
{
    _titleLabel = [[UILabel alloc] init];
    _ValueLabel = [[UILabel alloc] init];
    _label = [[UILabel alloc] init];
    
    [self.contentView addSubview:_label];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_ValueLabel];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _ValueLabel.font = [UIFont systemFontOfSize:12];
    [_ValueLabel setTextAlignment:NSTextAlignmentCenter];
    _ValueLabel.textColor = [UIColor grayColor];
    _ValueLabel.backgroundColor = [UIColor whiteColor];
    _ValueLabel.layer.masksToBounds = YES;
    _ValueLabel.layer.cornerRadius = 5;
    _ValueLabel.layer.borderWidth = 1;
    _ValueLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _label.backgroundColor = [UIColor grayColor];
}

-(void)layoutSubviews{
    
    
    _titleLabel.frame = CGRectMake(30*KWidth6scale, 10*KHeight6scale, 100*KWidth6scale, 30*KHeight6scale);
    
    _ValueLabel.frame = CGRectMake(self.contentView.frame.size.width - 120*KWidth6scale, CGRectGetMinY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_titleLabel.frame));
    
    _label.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame)-0.5*KWidth6scale, CGRectGetWidth(self.contentView.frame), 0.5*KWidth6scale);

    
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
