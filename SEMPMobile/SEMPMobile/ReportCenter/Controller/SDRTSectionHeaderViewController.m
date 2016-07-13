//
//  SDRTSectionHeaderViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/13.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDRTSectionHeaderViewController.h"

@interface SDRTSectionHeaderViewController ()

@end

@implementation SDRTSectionHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view .backgroundColor = [UIColor whiteColor];
    [self makeSectionView];
    // Do any additional setup after loading the view.
}
- (void)makeSectionView{
    
    self.sectionTitleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.sectionTitleButton setBackgroundImage:[UIImage imageNamed:@"12.png"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.sectionTitleButton];
    self.moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.moreButton setTitle:@"more" forState:UIControlStateNormal];
    self.moreButton.layer.borderWidth = 1;
    self.moreButton.layer.cornerRadius = 5;
    self.moreButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:self.moreButton];
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
