//
//  DatePickerView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/27.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DatePickerView.h"
@interface DatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@end
@implementation DatePickerView
{
    NSMutableArray * yearArray;
    NSArray        * monthArray;
    NSMutableArray * monthMutableArray;
    NSMutableArray * DaysMutableArray;
    NSMutableArray * DaysArray;
    NSString       * currentMonthString;
    UIImageView    * bgImageView;
    NSMutableArray * quarterMutableArray;
    NSMutableArray * weekMutableArray;
    NSString       * currentQuarterString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    NSInteger selectedQuarterRow;
    NSInteger selectedWeekRow;
    
    BOOL firstTimeLoad;
    
    NSInteger m ;
    int year;
    int month;
    int day;
    int quarter;
    int week;
    int yearDaysCount;
    int number;
    // 默认日期年月日
    NSInteger  yearNumeber;
    NSInteger  mouthNumber;
    NSInteger  DayNumber;
    NSInteger  weekNumber;
    NSInteger  quarterNumber;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        _defaultDateString = [NSString string];
        [self makePickerView];
        
    }
    return self;
}
- (void)makePickerView
{
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
}
// 进入日期选择器时的默认日期，年，月，日（从DataView界面传值过来的）
- (void)makeDefaultDate
{
    
    if ([_defaultDateString rangeOfString:@"Q"].location != NSNotFound) {
        
        NSRange rangeYear = [_defaultDateString rangeOfString:@"Q"];//匹配得到的下标
        yearNumeber = [[_defaultDateString substringWithRange:NSMakeRange(0, 4)] intValue];
        quarterNumber = [[_defaultDateString substringWithRange:NSMakeRange(rangeYear.location+1, _defaultDateString.length-5)] intValue];
        
    }else if([_defaultDateString rangeOfString:@"W"].location != NSNotFound){
        
        NSRange rangeYear = [_defaultDateString rangeOfString:@"W"];//匹配得到的下标
        yearNumeber = [[_defaultDateString substringWithRange:NSMakeRange(0, 4)] intValue];
        weekNumber = [[_defaultDateString substringWithRange:NSMakeRange(rangeYear.location+1, _defaultDateString.length-5)] intValue];
        
    }else{
        
        // 根据日期字符串长度 判断默认日期的年月日
        // 默认仅有年
        if (_defaultDateString.length <= 5) {
            
            yearNumeber = [[_defaultDateString substringWithRange:NSMakeRange(0, 4)] intValue];
        }
        // 默认仅有年月
        if (_defaultDateString.length > 5 && _defaultDateString.length < 8) {
            NSRange rangeYear = [_defaultDateString rangeOfString:@"-"];//匹配得到的下标
            yearNumeber = [[_defaultDateString substringWithRange:NSMakeRange(0, 4)] intValue];
            mouthNumber = [[_defaultDateString substringWithRange:NSMakeRange(rangeYear.location+1, _defaultDateString.length-5)] intValue];
            
        }
        // 默认年月日
        if (_defaultDateString.length >= 8) {
            NSRange rangeYear = [_defaultDateString rangeOfString:@"-"];//匹配得到的下标
            NSString * string = [_defaultDateString stringByReplacingCharactersInRange:rangeYear withString:@"+"];
            
            NSRange rangeMouth = [string rangeOfString:@"-"];//匹配得到的下标
            //            NSUInteger lenghtMouth = rangeMouth.location - rangeYear.location;// 月截取的长度
            
            yearNumeber = [[_defaultDateString substringWithRange:NSMakeRange(0, 4)] intValue];
            
            mouthNumber = [[_defaultDateString substringWithRange:NSMakeRange(rangeYear.location+1, 2)] intValue];
            DayNumber = [[_defaultDateString substringWithRange:NSMakeRange(rangeMouth.location+1, _defaultDateString.length-(rangeMouth.location+1))] intValue];
            
        }
        
    }
}
- (void)makedata
{
    yearArray = [[NSMutableArray alloc]init];
    monthMutableArray = [[NSMutableArray alloc]init];
    DaysMutableArray= [[NSMutableArray alloc]init];
    quarterMutableArray = [[NSMutableArray alloc] init];
    weekMutableArray = [[NSMutableArray alloc] init];
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
    
    // Get Current  Quarter
    
    //    [formatter setDateFormat:@"QM"];
    //
    //    currentQuarterString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    //    quarter =[currentQuarterString intValue];
    
    // Get Current Week
    [formatter setDateFormat:@"w"];
    
    NSString *currentWeekString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    
    week =[currentWeekString intValue];
    
    for (int i = 1900; i <= year ; i++)
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
    
    for (int i = 1; i <= 4; i++)
    {
        
        [quarterMutableArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    if(((year %4==0)&&(year %100!=0))||(year %400==0)){
        yearDaysCount = 366;
    }
    else
    {
        yearDaysCount = 365;
    }
    for (int i = 1; i <=(int)(yearDaysCount/7)+1 ; i++) {
        
        [weekMutableArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    // PickerView - Default Selection as per current Date
    // 设置初始默认值
    // [_myPickerView selectRow:20 inComponent:0 animated:YES];
    
    
}
- (void)makeYearPicker
{
    number = 1;
    [self makedata];
    [self makeDefaultDate];
    // 进入日期选择器是的默认日期
    [self selectRow:yearNumeber-1900 inComponent:0 animated:YES];
}
- (void)makeYearMouthPicker
{
    // 点击nav上的日期是more选中月按钮
    //    [self layoutSubviews];
    number = 2;
    // 此方法是创建日期选择器
    [self makedata];
    // 进入日期选择器时的默认日期，年，月，日（从DataView界面传值过来的）
    [self makeDefaultDate];
    NSLog(@"%@",_defaultDateString);
    
    // 进入日期选择器是的默认日期
    [self selectRow:yearNumeber-1900 inComponent:0 animated:NO];
    [self selectRow:mouthNumber-1 inComponent:1 animated:NO];
}
- (void)makeYearMouthDayPicker
{
    number = 3;
    [self makedata];
    [self makeDefaultDate];
    // 进入日期选择器是的默认日期
    [self selectRow:yearNumeber-1900 inComponent:0 animated:NO];
    
    [self selectRow:mouthNumber-1 inComponent:1 animated:NO];
    
    [self selectRow:DayNumber-1 inComponent:2 animated:NO];
    
}

// year quarter
- (void)makeQuarterPicker
{
    number = 4;
    [self makedata];
    [self makeDefaultDate];
    // 进入日期选择器是的默认日期
    [self selectRow:yearNumeber-1900 inComponent:0 animated:NO];
    
    [self selectRow:quarterNumber-1 inComponent:1 animated:NO];
    
}
// year week
- (void)makeYearWeekPicker
{
    number = 5;
    [self makedata];
    [self makeDefaultDate];
    // 进入日期选择器是的默认日期
    [self selectRow:yearNumeber-1900 inComponent:0 animated:NO];
    
    [self selectRow:weekNumber-1 inComponent:1 animated:NO];
    
}
#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m = row;
    
    if (component == 0)
    {
        selectedYearRow = row;
        [self reloadAllComponents];
    }
    else if (component == 1)
    {
        if ((number == 2) | (number == 3)) {
            selectedMonthRow = row;
        }else if(number == 4 ){
            selectedQuarterRow = row;
        }else if (number == 5){
            selectedWeekRow = row;
        }
        
        [self reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [self reloadAllComponents];
        
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
        CGRect frame = CGRectMake(0.0, 0.0, 80, 80);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:22.0f]];
    }
    if (component == 0)
    {
        //        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
        pickerLabel.text = [NSString stringWithFormat:@"%@年",[yearArray objectAtIndex:row]];
    }
    else if (component == 1)
    {
        //        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
        if ((number == 2) | (number == 3)) {
            pickerLabel.text = [NSString stringWithFormat:@"%@月",[monthArray objectAtIndex:row]];
            
        }else if(number == 4){
            
            pickerLabel.text = [NSString stringWithFormat:@"第%@季度",[quarterMutableArray objectAtIndex:row]];
            
        }else if (number == 5){
            pickerLabel.text = [NSString stringWithFormat:@"第%@周",[weekMutableArray objectAtIndex:row]];
            
        }
        
    }
    else if (component == 2)
    {
        //        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        pickerLabel.text = [NSString stringWithFormat:@"%@日",[DaysArray objectAtIndex:row]];
        
    }
    return pickerLabel;
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ((number == 2) | (number == 4) | (number == 5)){
        return 2;
    }else {
        return number;
    }
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
        n= year-1900;
        if ((number == 2 )| (number == 3)) {
            
            if (selectRow==n) {
                
                return [monthMutableArray count];
            }else
            {
                return [monthArray count];
                
            }
        }else if (number == 4){
            
            return [quarterMutableArray count];
        }else  if(number == 5){
            
            return [weekMutableArray count];
            
            
        }else{
            return 0;
        }
    }
    else
    {
        NSInteger selectRow1 =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1900;
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

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (number == 1) {
        return 100  ;
    }else if ((number == 2) | (number == 4) | (number == 5)){
        return 120;
    }else {
        return 70;
    }
    
}

- (NSString *)saveDateString
{
    if (number == 1) {
        _dateString = [NSString stringWithFormat:@"%@",[yearArray objectAtIndex:[self selectedRowInComponent:0]]];
        
    }else if (number == 2){
        _dateString = [NSString stringWithFormat:@"%@-%@",[yearArray objectAtIndex:[self selectedRowInComponent:0]],[monthArray objectAtIndex:[self selectedRowInComponent:1]]];
        
    }else if(number == 3){
        _dateString = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[self selectedRowInComponent:0]],[monthArray objectAtIndex:[self selectedRowInComponent:1]],[DaysArray objectAtIndex:[self selectedRowInComponent:2]]];
        
    }else if(number == 4){
        _dateString = [NSString stringWithFormat:@"%@Q%@",[yearArray objectAtIndex:[self selectedRowInComponent:0]],[quarterMutableArray objectAtIndex:[self selectedRowInComponent:1]]];
    }else if (number == 5){
        _dateString = [NSString stringWithFormat:@"%@W%@",[yearArray objectAtIndex:[self selectedRowInComponent:0]],[weekMutableArray objectAtIndex:[self selectedRowInComponent:1]]];
        
    }
    
    return _dateString;
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
