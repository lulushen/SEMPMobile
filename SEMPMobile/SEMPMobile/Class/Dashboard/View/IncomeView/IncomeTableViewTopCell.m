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
    _defaultvalLabel = [[UILabel alloc] init];
    _defaultunitLabel = [[UILabel alloc] init];
    _contrastvalLabel = [[UILabel alloc] init];
    _contrastnameLabel = [[UILabel alloc] init];
    _contrastunitLable = [[UILabel alloc] init];
    _otherval = [[UILabel alloc] init];
    _othernameLabel = [[UILabel alloc] init];
    _otherunitLabel = [[UILabel alloc] init];

    
    _label = [[UILabel alloc] init];
    [self.contentView addSubview:_titleImage];
    [self.contentView addSubview:_defaultvalLabel];
    [self.contentView addSubview:_defaultunitLabel];
    [self.contentView addSubview:_contrastvalLabel];
    [self.contentView addSubview:_contrastnameLabel];
    [self.contentView addSubview:_contrastunitLable];
    [self.contentView addSubview:_otherval];
    [self.contentView addSubview:_otherunitLabel];
    [self.contentView addSubview:_othernameLabel];

    
    [self.contentView addSubview:_label];

//    
//    [_bottomtitleLabel setTextAlignment:NSTextAlignmentCenter];
//    [_bottomvalLabel setTextAlignment:NSTextAlignmentRight];
//    [_bottomunitLable setTextAlignment:NSTextAlignmentLeft];
//    [_bottomtitleTwoLabel setTextAlignment:NSTextAlignmentCenter];
//    [_bottomvalTwoLabel setTextAlignment:NSTextAlignmentCenter];
//    _bottomvalLabel.numberOfLines=0;
//    [_bottomvalLabel sizeToFit];
    _defaultvalLabel.font = [UIFont systemFontOfSize:22];
    _defaultunitLabel.font = [UIFont systemFontOfSize:22];
    _contrastnameLabel.font = [UIFont systemFontOfSize:12];
    _contrastvalLabel.font = [UIFont systemFontOfSize:12];
    _contrastunitLable.font = [UIFont systemFontOfSize:12];

    _otherunitLabel.font = [UIFont systemFontOfSize:12];
    _otherval.font = [UIFont systemFontOfSize:12];
    _othernameLabel.font =[UIFont systemFontOfSize:12];
    
    _othernameLabel.textColor = [UIColor grayColor];
    _otherval.textColor = [UIColor grayColor];
    _otherunitLabel.textColor = [UIColor grayColor];
    _contrastunitLable.textColor = [UIColor grayColor];
    _contrastvalLabel.textColor = [UIColor grayColor];
    _contrastnameLabel.textColor = [UIColor grayColor];

    _label.backgroundColor = [UIColor grayColor];

//    _defaultvalLabel.backgroundColor = [UIColor grayColor];
//    _defaultunitLabel.backgroundColor = [UIColor redColor];
//    _contrastunitLable.backgroundColor = [UIColor orangeColor];
//    _contrastvalLabel.backgroundColor = [UIColor blueColor];
//    _contrastnameLabel.backgroundColor = [UIColor blackColor];
//    _othernameLabel.backgroundColor = [UIColor redColor];
//    _otherval.backgroundColor = [UIColor cyanColor];
//    _otherunitLabel.backgroundColor = [UIColor purpleColor];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleImage.frame = CGRectMake(50*KWidth6scale, CGRectGetHeight(self.contentView.frame)/2.0-15*KHeight6scale, 30*KWidth6scale, 40*KHeight6scale);
    CGRect defaultvalStringRect = [_defaultvalLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_defaultvalLabel.font} context:nil];
    CGRect defaultunitStringRect = [_defaultunitLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_defaultunitLabel.font} context:nil];
    CGRect contrastnameStringRect = [_contrastnameLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contrastnameLabel.font} context:nil];
    CGRect contrastvalStringRect = [_contrastvalLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contrastvalLabel.font} context:nil];

    CGRect contrastunitStringRect = [_contrastunitLable.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contrastunitLable.font} context:nil];
    CGRect othernameStringRect = [_othernameLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_othernameLabel.font} context:nil];
    CGRect othervalStringRect = [_otherval.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_otherval.font} context:nil];
    
    CGRect otherunitLabelStringRect = [_otherunitLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_otherunitLabel.font} context:nil];
    _defaultvalLabel.frame = CGRectMake(CGRectGetMaxX(_titleImage.frame)+30*KWidth6scale, CGRectGetMinY(_titleImage.frame), defaultvalStringRect.size.width+10*KWidth6scale,CGRectGetHeight(_titleImage.frame));
    
    _defaultunitLabel.frame = CGRectMake(CGRectGetMaxX(_defaultvalLabel.frame), CGRectGetMinY(_defaultvalLabel.frame), defaultunitStringRect.size.width+20*KWidth6scale,CGRectGetHeight(_defaultvalLabel.frame));

    _contrastnameLabel.frame = CGRectMake(self.contentView.frame.size.width-110*KWidth6scale, CGRectGetMidY(self.contentView.frame)-(contrastnameStringRect.size.height + 10*KHeight6scale), contrastnameStringRect.size.width+20*KWidth6scale , contrastnameStringRect.size.height);
    
    _contrastvalLabel.frame = CGRectMake(CGRectGetMaxX(_contrastnameLabel.frame), CGRectGetMinY(_contrastnameLabel.frame), contrastvalStringRect.size.width+5*KWidth6scale , contrastvalStringRect.size.height);
    
    _contrastunitLable.frame = CGRectMake(CGRectGetMaxX(_contrastvalLabel.frame), CGRectGetMinY(_contrastvalLabel.frame), contrastunitStringRect.size.width , contrastunitStringRect.size.height);
    

    
     _othernameLabel.frame = CGRectMake(CGRectGetMinX(_contrastnameLabel.frame), CGRectGetMidY(self.contentView.frame)+10*KHeight6scale, othernameStringRect.size.width+20*KWidth6scale , othernameStringRect.size.height);
    
     _otherval.frame = CGRectMake(CGRectGetMaxX(_othernameLabel.frame), CGRectGetMinY(_othernameLabel.frame), othervalStringRect.size.width+5*KWidth6scale , othervalStringRect.size.height);
    
     _otherunitLabel.frame = CGRectMake(CGRectGetMaxX(_otherval.frame), CGRectGetMinY(_otherval.frame), otherunitLabelStringRect.size.width , otherunitLabelStringRect.size.height);
    
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
