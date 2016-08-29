//
//  DataSearchView.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/27.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataSearchView : UIView

@property (nonatomic , strong) UIButton * dayButton;
@property (nonatomic , strong) UIButton * mouthButton;
@property (nonatomic , strong) UIButton * yearButton;
@property (nonatomic , strong) UIButton * okButton;
@property (nonatomic , strong) UIButton * deleteButton;

@property (strong, nonatomic)  UIPickerView *myPickerView;
@property (strong, nonatomic)  UILabel *dateLabel;
// 日期选择器最终确定的日期
@property (nonatomic , strong) NSString * dateString;
// 打开日期选择器时的默认日期
@property (nonatomic , strong) NSString * defaultDateString;
- (void)mouthButtonClick:(UIButton *)button;

@end
