//
//  DataView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/27.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DataView.h"


@implementation DataView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, Main_Screen_Width*4/9, 44);
        
        [self p_makeDateview];
        
    }
    return self;
}
- (void)p_makeDateview
{
    
    _dateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_dateButton];
    _dateButton.userInteractionEnabled = YES;
    
    _dateLabel = [[UILabel alloc] init];
    [_dateLabel setTextAlignment:NSTextAlignmentCenter];
    _dateLabel.textColor = [UIColor whiteColor];
    [_dateButton addSubview:_dateLabel];
    
    _dateImage = [[UIImageView alloc] init];
    _dateImage.image = [UIImage imageNamed:@"date.png"];
    [_dateButton addSubview:_dateImage];
}

- (void)layoutSubviews{
    

    _dateButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _dateLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_dateButton.frame)*5/6, self.frame.size.height);

    _dateImage.frame = CGRectMake(CGRectGetMaxX(_dateLabel.frame), CGRectGetMinY(_dateLabel.frame)+10, CGRectGetWidth(_dateButton.frame)/6 -10, CGRectGetHeight(_dateLabel.frame)-20);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
