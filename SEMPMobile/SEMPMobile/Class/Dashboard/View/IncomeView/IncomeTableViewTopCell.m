//
//  IncomeTableViewTopCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "IncomeTableViewTopCell.h"

@implementation IncomeTableViewTopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        [self  makeCell];
    }
    return self;
}

- (void)makeCell
{
    _titleImage = [[UIImageView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    _bottomtitleLabel = [[UILabel alloc] init];
    _bottomvalLabel = [[UILabel alloc] init];
    _bottomunitLable = [[UILabel alloc] init];
    _bottomvalTwoLabel = [[UILabel alloc] init];
    _bottomtitleTwoLabel = [[UILabel alloc] init];
    _label = [[UILabel alloc] init];
    [self.contentView addSubview:_titleImage];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_bottomtitleLabel];
    [self.contentView addSubview:_bottomvalLabel];
    [self.contentView addSubview:_bottomunitLable];
    [self.contentView addSubview:_bottomtitleTwoLabel];
    [self.contentView addSubview:_bottomvalTwoLabel];
    [self.contentView addSubview:_label];

    
    [_bottomtitleLabel setTextAlignment:NSTextAlignmentCenter];
    [_bottomvalLabel setTextAlignment:NSTextAlignmentRight];
    [_bottomunitLable setTextAlignment:NSTextAlignmentLeft];
    [_bottomtitleTwoLabel setTextAlignment:NSTextAlignmentCenter];
    [_bottomvalTwoLabel setTextAlignment:NSTextAlignmentCenter];
    _bottomvalLabel.numberOfLines=0;
    [_bottomvalLabel sizeToFit];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _bottomtitleLabel.font = [UIFont systemFontOfSize:12];
    _bottomvalLabel.font = [UIFont systemFontOfSize:11];
    _bottomunitLable.font = [UIFont systemFontOfSize:11];

    _bottomtitleTwoLabel.font = [UIFont systemFontOfSize:12];
    _bottomvalTwoLabel.font = [UIFont systemFontOfSize:12];
    _bottomtitleLabel.textColor = [UIColor grayColor];
    _bottomtitleTwoLabel.textColor = [UIColor grayColor];
   
    _label.backgroundColor = [UIColor grayColor];

//    _titleImage.backgroundColor = [UIColor grayColor];
//    _titleLabel.backgroundColor = [UIColor redColor];
//    _bottomtitleLabel.backgroundColor = [UIColor orangeColor];
//    _bottomvalLabel.backgroundColor = [UIColor blueColor];
//    _bottomunitLable.backgroundColor = [UIColor grayColor];
//
//    _bottomtitleTwoLabel.backgroundColor = [UIColor blackColor];
//    _bottomvalTwoLabel.backgroundColor = [UIColor cyanColor];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleImage.frame = CGRectMake(50*KWidth6scale, CGRectGetHeight(self.contentView.frame)/2.0-15*KHeight6scale, 30*KWidth6scale, 40*KHeight6scale);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_titleImage.frame)+30*KWidth6scale, CGRectGetMinY(_titleImage.frame), 140*KWidth6scale, CGRectGetHeight(_titleImage.frame));
    
     _bottomtitleLabel.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame), CGRectGetMinY(_titleLabel.frame)-10*KHeight6scale, 50*KWidth6scale, 30*KHeight6scale);
    
     _bottomvalLabel.frame = CGRectMake(CGRectGetMaxX(_bottomtitleLabel.frame), CGRectGetMinY(_bottomtitleLabel.frame), 35*KWidth6scale, 30*KHeight6scale);
    
      _bottomunitLable.frame = CGRectMake(CGRectGetMaxX(_bottomvalLabel.frame), CGRectGetMinY(_bottomvalLabel.frame), 25*KWidth6scale, 30*KHeight6scale);
    
     _bottomtitleTwoLabel.frame = CGRectMake(CGRectGetMinX(_bottomtitleLabel.frame), CGRectGetMaxY(_bottomtitleLabel.frame)+10*KHeight6scale, CGRectGetWidth(_bottomtitleLabel.frame), CGRectGetHeight(_bottomtitleLabel.frame));
    
     _bottomvalTwoLabel.frame = CGRectMake(CGRectGetMinX(_bottomvalLabel.frame), CGRectGetMinY(_bottomtitleTwoLabel.frame), CGRectGetWidth(_bottomvalLabel.frame), CGRectGetHeight(_bottomvalLabel.frame));
    
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
