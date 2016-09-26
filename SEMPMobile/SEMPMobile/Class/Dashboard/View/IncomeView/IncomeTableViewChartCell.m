//
//  IncomeTableViewChartCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "IncomeTableViewChartCell.h"

@implementation IncomeTableViewChartCell

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
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_label];
    
    _defaultvalColorLabel = [[UILabel alloc] init];
    _contrastvalColorLabel = [[UILabel alloc] init];
    _defaultvalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _contrastvalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chartView = [[UIView alloc] init];
    _scrollView = [[UIScrollView alloc] init];

    [self.contentView addSubview:_defaultvalColorLabel];
    [self.contentView addSubview:_contrastvalColorLabel];
    [self.contentView addSubview:_defaultvalButton];
    [self.contentView addSubview:_contrastvalButton];
    [self.contentView addSubview:_chartView];
    [self.chartView addSubview:_scrollView];
    
    [_defaultvalButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_contrastvalButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_defaultvalButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3 ] forState:UIControlStateHighlighted];
    [_contrastvalButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3 ] forState:UIControlStateHighlighted];

    [_defaultvalButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_contrastvalButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];

    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    _label.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame)-0.5*KWidth6scale, CGRectGetWidth(self.contentView.frame), 0.5*KWidth6scale);
   
    CGRect defaultvalButtonRect = [_defaultvalButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)/2.0, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_defaultvalButton.titleLabel.font} context:nil];
    CGRect contrastvaButtonRect = [_contrastvalButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)/2.0, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contrastvalButton.titleLabel.font} context:nil];

    _defaultvalColorLabel.frame = CGRectMake(CGRectGetMidX(self.contentView.frame)-defaultvalButtonRect.size.width-40*KWidth6scale, 20*KHeight6scale, 10*KWidth6scale, 10*KHeight6scale);
    
    _defaultvalButton.frame = CGRectMake(CGRectGetMaxX(_defaultvalColorLabel.frame)+10*KWidth6scale, CGRectGetMinY(_defaultvalColorLabel.frame)-CGRectGetHeight(_defaultvalColorLabel.frame)/2.0, defaultvalButtonRect.size.width+10*KWidth6scale, CGRectGetHeight(_defaultvalColorLabel.frame)*2);
    
    _contrastvalColorLabel.frame = CGRectMake(CGRectGetMidX(self.contentView.frame) + 10*KWidth6scale, CGRectGetMinY(_defaultvalColorLabel.frame), CGRectGetWidth(_defaultvalColorLabel.frame), CGRectGetHeight(_defaultvalColorLabel.frame));
    
    _contrastvalButton.frame = CGRectMake(CGRectGetMaxX(_contrastvalColorLabel.frame)+10*KWidth6scale, CGRectGetMinY(_defaultvalButton.frame),contrastvaButtonRect.size.width+10*KWidth6scale, CGRectGetHeight(_contrastvalColorLabel.frame)*2);
   
    _chartView.frame = CGRectMake(20*KWidth6scale, CGRectGetMaxY(_defaultvalButton.frame)+10*KHeight6scale, CGRectGetWidth(self.contentView.frame)-40*KWidth6scale, CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(_defaultvalButton.frame)-40*KHeight6scale);
    
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(_chartView.frame),CGRectGetHeight(_chartView.frame));
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_chartView.frame), CGRectGetHeight(_chartView.frame)*2 + 40*KHeight6scale);

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
