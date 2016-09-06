//
//  ActionIncomeSubView.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/5.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionIncomeSubView : UIView
@property  (nonatomic , strong) UIImageView * imageIncomeActionView;
@property (nonatomic , strong) UILabel  * actionFuBuTitleLabel;
@property (nonatomic , strong) UILabel  * actionFuBuPersonLabel;
@property (nonatomic , strong) UILabel * actionStatuLabel;

@property (nonatomic , strong) UILabel * chuangJianDataTitleLabel;
@property (nonatomic , strong) UILabel * jieZhiDataTitleLabel;

@property (nonatomic , strong) UILabel * chuangJianDataStringLabel;
@property (nonatomic , strong) UIButton * jieZhiDataStringButton;

@property (nonatomic , strong) UIButton * oneButton;
@property (nonatomic , strong) UIButton * twoButton;

// 编辑的时候的界面
@property (nonatomic , strong) UIView * taskEditView;

@property (nonatomic , strong) UILabel * lineLabel;


@end
