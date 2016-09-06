//
//  AddActionSelectTableViewCell.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/24.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddActionSelectTableViewCell : UITableViewCell
// 选中button
@property (nonatomic , strong) UIButton * selectButton;
// 相关指标的title或者带选中的相关协助人和负责人
@property (nonatomic , strong) UILabel * titleLabel;

@property (nonatomic , strong)NSString * userID;

@property (nonatomic , strong)NSString * indexID;
@end
