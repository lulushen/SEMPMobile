//
//  SetTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/22.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell
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
    _setImageView = [[UIImageView alloc] init];
    _setTitleLabel = [[UILabel alloc] init];
    _setDetailLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:_setImageView];
    [self.contentView addSubview:_setTitleLabel];
    [self.contentView addSubview:_setDetailLabel];
    
    _setDetailLabel.textColor  = [UIColor grayColor];
//    _setImageView.backgroundColor = [UIColor redColor];
//    _setTitleLabel.backgroundColor = [UIColor blueColor];
//    _setDetailLabel.backgroundColor = [UIColor blackColor];
    _line = [[UILabel alloc] init];
    [self.contentView addSubview:_line];
   
    _line.backgroundColor = DEFAULT_BGCOLOR;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect detailsString =  [_setDetailLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 80*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_setDetailLabel.font} context:nil];
    

    
    _setImageView.frame  = CGRectMake(40*KWidth6scale, CGRectGetMidY(self.contentView.frame)-10*KWidth6scale, 20*KWidth6scale, 20*KWidth6scale);
    _setTitleLabel.frame = CGRectMake(CGRectGetMaxX(_setImageView.frame)+10*KWidth6scale, CGRectGetMinY(_setImageView.frame), 150*KWidth6scale, CGRectGetHeight(_setImageView.frame));
    _setDetailLabel.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame)- (detailsString.size.width+20*KWidth6scale), CGRectGetMinY(_setTitleLabel.frame), detailsString.size.width, CGRectGetHeight(_setTitleLabel.frame));
     _line.frame = CGRectMake(10*KWidth6scale, CGRectGetMaxY(self.contentView.frame)-1, CGRectGetWidth(self.contentView.frame)-20, 1);
    
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
