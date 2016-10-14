//
//  IncomeTableViewChartCell.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeTableViewChartCell : UITableViewCell
// 分割线
@property (nonatomic , strong)UILabel * label;
// 颜色
@property (nonatomic , strong)UILabel * defaultvalColorLabel;
// 对比颜色
@property (nonatomic , strong)UILabel * contrastvalColorLabel;
// 实际值button
@property (nonatomic , strong)UIButton * defaultvalButton;
// 对比值button
@property (nonatomic , strong)UIButton * contrastvalButton;
// 图view
@property (nonatomic , strong)UIView * chartView;

@property (nonatomic , strong)UIScrollView * scrollView;

@end
