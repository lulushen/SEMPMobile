//
//  ActionIncomeViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionIncomeViewController.h"
#import "ActionIncomeTableViewCell.h"
#import "ActionIncomeFootView.h"

@interface ActionIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)UITableView * actionIncomeTableView;
@end

@implementation ActionIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _titleString;
    
    [self makeLeftButtonItme];
    
    
    [self makeActionIncomeTableView];
    // Do any additional setup after loading the view.
}
// 自定义返回按钮LeftButtonItme
- (void)makeLeftButtonItme
{
    UIImage * backImage = [UIImage imageNamed:@"back.png"];
    CGRect backframe = CGRectMake(0, 0, 35*KWidth6scale, 25*KHeight6scale);
    UIButton * backButton = [[UIButton alloc] initWithFrame:backframe];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}
// 返回按钮点击事件
- (void)backButtonClick:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
//
- (void)makeActionIncomeTableView
{
    
    _actionIncomeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight) style:UITableViewStylePlain];
    _actionIncomeTableView.delegate = self;
    _actionIncomeTableView.dataSource = self;
    _actionIncomeTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_actionIncomeTableView];
    [_actionIncomeTableView registerClass:[ActionIncomeTableViewCell class] forCellReuseIdentifier:@"ActionIncomeCell"];
}


#pragma =====tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ActionIncomeCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageIncomeActionView.image  = [UIImage imageNamed:@"1.png"];
        cell.actionIncomeTitleLabel.text = @"任务发布：";
        [self makeTableViewFirstCell:cell indexPath:indexPath];
        return cell;
    }else if (indexPath.row == 1){
        cell.imageIncomeActionView.image  = [UIImage imageNamed:@"1.png"];
        cell.actionIncomeTitleLabel.text = @"负责人";

        return cell;
    }else if (indexPath.row == 2){
        cell.imageIncomeActionView.image  = [UIImage imageNamed:@"2.png"];
        cell.actionIncomeTitleLabel.text = @"协助人";

        return cell;
    }else if (indexPath.row == 3){
        cell.imageIncomeActionView.image  = [UIImage imageNamed:@"3.png"];
        cell.actionIncomeTitleLabel.text = @"相关指标";

        return cell;
    }else if(indexPath.row == 4){
        cell.imageIncomeActionView.image  = [UIImage imageNamed:@"4.png"];
        cell.actionIncomeTitleLabel.text = @"任务详情";
        return cell;
    }else{
        
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120*KHeight6scale;
    }else if (indexPath.row == 4){
        return 100*KHeight6scale;
    }else{
        return (KViewHeight-120-100-150)/3.0*KHeight6scale;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ActionIncomeFootView * view = [[ActionIncomeFootView alloc] init];
    view.backgroundColor = DEFAULT_BGCOLOR;
    return view;
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 150;
//}
- (void)makeTableViewFirstCell:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath
{
    

    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50*KWidth6scale, 50*KHeight6scale, 70*KWidth6scale, 20*KHeight6scale)];
    dateLabel.text = @"创建日期 ：" ;
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.font = [UIFont systemFontOfSize:12.0f];
    [cell addSubview:dateLabel];
    UILabel* dateLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel.frame),CGRectGetMinY(dateLabel.frame), CGRectGetWidth(dateLabel.frame), CGRectGetHeight(dateLabel.frame))];
    dateLabelTwo.text = @"2016-07-01" ;
    dateLabelTwo.textColor = [UIColor grayColor];
    dateLabelTwo.font = [UIFont systemFontOfSize:12.0f];
    [cell addSubview:dateLabelTwo];
    UILabel* wanchengDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(dateLabel.frame), CGRectGetMaxY(dateLabel.frame),CGRectGetWidth(dateLabel.frame), CGRectGetHeight(dateLabel.frame))];
    wanchengDateLabel.text = @"截止日期 ：" ;
    wanchengDateLabel.textColor = [UIColor grayColor];
    wanchengDateLabel.font = [UIFont systemFontOfSize:12.0f];
    [cell addSubview:wanchengDateLabel];
    UILabel* wanchengDateLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(dateLabelTwo.frame), CGRectGetMaxY(dateLabelTwo.frame),CGRectGetWidth(dateLabelTwo.frame), CGRectGetHeight(dateLabelTwo.frame))];
    wanchengDateLabelTwo.text = @"2016-08-01" ;
    wanchengDateLabelTwo.textColor = [UIColor grayColor];
    wanchengDateLabelTwo.font = [UIFont systemFontOfSize:12.0f];
    [cell addSubview:wanchengDateLabelTwo];
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
