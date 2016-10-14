//
//  ReportTableViewCell.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/10.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewCell : UITableViewCell
// title
@property (nonatomic , strong)UILabel * titleLabel;
//日期
@property (nonatomic , strong)UILabel * dateLabel;
// 关注按钮
@property (nonatomic , strong)UIButton * concernButton;
// 按钮
@property (nonatomic , strong)UIButton * detailButton;
//分割线label
@property (nonatomic , strong)UILabel * lineLabel;

@end
