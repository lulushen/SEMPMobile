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
    
    _midvalColorLabel = [[UILabel alloc] init];
    _bottomvalColorLabel = [[UILabel alloc] init];
    _midvalTitleLabel = [[UILabel alloc] init];
    _bottomTitleLabel = [[UILabel alloc] init];
    _chartView = [[UIView alloc] init];
    _scrollView = [[UIScrollView alloc] init];

    [self.contentView addSubview:_midvalColorLabel];
    [self.contentView addSubview:_bottomvalColorLabel];
    [self.contentView addSubview:_midvalTitleLabel];
    [self.contentView addSubview:_bottomTitleLabel];
    [self.contentView addSubview:_chartView];
    
    _midvalTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    _bottomTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    _midvalTitleLabel.textColor = [UIColor grayColor];
    _bottomTitleLabel.textColor = [UIColor grayColor];
//    _midvalColorLabel.backgroundColor = [UIColor orangeColor];
//    _midvalTitleLabel.backgroundColor = [UIColor blackColor];
//    _bottomvalColorLabel.backgroundColor = [UIColor blueColor];
//    _bottomTitleLabel.backgroundColor = [UIColor redColor];
//    _chartView.backgroundColor = [UIColor grayColor];
    

    
  
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    _label.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame)-0.5*KWidth6scale, CGRectGetWidth(self.contentView.frame), 0.5*KWidth6scale);
    
    _midvalColorLabel.frame = CGRectMake(CGRectGetMidX(self.contentView.frame)-100*KWidth6scale, 20*KHeight6scale, 10*KWidth6scale, 10*KHeight6scale);
    _midvalTitleLabel.frame = CGRectMake(CGRectGetMaxX(_midvalColorLabel.frame)+10*KWidth6scale, CGRectGetMinY(_midvalColorLabel.frame)-CGRectGetHeight(_midvalColorLabel.frame)/2.0, 60*KWidth6scale, CGRectGetHeight(_midvalColorLabel.frame)*2);
    _bottomvalColorLabel.frame = CGRectMake(CGRectGetMidX(self.contentView.frame) + 10*KWidth6scale, CGRectGetMinY(_midvalColorLabel.frame), CGRectGetWidth(_midvalColorLabel.frame), CGRectGetHeight(_midvalColorLabel.frame));
    _bottomTitleLabel.frame = CGRectMake(CGRectGetMaxX(_bottomvalColorLabel.frame)+10*KWidth6scale, CGRectGetMinY(_midvalTitleLabel.frame), CGRectGetWidth(_midvalTitleLabel.frame), CGRectGetHeight(_midvalTitleLabel.frame));
   
    _chartView.frame = CGRectMake(20*KWidth6scale, CGRectGetMaxY(_midvalTitleLabel.frame)+10*KHeight6scale, CGRectGetWidth(self.contentView.frame)-40*KWidth6scale, CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(_midvalTitleLabel.frame)-40*KHeight6scale);
    
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(_chartView.frame),CGRectGetHeight(_chartView.frame));
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_chartView.frame)*2.0, CGRectGetHeight(_chartView.frame));

    
//    _scrollView.backgroundColor = [UIColor grayColor];
    
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
