//
//  NoReadInfoTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "NoReadInfoTableViewCell.h"

@implementation NoReadInfoTableViewCell
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
    _infoImageView = [[UIImageView alloc] init];
    _infoLabel = [[UILabel alloc] init];
    _infoTitleLabel = [[UILabel alloc] init];
    _infoDateLabel = [[UILabel alloc] init];
    _lineLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:_infoImageView];
    [self.contentView addSubview:_infoLabel];
    [_infoLabel addSubview:_infoTitleLabel];
    [_infoLabel addSubview:_infoDateLabel];
    [self.contentView addSubview:_lineLabel];
//    _lineLabel.backgroundColor = DEFAULT_BGCOLOR;
    
    _infoLabel.layer.masksToBounds = YES;
    _infoLabel.backgroundColor = DEFAULT_BGCOLOR;
    _infoLabel.layer.cornerRadius = 15;
    _infoLabel.numberOfLines = 0;
    _infoTitleLabel.numberOfLines = 0;
    _infoDateLabel.numberOfLines = 0;
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rectTitle = [_infoTitleLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width-80, KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_infoTitleLabel.font} context:nil];
    CGRect rectDate = [_infoDateLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_infoDateLabel.font} context:nil];
    _infoImageView.frame = CGRectMake(10*KWidth6scale, 10*KHeight6scale, 20*KWidth6scale, 15*KHeight6scale);
    
    _infoLabel.frame = CGRectMake(CGRectGetMaxX(_infoImageView.frame)+5*KWidth6scale, 10*KHeight6scale, Main_Screen_Width - (CGRectGetMaxX(_infoImageView.frame)+20*KWidth6scale), rectTitle.size.height + rectDate.size.height+ 30*KHeight6scale);
    
    _infoTitleLabel.frame = CGRectMake(5*KWidth6scale, 10*KHeight6scale, rectTitle.size.width, rectTitle.size.height);
    _infoDateLabel.frame = CGRectMake(CGRectGetMinX(_infoTitleLabel.frame), CGRectGetMaxY(_infoTitleLabel.frame)+10*KHeight6scale, rectDate.size.width, rectDate.size.height);
   
//    _lineLabel.frame
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
