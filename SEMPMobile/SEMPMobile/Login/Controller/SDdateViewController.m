//
//  SDdateViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/22.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDdateViewController.h"

@interface SDdateViewController ()

@end

@implementation SDdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*3/4.0, self.view.frame.size.height)];
    _dateLabel.backgroundColor = [UIColor redColor];
    _dateLabel.text  = @"2016年7月";
    [self.view addSubview:_dateLabel];
    _dateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _dateButton.frame = CGRectMake(CGRectGetMaxX(_dateLabel.frame), CGRectGetMinY(_dateLabel.frame), self.view.frame.size.width/4.0, CGRectGetHeight(_dateLabel.frame));
    _dateButton.backgroundColor = [UIColor blackColor];
    [_dateButton setTitle:@"date" forState:UIControlStateNormal];
    
    [self.view addSubview:_dateButton];
    // Do any additional setup after loading the view.
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
