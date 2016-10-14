//
//  ReportTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/10.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ReportTableViewCell.h"

@implementation ReportTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell选中后不变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self makeCell];
    }
    return self;
}
- (void)makeCell
{
    _titleLabel = [[UILabel alloc] init];
    _dateLabel =[[UILabel alloc] init];
    _concernButton = [[UIButton alloc] init];
    _detailButton = [[UIButton alloc] init];
    _lineLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.font = [UIFont systemFontOfSize:10];
    [_concernButton setImage:[UIImage imageNamed:@"concern.png"] forState:UIControlStateNormal];
    [_detailButton setImage:[UIImage imageNamed:@"detail.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_dateLabel];
    [self.contentView addSubview:_concernButton];
    [self.contentView addSubview:_detailButton];
    [self.contentView addSubview:_lineLabel];
    _lineLabel.backgroundColor = DEFAULT_BGCOLOR;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(20*KWidth6scale, 10*KHeight6scale, 100*KWidth6scale, 20*KHeight6scale);
    _dateLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame), 10*KHeight6scale);
    _concernButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - 80*KWidth6scale, CGRectGetMidY(self.contentView.frame)-10*KHeight6scale, 20*KWidth6scale, 20*KHeight6scale);
    _detailButton.frame = CGRectMake(CGRectGetMaxX(_concernButton.frame) + 20*KWidth6scale, CGRectGetMinY(_concernButton.frame), CGRectGetWidth(_concernButton.frame), CGRectGetHeight(_concernButton.frame));
    _lineLabel.frame = CGRectMake(CGRectGetMinX(self.contentView.frame)+10*KWidth6scale, CGRectGetMaxY(self.contentView.frame)-1*KHeight6scale, CGRectGetWidth(self.contentView.frame)-20*KWidth6scale, 1*KHeight6scale);
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
