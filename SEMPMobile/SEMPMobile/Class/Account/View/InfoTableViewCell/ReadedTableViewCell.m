//
//  ReadedTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ReadedTableViewCell.h"

@implementation ReadedTableViewCell
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
//    _lineLabel = [[UILabel alloc] init];
    
    _readedView = [[UIView alloc] init];
    _senderLabel = [[UILabel alloc] init];
    _senderImageView = [[UIImageView alloc] init];
    _senderTitleLabel = [[UILabel alloc] init];
    _receiveLabel = [[UILabel alloc] init];
    _receiveImageView = [[UIImageView alloc] init];
    _receiveTitleLabel = [[UILabel alloc] init];
    _contentLabel = [[UILabel alloc] init];
    _contentTitleLabel = [[UILabel alloc] init];
    _connectImageView = [[UIImageView alloc] init];
    _hornImageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:_infoImageView];
    [self.contentView addSubview:_infoLabel];
    [_infoLabel addSubview:_infoTitleLabel];
    [_infoLabel addSubview:_infoDateLabel];
//    [self.contentView addSubview:_lineLabel];
    
    [self.contentView addSubview:_readedView];
    [_readedView addSubview:_hornImageView];
    [_readedView addSubview:_senderImageView];
    [_readedView addSubview:_senderTitleLabel];
    [_readedView addSubview:_senderLabel];
    [_readedView addSubview:_connectImageView];
    [_readedView addSubview:_receiveImageView];
    [_readedView addSubview:_receiveTitleLabel];
    [_readedView addSubview:_receiveLabel];
    [_readedView addSubview:_contentTitleLabel];
    [_readedView addSubview:_contentLabel];

    _senderImageView.image = [UIImage imageNamed:@"sender.png"];
    _receiveImageView.image = [UIImage imageNamed:@"receive.png"];
    _connectImageView.image = [UIImage imageNamed:@"contect.png"];
    _hornImageView.image = [UIImage imageNamed:@"jiao.png"];
    
    _senderTitleLabel.text = @"发送人 : ";
    _receiveTitleLabel.text = @"接收人 : ";
    
    _contentTitleLabel.text = @"内容 : ";
    
    _infoLabel.layer.masksToBounds = YES;
    _infoLabel.backgroundColor = DEFAULT_BGCOLOR;
    _infoLabel.layer.cornerRadius = 5;
    _infoLabel.numberOfLines = 0;
    _infoTitleLabel.numberOfLines = 0;
    _infoDateLabel.numberOfLines = 0;
    _contentLabel.numberOfLines = 0;
    _infoTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    _infoDateLabel.font = [UIFont systemFontOfSize:13.0f];
    _senderTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    _senderLabel.font = [UIFont systemFontOfSize:14.0f];
    _receiveTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    _receiveLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];

    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _rectTitle = [_infoTitleLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width-80*KWidth6scale, KViewHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_infoTitleLabel.font} context:nil];
    _rectDate = [_infoDateLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width-80*KWidth6scale, KViewHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_infoDateLabel.font} context:nil];
    
    _infoImageView.frame = CGRectMake(10*KWidth6scale, CGRectGetMidY(_infoLabel.frame)-15*KHeight6scale, 30*KWidth6scale, 30*KHeight6scale);

    _infoLabel.frame = CGRectMake(CGRectGetMaxX(_infoImageView.frame)+5*KWidth6scale, 10*KHeight6scale, Main_Screen_Width - (CGRectGetMaxX(_infoImageView.frame)+20*KWidth6scale), _rectTitle.size.height + _rectDate.size.height+ 30*KHeight6scale);
   
    _infoTitleLabel.frame = CGRectMake(5*KWidth6scale, 10*KHeight6scale, _rectTitle.size.width, _rectTitle.size.height);
    _infoDateLabel.frame = CGRectMake(CGRectGetMinX(_infoTitleLabel.frame), CGRectGetMaxY(_infoTitleLabel.frame)+10*KHeight6scale, _rectDate.size.width, _rectDate.size.height);
   

    

    
    CGRect senderRect = [_senderLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width/2.0, KViewHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_senderLabel.font} context:nil];
    CGRect  receiveRect = [_receiveLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width/2.0, KViewHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_receiveLabel.font} context:nil];
    CGRect  contentRect = [_contentLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width-130*KWidth6scale, KViewHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contentLabel.font} context:nil];

    _senderImageView.frame = CGRectMake(0, 20*KHeight6scale, 15*KWidth6scale, 15*KHeight6scale);
    _senderTitleLabel.frame =  CGRectMake(CGRectGetMaxX(_senderImageView.frame) + 5*KWidth6scale, CGRectGetMinY(_senderImageView.frame), 50*KWidth6scale, CGRectGetHeight(_senderImageView.frame));
    _senderLabel.frame = CGRectMake(CGRectGetMaxX(_senderTitleLabel.frame), CGRectGetMinY(_senderTitleLabel.frame), senderRect.size.width + 5*KWidth6scale, CGRectGetHeight(_senderTitleLabel.frame));
    _connectImageView.frame = CGRectMake(CGRectGetMaxX(_senderLabel.frame) + 10*KWidth6scale, CGRectGetMinY(_senderLabel.frame), 40*KWidth6scale, 10*KHeight6scale);
    
    _receiveImageView.frame = CGRectMake(CGRectGetMaxX(_connectImageView.frame)+10*KWidth6scale, CGRectGetMinY(_senderImageView.frame), CGRectGetWidth(_senderImageView.frame), CGRectGetHeight(_senderImageView.frame));
    _receiveTitleLabel.frame = CGRectMake(CGRectGetMaxX(_receiveImageView.frame)+5*KWidth6scale, CGRectGetMinY(_receiveImageView.frame), CGRectGetWidth(_senderTitleLabel.frame), CGRectGetHeight(_senderTitleLabel.frame));
    _receiveLabel.frame = CGRectMake(CGRectGetMaxX(_receiveTitleLabel.frame), CGRectGetMinY(_receiveTitleLabel.frame), receiveRect.size.width, CGRectGetHeight(_senderLabel.frame));
    
    _contentTitleLabel.frame = CGRectMake(CGRectGetMinX(_senderImageView.frame), CGRectGetMaxY(_senderImageView.frame)+10*KHeight6scale, 50*KWidth6scale, CGRectGetHeight(_senderImageView.frame));
    _contentLabel.frame = CGRectMake(CGRectGetMaxX(_contentTitleLabel.frame), CGRectGetMinY(_contentTitleLabel.frame), contentRect.size.width + 5*KWidth6scale, contentRect.size.height);
    
    _hornImageView.frame = CGRectMake(CGRectGetMaxX(_senderImageView.frame), 0, 10*KWidth6scale, 10*KHeight6scale);
    _readedView.frame = CGRectMake(CGRectGetMinX(_infoLabel.frame), CGRectGetMaxY(_infoLabel.frame), CGRectGetWidth(_infoLabel.frame), CGRectGetMaxY(_contentLabel.frame)+10*KHeight6scale);
    
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
