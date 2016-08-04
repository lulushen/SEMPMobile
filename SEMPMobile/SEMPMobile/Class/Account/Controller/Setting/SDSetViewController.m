//
//  SDSetViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/11.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDSetViewController.h"

@interface SDSetViewController ()

@end

@implementation SDSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    [self makeSettingView];
    
    // Do any additional setup after loading the view.
}

- (void)makeSettingView
{
    
    
    UILabel * passLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width - 100*KWidth6scale, 50*KHeight6scale)];
    passLabel.backgroundColor = [UIColor grayColor];
    [passLabel setText:@"开启手势密码"];
    [self.view addSubview:passLabel];
    
    
    
}
- (void)switchButtonClick:(UIButton *)button
{
    
    NSLog(@"---------开启手势密码");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
