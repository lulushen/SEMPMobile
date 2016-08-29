//
//  ActionIncomeTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionIncomeTableViewCell.h"

@implementation ActionIncomeTableViewCell
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
    
    _imageIncomeActionView = [[UIImageView alloc] init];
    _actionFuBuTitleLabel = [[UILabel alloc] init];
    _actionFuBuPersonLabel = [[UILabel alloc] init];
    _chuangJianDataTitleLabel = [[UILabel alloc] init];
    _jieZhiDataTitleLabel = [[UILabel alloc] init];
    _chuangJianDataStringLabel = [[UILabel alloc] init];
    _jieZhiDataStringLabel = [[UILabel alloc] init];
    _actionStatuLabel = [[UILabel alloc] init];
    
    _oneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    _twoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    
//    _imageIncomeActionView.backgroundColor = [UIColor orangeColor];
//    _actionFuBuTitleLabel.backgroundColor = [UIColor orangeColor];
//    _actionFuBuPersonLabel.backgroundColor = [UIColor orangeColor];
//    _chuangJianDataTitleLabel.backgroundColor = [UIColor orangeColor];
//    _jieZhiDataTitleLabel.backgroundColor = [UIColor orangeColor];
//    _chuangJianDataStringLabel.backgroundColor = [UIColor orangeColor];
//    _jieZhiDataStringLabel.backgroundColor = [UIColor orangeColor];
//    _oneButton.backgroundColor = [UIColor orangeColor];


    _actionFuBuTitleLabel.textColor = [UIColor grayColor];
    _actionFuBuTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    _actionFuBuPersonLabel.textColor = [UIColor grayColor];
    _actionFuBuPersonLabel.font = [UIFont systemFontOfSize:14.0f];

    [self.contentView addSubview:_imageIncomeActionView];
    [self.contentView addSubview:_actionFuBuTitleLabel];
    [self.contentView addSubview:_actionFuBuPersonLabel];
    [self.contentView addSubview:_chuangJianDataTitleLabel];
    [self.contentView addSubview:_jieZhiDataTitleLabel];
    [self.contentView addSubview:_chuangJianDataStringLabel];
    [self.contentView addSubview:_jieZhiDataStringLabel];
    [self.contentView addSubview:_oneButton];
    [self.contentView addSubview:_twoButton];
    [self.contentView addSubview:_actionStatuLabel];
    _actionStatuLabel.layer.masksToBounds = YES;
    _actionStatuLabel.layer.cornerRadius = 2.0;
    _actionStatuLabel.textColor = [UIColor whiteColor];
    _actionStatuLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _actionStatuLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _chuangJianDataTitleLabel.text = @"创建日期 ：" ;
    _chuangJianDataTitleLabel.textColor = [UIColor grayColor];
    _chuangJianDataTitleLabel.font = [UIFont systemFontOfSize:12.0f];
//    _chuangJianDataStringLabel.text = @"2016-07-01" ;
    _chuangJianDataStringLabel.textAlignment = NSTextAlignmentLeft;
    _chuangJianDataStringLabel.textColor = [UIColor grayColor];
    _chuangJianDataStringLabel.font = [UIFont systemFontOfSize:12.0f];
    _jieZhiDataTitleLabel.text = @"截止日期 ：" ;
    _jieZhiDataTitleLabel.textColor = [UIColor grayColor];
    _jieZhiDataTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    _jieZhiDataStringLabel.textAlignment = NSTextAlignmentLeft;

    _jieZhiDataStringLabel.textColor = [UIColor grayColor];
    _jieZhiDataStringLabel.font = [UIFont systemFontOfSize:12.0f];

    [_oneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_twoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    _oneButton.layer.masksToBounds = YES;
    _oneButton.layer.borderWidth = 1;
    _oneButton.layer.cornerRadius = 3;
    _oneButton.layer.borderColor = [UIColor grayColor].CGColor;
    _twoButton.layer.masksToBounds = YES;
    _twoButton.layer.borderWidth = 1;
    _twoButton.layer.cornerRadius = 3;
    _twoButton.layer.borderColor = [UIColor grayColor].CGColor;
    
}

