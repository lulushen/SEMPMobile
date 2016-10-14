//
//  AllReportCollectionViewCell.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/10.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllReportCollectionViewCell : UICollectionViewCell
// 图片
@property (nonatomic , strong)UIImageView * imageView;
// title
@property (nonatomic , strong)UILabel * titleLabel;
// 关注按钮
@property (nonatomic , strong)UIButton * concernButton;
// 按钮
@property (nonatomic , strong)UIButton * detailButton;

@end
