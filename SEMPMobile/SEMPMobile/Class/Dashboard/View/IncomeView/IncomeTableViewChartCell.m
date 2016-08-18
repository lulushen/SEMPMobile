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
        self.backgroundColor = DEFAULT_BGCOLOR;
        
        [self makeCell];
    }
    return self;
}
- (void)makeCell
{
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_label];
  
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
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
