//
//  ActionViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/10.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionViewController.h"
#import "ActionTopView.h"
#import "AddActionViewController.h"
#import "ActionTableViewCell.h"
#import "ActionIncomeViewController.h"
#import "userModel.h"
#import "ActionModel.h"
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

@property (nonatomic , strong) userModel * userModel;

@property (nonatomic , strong) NSMutableArray * allActionArray;
@property (nonatomic , strong) NSMutableArray * weiWanChengActionArray;
@property (nonatomic , strong) NSMutableArray * daiChuLiActionArray;
@property (nonatomic , strong) NSMutableArray * yiXiaDaActionArray;


@end

@implementation ActionViewController
- (NSMutableArray *)allActionArray
{
    if (_allActionArray.count == 0) {
        _allActionArray = [NSMutableArray array];
    }
    return _allActionArray;
}
- (NSMutableArray *)weiWanChengActionArray
{
    if (_weiWanChengActionArray.count == 0) {
        _weiWanChengActionArray = [NSMutableArray array];
    }
    return _weiWanChengActionArray;
}
- (NSMutableArray *)daiChuLiActionArray
{
    if (_daiChuLiActionArray.count == 0) {
        _daiChuLiActionArray = [NSMutableArray array];
    }
    return _daiChuLiActionArray;
}
- (NSMutableArray *)yiXiaDaActionArray
{
    if (_yiXiaDaActionArray.count == 0) {
        _yiXiaDaActionArray = [NSMutableArray array];
    }
    return _yiXiaDaActionArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 数据
    [self makeDataTableView];
    // nav
    [self makeNavigationView];
    // 头部视图
    [self makeActionTopView];
    
   
  
//
    // Do any additional setup after loading the view.
}
-(void)makeDataTableView
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    _userModel = [[userModel alloc] init];
    _userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //  转化成字符串
    NSString *   token = [NSString stringWithFormat:@"%@",_userModel.user_token];
    
    
    NSString * urlStr = [NSString stringWithFormat:ActionHttp];
    
    NSLog(@"----%@",urlStr);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        if (responseObject != nil) {
            
            NSMutableArray * array = responseObject[@"resdata"];
            
            for (NSDictionary * dict in array) {
                
                ActionModel * actionModel = [[ActionModel alloc] init];
                [actionModel setValuesForKeysWithDictionary:dict];
                // _xxx和self.xxx的区别：当使用self.xxx会调用xxx的get方法而_xxx并不会调用，正确的使用个方式是通过self去调用才会执行懒加载方法
                [self.allActionArray addObject:actionModel];
                
                if ([actionModel.task_state isEqualToString:@"9"]) {
                    
                    [self.weiWanChengActionArray addObject:actionModel];
                }else if ([actionModel.task_state isEqualToString:@"3"]) {
                    
                    [self.daiChuLiActionArray addObject:actionModel];
                }else if ([actionModel.task_state isEqualToString:@"1"]) {
                    
                    [self.yiXiaDaActionArray addObject:actionModel];
                }
                
                
                
            }
            
            NSLog(@"_allActionArray------%ld",_allActionArray.count);
            NSLog(@"ActionresponseObject------%@",responseObject);

            
        }
       
        //全部任务tableView
        [self makeAllActionTableView];
        //未完成任务tableView
        [self  makeWeiWanChengTableView];
        
        //已下达任务tableView
        [self makeYiXiaDaTableView];
        
        //待处理任务tableView
        [self makeDaiChuliTableView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
        
    }];

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
    AddActionViewController * addActionVC = [[AddActionViewController alloc] init];
    
    [self.navigationController pushViewController:addActionVC animated:YES];

}


#pragma =======tableView代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
     return 1;
  
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (tableView.tag == 0) {
        return _allActionArray.count;
    }else if (tableView.tag == 1){

        return _weiWanChengActionArray.count;
    }else if (tableView.tag == 2){
        
        return _yiXiaDaActionArray.count;
    }else{
        return _daiChuLiActionArray.count;
    }
   
}
- (ActionTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
    
    ActionModel * actionModel = [[ActionModel alloc] init];
    if (tableView.tag == 0) {
        
        actionModel = _allActionArray[indexPath.row];
        
        [self makeCell:cell actionModel:actionModel];
        
        if ([actionModel.loginUser isEqualToString:[NSString stringWithFormat:@"%@",actionModel.create_user]]) {
            
            if ([actionModel.task_state isEqualToString:@"1"]) {
              
                cell.actionStatuLabel.text = @"已下达";
            }
            
        }else{
            if ([actionModel.task_state isEqualToString:@"1"]) {
                cell.actionStatuLabel.text = @"待接收";
            }
            
        }
        NSLog(@"actionModel.task_type---%@",actionModel.task_type);
      if ([actionModel.task_state isEqualToString:@"3"]) {
            
            cell.actionStatuLabel.text = @"待处理";
            
            
        }else if ([actionModel.task_state isEqualToString:@"9"]){
            cell.actionStatuLabel.text = @"进行中";
            
        }else if ([actionModel.task_state isEqualToString:@"7"]){
            
            cell.actionStatuLabel.text = @"已完成";
            
        }

        
      return cell;
        
    }else if (tableView.tag == 1){
        actionModel = _weiWanChengActionArray[indexPath.row];
        [self makeCell:cell actionModel:actionModel];
        cell.actionStatuLabel.text = @"进行中";
        return cell;
        
    }else if (tableView.tag == 2){
        actionModel = _yiXiaDaActionArray[indexPath.row];
        [self makeCell:cell actionModel:actionModel];
        
        if ([actionModel.loginUser isEqualToString:[NSString stringWithFormat:@"%@",actionModel.create_user]]) {
            
            if ([actionModel.task_state isEqualToString:@"1"]) {
                
                cell.actionStatuLabel.text = @"已下达";
            }
            
        }else{
            if ([actionModel.task_state isEqualToString:@"1"]) {
                cell.actionStatuLabel.text = @"待接收";
            }
            
        }

        return cell;
    }else {
        
        actionModel = _daiChuLiActionArray[indexPath.row];
        
        [self makeCell:cell actionModel:actionModel];

        cell.actionStatuLabel.text = @"待处理";

        return cell;
    }
    
}

-(void)makeCell:(ActionTableViewCell *)cell actionModel: (ActionModel*)actionModel
{
    
    cell.actionTitleLabel.text = actionModel.task_title;

    cell.actionDateLabel.text = actionModel.create_time;
    
 
    if ([actionModel.task_priority isEqualToString:@"1" ]) {
        
        cell.actionDifficultyLabel.backgroundColor = [UIColor grayColor];
        cell.actionDifficultyLabel.text = @"高";
        
    }else if ([actionModel.task_priority isEqualToString:@"2" ]){
        cell.actionDifficultyLabel.backgroundColor = [UIColor orangeColor];
        
        cell.actionDifficultyLabel.text = @"中";
        
    }else{
        
        cell.actionDifficultyLabel.text = @"低";
        
    }
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionIncomeViewController * ActionIncomeVC = [[ActionIncomeViewController alloc]init];
    
//    ActionIncomeVC.titleString =
    
    [self.navigationController pushViewController:ActionIncomeVC animated:YES];
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
