//
//  AddCollectionViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AddCollectionViewCell.h"

@implementation AddCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.backgroundColor = [UIColor whiteColor];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        _titleLab.numberOfLines = 2;
        _titleLab.layer.masksToBounds = YES;
        _titleLab.layer.cornerRadius = 10.0;
        _titleLab.layer.borderWidth = 1.0;
        _titleLab.layer.borderColor = [DEFAULT_BGCOLOR CGColor ];
        
        [self.contentView addSubview:_titleLab];
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    _titleLab.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
