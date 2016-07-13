//
//  SDReportViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDReportViewController.h"
#import "SDReportTableViewCell.h"
#import "SDRTSectionHeaderViewController.h"
#import "SDAddReportViewController.h"


#define  SVCFrame   sectionViewC.view.frame
#define  FootVFrameSize   self.footerView.frame.size

@interface SDReportViewController ()<UITableViewDelegate,UITableViewDataSource>
//报表列表
@property (nonatomic , strong) UITableView * reportTableView;
//footView
@property (nonatomic , strong) UIView * footerView;

@end

@implementation SDReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeReportTable];
}
- (void)makeReportTable
{
    
    self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, KTableViewHeight )  style:(UITableViewStyleGrouped)];
     NSLog(@"=====%f",self.reportTableView.frame.size.height);
    [self.view addSubview:self.reportTableView];
    self.reportTableView.delegate = self;
    self.reportTableView.dataSource = self;
    [self.reportTableView registerClass:[SDReportTableViewCell class] forCellReuseIdentifier:@"ReportCell"];
    
    [self makeFooterView];
    
}
- (void)makeFooterView
{
    self.footerView = [[UIView alloc] init];
    self.footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.reportTableView.frame),CGRectGetHeight(self.reportTableView.frame)/5.0 );
    self.footerView.backgroundColor = [UIColor grayColor];
    self.reportTableView.tableFooterView = self.footerView;
    
    UIButton * AddButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    AddButton.frame = CGRectMake(FootVFrameSize.width/2.0 - FootVFrameSize.width/4.0 , FootVFrameSize.height/4.0 , FootVFrameSize.width/2.0, FootVFrameSize.height/2.0);
    [AddButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(AddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:AddButton];
    
}
- (void)AddButtonClick:(UIButton *)button
{
    SDAddReportViewController * addRVC = [[SDAddReportViewController alloc] init];
    [self.navigationController pushViewController:addRVC animated:YES];
}

// 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDReportTableViewCell * reportCell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell" forIndexPath:indexPath];
    reportCell.textLabel.text = @"测试";
    reportCell.detailTextLabel.text = @"123";
    
    
    return reportCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SDRTSectionHeaderViewController * sectionViewC = [[SDRTSectionHeaderViewController alloc] init];
    CGFloat  SHeight = [self tableView:tableView heightForHeaderInSection:0];
    sectionViewC.view.frame = CGRectMake(0, 0, tableView.frame.size.width, SHeight);
    sectionViewC.sectionTitleButton.frame = CGRectMake(0, 0, CGRectGetWidth(SVCFrame)/3.0, CGRectGetHeight(SVCFrame));
    if (section == 0) {
        
        sectionViewC.moreButton.frame = CGRectMake(CGRectGetMaxX(SVCFrame)-100, CGRectGetMidY(SVCFrame) - CGRectGetHeight(SVCFrame)/4.0, 80, CGRectGetHeight(SVCFrame)/2.0);
        
    }else{
        sectionViewC.moreButton.hidden = YES;
    }
    return sectionViewC.view;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"零售管理";
//    }else if (section == 1) {
//        return @"库存管理";
//    }else{
//        return @"商品管理";
//    }
//}

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
