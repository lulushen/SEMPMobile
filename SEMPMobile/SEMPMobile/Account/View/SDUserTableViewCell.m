//
//  SDUserTableViewCell.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDUserTableViewCell.h"

@implementation SDUserTableViewCell

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
