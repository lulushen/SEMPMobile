//
//  SDoneCollectionViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/20.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDoneCollectionViewCell.h"

@implementation SDoneCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _titLabone = [[UILabel alloc] init];
        _titLabone.backgroundColor = [UIColor grayColor];
        [_titLabone setTextAlignment:NSTextAlignmentCenter];
        _titLabone.numberOfLines = 2;
       
        
        [self.contentView addSubview:_titLabone];
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    _titLabone.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    
    
    
}
@end
