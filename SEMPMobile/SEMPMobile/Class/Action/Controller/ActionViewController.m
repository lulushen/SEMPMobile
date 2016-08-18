//
//  ActionViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/10.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionViewController.h"
#import "ActionTopView.h"
#import "ActionTableViewCell.h"
//#import "ReportTableViewCell.h"

@interface ActionViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

// 头部视图
@property (nonatomic , strong) ActionTopView * actionTopView;
// 添加按钮
@property (nonatomic , strong) UIButton * addActionButton;
// 全部任务的tableView
@property (nonatomic , strong) UITableView * allActionTableView;
// 未完成的tableView
@property (nonatomic , strong) UITableView * weiWanChengTableView;
// 已下达任务的tableView
@property (nonatomic , strong) UITableView * yiXiaDaTableView;
// 待处理任务的tableView
@property (nonatomic , strong) UITableView * daiChuliTableView;
@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // nav
    [self makeNavigationView];
    // 头部视图
    [self makeActionTopView];
    
    //全部任务tableView
    [self makeAllActionTableView];
    //未完成任务tableView
    [self  makeWeiWanChengTableView];
    
    //已下达任务tableView
    [self makeYiXiaDaTableView];
    
    //待处理任务tableView
    [self makeDaiChuliTableView];
//
    // Do any additional setup after loading the view.
}
-(void)makeNavigationView
{
    self.navigationItem.title = @"Action";
    // navigation上的分享按钮
    UIImage * AddImage = [UIImage imageNamed:@"add.png"];
    
    CGRect addFrame = CGRectMake(0, 0, 25*KWidth6scale, 25*KHeight6scale);
    
    _addActionButton = [[UIButton alloc] initWithFrame:addFrame];
    
    [_addActionButton setImage:AddImage forState:UIControlStateNormal];
    
    [_addActionButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_addActionButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}
- (void)makeActionTopView
{
    
    _actionTopView = [[ActionTopView alloc] init];
    _actionTopView.backgroundColor = DEFAULT_BGCOLOR;
    _actionTopView.frame = CGRectMake(0, 0, Main_Screen_Width, 40*KHeight6scale);
    [_actionTopView.daiChuliButton setTitle:[NSString stringWithFormat:@"待处理(%@)",@"0"] forState:UIControlStateNormal];
    [_actionTopView.weiWanChengButton addTarget:self action:@selector(weiWanChengButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionTopView.daiChuliButton addTarget:self action:@selector(daiChuliButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionTopView.yiXiaDaButton addTarget:self action:@selector(yiXiaDaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionTopView.allActionButton addTarget:self action:@selector(allActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _actionTopView.allActionButton.selected = YES;
    [self.view addSubview:_actionTopView];
    
}
// 全部任务点击事件
- (void)allActionButtonClick:(UIButton *)button
{
  
       if (button.selected != YES) {
        //   四个任务按钮的公共属性
        [self makeSelectedButton:button];
        [self.view addSubview:_allActionTableView];
    
    }
}
// 未完成点击事件
- (void)weiWanChengButtonClick:(UIButton *)button
{
    
    
    if (button.selected != YES) {
        [self makeSelectedButton:button];
        [self.view addSubview:_weiWanChengTableView];
    }
    
}
//已下达点击事件
- (void)yiXiaDaButtonClick:(UIButton *)button
{
    
    
    if (button.selected != YES) {
        [self makeSelectedButton:button];
        
        [self.view addSubview:_yiXiaDaTableView];
        
    }
}
// 待处理点击事件
- (void)daiChuliButtonClick:(UIButton *)button
{
    
    
    if (button.selected != YES) {
        [self makeSelectedButton:button];
       
        [self.view addSubview:_daiChuliTableView];

    }
    
}

//   四个任务按钮的公共属性
- (void)makeSelectedButton:(UIButton *)button
{
    _actionTopView.weiWanChengButton.selected = NO;
    _actionTopView.yiXiaDaButton.selected = NO;
    _actionTopView.daiChuliButton.selected = NO;
    _actionTopView.allActionButton.selected = NO;
    [_allActionTableView removeFromSuperview];
    [_weiWanChengTableView removeFromSuperview];
    [_yiXiaDaTableView removeFromSuperview];
    [_daiChuliTableView removeFromSuperview];

    
    button.selected = YES;
    
    _actionTopView.weiWanChengButton.backgroundColor = [UIColor clearColor];
    _actionTopView.daiChuliButton.backgroundColor = [UIColor clearColor];
    _actionTopView.yiXiaDaButton.backgroundColor = [UIColor clearColor];
    _actionTopView.allActionButton.backgroundColor = [UIColor clearColor];
    
    [_actionTopView.weiWanChengButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_actionTopView.daiChuliButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_actionTopView.yiXiaDaButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_actionTopView.allActionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:ActionButtonColor];
    
    
    
}

// 全部任务的界面
- (void)makeAllActionTableView
{
    
    _allActionTableView = [[UITableView alloc] init];
    _allActionTableView.tag = 0;
    [self.view addSubview:_allActionTableView];
     //   四个任务界面的公共属性
    [self makeTableView:_allActionTableView];

}
// 未完成任务的界面
- (void)makeWeiWanChengTableView
{
    _weiWanChengTableView = [[UITableView alloc] init];
    _weiWanChengTableView.tag = 1;
    [self makeTableView:_weiWanChengTableView];
}
// 已下达任务的界面
- (void)makeYiXiaDaTableView
{
    _yiXiaDaTableView = [[UITableView alloc] init];
    _yiXiaDaTableView.tag = 2;
    [self makeTableView:_yiXiaDaTableView];
    
    
}
// 待处理任务的界面
- (void)makeDaiChuliTableView
{
    _daiChuliTableView = [[UITableView alloc] init];
    _daiChuliTableView.tag = 3;
    [self makeTableView:_daiChuliTableView];
    
}
//   四个任务界面的公共属性
-(void)makeTableView:(UITableView *)tableView
{
    tableView.frame = CGRectMake(0, CGRectGetMaxY(_actionTopView.frame), Main_Screen_Width, KViewHeight- CGRectGetHeight(_actionTopView.frame));
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ActionTableViewCell class] forCellReuseIdentifier:@"cell"];
    // 去掉分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
   
    [tableView registerClass:[ActionTableViewCell class] forCellReuseIdentifier:@"actionCell"];
    


    
}
//添加按钮点击事件
- (void)addButtonClick:(UIButton *)button
{
    
}


#pragma =======tableView代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
     return 1;
  
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (tableView.tag == 0) {
       
        return 10;
    }else if (tableView.tag == 1){
        
        return 12;
    }else if (tableView.tag == 2){
        
        return 5;
    }else{
        return 1;
    }
   
}
- (ActionTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
    cell.actionTitleLabel.text = @"SEMP ";
    cell.actionDateLabel.text = @"2016/08/01";
    cell.actionTimeLabel.text = @"15.44";
    cell.actionDifficultyLabel.text = @"高";
    cell.actionStatuLabel.text = @"进行中";
    
    
    if (tableView.tag == 0) {
              return cell;
        
    }else if (tableView.tag == 1){
      
        
        return cell;
        
    }else if (tableView.tag == 2){
       
        return cell;
    }else {
       
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (KViewHeight-CGRectGetHeight(_actionTopView.frame))/6.0;
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
