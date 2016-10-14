//
//  SetTableViewCell.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/22.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTableViewCell : UITableViewCell

@property (nonatomic , strong)UIImageView * setImageView;
//设置的text
@property (nonatomic , strong)UILabel * setTitleLabel;

@property (nonatomic , strong)UILabel * setDetailLabel;
@property (nonatomic , strong)UILabel * line;

@end
