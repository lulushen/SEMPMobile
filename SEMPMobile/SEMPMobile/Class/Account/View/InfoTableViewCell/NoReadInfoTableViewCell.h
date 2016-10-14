//
//  NoReadInfoTableViewCell.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoReadInfoTableViewCell : UITableViewCell

@property (nonatomic , strong)UIImageView * infoImageView;

@property (nonatomic , strong)UILabel * infoTitleLabel;

@property (nonatomic , strong)UILabel * infoDateLabel;

@property (nonatomic , strong)UILabel * infoLabel;

//@property (nonatomic , strong)UILabel * lineLabel;

@property (nonatomic , assign)CGRect rectTitle;

@property (nonatomic , assign)CGRect rectDate;



@end
