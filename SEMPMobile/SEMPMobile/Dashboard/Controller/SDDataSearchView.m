//
//  SDDataSearchView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/27.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDDataSearchView.h"
#import "NSDate+YN.h"
#import "UIPickerView+YLT.h"
#import "PickerCell.h"

@interface SDDataSearchView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@end
@implementation SDDataSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self p_makeview];
        
    }
    return self;
}
- (void)p_makeview
{

    _yearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _yearButton.frame = CGRectMake(0, 10, Kwidth/5.0, 50);
    _yearButton.backgroundColor = [UIColor redColor];
    NSLog(@"%@",_yearButton);
    [_yearButton setTitle:@"年" forState:UIControlStateNormal];
    [self addSubview:_yearButton];
    [_yearButton addTarget:self action:@selector(yearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _mouthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _mouthButton.frame = CGRectMake(CGRectGetMaxX(_yearButton.frame), CGRectGetMinY(_yearButton.frame), CGRectGetWidth(_yearButton.frame), CGRectGetHeight(_yearButton.frame));
    [_mouthButton setTitle:@"月" forState:UIControlStateNormal];
    _mouthButton.backgroundColor = [UIColor redColor];
    [self addSubview:_mouthButton];
    [_mouthButton addTarget:self action:@selector(mouthButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    _dayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _dayButton.frame = CGRectMake( CGRectGetMaxX(_mouthButton.frame), CGRectGetMinY(_mouthButton.frame), CGRectGetWidth(_mouthButton.frame), CGRectGetHeight(_mouthButton.frame));
    [_dayButton setTitle:@"日" forState:UIControlStateNormal];
    _dayButton.backgroundColor = [UIColor grayColor];
    [self addSubview:_dayButton];
    [_dayButton addTarget:self action:@selector(dayButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    

    _okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _okButton.frame = CGRectMake(CGRectGetMaxX(_dayButton.frame), CGRectGetMinY(_dayButton.frame), Kwidth*4/5.0 - Kwidth*3/5.0, CGRectGetHeight(_dayButton.frame));
    [_okButton setTitle:@"ok" forState:UIControlStateNormal];
//    _okButton.backgroundColor = [UIColor redColor];
    [self addSubview:_okButton];
    [_okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _deleteButton.frame = CGRectMake(0, Kheight*7/16 - 50, Kwidth*4/5, CGRectGetHeight(_dayButton.frame));
    [_deleteButton setTitle:@"delete" forState:UIControlStateNormal];
    _deleteButton.backgroundColor = [UIColor redColor];
    _deleteButton.userInteractionEnabled = YES;
    [self addSubview:_deleteButton];
    

    _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_yearButton.frame), CGRectGetMaxY(_yearButton.frame), Kwidth*4/5, Kheight*7/16.0-100)];
    _myPickerView.userInteractionEnabled = YES;
    _myPickerView.backgroundColor = [UIColor grayColor];
    [self addSubview:_myPickerView];
    [self makedataview];
}
- (void)yearButtonClick:(UIButton *)button
{
    NSLog(@"-=-=nian-=-=-");
    
}
- (void)mouthButtonClick:(UIButton *)button
{
    NSLog(@"-=-=yue-=-=-");

}
- (void)dayButtonClick:(UIButton *)button
{
    NSLog(@"-=-=day-=-=-");

}
- (void)okButtonClick:(UIButton *)button
{
 
    NSLog(@"-=-=-obbutton=-=-");

}

- (NSMutableArray *)arrayYears
{
    if (!_arrayYears) {
        _arrayYears = [NSMutableArray array];
        
        for (int i = 1; i < 10000; i++) {
            NSString *strYear = [NSString stringWithFormat:@"%04i", i];
            [_arrayYears addObject:strYear];
        }
    }
    
    return _arrayYears;
}

- (NSMutableArray *)arrayMonths
{
    if (!_arrayMonths) {
        _arrayMonths = [NSMutableArray array];
        
        for (int i = 1; i <= 12; i++) {
            NSString *str = [NSString stringWithFormat:@"%02i", i];
            [_arrayMonths addObject:str];
        }
    }
    
    return _arrayMonths;
}

- (NSMutableArray *)arrayDays
{
    if (!_arrayDays) {
        _arrayDays = [NSMutableArray array];
    }
    
    return _arrayDays;
}

- (void)makedataview {
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyyMM";
    
    NSInteger allDays = [self totaldaysInMonth:[NSDate date]];
    for (int i = 1; i <= allDays; i++) {
        NSString *strDay = [NSString stringWithFormat:@"%02i", i];
        [self.arrayDays addObject:strDay];
    }
    
    self.myPickerView.delegate = self;
    self.myPickerView.dataSource = self;
    
    //  更新年
    NSInteger currentYear = [[NSDate date] getYear];
    NSString *strYear = [NSString stringWithFormat:@"%04li", currentYear];
    NSInteger indexYear = [self.arrayYears indexOfObject:strYear];
    if (indexYear == NSNotFound) {
        indexYear = 0;
    }
    [self.myPickerView selectRow:indexYear inComponent:0 animated:YES];
    self.strYear = self.arrayYears[indexYear];;
    
    //  更新月份
    NSInteger currentMonth = [[NSDate date] getMonth];
    NSString *strMonth = [NSString stringWithFormat:@"%02li", currentMonth];
    NSInteger indexMonth = [self.arrayMonths indexOfObject:strMonth];
    if (indexMonth == NSNotFound) {
        indexMonth = 0;
    }
    [self.myPickerView selectRow:indexMonth inComponent:1 animated:YES];
    self.strMonth = self.arrayMonths[indexMonth];
    
    //  更新日
    NSInteger currentDay = [[NSDate date] getDay];
    NSString *strDay = [NSString stringWithFormat:@"%02li", currentDay];
    NSInteger indexDay = [self.arrayDays indexOfObject:strDay];
    if (indexDay == NSNotFound) {
        indexDay = 0;
    }
    [self.myPickerView selectRow:indexDay inComponent:2 animated:YES];
    self.strDay = self.arrayDays[indexDay];
    
    [self updateLabelText];
    [self.myPickerView clearSpearatorLine];
}

#pragma mark - 计算出当月有多少天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - UIPickerView DataSource and Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayYears.count;
    } else if (component == 1) {
        return self.arrayMonths.count;
    } else {
        return self.arrayDays.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (component == 0) {
        PickerCell *cell = [PickerCell cellWithName:self.arrayYears[row]];
        return cell;
    } else if (component == 1) {
        PickerCell *cell = [PickerCell cellWithName:self.arrayMonths[row]];
        return cell;
    } else {
        PickerCell *cell = [PickerCell cellWithName:self.arrayDays[row]];
        return cell;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.strYear = self.arrayYears[row];
    } else if (component == 1) {
        self.strMonth = self.arrayMonths[row];
    } else {
        self.strDay = self.arrayDays[row];
    }
    
    [self updateLabelText];
    
    if (component != 2) {
        NSString *strDate = [NSString stringWithFormat:@"%@%@", self.strYear, self.strMonth];
        [self upDateCurrentAllDaysWithDate:[self.dateFormatter dateFromString:strDate]];
    }
}

#pragma mark - 更新当前label的日期
- (void)updateLabelText
{
    self.dateLabel.text = [NSString stringWithFormat:@"%@年%@月%@日", self.strYear, self.strMonth, self.strDay];
}

#pragma mark - 更新选中的年、月份时的日期
- (void)upDateCurrentAllDaysWithDate:(NSDate *)currentDate
{
    [self.arrayDays removeAllObjects];
    
    NSInteger allDays = [self totaldaysInMonth:currentDate];
    for (int i = 1; i <= allDays; i++) {
        NSString *strDay = [NSString stringWithFormat:@"%02i", i];
        [self.arrayDays addObject:strDay];
    }
    
    [self.myPickerView reloadComponent:2];
    
    //  更新日
    NSInteger indexDay = [self.arrayDays indexOfObject:self.strDay];
    if (indexDay == NSNotFound) {
        indexDay = (self.arrayDays.count - 1) > 0 ? (self.arrayDays.count - 1) : 0;
    }
    [self.myPickerView selectRow:indexDay inComponent:2 animated:YES];
    self.strDay = self.arrayDays[indexDay];
    
    [self updateLabelText];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
