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
// 已下达的tableView
@property (nonatomic , strong) UITableView * yiXiaTableView;
// 已接收任务的tableView
@property (nonatomic , strong) UITableView * yiJieShouTableView;
// 待接收任务的tableView
@property (nonatomic , strong) UITableView * daiJieShouTableView;

@property (nonatomic , strong) userModel * userModel;
// 全部任务数组
@property (nonatomic , strong) NSMutableArray * allActionArray;
// 已下达任务数组
@property (nonatomic , strong) NSMutableArray * yiXiaActionArray;
// 已接收任务数组
@property (nonatomic , strong) NSMutableArray * yiJieShouActionArray;
// 待接收任务数组
@property (nonatomic , strong) NSMutableArray * daiJieShouActionArray;


@end

@implementation ActionViewController
- (NSMutableArray *)allActionArray
{
    if (_allActionArray.count == 0) {
        _allActionArray = [NSMutableArray array];
    }
    return _allActionArray;
}
- (NSMutableArray *)yiXiaActionArray
{
    if (_yiXiaActionArray.count == 0) {
        _yiXiaActionArray = [NSMutableArray array];
    }
    return _yiXiaActionArray;
}
- (NSMutableArray *)yiJieShouActionArray
{
    if (_yiJieShouActionArray.count == 0) {
        _yiJieShouActionArray = [NSMutableArray array];
    }
    return _yiJieShouActionArray;
}
- (NSMutableArray *)daiJieShouActionArray
{
    if (_daiJieShouActionArray.count == 0) {
        _daiJieShouActionArray = [NSMutableArray array];
    }
    return _daiJieShouActionArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [_allActionArray removeAllObjects];
    [_yiXiaActionArray removeAllObjects];
    [_yiJieShouActionArray removeAllObjects];
    [_daiJieShouActionArray removeAllObjects];
    [_allActionTableView removeFromSuperview];
    [_yiXiaTableView removeFromSuperview];
    [_yiJieShouTableView removeFromSuperview];
    [_daiJieShouTableView removeFromSuperview];

    // 数据
    [self makeDataTableView];
    
    [_allActionTableView reloadData];
    [_yiXiaTableView reloadData];

    [_yiJieShouTableView reloadData];

    [_daiJieShouTableView reloadData];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
//    NSString *   token = [NSString stringWithFormat:@"%@",_userModel.user_token];
    
    
    NSString * urlStr = [NSString stringWithFormat:ActionHttp];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        NSLog(@"------任务界面的responseObject ：%@",responseObject);
        if (responseObject != nil) {
            
            NSMutableArray * array = responseObject[@"resdata"];
            
            for (NSDictionary * dict in array) {
                
                ActionModel * actionModel = [[ActionModel alloc] init];
                [actionModel setValuesForKeysWithDictionary:dict];
                // _xxx和self.xxx的区别：当使用self.xxx会调用xxx的get方法而_xxx并不会调用，正确的使用个方式是通过self去调用才会执行懒加载方法
                [self.allActionArray addObject:actionModel];
                //  状态1 ：id相同－－已下达，id不同－－待接受
                //  状态2 ：拒绝任务    ID相同：可删除，可编辑；ID不同：不可删除，不可编辑；
                //  状态3 ：处理中      ID相同：不可删除，可编辑；ID不同：不可删除，不可编辑；
                //  状态4 ：撤销       ID相同：可删除，不可编辑；ID不同：不可删除，不可编辑；
                //  状态5 ：申请延期    ID相同：可删除，可编辑；ID不同：不可删除，不可编辑；
                //  状态6 ：待审核     ID相同：不可删除，不可编辑；ID不同：不可删除，不可编辑；
                //  状态7 ：完成
                //  状态8 ：延期完成
                //  状态9 ：未完成     ID相同：可删除，不可编辑；ID不同：不可删除，不可编辑；
                //  状态10 ：删除
                //  已下达包含：ID相同1/2/3/4/5/6/9； 待接受包含：ID不同的1；已接受包含：ID不同的2／3／4／5／6／9 全部任务包含所有


                if ((actionModel.loginUser != actionModel.create_user) && [actionModel.task_state isEqualToString:@"1"]) {
                    
                    [self.daiJieShouActionArray addObject:actionModel];
                    
                }else if ((actionModel.loginUser == actionModel.create_user)&&([actionModel.task_state isEqualToString:@"1"] | [actionModel.task_state isEqualToString:@"4"] | [actionModel.task_state isEqualToString:@"2"]|[actionModel.task_state isEqualToString:@"3"] | [actionModel.task_state isEqualToString:@"5"] | [actionModel.task_state isEqualToString:@"6"] | [actionModel.task_state isEqualToString:@"7"] |[actionModel.task_state isEqualToString:@"8"] | [actionModel.task_state isEqualToString:@"9"])) {
                
                    
                    [self.yiXiaActionArray addObject:actionModel];
                    
                    
                }else if ((actionModel.loginUser != actionModel.create_user)&&([actionModel.task_state isEqualToString:@"4"] | [actionModel.task_state isEqualToString:@"2"]|[actionModel.task_state isEqualToString:@"3"] | [actionModel.task_state isEqualToString:@"5"] | [actionModel.task_state isEqualToString:@"6"] | [actionModel.task_state isEqualToString:@"7"] |[actionModel.task_state isEqualToString:@"8"] | [actionModel.task_state isEqualToString:@"9"])) {
                    
                    [self.yiJieShouActionArray addObject:actionModel];
                }
                
                
                
            }
            
        }
       
        //全部任务tableView
        [self makeAllActionTableView];
        //已下达任务tableView
        [self  makeYiXiaTableView];
        
        //已接收任务tableView
        [self makeYiJieShouTableView];
        
        //待接收任务tableView
        [self makeDaiJieShouTableView];
        
        // 发送通知改变待接收数据个数
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DaiJieShouShuLiangChange" object:nil];

        
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DaiJieShouShuLiangChange) name:@"DaiJieShouShuLiangChange" object:nil];
    _actionTopView = [[ActionTopView alloc] init];
    _actionTopView.backgroundColor = DEFAULT_BGCOLOR;
    _actionTopView.frame = CGRectMake(0, 0, Main_Screen_Width, 40*KHeight6scale);
   [_actionTopView.daiJieShouButton setTitle:[NSString stringWithFormat:@"待接收"] forState:UIControlStateNormal];
    [_actionTopView.yiXiaButton addTarget:self action:@selector(yiXiaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionTopView.daiJieShouButton addTarget:self action:@selector(daiJieShouButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionTopView.yiJieShouButton addTarget:self action:@selector(yiJieShouButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionTopView.allActionButton addTarget:self action:@selector(allActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _actionTopView.allActionButton.selected = YES;
    [self.view addSubview:_actionTopView];
    
}
- (void)DaiJieShouShuLiangChange
{
      [_actionTopView.daiJieShouButton setTitle:[NSString stringWithFormat:@"待接收(%ld)",_daiJieShouActionArray.count] forState:UIControlStateNormal];
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
// 已下达点击事件
- (void)yiXiaButtonClick:(UIButton *)button
{
    
    
    if (button.selected != YES) {
        [self makeSelectedButton:button];
        [self.view addSubview:_yiXiaTableView];
    }
    
}
//已接收点击事件
- (void)yiJieShouButtonClick:(UIButton *)button
{
    
    
    if (button.selected != YES) {
        [self makeSelectedButton:button];
        
        [self.view addSubview:_yiJieShouTableView];
        
    }
}
// 待接收点击事件
- (void)daiJieShouButtonClick:(UIButton *)button
{
    
    
    if (button.selected != YES) {
        [self makeSelectedButton:button];
       
        [self.view addSubview:_daiJieShouTableView];

    }
    
}

//   四个任务按钮的公共属性
- (void)makeSelectedButton:(UIButton *)button
{
    _actionTopView.yiXiaButton.selected = NO;
    _actionTopView.yiJieShouButton.selected = NO;
    _actionTopView.daiJieShouButton.selected = NO;
    _actionTopView.allActionButton.selected = NO;
    [_allActionTableView removeFromSuperview];
    [_yiXiaTableView removeFromSuperview];
    [_yiJieShouTableView removeFromSuperview];
    [_daiJieShouTableView removeFromSuperview];

    
    button.selected = YES;
    
    _actionTopView.yiXiaButton.backgroundColor = [UIColor clearColor];
    _actionTopView.daiJieShouButton.backgroundColor = [UIColor clearColor];
    _actionTopView.yiJieShouButton.backgroundColor = [UIColor clearColor];
    _actionTopView.allActionButton.backgroundColor = [UIColor clearColor];
    
    [_actionTopView.yiXiaButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_actionTopView.daiJieShouButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_actionTopView.yiJieShouButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
// 已下达任务的界面
- (void)makeYiXiaTableView
{
    _yiXiaTableView = [[UITableView alloc] init];
    _yiXiaTableView.tag = 1;
    [self makeTableView:_yiXiaTableView];
}
// 已接收任务的界面
- (void)makeYiJieShouTableView
{
    _yiJieShouTableView = [[UITableView alloc] init];
    _yiJieShouTableView.tag = 2;
    [self makeTableView:_yiJieShouTableView];
    
    
}
// 待接收任务的界面
- (void)makeDaiJieShouTableView
{
    _daiJieShouTableView = [[UITableView alloc] init];
    _daiJieShouTableView.tag = 3;
    [self makeTableView:_daiJieShouTableView];
    
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

        return _yiXiaActionArray.count;
        
    }else if (tableView.tag == 2){
        
        return _yiJieShouActionArray.count;
        
    }else{
        return _daiJieShouActionArray.count;
    }
   
}
- (ActionTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
    
    ActionModel * actionModel = [[ActionModel alloc] init];
    if (tableView.tag == 0) {
        
        actionModel = _allActionArray[indexPath.row];
#warning ======= 判断此任务的负责人是否是本用户
        if (actionModel.loginUser == actionModel.responsible_person) {
            cell.responsiblePersonImageView.backgroundColor = [UIColor redColor];
        }else{
            cell.responsiblePersonImageView.backgroundColor = [UIColor whiteColor];
        }
        
        [self makeCell:cell actionModel:actionModel];

        if (actionModel.loginUser == actionModel.create_user) {
            
            if ([actionModel.task_state isEqualToString:@"1"]) {
              
                cell.actionStatuLabel.text = @"已下达";
            }
            
        }else{
            
            if ([actionModel.task_state isEqualToString:@"1"]) {
             
                cell.actionStatuLabel.text = @"待接收";
            }
            
        }
      if ([actionModel.task_state isEqualToString:@"3"]) {
            
            cell.actionStatuLabel.text = @"处理中";
          
        }else if ([actionModel.task_state isEqualToString:@"9"]){
            
            cell.actionStatuLabel.text = @"未完成";
            
        }else if ([actionModel.task_state isEqualToString:@"7"]){
            
            cell.actionStatuLabel.text = @"已完成";
            
        }else if ([actionModel.task_state isEqualToString:@"8"]){
            cell.actionStatuLabel.text = @"延迟完成";

        }else if ([actionModel.task_state isEqualToString:@"2"]){
            cell.actionStatuLabel.text = @"被拒绝";
            
        }else if ([actionModel.task_state isEqualToString:@"4"]){
          
            cell.actionStatuLabel.text = @"已撤销";
            
        }else if ([actionModel.task_state isEqualToString:@"5"]){
            
            cell.actionStatuLabel.text = @"申请延期";
        }else if ([actionModel.task_state isEqualToString:@"6"]){
            
            cell.actionStatuLabel.text = @"待审核";
        }

        
      return cell;
        
    }else if (tableView.tag == 1){
        
        actionModel = _yiXiaActionArray[indexPath.row];
        [self makeCell:cell actionModel:actionModel];
        
        
            
        if ([actionModel.task_state isEqualToString:@"1"]) {
            
            cell.actionStatuLabel.text = @"已下达";
            
        }else if ([actionModel.task_state isEqualToString:@"3"]) {
            
            cell.actionStatuLabel.text = @"处理中";
            
        }else if ([actionModel.task_state isEqualToString:@"9"]){
            
            cell.actionStatuLabel.text = @"未完成";
            
        }else if ([actionModel.task_state isEqualToString:@"2"]){
            cell.actionStatuLabel.text = @"被拒绝";
            
        }else if ([actionModel.task_state isEqualToString:@"4"]){
            
            cell.actionStatuLabel.text = @"已撤销";
            
        }else if ([actionModel.task_state isEqualToString:@"5"]){
            
            cell.actionStatuLabel.text = @"申请延期";
        }else if ([actionModel.task_state isEqualToString:@"6"]){
            
            cell.actionStatuLabel.text = @"待审核";
        }else if ([actionModel.task_state isEqualToString:@"7"]){
            
            cell.actionStatuLabel.text = @"已完成";
            
        }else if ([actionModel.task_state isEqualToString:@"8"]){
            cell.actionStatuLabel.text = @"延迟完成";
            
        }
        return cell;
        
    }else if (tableView.tag == 2){
        
        actionModel = _yiJieShouActionArray[indexPath.row];
        [self makeCell:cell actionModel:actionModel];
        
        if ([actionModel.task_state isEqualToString:@"3"]) {
            
            cell.actionStatuLabel.text = @"处理中";
            
        }else if ([actionModel.task_state isEqualToString:@"9"]){
            
            cell.actionStatuLabel.text = @"未完成";
            
        }else if ([actionModel.task_state isEqualToString:@"2"]){
            cell.actionStatuLabel.text = @"被拒绝";
            
        }else if ([actionModel.task_state isEqualToString:@"4"]){
            
            cell.actionStatuLabel.text = @"已撤销";
            
        }else if ([actionModel.task_state isEqualToString:@"5"]){
            
            cell.actionStatuLabel.text = @"申请延期";
        }else if ([actionModel.task_state isEqualToString:@"6"]){
            
            cell.actionStatuLabel.text = @"待审核";
        }else if ([actionModel.task_state isEqualToString:@"7"]){
            
            cell.actionStatuLabel.text = @"已完成";
            
        }else if ([actionModel.task_state isEqualToString:@"8"]){
            cell.actionStatuLabel.text = @"延迟完成";
            
        }

        return cell;
    }else if (tableView.tag == 3){
        
        actionModel = _daiJieShouActionArray[indexPath.row];
        
        [self makeCell:cell actionModel:actionModel];

        if ([actionModel.task_state isEqualToString:@"1"]) {
            
            cell.actionStatuLabel.text = @"待接收";
            
        }
        return cell;
    }else{
        
        return nil;
    }
    
}

-(void)makeCell:(ActionTableViewCell *)cell actionModel: (ActionModel*)actionModel
{
    
    cell.actionTitleLabel.text = actionModel.task_title;

    cell.actionDateLabel.text = actionModel.create_time;
    
 
    if ([actionModel.task_priority isEqualToString:@"1" ]) {
         cell.actionDifficultyLabel.backgroundColor = RGBCOLOR(250.0, 110.0, 114.0);

        cell.actionDifficultyLabel.text = @"高";
        
    }else if ([actionModel.task_priority isEqualToString:@"2" ]){
        cell.actionDifficultyLabel.backgroundColor = [UIColor orangeColor];
        
        cell.actionDifficultyLabel.text = @"中";
        
    }else{
        
        cell.actionDifficultyLabel.text = @"低";
        cell.actionDifficultyLabel.backgroundColor = [UIColor grayColor];

    }
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionIncomeViewController * ActionIncomeVC = [[ActionIncomeViewController alloc]init];

    ActionModel * model = [[ActionModel alloc] init];
    if (tableView.tag == 0) {
        model = _allActionArray[indexPath.row] ;

    }else if (tableView.tag == 1){
        
        model = _yiXiaActionArray[indexPath.row] ;

    }else if (tableView.tag == 2){
        model = _yiJieShouActionArray[indexPath.row] ;

    }else if (tableView.tag == 3){
       
        model = _daiJieShouActionArray[indexPath.row] ;

    }else{
        
    }
    ActionIncomeVC.taskIDString = model.task_id;
    ActionIncomeVC.titleString = model.task_title;
    ActionIncomeVC.task_stateString = model.task_state;
    ActionIncomeVC.loginUserString = model.loginUser;
    ActionIncomeVC.creat_userString = model.create_user;
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
