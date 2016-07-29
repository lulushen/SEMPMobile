//
//  SDDataSearchView.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/27.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDDataSearchView : UIView

@property (nonatomic , strong) UIButton * dayButton;
@property (nonatomic , strong) UIButton * mouthButton;
@property (nonatomic , strong) UIButton * yearButton;
@property (nonatomic , strong) UIButton * okButton;
@property (nonatomic , strong) UIButton * deleteButton;

@property (strong, nonatomic)  UIPickerView *myPickerView;
@property (strong, nonatomic)  UILabel *dateLabel;

@property (strong, nonatomic) NSMutableArray *arrayYears;
@property (strong, nonatomic) NSMutableArray *arrayMonths;
@property (strong, nonatomic) NSMutableArray *arrayDays;

@property (copy, nonatomic) NSString *strYear;      //  年
@property (copy, nonatomic) NSString *strMonth;     //  月
@property (copy, nonatomic) NSString *strDay;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;


@end
