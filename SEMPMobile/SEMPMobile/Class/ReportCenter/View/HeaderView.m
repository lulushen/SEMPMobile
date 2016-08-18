//
//  HeaderView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/11.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = DEFAULT_BGCOLOR;
        
        [self makeView];
        
    }
    return self;
}
- (void)makeView
{
    _bgImageView = [[UIImageView alloc] init];
    _imageView = [[UIImageView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_bgImageView];
    _imageView.image = [UIImage imageNamed:@"shu.png"];
    [_bgImageView addSubview:_imageView];
    [_bgImageView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:16];
}
-(void)layoutSubviews
{
    _bgImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _imageView.frame = CGRectMake(20*KWidth6scale, 15*KHeight6scale, 20*KWidth6scale, 20*KHeight6scale);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + 10*KWidth6scale, CGRectGetMinY(_imageView.frame)-10*KHeight6scale, self.frame.size.width, self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
