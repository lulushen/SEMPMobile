//
//  DataSearchView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/27.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DataSearchView.h"

@interface DataSearchView ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@end
@implementation DataSearchView
{
    
    NSMutableArray * yearArray;
    NSArray        * monthArray;
    NSMutableArray * monthMutableArray;
    NSMutableArray * DaysMutableArray;
    NSMutableArray * DaysArray;
    NSString       * currentMonthString;
    UIImageView    * bgImageView;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
    NSInteger m ;
    int year;
    int month;
    int day;
    int number;
    // 默认日期年月日
    int yearNumeber;
    int  mouthNumber;
    int  DayNumber;
    
    
}
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
//    bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"databgImage.png"]];
    [self addSubview:bgImageView];

    
    _yearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_yearButton setTitle:@"年" forState:UIControlStateNormal];
    [self addSubview:_yearButton];
    [_yearButton addTarget:self action:@selector(yearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _mouthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_mouthButton setTitle:@"月" forState:UIControlStateNormal];
    [self addSubview:_mouthButton];
    [_mouthButton addTarget:self action:@selector(mouthButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _dayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_dayButton setTitle:@"日" forState:UIControlStateNormal];
    [self addSubview:_dayButton];
    [_dayButton addTarget:self action:@selector(dayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self addSubview:_okButton];
    [_okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_deleteButton setTitle:@"关闭" forState:UIControlStateNormal];
    _deleteButton.userInteractionEnabled = YES;
    [self addSubview:_deleteButton];
    
    
    _myPickerView = [[UIPickerView alloc] init];
    _myPickerView.userInteractionEnabled = YES;
    _myPickerView.backgroundColor = [UIColor whiteColor];
    
}
- (void)layoutSubviews{
    bgImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _yearButton.frame = CGRectMake(0, 10, CGRectGetWidth(self.frame)/3.0, 30*KHeight6scale);
    _mouthButton.frame = CGRectMake(CGRectGetMaxX(_yearButton.frame), CGRectGetMinY(_yearButton.frame), CGRectGetWidth(_yearButton.frame), CGRectGetHeight(_yearButton.frame));
    _dayButton.frame = CGRectMake( CGRectGetMaxX(_mouthButton.frame), CGRectGetMinY(_mouthButton.frame), CGRectGetWidth(_mouthButton.frame), CGRectGetHeight(_mouthButton.frame));
    
    _okButton.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 30*KHeight6scale, CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(_dayButton.frame));
    _deleteButton.frame = CGRectMake(CGRectGetMaxX(_okButton.frame), CGRectGetMinY(_okButton.frame), CGRectGetWidth(_okButton.frame), CGRectGetHeight(_yearButton.frame));
    _myPickerView.frame = CGRectMake(CGRectGetWidth(self.frame)/2-CGRectGetWidth(self.frame)*3/8, CGRectGetMaxY(_yearButton.frame), CGRectGetWidth(self.frame)*3/4, CGRectGetHeight(self.frame) - CGRectGetHeight(_yearButton.frame) - CGRectGetMaxY(_yearButton.frame));
    [self addSubview:_myPickerView];
    
}
// 进入日期选择器时的默认日期，年，月，日（从DataView界面传值过来的）
- (void)makeDefaultDate
{
    // 根据日期字符串长度 判断默认日期的年月日
    // 默认仅有年
    if (_defaultDateString.length == 5) {
        yearNumeber = [[_defaultDateString substringWithRange:NSMakeRange(0, 4)] intValue];
    }
    // 默认仅有年月
    if (_defaultDateString.length > 5 && _defaultDateString.length <= 8) {
        NSRange rangeYear = [_defaultDateString rangeOfString:@"年"];//匹配得到的下标
        
        NSRange rangeMouth = [_defaultDateString rangeOfString:@"月"];//匹配得到的下标
        NSUInteger  lenghtMouth = rangeMouth.location - rangeYear.location;// 月截取的长度
        yearNumeber = [[_defaultDateString substringWithRange:NSMakeRange(0, 4)] intValue];
        
        mouthNumber = [[_defaultDateString substringWithRange:NSMakeRange(rangeYear.location+1, lenghtMouth-1)] intValue];
    }
    // 默认年月日
    if (_defaultDateString.length > 8) {
        NSRange rangeYear = [_defaultDateString rangeOfString:@"年"];//匹配得到的下标
        NSRange rangeMouth = [_defaultDateString rangeOfString:@"月"];//匹配得到的下标
        NSRange rangeDay = [_defaultDateString rangeOfString:@"日"];//匹配得到的下标
        NSUInteger lenghtMouth = rangeMouth.location - rangeYear.location;// 月截取的长度
        NSUInteger lenghtDay = rangeDay.location - rangeMouth.location;// 日截取的长度
        yearNumeber = [[_defaultDateString substringWithRange:NSMakeRange(0, 4)] intValue];
        mouthNumber = [[_defaultDateString substringWithRange:NSMakeRange(rangeYear.location+1, lenghtMouth-1)] intValue];
        DayNumber = [[_defaultDateString substringWithRange:NSMakeRange(rangeMouth.location+1, lenghtDay-1)] intValue];
    }
    
    
    
}
- (void)yearButtonClick:(UIButton *)button
{
    
    number = 1;
    [self makedata];
    [self makeDefaultDate];
    // 进入日期选择器是的默认日期
    [_myPickerView selectRow:yearNumeber-1970 inComponent:0 animated:YES];
    
}
- (void)mouthButtonClick:(UIButton *)button
{
    // 点击nav上的日期是more选中月按钮
    [self layoutSubviews];
    number = 2;
    // 此方法是创建日期选择器
    [self makedata];
    // 进入日期选择器时的默认日期，年，月，日（从DataView界面传值过来的）
    [self makeDefaultDate];
    
    // 进入日期选择器是的默认日期
    [_myPickerView selectRow:yearNumeber-1970 inComponent:0 animated:NO];
    [_myPickerView selectRow:mouthNumber-1 inComponent:1 animated:NO];
    
}
- (void)dayButtonClick:(UIButton *)button
{
    number = 3;
    [self makedata];
    [self makeDefaultDate];
    
    // 进入日期选择器是的默认日期
    [_myPickerView selectRow:yearNumeber-1970 inComponent:0 animated:NO];
    
    [_myPickerView selectRow:mouthNumber-1 inComponent:1 animated:NO];
    
    [_myPickerView selectRow:DayNumber-1 inComponent:2 animated:NO];
    
    
}
- (void)makedata
{
    _myPickerView.delegate = self;
    _myPickerView.dataSource = self;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    year =[currentyearString intValue];
    
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    month =[currentMonthString intValue];
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    day =[currentDateString intValue];
    
    yearArray = [[NSMutableArray alloc]init];
    monthMutableArray = [[NSMutableArray alloc]init];
    DaysMutableArray= [[NSMutableArray alloc]init];
    
    for (int i = 1970; i <= year ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    // PickerView -  Months data
    
    
    monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    
    for (int i = 1; i<month+1; i++) {
        [monthMutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }
    for (int i = 1; i <day+1; i++)
    {
        [DaysMutableArray addObject:[NSString stringWithFormat:@"02%d",i]];
        
    }
    // PickerView - Default Selection as per current Date
    // 设置初始默认值
    // [_myPickerView selectRow:20 inComponent:0 animated:YES];
    
    
}

- (void)okButtonClick:(UIButton *)button
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DateChange"];

    if (number == 1) {
        _dateString = [NSString stringWithFormat:@"%@年",[yearArray objectAtIndex:[_myPickerView selectedRowInComponent:0]]];
    }else if (number == 2){
        _dateString = [NSString stringWithFormat:@"%@年%@月",[yearArray objectAtIndex:[_myPickerView selectedRowInComponent:0]],[monthArray objectAtIndex:[_myPickerView selectedRowInComponent:1]]];
    }else if(number == 3){
        _dateString = [NSString stringWithFormat:@"%@年%@月%@日",[yearArray objectAtIndex:[_myPickerView selectedRowInComponent:0]],[monthArray objectAtIndex:[_myPickerView selectedRowInComponent:1]],[DaysArray objectAtIndex:[_myPickerView selectedRowInComponent:2]]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_dateString forKey:@"DateChange"];

    // 发送消息   对应观察者在DashBoard视图中  当日期选择器中的日期确定是发送消息到DataView视图的观察者，在观察者方法中确定nav上label.text值，再把label.text的值赋给_defaultDateString默认日期  下次打开日期选择器的时候就会显示默认日期

    // 发送消息 对应观察者在Income视图中
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DateIncomeChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DateChange" object:nil];

}


#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m = row;
    
    
    
    if (component == 0)
    {
        selectedYearRow = row;
        [_myPickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [_myPickerView reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [_myPickerView reloadAllComponents];
        
    }
    
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return number;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        NSInteger selectRow =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1970;
        if (selectRow==n) {
            return [monthMutableArray count];
        }else
        {
            return [monthArray count];
            
        }
    }
    else
    {
        NSInteger selectRow1 =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1970;
        NSInteger selectRow =  [pickerView selectedRowInComponent:1];
        
        if (selectRow==month-1 &selectRow1==n) {
            
            return day;
            
        }else{
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
                
                
            }
            else
            {
                return 30;
            }
            
            
        }
        
    }
    
    
    
    
    
    
}







/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