- (void)layoutSubviews{
    
    
    [super layoutSubviews];
    
     CGRect rectActionFuBuPersonLabel = [_actionFuBuPersonLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_actionFuBuPersonLabel.font} context:nil];
     CGRect rectOneButton = [_oneButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_oneButton.titleLabel.font} context:nil];
    
     CGRect rectTwoButton = [_twoButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.contentView.frame)-60, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_twoButton.titleLabel.font} context:nil];
    
    _imageIncomeActionView.frame = CGRectMake(20*KWidth6scale, 40*KHeight6scale, 20*KWidth6scale,20*KHeight6scale);
    _actionFuBuTitleLabel.frame = CGRectMake(CGRectGetMaxX(_imageIncomeActionView.frame)+10*KWidth6scale, CGRectGetMinY(_imageIncomeActionView.frame), CGRectGetWidth(_imageIncomeActionView.frame)*4, CGRectGetHeight(_imageIncomeActionView.frame));
    _actionFuBuPersonLabel.frame = CGRectMake(CGRectGetMaxX(_actionFuBuTitleLabel.frame), CGRectGetMinY(_actionFuBuTitleLabel.frame),rectActionFuBuPersonLabel.size.width, CGRectGetHeight(_actionFuBuTitleLabel.frame));
    _actionStatuLabel.frame = CGRectMake(CGRectGetMaxX(_actionFuBuPersonLabel.frame) + 20*KWidth6scale, CGRectGetMinY(_actionFuBuPersonLabel.frame), CGRectGetHeight(_actionFuBuPersonLabel.frame),  CGRectGetHeight(_actionFuBuPersonLabel.frame));
    
    _chuangJianDataTitleLabel.frame = CGRectMake(CGRectGetMinX(_actionFuBuTitleLabel.frame), CGRectGetMaxY(_actionFuBuTitleLabel.frame) + 10*KHeight6scale, CGRectGetWidth(_actionFuBuTitleLabel.frame)-10*KWidth6scale, CGRectGetHeight(_actionFuBuTitleLabel.frame));
    
    _chuangJianDataStringLabel.frame = CGRectMake(CGRectGetMaxX(_chuangJianDataTitleLabel.frame), CGRectGetMinY(_chuangJianDataTitleLabel.frame), CGRectGetWidth(_chuangJianDataTitleLabel.frame), CGRectGetHeight(_chuangJianDataTitleLabel.frame));
    
    _jieZhiDataTitleLabel.frame = CGRectMake(CGRectGetMinX(_chuangJianDataTitleLabel.frame), CGRectGetMaxY(_chuangJianDataTitleLabel.frame), CGRectGetWidth(_chuangJianDataTitleLabel.frame), CGRectGetHeight(_chuangJianDataTitleLabel.frame));
    
    _jieZhiDataStringLabel.frame = CGRectMake(CGRectGetMinX(_chuangJianDataStringLabel.frame), CGRectGetMaxY(_chuangJianDataStringLabel.frame), CGRectGetWidth(_chuangJianDataStringLabel.frame), CGRectGetHeight(_chuangJianDataStringLabel.frame));
    
    _twoButton.frame = CGRectMake(Main_Screen_Width-rectTwoButton.size.width -20*KWidth6scale, 10*KHeight6scale, rectTwoButton.size.width+10*KWidth6scale, 25*KHeight6scale);
    
    _oneButton.frame = CGRectMake(CGRectGetMinX(_twoButton.frame)-20*KWidth6scale-rectOneButton.size.width, CGRectGetMinY(_twoButton.frame), rectOneButton.size.width+10*KWidth6scale, CGRectGetHeight(_twoButton.frame));

    
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
