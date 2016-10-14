//
//  DashCollectionReusableView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/16.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DashCollectionReusableView.h"

@implementation DashCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self p_setupView];
        
    }
    return self;
}
- (void)p_setupView
{
    _labelimage = [[UIImageView alloc] init];
    
    _labelimage.image = [UIImage imageNamed:@"report_normal.png"];
    
    _labelTitle = [[UILabel alloc] init];
    
    _moreButton = [[UIButton alloc] init];
    
    _labelTitle.text = @"指标看板";
   
    
    [self addSubview:_labelimage];
    
    [self addSubview:_labelTitle];
    
    
    [self addSubview:_moreButton];
    
    _lable = [[UILabel  alloc] init];
    
    _lable.text = @"Add";
    _lable.font = [UIFont systemFontOfSize:13.0f];
    
    _lable.textColor = MoreButtonColor;
    
    [_lable setTextAlignment:NSTextAlignmentCenter];
    
    [_moreButton addSubview:_lable];
    
    _lable.layer.borderWidth = 1;
    
    _lable.layer.cornerRadius = 5;
    
    _lable.layer.borderColor = [MoreButtonColor CGColor];
//    _labelTitle.backgroundColor = [UIColor redColor];
//    _labelimage.backgroundColor = [UIColor orangeColor];
//    _lable.backgroundColor = [UIColor blueColor];
//    _moreButton.backgroundColor = [UIColor grayColor];
    
}
-(void)layoutSubviews
{
    _labelimage.frame  =  CGRectMake(KBianJu, 5*KHeight6scale, 25*KWidth6scale, 20*KHeight6scale);
    
    _labelTitle.frame = CGRectMake(CGRectGetMaxX(_labelimage.frame)+5*KWidth6scale, CGRectGetMinY(_labelimage.frame), CGRectGetWidth(_labelimage.frame) * 3, CGRectGetHeight(_labelimage.frame));
    
    _lable.frame = CGRectMake(20*KWidth6scale, CGRectGetMidY(_moreButton.frame)-5*KHeight6scale, 60*KWidth6scale, CGRectGetHeight(_moreButton.frame)/2);

    _moreButton.frame = CGRectMake(Main_Screen_Width - 100*KWidth6scale, CGRectGetMinY(self.frame), 150*KWidth6scale, CGRectGetHeight(self.frame));
}
@end
