//
//  SettingLockTableViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/10/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SettingLockTableViewCell.h"

@implementation SettingLockTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        [self makeLockCell];
    }
    return self;
}
- (void)makeLockCell
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_titleLabel];
    
    _searchImageView = [[UIImageView alloc] init];
//    _searchImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_searchImageView];
    
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = DEFAULT_BGCOLOR;
    [self.contentView addSubview:_lineLabel];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(30, 0, 100, self.contentView.frame.size.height);
    _searchImageView.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame)-70, CGRectGetMidY(self.contentView.frame)-15, 30, 30);
    _lineLabel.frame = CGRectMake(10, CGRectGetMaxY(self.contentView.frame)-1, CGRectGetWidth(self.contentView.frame)-20, 1);
    
    
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
