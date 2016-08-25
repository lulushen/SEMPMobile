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
@property (nonatomic , strong)UILabel * midvalColorLabel;
// 对比颜色
@property (nonatomic , strong)UILabel * bottomvalColorLabel;
// 实际值title
@property (nonatomic , strong)UILabel * midvalTitleLabel;
// 对比值title
@property (nonatomic , strong)UILabel * bottomTitleLabel;
// 图view
@property (nonatomic , strong)UIView * chartView;

@property (nonatomic , strong)UIScrollView * scrollView;

@end
