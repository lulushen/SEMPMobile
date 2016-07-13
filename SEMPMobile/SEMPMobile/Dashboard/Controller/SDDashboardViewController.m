//
//  SDDashboardViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDDashboardViewController.h"
#import "SDAddViewController.h"

@interface SDDashboardViewController ()

@end

@implementation SDDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar
    UIBarButtonItem * rightButotn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButotn;
    // Do any additional setup after loading the view.
}
- (void)clickRightButton:(UIButton *)button
{
    SDAddViewController * addVC = [[SDAddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
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
