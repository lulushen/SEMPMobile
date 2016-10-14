//
//  AllReportCollectionViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/10.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AllReportCollectionViewCell.h"

@implementation AllReportCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DEFAULT_BGCOLOR;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor grayColor] CGColor];
        [self prepareUI];
    }
    return self;
}
- (void)prepareUI
{
    //布局
    _imageView = [[UIImageView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    _concernButton = [[UIButton alloc] init];
    _detailButton = [[UIButton alloc] init];
    
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [[UIColor grayColor] CGColor];
    _imageView.layer.borderWidth = 1;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [_concernButton setImage:[UIImage imageNamed:@"concern.png"] forState:UIControlStateNormal];
    [_detailButton setImage:[UIImage imageNamed:@"detail.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_concernButton];
    [self.contentView addSubview:_detailButton];
//    _imageView.backgroundColor = [UIColor orangeColor];
//    _titleLabel.backgroundColor = DEFAULT_BGCOLOR;
//    _concernButton.backgroundColor = [UIColor orangeColor];
//    _detailButton.backgroundColor = [UIColor redColor];
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    _imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - 30*KHeight6scale);
    _titleLabel.frame = CGRectMake(CGRectGetMinX(_imageView.frame) + 10*KWidth6scale, CGRectGetMaxY(_imageView.frame), CGRectGetWidth(_imageView.frame)/2.0, 30*KHeight6scale);
    _concernButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame)-(CGRectGetWidth(_imageView.frame)/4.0+10*KWidth6scale), CGRectGetMinY(_titleLabel.frame)+5*KHeight6scale, CGRectGetWidth(_imageView.frame)/8.0, CGRectGetHeight(_titleLabel.frame)-10*KHeight6scale);
    _detailButton.frame = CGRectMake(CGRectGetMaxX(_concernButton.frame)+5*KHeight6scale, CGRectGetMinY(_concernButton.frame), CGRectGetWidth(_concernButton.frame), CGRectGetHeight(_concernButton.frame)); 
}
@end
