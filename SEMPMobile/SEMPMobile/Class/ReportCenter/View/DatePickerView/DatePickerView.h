//
//  DatePickerView.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/27.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIPickerView
// 日期选择器最终确定的日期
@property (nonatomic , strong) NSString * dateString;
// 打开日期选择器时的默认日期
@property (nonatomic , strong) NSString * defaultDateString;

//year
- (void)makeYearPicker;
//year mouth
- (void)makeYearMouthPicker;
// year mouth day
- (void)makeYearMouthDayPicker;
// year quarter
- (void)makeQuarterPicker;
// year week
- (void)makeYearWeekPicker;
//返回选择的日期
- (NSString *)saveDateString;


@end
