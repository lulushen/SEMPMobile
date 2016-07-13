//
//  SDAccountViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDAccountViewController.h"
#import "SDUserTableViewCell.h"
#import "SDSetViewController.h"
#import "SDInfoViewController.h"
#import "SDFeedBackViewController.h"

@interface SDAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)UITableView * userTableView;
// UITableView头部视图
@property (nonatomic , strong)UIView * userTableHeaderView;
//UITableView头部视图的头像button
@property (nonatomic , strong)UIButton * headerImageButton;

@end

@implementation SDAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeTableView];
    // Do any additional setup after loading the view.
}

- (void)makeTableView{
    
    self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMinY(self.tabBarController.tabBar.frame) - KSTATUSBarFrameHeight) style:(UITableViewStyleGrouped)];
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    [self.view addSubview:self.userTableView];
    self.userTableView.separatorStyle = NO;
    // UITableView头部
    [self makeTableHeaderView];
    [self.userTableView registerClass:[SDUserTableViewCell class] forCellReuseIdentifier:@"CELL"];
}
- (void)makeTableHeaderView
{
    
    self.userTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, self.userTableView.frame.size.width, self.view.frame.size.height/3)];
    self.userTableHeaderView.backgroundColor = [UIColor grayColor];
    self.headerImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.headerImageButton.frame = CGRectMake(self.userTableHeaderView.frame.size.width/2 - 45, 30, 90, 90);
    self.headerImageButton.backgroundColor = [UIColor whiteColor];
    self.headerImageButton.layer.cornerRadius = 45;
    [self.userTableHeaderView addSubview:self.headerImageButton];
    UILabel * userLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userTableHeaderView.frame.size.width/2-100, CGRectGetMaxY(self.headerImageButton.frame) + 10, 100, 30)];
    userLabel.text = @"用户名 :";
    userLabel.textColor = [UIColor whiteColor];
    [userLabel setTextAlignment:NSTextAlignmentRight];
    [self.userTableHeaderView addSubview:userLabel];
    UILabel * jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userTableHeaderView.frame.size.width/2-100, CGRectGetMaxY(userLabel.frame), userLabel.frame.size.width, userLabel.frame.size.height)];
    jobLabel.text = @"职    位 :";
    jobLabel.textColor = [UIColor whiteColor];
    [jobLabel setTextAlignment:NSTextAlignmentRight];
    [self.userTableHeaderView addSubview:jobLabel];
    self.userTableView.tableHeaderView = self.userTableHeaderView;
    self.userTableHeaderView.layer.borderWidth = 1;
    self.userTableHeaderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    
    
}

#pragma mark --- tableView 实现代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"four.png"];
    cell.textLabel.textColor = [UIColor grayColor];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"消息中心";
        UILabel * la = [[UILabel alloc] init];
        la.frame = CGRectMake(cell.frame.size.width/2,cell.frame.size.height/2-cell.frame.size.height/4.0, cell.frame.size.height/2.0,cell.frame.size.height/2.0);
     
        [la setTextColor:[UIColor whiteColor]];
        la.backgroundColor = [UIColor redColor];
        [la setTextAlignment:NSTextAlignmentCenter];
        la.text = @"1";
        [cell.contentView addSubview:la];
        // 设置label的圆角
        la.layer.cornerRadius = cell.frame.size.height/4.0;
        la.clipsToBounds = YES;
        
    }else if ( indexPath.section == 1) {
        cell.textLabel.text = @"设置";
    }else if ( indexPath.section == 2) {
        cell.textLabel.text = @"意见反馈";
    }else if ( indexPath.section == 3) {
        cell.textLabel.text = @"退出登录";
    }
    
    return cell;
}
// heightforheaderinsection不起作用时 同时设置heightForFooterInSection即可（不能为0）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 10;
    }else
    {
        return 5;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        SDInfoViewController * infoVC = [[SDInfoViewController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }else if (indexPath.section == 1){
        
        SDSetViewController * setVC = [[SDSetViewController alloc] init];
        [self.navigationController pushViewController:setVC animated:YES];

    }else if (indexPath.section == 2){
        
        SDFeedBackViewController * feedBackVC = [[SDFeedBackViewController alloc] init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
        
        
    }
    
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
