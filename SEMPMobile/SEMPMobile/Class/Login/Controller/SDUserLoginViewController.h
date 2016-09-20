//
//  SDUserLoginViewController.h
//  SempMobile
//
//  Created by 上海数聚 on 16/7/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SDUserLoginViewController : UIViewController

// 企业标示码
@property (nonatomic , strong) UITextField * biaoshiTextField;
// 用户名
@property (nonatomic , strong) UITextField * userTextField;
// 用户密码
@property (nonatomic , strong) UITextField * passWordTextField;
// 登录按钮
@property (nonatomic , strong) UIButton * LoginButton;

@end
