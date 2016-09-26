//
//  ReadedTableViewCell.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/9/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadedTableViewCell : UITableViewCell
@property (nonatomic , strong)UIImageView * infoImageView;

@property (nonatomic , strong)UILabel * infoTitleLabel;

@property (nonatomic , strong)UILabel * infoDateLabel;

@property (nonatomic , strong)UILabel * infoLabel;

//@property (nonatomic , strong)UILabel * lineLabel;

@property (nonatomic , assign)CGRect rectTitle;

@property (nonatomic , assign)CGRect rectDate;

@property (nonatomic , strong)UIView * readedView;
@property (nonatomic , strong)UIImageView * hornImageView;
@property (nonatomic , strong)UIImageView * senderImageView;
@property (nonatomic , strong)UILabel * senderTitleLabel;
@property (nonatomic , strong)UILabel * senderLabel;

@property (nonatomic , strong)UIImageView * connectImageView;

@property (nonatomic , strong)UIImageView * receiveImageView;
@property (nonatomic , strong)UILabel * receiveTitleLabel;
@property (nonatomic , strong)UILabel * receiveLabel;

@property (nonatomic , strong)UILabel * contentTitleLabel;
@property (nonatomic , strong)UILabel * contentLabel;

@end
