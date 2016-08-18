//
//  ActionTableViewCell.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/17.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionTableViewCell : UITableViewCell

@property (nonatomic , strong) UILabel * actionTitleLabel;

@property (nonatomic , strong) UILabel * actionDifficultyLabel;

@property (nonatomic , strong) UILabel * actionDateLabel;

@property (nonatomic , strong) UILabel * actionTimeLabel;

@property (nonatomic , strong) UILabel * actionStatuLabel;

@property (nonatomic , strong) UIImageView * actionPersonImage;
//分割线label
@property (nonatomic , strong)UILabel * lineLabel;
@end
