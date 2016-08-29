//
//  ActionIncomeTableViewCell.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionIncomeTableViewCell : UITableViewCell

@property  (nonatomic , strong) UIImageView * imageIncomeActionView;
@property (nonatomic , strong) UILabel  * actionFuBuTitleLabel;
@property (nonatomic , strong) UILabel  * actionFuBuPersonLabel;
@property (nonatomic , strong) UILabel * actionStatuLabel;

@property (nonatomic , strong) UILabel * chuangJianDataTitleLabel;
@property (nonatomic , strong) UILabel * jieZhiDataTitleLabel;

@property (nonatomic , strong) UILabel * chuangJianDataStringLabel;
@property (nonatomic , strong) UILabel * jieZhiDataStringLabel;

@property (nonatomic , strong) UIButton * oneButton;
@property (nonatomic , strong) UIButton * twoButton;

@end
