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
#import "SDReportDetailViewController.h"


#define  KSVCFrame   sectionViewC.view.frame
#define  KFootVFrameSize   self.footerView.frame.size

@interface SDReportViewController ()<UITableViewDelegate,UITableViewDataSource>
// 报表列表
@property (nonatomic , strong) UITableView * reportTableView;
// footView
@property (nonatomic , strong) UIView * footerView;
// 分区的数组
@property (nonatomic , strong) NSMutableArray * sectionCountArray;
// 分区中cell 的数组
@property (nonatomic ,strong) NSMutableArray * sectionRowCellArray;

@end

@implementation SDReportViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeReportTable];
}
- (void)makeReportTable
{
    
    self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, KTableViewHeight + KSNHeight)  style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.reportTableView];
    self.reportTableView.delegate = self;
    self.reportTableView.dataSource = self;
    [self.reportTableView registerClass:[SDReportTableViewCell class] forCellReuseIdentifier:@"ReportCell"];
    [self makeFooterView];
    
}
- (void)makeFooterView
{
    self.footerView = [[UIView alloc] init];
    self.footerView.frame = CGRectMake(0, 0, Kwidth,KTableViewHeight/5.0);
    self.footerView.backgroundColor = [UIColor grayColor];
    self.reportTableView.tableFooterView = self.footerView;
    UIButton * AddButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    AddButton.frame = CGRectMake(KFootVFrameSize.width/2.0 - KFootVFrameSize.width/4.0 , KFootVFrameSize.height/4.0 , KFootVFrameSize.width/2.0, KFootVFrameSize.height/2.0);
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
    self.sectionCountArray = [[NSMutableArray alloc] initWithObjects:@"1",@"",@"", nil];
    return self.sectionCountArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.sectionRowCellArray = [[NSMutableArray alloc] initWithObjects:@"1",@"",@"",@"", nil];
    return self.sectionRowCellArray.count;
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
    return 40*KHeight6scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01*KHeight6scale;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SDRTSectionHeaderViewController * sectionViewC = [[SDRTSectionHeaderViewController alloc] init];
    CGFloat  SHeight = [self tableView:tableView heightForHeaderInSection:0];
    sectionViewC.view.frame = CGRectMake(0, 0, tableView.frame.size.width, SHeight);
    sectionViewC.sectionTitleButton.frame = CGRectMake(0, 0, CGRectGetWidth(KSVCFrame)/3.0, CGRectGetHeight(KSVCFrame));
    // 分区头部按钮的点击方法
//    [sectionViewC.sectionTitleButton addTarget:self action:@selector(sectionTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    sectionViewC.sectionTitleButton.selected = NO;
  
    
    if (section == 0) {
        
        sectionViewC.moreButton.frame = CGRectMake(CGRectGetMaxX(KSVCFrame)-100*KWidth6scale, CGRectGetMidY(KSVCFrame) - CGRectGetHeight(KSVCFrame)/4.0, 80*KWidth6scale, CGRectGetHeight(KSVCFrame)/2.0);
        
    }else{
        sectionViewC.moreButton.hidden = YES;
    }
    return sectionViewC.view;
}
//- (void)sectionTitleButtonClick:(UIButton *)button{
//    if (button.selected == NO) {
//        button.selected = YES;
//        self.sectionRowCellArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
//    }else{
//        button.selected = NO;
//        
//    }
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDReportDetailViewController * reportDetailVC = [[SDReportDetailViewController alloc] init];
    reportDetailVC.titleString = @"123";
    [self.navigationController pushViewController:reportDetailVC animated:YES];
    
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
