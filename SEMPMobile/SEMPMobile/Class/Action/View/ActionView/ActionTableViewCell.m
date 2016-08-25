//
//  ActionTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/17.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionTableViewCell.h"

@implementation ActionTableViewCell

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
    _actionTitleLabel = [[UILabel alloc] init];
    _actionDifficultyLabel = [[UILabel alloc] init];
    _actionDateLabel = [[UILabel alloc] init];
    _actionStatuLabel = [[UILabel alloc] init];
    _actionPersonImage = [[UIImageView alloc] init];
    _lineLabel = [[UILabel alloc] init];

    [self.contentView addSubview:_actionTitleLabel];
    [self.contentView addSubview:_actionDifficultyLabel];
    [self.contentView addSubview:_actionDateLabel];
    [self.contentView addSubview:_actionStatuLabel];
    [self.contentView addSubview:_actionPersonImage];
    [self.contentView addSubview:_lineLabel];


    
    _actionTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    _actionDateLabel.font = [UIFont systemFontOfSize:11.0f];
    _actionStatuLabel.font = [UIFont systemFontOfSize:14.0f];
    _actionDateLabel.textAlignment = NSTextAlignmentCenter;
//    _actionTimeLabel.textAlignment = NSTextAlignmentCenter;
    _actionStatuLabel.textAlignment = NSTextAlignmentCenter;

    
    _actionDifficultyLabel.layer.masksToBounds = YES;
    _actionDifficultyLabel.layer.cornerRadius = 2.0;
    _actionDifficultyLabel.backgroundColor = RGBCOLOR(250.0, 110.0, 114.0);
    _actionDifficultyLabel.textColor = [UIColor whiteColor];
    _actionDifficultyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _actionDifficultyLabel.textAlignment = NSTextAlignmentCenter;
//    _actionTitleLabel.backgroundColor = [UIColor orangeColor];
//    _actionDifficultyImage.backgroundColor = [UIColor redColor];
//    _actionDateLabel.backgroundColor = [UIColor grayColor];
//    _actionTimeLabel.backgroundColor = [UIColor blueColor];
//    _actionStatuLabel.backgroundColor = [UIColor cyanColor];
//    _actionPersonImage.backgroundColor = [UIColor orangeColor];
    _lineLabel.backgroundColor = DEFAULT_BGCOLOR;

  
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rectTitle = [_actionTitleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_actionTitleLabel.font} context:nil];
    CGRect rectTime = [_actionDateLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_actionDateLabel.font} context:nil];
//    CGRect rectDifficulty = [_actionDifficultyLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_actionDifficultyLabel.font} context:nil];

    
    _actionTitleLabel.frame = CGRectMake(20*KWidth6scale, CGRectGetHeight(self.contentView.frame)/3.0, rectTitle.size.width, CGRectGetHeight(self.contentView.frame)/4.0);
    _actionDifficultyLabel.frame = CGRectMake(CGRectGetMinX(_actionTitleLabel.frame), CGRectGetMaxY(_actionTitleLabel.frame) + 5*KHeight6scale, 20*KWidth6scale, 20*KHeight6scale);
    _actionDateLabel.frame = CGRectMake(CGRectGetMaxX(_actionDifficultyLabel.frame) + 10*KWidth6scale, CGRectGetMinY(_actionDifficultyLabel.frame), rectTime.size.width, CGRectGetHeight(_actionDifficultyLabel.frame));
    
    _actionPersonImage.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)-40*KWidth6scale, 0, 20*KWidth6scale, 20*KHeight6scale);
    _actionStatuLabel.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) -(CGRectGetWidth(self.contentView.frame)-40*KWidth6scale)/4.0 -20*KWidth6scale, CGRectGetMaxY(_actionPersonImage.frame) + 10*KHeight6scale, (CGRectGetWidth(self.contentView.frame)-40*KWidth6scale)/4.0, CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(_actionPersonImage.frame) -20*KWidth6scale);
     _lineLabel.frame = CGRectMake(CGRectGetMinX(self.contentView.frame)+10*KWidth6scale, CGRectGetMaxY(self.contentView.frame)-1*KHeight6scale, CGRectGetWidth(self.contentView.frame)-20*KWidth6scale, 1*KHeight6scale);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
