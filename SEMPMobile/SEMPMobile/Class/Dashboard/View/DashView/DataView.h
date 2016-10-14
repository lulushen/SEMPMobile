//
//  DataView.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/27.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSearchView.h"
#import "DashBoardViewController.h"

@interface DataView : UIView
@property (nonatomic , strong) UILabel * dateLabel;
@property (nonatomic , strong) UIImageView * dateImage;
@property (nonatomic , strong) UIButton * dateButton;
@property (nonatomic , strong) DataSearchView * dataSearchView;
//@property (nonatomic , strong) DashBoardViewController * dashVC;
@end
