//
//  SDXiangqingViewController.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/18.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "RootViewController.h"
#import "D3RecordButton.h"
#import "IncomeDashModel.h"

@interface SDIncomeViewController : RootViewController <D3RecordDelegate,UIActionSheetDelegate,UMSocialUIDelegate,UMSocialDataDelegate>
{
    AVAudioPlayer *play;
}
//// block日期传值到DashBoardVC
//@property (nonatomic , copy) void (^IncomeDateBlockValue)(NSString * IncomeDateString,NSString * DefaultDateString);

// _dateview上的日期 从DashBoardVC传值
@property (nonatomic , strong) NSString * IncomeDateString;
// 打开日期选择器时的默认日期 从DashBoardVC传值
@property (nonatomic , strong) NSString * IncomeDefaultDateString;

//进入指标详情界面中的指标model
@property (nonatomic , strong) IncomeDashModel * incomeDashModel;
//被点击的指标id
@property (nonatomic , strong) NSString * IndexID;

@property (nonatomic , strong) NSMutableArray * pieColorArray;

@end
