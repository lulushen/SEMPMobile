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
        self.frame = CGRectMake(0, 0, Kwidth*2/5, 44);
        
        //        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.png"]]];
        [self p_makeDateview];
        
    }
    return self;
}
- (void)p_makeDateview
{
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*5/6, self.frame.size.height)];
    _dateLabel.backgroundColor = [UIColor redColor];
    _dateLabel.text  = @"2016年7月";
    [_dateLabel setTextAlignment:NSTextAlignmentCenter];
    _dateLabel.textColor = [UIColor whiteColor];
    [self addSubview:_dateLabel];
    _dateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _dateButton.frame = CGRectMake(CGRectGetMaxX(_dateLabel.frame), CGRectGetMinY(_dateLabel.frame), self.frame.size.width/6, CGRectGetHeight(_dateLabel.frame));
    _dateButton.backgroundColor = [UIColor grayColor];
    [_dateButton setTitle:@"历" forState:UIControlStateNormal];
      [self addSubview:_dateButton];
    _dataSearchView = [[SDDataSearchView alloc] init];
   _dataSearchView.frame = CGRectMake(CGRectGetWidth(self.frame)/2.0 - Kwidth*2/5.0, CGRectGetMaxY(self.frame), Kwidth*4/5.0, Kheight*7/16.0);
   [_dataSearchView.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_dateButton addTarget:self action:@selector(dataClick:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)dataClick:(UIButton *)button
{
    [self addSubview:_dataSearchView];

    if (button.selected) {
        

        _dataSearchView.hidden = YES;
        button.selected = NO;
        NSLog(@"button.selected : %d",button.selected);
        
    }else{

        [button setTitle:@"展" forState:UIControlStateSelected];
        _dataSearchView.hidden = NO;
        button.selected = YES;
        NSLog(@"button.selected-=-= : %d",button.selected);
        
        
    }
}

- (void)deleteButtonClick:(UIButton *)button
{
    _dataSearchView.hidden = YES;

    NSLog(@"-=-=delete-=-=-");
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
