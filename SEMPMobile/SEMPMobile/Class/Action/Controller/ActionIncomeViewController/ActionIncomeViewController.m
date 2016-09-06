//
//  ActionIncomeViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ActionIncomeViewController.h"
#import "ActionDetailModel.h"
#import "MBProgressHUD+MJ.h"
#import "NSDate+Helper.h"
#import "userModel.h"
#import "DefaultD_resModel.h"
#import "TreeTableView.h"
#import "AddActionSelectTableViewCell.h"
#import "DefaultIndexInfoModel.h"
#import "AddActionSubView.h"
#import "ActionIncomeSubView.h"

@interface ActionIncomeViewController ()<UITableViewDelegate,UITableViewDataSource,TreeTableCellDelegate>

@property (nonatomic , strong)  UIScrollView * actionIncomeScrollView;
@property (nonatomic , strong)  ActionDetailModel * detailModel;
@property (nonatomic ,assign)    CGRect rectFuZeRenView;
@property (nonatomic ,assign)    CGRect rectXieZhuRenCell;
@property (nonatomic ,assign)    CGRect rectXiangGuanIndexCell;
@property (nonatomic ,assign)    CGRect rectXiangQingCell;
@property (nonatomic ,assign)    CGRect rectJiLuCell;

// 截止日期label
//@property (nonatomic , strong) UILabel * 
// 任务详情信息
@property (nonatomic , strong) UILabel * taskDetaileLabel;
//确认审核弹框
@property (nonatomic , strong) UIView * ShenHeView;
@property (nonatomic , strong) UIButton * yesButton;
@property (nonatomic , strong) UIButton * noButton;
@property (nonatomic , strong) UITextView * textView;

//接收任务弹框
@property(nonatomic ,strong) UIView * acceptView;
//弹出框中确认按钮和取消按钮
@property (nonatomic , strong)UIButton * OKButton;
@property (nonatomic , strong)UIButton * cancelButton;
//弹出框视图
@property (nonatomic , strong)UIView *pupopView;
//弹出框中的说明信息textView
@property (nonatomic , strong)UITextView * shuoMingTextView;

//开始编辑时可以编辑的任务详情
@property (nonatomic , strong)UITextView * taskInfoTextView;

#pragma ====
// 任务优先级按钮
@property (nonatomic , strong) UIButton * gaoButton;
@property (nonatomic , strong) UIButton * midButton;
@property (nonatomic , strong) UIButton * diButton;
// 任务类型button
@property (nonatomic , strong) UIButton * puTongTaskButton;
@property (nonatomic , strong) UIButton * zhuanXiangTaskButton;
// 添加相关指标界面
@property (nonatomic , strong) UIView * defaultIndexInfoView;
// 添加协助人，负责人界面
@property (nonatomic , strong) UIView * addPersonView;
@property (nonatomic , strong) UITableView * defaultPersonTabelView;
@property (nonatomic , strong) userModel * userModel;

// 全部相关指标数组
@property (nonatomic , strong) NSMutableArray * defaultIndexInfoModelArray;
// 被选中的相关指标数组
@property (nonatomic , strong) NSMutableArray * selectedDefaultIndexModelArray;
// 全部人员所在组织的数组
@property (nonatomic , strong) NSMutableArray * defaultD_resModelArray;
// 全部人员的数组
@property (nonatomic , strong) NSMutableArray * defaultUserArray;
// 每个组织中人员（个数）数组
@property (nonatomic , strong) NSMutableArray * MeiGeZhuZhiDeUserCountArray;
// 被选中的协助人的数组
@property (nonatomic , strong) NSMutableArray * selectedDefaultUserArray;
// 被选中负责人的数组
@property (nonatomic , strong) NSMutableArray * selectedUserArray;
// 负责人中曾经被选中的所有button数组
@property (nonatomic , strong) NSMutableArray * butArray;
// 全局变量 （判断点击的那个添加按钮，相应按钮出现相应界面并且在touchBegan时做出相应的事件）
@property (nonatomic , strong) NSString * addString;
// 选择组织的按钮
@property (nonatomic , strong)UIButton * chooseZuZhiButton;
// 选择的ZuZhimodel
@property (nonatomic , strong)DefaultD_resModel * chooseZuZhiModel;
// 组织树tableView
@property (nonatomic , strong)TreeTableView *tableview;

// 参数任务类型
@property (nonatomic , strong) NSString * tasktype;
// 参数优先级类型
@property (nonatomic , assign) NSInteger priorityIntType;
// 参数关联的指标数组
@property (nonatomic , strong) NSMutableArray * indexArray;
// 参数关联user的数组
@property (nonatomic , strong) NSMutableArray * userArray;
// 参数时间
@property (nonatomic , strong) NSString * dateString;

@property (nonatomic , strong)ActionIncomeSubView * firstView;
@property (nonatomic , strong)AddActionSubView * incomeFuZePeopleView;
@property (nonatomic , strong)AddActionSubView * incomeXieZhuPeopleView;
@property (nonatomic , strong)AddActionSubView * incomeIndexView;
@property (nonatomic , strong)AddActionSubView * incomeTaskDetailView;
@property (nonatomic , strong)AddActionSubView * incomeTaskJiLuView;

@end

@implementation ActionIncomeViewController
// 全部的相关指标数组懒加载  ( 调用懒加载用self.xx)
-(NSMutableArray *)defaultIndexInfoModelArray
{
    if (_defaultIndexInfoModelArray == nil) {
        _defaultIndexInfoModelArray = [NSMutableArray array];
    }
    return _defaultIndexInfoModelArray;
}
// 被选中的相关指标数组懒加载  ( 调用懒加载用self.xx)
-(NSMutableArray *)selectedDefaultIndexModelArray
{
    if (_selectedDefaultIndexModelArray == nil) {
        _selectedDefaultIndexModelArray = [NSMutableArray array];
    }
    return _selectedDefaultIndexModelArray;
}
// 全部的组织数组懒加载  ( 调用懒加载用self.xx)
-(NSMutableArray *)defaultD_resModelArray
{
    if (_defaultD_resModelArray == nil) {
        _defaultD_resModelArray = [NSMutableArray array];
    }
    return _defaultD_resModelArray;
}
// 被选中的协助人数组懒加载  ( 调用懒加载用self.xx)
-(NSMutableArray *)selectedDefaultUserArray
{
    if (_selectedDefaultUserArray == nil) {
        _selectedDefaultUserArray = [NSMutableArray array];
    }
    return _selectedDefaultUserArray;
}
-(NSMutableArray *)defaultUserArray
{
    if (_defaultUserArray == nil) {
        _defaultUserArray = [NSMutableArray array];
    }
    return _defaultUserArray;
}
-(NSMutableArray *)selectedUserArray
{
    if (_selectedUserArray == nil) {
        _selectedUserArray= [NSMutableArray array];
    }
    return _selectedUserArray;
}

-(NSMutableArray *)butArray
{
    if (_butArray == nil) {
        _butArray = [NSMutableArray array];
    }
    return _butArray;
}
-(NSMutableArray *)MeiGeZhuZhiDeUserCountArray
{
    if (_MeiGeZhuZhiDeUserCountArray == nil) {
        _MeiGeZhuZhiDeUserCountArray = [NSMutableArray array];
    }
    return _MeiGeZhuZhiDeUserCountArray;
}
-(NSMutableArray *)indexArray
{
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}
-(NSMutableArray *)userArray
{
    if (_userArray == nil) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _titleString;
    
    [self makeLeftButtonItme];
    // 负责人、协助人数据
    [self makeAddActionPersonData];
    // 指标数据
    [self makeDefaultIndexInfoData];
    
    [self makeActionIncomeData];
   
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
- (void)makeActionIncomeScrollView
{
    
    _actionIncomeScrollView = [[UIScrollView alloc] init];
    _actionIncomeScrollView.frame = CGRectMake(0, 0, Main_Screen_Width, KViewHeight);
    [self.view addSubview:_actionIncomeScrollView];

    _actionIncomeScrollView.backgroundColor = [UIColor whiteColor];
    [self makeFirstSbView];
    [self makeFuZePeopleView];
    [self makeXieZhuPeople];
    [self makeIncomeIndexView];
    [self makeIncomeTaskDetailView];
    [self makeIncomeTaskJiLuView] ;

}
- (void)makeActionIncomeData
{
    
    NSString * urlStr = [NSString stringWithFormat:GetTaskInfoHttp,_taskIDString];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---income----%@",responseObject);
        if (responseObject != nil) {
            
            NSMutableDictionary * dict = responseObject[@"resdata"];
            
            _detailModel = [[ActionDetailModel alloc] init];
            
            [_detailModel setValuesForKeysWithDictionary:dict];
            //有数据后再添加表
            [self makeActionIncomeScrollView];
            NSMutableDictionary * responsiblePersonDict = [NSMutableDictionary dictionary];
            
            [responsiblePersonDict setValue:[_detailModel.responsiblePerson[0] valueForKey:@"userid"] forKey:@"id"];
            [responsiblePersonDict setValue:[_detailModel.responsiblePerson[0] valueForKey:@"type"] forKey:@"type"];
            [self.userArray addObject:responsiblePersonDict];
            
          
            NSLog(@"--userArray--%@",_userArray);
            
            for (NSMutableDictionary * assistPeopleDict in _detailModel.assistPeople) {
                
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:assistPeopleDict[@"userid"] forKey:@"id"];
                 
                [dict setValue:assistPeopleDict[@"type"]   forKey:@"type"];
                [self.userArray addObject:dict];
                
    
            }
            NSLog(@"userArray-------%@",_userArray);

            
            for (NSMutableDictionary * indexDict in _detailModel.index) {
                
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                
                [dict setValue:indexDict[@"indexresid"] forKey:@"id"];
                
                [dict setValue:indexDict[@"indexrootid"]   forKey:@"rootid"];
                
                [self.indexArray addObject:dict];

            }
            NSLog(@"indexArray---%@",_indexArray);
            
            self.dateString =[NSString stringWithFormat:@"%@",_detailModel.deadtime];
            
        }
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
        
    }];
    
}

#pragma =====tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if (tableView.tag == 1){
        
        return _defaultIndexInfoModelArray.count; ;
    }else if (tableView.tag == 2){
        
        return self.chooseZuZhiModel.user.count;
        
    }else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

if(tableView.tag == 1){
        
        NSString *CellIdentifier = [NSString stringWithFormat:@"SelectCell%ld%ld", (long)[indexPath section], [indexPath row]];//以indexPath来唯一确定cell
        AddActionSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //列出可重用的cell
        if (cell == nil) {
            cell = [[AddActionSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        DefaultIndexInfoModel * defaultIndexInfoModel = [[DefaultIndexInfoModel alloc] init];
        defaultIndexInfoModel = _defaultIndexInfoModelArray[indexPath.row];
        cell.titleLabel.text = defaultIndexInfoModel.title;
        cell.selectButton .tag = indexPath.row;
       cell.indexID = defaultIndexInfoModel.indexId;

        [cell.selectButton addTarget:self action:@selector(selectDefaultIndexInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_selectedDefaultIndexModelArray.count == 0) {
        
    }else{
        
        for (int i = 0; i< _selectedDefaultIndexModelArray.count;i++) {
            
            DefaultIndexInfoModel * model = _selectedDefaultIndexModelArray[i];
            
            if ([cell.indexID isEqualToString:model.indexId]) {
                
                cell.selectButton.selected = YES;
                [cell.selectButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                [self.butArray addObject:cell.selectButton];
                
            }
            
            
        }
        
    }
        return cell;
    
    }else if(tableView.tag == 2){
        // 选中的当前组织
        NSInteger  dangqizhizi = 0;
        for (int i = 0;i< _defaultD_resModelArray.count;i++ ) {
            
            DefaultD_resModel * model = _defaultD_resModelArray[i];
            
            if (_chooseZuZhiModel.d_res_id == model.d_res_id) {
                
                dangqizhizi = i;
                
            }
        }
        // 当前组织前面所有组织中所包含组织人员的总数量
        NSInteger count = 0;
        for (int i = 0; i < _MeiGeZhuZhiDeUserCountArray.count; i++) {
            if (i == dangqizhizi) {
                
                
                break;
            }else{
                
                count = count + [_MeiGeZhuZhiDeUserCountArray[i] integerValue];
                
            }
            
        }
        
        NSString *CellIdentifier = [NSString stringWithFormat:@"SelectCell%ld",count + indexPath.row];//以indexPath+count来唯一确定cell
        AddActionSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //列出可重用的cell
        if (cell == nil) {
            cell = [[AddActionSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.titleLabel.text = [self.chooseZuZhiModel.user[indexPath.row] valueForKey:@"user_clname"];
        cell.userID = [self.chooseZuZhiModel.user[indexPath.row] valueForKey:@"user_id"];

        cell.selectButton.tag = count + indexPath.row;
        
        [cell.selectButton addTarget:self action:@selector(selectDefaultIndexInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //判断是否已经选择负责人
        if ([_addString isEqualToString:@"AddAssistPeople"]) {
            
            NSLog(@"----%@",_selectedUserArray);
            
            if (_selectedUserArray.count == 0) {
                
            }else{
                
                if ([cell.userID isEqualToString:[_selectedUserArray[0] valueForKey:@"user_id"]]) {
                    cell.selectButton.userInteractionEnabled = NO;
                    cell.contentView.alpha = 0.5;
                }
                
            }
            for (int i = 0; i< _selectedDefaultUserArray.count;i++) {
                
                if ([cell.userID isEqualToString:[_selectedDefaultUserArray[i] valueForKey:@"user_id"]]) {
                    cell.selectButton.selected = YES;
                    [cell.selectButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                    
                }
                
                
            }
            
        }else{
            NSLog(@"----%@",_selectedDefaultUserArray);
            
            if (_selectedDefaultUserArray.count == 0) {
                
                
                
            }else{
                
                for (int i = 0; i< _selectedDefaultUserArray.count;i++) {
                    
                    if ([cell.userID isEqualToString:[_selectedDefaultUserArray[i] valueForKey:@"user_id"]]) {
                        cell.selectButton.userInteractionEnabled = NO;
                        cell.contentView.alpha = 0.5;
                    }
                    
                }
                
            }
            if ([cell.userID isEqualToString:[_selectedUserArray[0] valueForKey:@"user_id"]]) {
                
                cell.selectButton.selected = YES;
                [cell.selectButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                [self.butArray addObject:cell.selectButton];
                NSLog(@"---select--%@",_selectedUserArray);
            }
            
        }
        
        
        
        
        
        return cell;
        
    }else{
        
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        if (indexPath.row == 0) {
            
            return 120*KHeight6scale;
            
        }else if (indexPath.row == 5){
            
            if (_rectJiLuCell.size.height == 0) {
                
                return 150*KHeight6scale;
            }else{
                
                return _rectJiLuCell.size.height;
                
            }
            
        }else if(indexPath.row == 1){
            
            
            if (_rectFuZeRenView.size.height == 0) {
                return (KViewHeight- 270*KHeight6scale)/4.0;
                
            }else{
                
                return _rectFuZeRenView.size.height;
                
            }
            
            
        }else if(indexPath.row == 2){
            
            if (_rectXieZhuRenCell.size.height == 0) {
                return (KViewHeight- 270*KHeight6scale)/4.0;
                
            }else{
                
                return _rectXieZhuRenCell.size.height;
                
            }
            
        }else if(indexPath.row == 3){
            if (_rectXiangGuanIndexCell.size.height == 0) {
                return (KViewHeight- 270*KHeight6scale)/4.0;
                
            }else{
                return _rectXiangGuanIndexCell.size.height;
                
            }
        }else if(indexPath.row == 4){
            
            if (_rectXiangGuanIndexCell.size.height == 0) {
                
                return (KViewHeight- 270*KHeight6scale)/4.0+ 30*KHeight6scale;
                
            }else{
                
                return _rectXiangQingCell.size.height + 20*KHeight6scale;
                
            }
            
        }else {
            
            return (KViewHeight- 270*KHeight6scale)/4.0;
            
        }

    }else if (tableView.tag == 1){
        
        return 30*KHeight6scale;
    }else{
        
        return 30*KHeight6scale;
        
    }
    
    
}
- (void)makeFirstSbView
{
    _firstView = [[ActionIncomeSubView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 120*KWidth6scale)];
    [_actionIncomeScrollView addSubview:_firstView];
    
    _firstView.chuangJianDataStringLabel.text = _detailModel.createtime ;
    [_firstView.jieZhiDataStringButton setTitle:_detailModel.deadtime forState:UIControlStateNormal];
    _firstView.actionFuBuPersonLabel.text = _detailModel.createuser;
    _firstView.imageIncomeActionView.image  = [UIImage imageNamed:@"1.png"];
    
    if ([_detailModel.priority isEqualToString:@"1"]) {
        _firstView.actionStatuLabel.text = @"高";
        _firstView.actionStatuLabel.backgroundColor = RGBCOLOR(250.0, 110.0, 114.0);
    }else if ([_detailModel.priority isEqualToString:@"2"]) {
        _firstView.actionStatuLabel.text = @"中";
        _firstView.actionStatuLabel.backgroundColor = [UIColor orangeColor];
    }else{
        _firstView.actionStatuLabel.text = @"低";
        _firstView.actionStatuLabel.backgroundColor = [UIColor grayColor];
        
        
    }
    
    _firstView.actionFuBuTitleLabel.text = @"任务发布：";
    if ([_loginUserString isEqualToString:_creat_userString]) {
        
        if ([_task_stateString isEqualToString:@"1"] | [_task_stateString isEqualToString:@"2"] |[_task_stateString isEqualToString:@"3"] | [_task_stateString isEqualToString:@"5"]) {
            
            [_firstView.oneButton setTitle:@"编辑" forState:UIControlStateNormal];
            [_firstView.twoButton setTitle:@"撤销" forState:UIControlStateNormal];
            [_firstView.oneButton addTarget:self action:@selector(EidtActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_firstView.twoButton addTarget:self action:@selector(CancelActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ([_task_stateString isEqualToString:@"6"] ){
            
            _firstView.oneButton.hidden = YES;
            [_firstView.twoButton setTitle:@"审核确认" forState:UIControlStateNormal];
            [_firstView.twoButton addTarget:self action:@selector(reviewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ([_task_stateString isEqualToString:@"4"] ){
            
            _firstView.oneButton.hidden = YES;
            [_firstView.twoButton setTitle:@"删除" forState:UIControlStateNormal];
            [_firstView.twoButton addTarget:self action:@selector(deleteActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if( [_task_stateString isEqualToString:@"7"] |[_task_stateString isEqualToString:@"8"] | [_task_stateString isEqualToString:@"9"]){
            _firstView.oneButton.hidden = YES;
            _firstView.twoButton.hidden = YES;
            
        }else{
            
            _firstView.oneButton.hidden = YES;
            _firstView.twoButton.hidden = YES;
            
        }
        
    }else{
        
        
        if ([_task_stateString isEqualToString:@"1"]){
            
            [_firstView.oneButton setTitle:@"接收" forState:UIControlStateNormal];
            [_firstView.oneButton addTarget:self action:@selector(acceptActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_firstView.twoButton setTitle:@"拒绝" forState:UIControlStateNormal];
            [_firstView.twoButton addTarget:self action:@selector(refuseActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([_task_stateString isEqualToString:@"3"]){
            
            [_firstView.oneButton setTitle:@"完成" forState:UIControlStateNormal];
            [_firstView.oneButton addTarget:self action:@selector(reviewActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_firstView.twoButton setTitle:@"申请延迟" forState:UIControlStateNormal];
            [_firstView.twoButton addTarget:self action:@selector(yanchiActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ([_task_stateString isEqualToString:@"5"]){
            
            _firstView.oneButton.hidden = YES;
            [_firstView.twoButton setTitle:@"完成" forState:UIControlStateNormal];
            
            
        }else{
            
            //退回的暂时不可编辑
            
            _firstView.oneButton.hidden = YES;
            _firstView.twoButton.hidden = YES;
            
        }
        
    }
    
    
}
#warning =======cell,2,3,4的方法可以合并 －－后期修改
- (void)makeFuZePeopleView
{
    
    _incomeFuZePeopleView =[[AddActionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_firstView.frame), Main_Screen_Width, 80*KWidth6scale)] ;
    [_actionIncomeScrollView addSubview:_incomeFuZePeopleView];
    
    [_incomeFuZePeopleView.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_detailModel.responsiblePerson.count == 0) {
        
    }else{
        
        UILabel * indexLabel = [[UILabel alloc] init];
        
        indexLabel.backgroundColor = DEFAULT_BGCOLOR;
        indexLabel.layer.masksToBounds = YES;
        indexLabel.layer.cornerRadius = 5;
        indexLabel.textAlignment = NSTextAlignmentCenter;
        
        indexLabel.text = [_detailModel.responsiblePerson[0] valueForKey:@"name"];
        NSLog(@"----%@",indexLabel.text);
        
        indexLabel.font = [UIFont systemFontOfSize:14.0f];
        
        CGRect rect = [indexLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_incomeFuZePeopleView.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
        
        indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);
        [_incomeFuZePeopleView.actionAddView  addSubview:indexLabel];
        
    }
    _incomeFuZePeopleView.imageActionView.image  = [UIImage imageNamed:@"1.png"];
    _incomeFuZePeopleView.actionTitleLabel.text = @"负责人";
    _incomeFuZePeopleView.addButton.hidden = YES;
    
    
    
}
- (void)makeXieZhuPeople
{
    _incomeXieZhuPeopleView = [[AddActionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_incomeFuZePeopleView.frame), Main_Screen_Width, CGRectGetHeight(_incomeFuZePeopleView.frame))];
    [_actionIncomeScrollView addSubview:_incomeXieZhuPeopleView];
    
    [_incomeXieZhuPeopleView.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_detailModel.assistPeople.count != 0) {
        
        for (int i = 0; i <= _detailModel.assistPeople.count-1; i++ ){
            
            
            UILabel * indexLabel = [[UILabel alloc] init];
            
            
            static UILabel *recordLab = nil;
            
            indexLabel.backgroundColor = DEFAULT_BGCOLOR;
            indexLabel.layer.masksToBounds = YES;
            indexLabel.layer.cornerRadius = 5;
            indexLabel.textAlignment = NSTextAlignmentCenter;
            
            
            indexLabel.text = [_detailModel.assistPeople[i] valueForKey:@"username"];
            indexLabel.font = [UIFont systemFontOfSize:14.0f];
            CGRect rect = [indexLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_incomeXieZhuPeopleView.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
            
            if (i == 0) {
                
                indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);
                
            }else{
                
#warning cell.actionAddView.frame 为0？？？？？---未解决
                //                CGFloat yuWidth = CGRectGetWidth(cell.actionAddView.frame) -recordLab.frame.origin.x -recordLab.frame.size.width - 30*KWidth6scale;
                
                CGFloat yuWidth = 275*KWidth6scale -recordLab.frame.origin.x -recordLab.frame.size.width - 30*KWidth6scale;
                if (yuWidth >= rect.size.width) {
                    
                    indexLabel.frame =CGRectMake(recordLab.frame.origin.x +recordLab.frame.size.width + 10*KWidth6scale, recordLab.frame.origin.y, rect.size.width + 5*KWidth6scale, rect.size.height +5*KHeight6scale);
                    
                }else{
                    
                    indexLabel.frame =CGRectMake(0, recordLab.frame.origin.y+recordLab.frame.size.height+10, rect.size.width + 5*KWidth6scale, rect.size.height + 5*KHeight6scale);
                }
                
            }
            recordLab = indexLabel;
            
            CGRect rectCellActionAddView = _incomeXieZhuPeopleView.actionAddView.frame;
            
            rectCellActionAddView.size.height = CGRectGetMaxY(indexLabel.frame);
            
            _incomeXieZhuPeopleView.actionAddView.frame = rectCellActionAddView;
            CGRect rectcell = _incomeXieZhuPeopleView.frame;
            
            rectcell.size.height = CGRectGetMaxY(indexLabel.frame)+(KViewHeight - 270*KHeight6scale)/4.0 - 20*KHeight6scale;
            
            _incomeXieZhuPeopleView.frame = rectcell;
            
            [_incomeXieZhuPeopleView.actionAddView  addSubview:indexLabel];
            
        }
        
    }
    _incomeXieZhuPeopleView.imageActionView.image  = [UIImage imageNamed:@"2.png"];
    _incomeXieZhuPeopleView.actionTitleLabel.text = @"协助人";
    _incomeXieZhuPeopleView.addButton.hidden = YES;
    
    
    
}
- (void)makeIncomeIndexView
{
    
    _incomeIndexView = [[AddActionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_incomeXieZhuPeopleView.frame), Main_Screen_Width, CGRectGetHeight(_incomeXieZhuPeopleView.frame))];
    [_actionIncomeScrollView addSubview:_incomeIndexView];
    
//    [_incomeIndexView.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    if (_detailModel.index.count == 0) {
        
        
    }else{
        
        
        for (int i = 0; i < _detailModel.index.count; i++ ){
            
            
            UILabel * indexLabel = [[UILabel alloc] init];
            
            static UILabel *recordLab = nil;
            
            indexLabel.backgroundColor = DEFAULT_BGCOLOR;
            indexLabel.layer.masksToBounds = YES;
            indexLabel.layer.cornerRadius = 5;
            indexLabel.textAlignment = NSTextAlignmentCenter;
            indexLabel.text = [_detailModel.index[i] valueForKey:@"indexname"];
            

            indexLabel.font = [UIFont systemFontOfSize:14.0f];
            CGRect rect = [indexLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_incomeIndexView.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
            
            if (i == 0) {
                
                indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);
                
            }else{
                
                
                //                CGFloat yuWidth = CGRectGetWidth(cell.actionAddView.frame) -recordLab.frame.origin.x -recordLab.frame.size.width - 50*KWidth6scale;
                CGFloat yuWidth = 275*KWidth6scale -recordLab.frame.origin.x -recordLab.frame.size.width - 30*KWidth6scale;
                if (yuWidth >= rect.size.width) {
                    
                    indexLabel.frame =CGRectMake(recordLab.frame.origin.x +recordLab.frame.size.width + 10*KWidth6scale, recordLab.frame.origin.y, rect.size.width + 5*KWidth6scale, rect.size.height +5*KHeight6scale);
                    
                }else{
                    
                    indexLabel.frame =CGRectMake(0, recordLab.frame.origin.y+recordLab.frame.size.height+10, rect.size.width + 5*KWidth6scale, rect.size.height + 5*KHeight6scale);
                }
                
            }
            recordLab = indexLabel;
            
            CGRect rectCellActionAddView = _incomeIndexView.actionAddView.frame;
            
            rectCellActionAddView.size.height = CGRectGetMaxY(indexLabel.frame);
            
            _incomeIndexView.actionAddView.frame = rectCellActionAddView;
            CGRect rectcell = _incomeIndexView.frame;
            
            rectcell.size.height = CGRectGetMaxY(indexLabel.frame)+(KViewHeight - 270*KHeight6scale)/4.0 - 20*KHeight6scale;
            
            _incomeIndexView.frame = rectcell;
            
            [_incomeIndexView.actionAddView  addSubview:indexLabel];
            
            
        }
        
    }
    
    _incomeIndexView.imageActionView.image  = [UIImage imageNamed:@"3.png"];
    
    _incomeIndexView.actionTitleLabel.text = @"相关指标";
    _incomeIndexView.addButton.hidden = YES;
}
- (void)makeIncomeTaskDetailView
{
    _incomeTaskDetailView = [[AddActionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_incomeIndexView.frame), Main_Screen_Width, CGRectGetHeight(_incomeIndexView.frame))];
    
    
    [_actionIncomeScrollView addSubview:_incomeTaskDetailView];
    
    _incomeTaskDetailView.imageActionView.image  = [UIImage imageNamed:@"4.png"];
                _incomeTaskDetailView.actionTitleLabel.text = @"任务详情";
                _incomeTaskDetailView.addButton.hidden = YES;
                _taskDetaileLabel = [[UILabel alloc] init];
    
                _taskDetaileLabel.text = _detailModel.taskinfo;
                _taskDetaileLabel.numberOfLines = 0;
    
                _taskDetaileLabel.font = [UIFont systemFontOfSize:14.0f];
    
                CGRect rect = [_taskDetaileLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_incomeTaskDetailView.actionAddView.frame)-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_taskDetaileLabel.font} context:nil];
    
                _taskDetaileLabel.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
                CGRect rectCellActionAddView = _incomeTaskDetailView.actionAddView.frame;
    
                rectCellActionAddView.size.height = CGRectGetMaxY(_taskDetaileLabel.frame);
    
                _incomeTaskDetailView.actionAddView.frame = rectCellActionAddView;
    
                CGRect rectcell = _incomeTaskDetailView.frame;
    
                rectcell.size.height = CGRectGetMaxY(_taskDetaileLabel.frame)+(KViewHeight - 270*KHeight6scale)/4.0 - 20*KHeight6scale;
                _incomeTaskDetailView.frame = rectcell;
    
                [_incomeTaskDetailView.actionAddView  addSubview:_taskDetaileLabel];
    
    
                
                

}
- (void)makeIncomeTaskJiLuView
{
    _incomeTaskJiLuView = [[AddActionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_incomeTaskDetailView.frame), Main_Screen_Width, 300)];
    
    _incomeTaskJiLuView.backgroundColor = DEFAULT_BGCOLOR;
    _incomeTaskJiLuView.addButton.hidden  = YES;
    [_actionIncomeScrollView addSubview:_incomeTaskJiLuView];
    
//    [_incomeTaskJiLuPeopleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*KWidth6scale, 10*KWidth6scale, _incomeIndexView.frame.size.width - 40*KWidth6scale, 40*KWidth6scale)];
    titleLabel.text = @"任务状态记录";
    titleLabel.textColor = MoreButtonColor;
    [_incomeTaskJiLuView addSubview:titleLabel];
    static UIView *recordView = nil;
    
    for (int i = 0; i < _detailModel.deatil.count; i++) {
        
        
        UIView * view = [[UIView alloc]init];
        //user
        UILabel * userLabel = [[UILabel alloc ] init];
        userLabel.text = [_detailModel.deatil[i] valueForKey:@"user"];
        userLabel.font = [UIFont systemFontOfSize:13.0f];
        CGRect rectuserLabel = [userLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width-80, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:userLabel.font} context:nil];
        //type
        UILabel * typeLabel = [[UILabel alloc ] init];
        typeLabel.text = [NSString stringWithFormat:@"操作行为: %@",[_detailModel.deatil[i] valueForKey:@"type"]];
        typeLabel.font = [UIFont systemFontOfSize:13.0f];
        CGRect recttypeLabel = [typeLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width-80, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:typeLabel.font} context:nil];
        //text
        UILabel * textLabel = [[UILabel alloc ] init];
        textLabel.text = [NSString stringWithFormat:@"任务详情: %@",[_detailModel.deatil[i] valueForKey:@"text"]];
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:13.0f];
        CGRect recttextLabel = [textLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width-130, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textLabel.font} context:nil];
        
        
        if (i == 0) {
            
            view.frame = CGRectMake(CGRectGetMinX(titleLabel.frame) , CGRectGetMaxY(titleLabel.frame) , CGRectGetWidth(titleLabel.frame), rectuserLabel.size.height + recttextLabel.size.height + recttypeLabel.size.height + 40*KHeight6scale);
            
        }else{
            
            view.frame = CGRectMake(CGRectGetMinX(titleLabel.frame) ,CGRectGetMaxY(recordView.frame) + 5*KHeight6scale, CGRectGetWidth(titleLabel.frame), rectuserLabel.size.height + recttextLabel.size.height + recttypeLabel.size.height + 40*KHeight6scale);
            
        }
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20*KWidth6scale, 20*KHeight6scale)];
        imageView.image = [UIImage imageNamed:@"image.png"];
        [view addSubview:imageView];
        
        UILabel * dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), CGRectGetMinY(imageView.frame), CGRectGetWidth(view.frame) - CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame))];
        dataLabel.font = [UIFont systemFontOfSize:14.0f];
        dataLabel.text = [_detailModel.deatil[i] valueForKey:@"time"];
        
        [view addSubview:dataLabel];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(imageView.frame), CGRectGetMaxY(imageView.frame) + 5 *KHeight6scale, 1, CGRectGetHeight(view.frame) - CGRectGetWidth(imageView.frame) - 5*KHeight6scale)];
        line.backgroundColor = [UIColor grayColor];
        [view addSubview:line];
        
        UIView * taskView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(dataLabel.frame), CGRectGetMinY(line.frame), CGRectGetWidth(dataLabel.frame), CGRectGetHeight(line.frame))];
        taskView.layer.borderWidth = 1;
        taskView.layer.cornerRadius = 5;
        [view addSubview:taskView];
        
        UIImageView * userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*KWidth6scale, 10*KHeight6scale , 20*KWidth6scale, 20*KHeight6scale)];
        userImageView.image = [UIImage imageNamed:@"user.png"];
        [taskView addSubview:userImageView];
        
        userLabel.frame = CGRectMake(CGRectGetMaxX(userImageView.frame) + 5*KWidth6scale, CGRectGetMinY(userImageView.frame), rectuserLabel.size.width, CGRectGetHeight(userImageView.frame));
        [taskView addSubview:userLabel];
        
        UIImageView * typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userLabel.frame)+10*KWidth6scale, CGRectGetMinY(userLabel.frame), CGRectGetWidth(userImageView.frame), CGRectGetHeight(userImageView.frame))];
        typeImageView.image = [UIImage imageNamed:@"type.png"];
        [taskView addSubview:typeImageView];
        
        typeLabel.frame = CGRectMake(CGRectGetMaxX(typeImageView.frame) + 5*KWidth6scale, CGRectGetMinY(typeImageView.frame), recttypeLabel.size.width, CGRectGetHeight(typeImageView.frame));
        [taskView addSubview:typeLabel];
        
        UIImageView * textImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(userImageView.frame), CGRectGetMaxY(userImageView.frame) + 10*KHeight6scale, CGRectGetWidth(userImageView.frame), CGRectGetHeight(userImageView.frame))];
        textImageView.image = [UIImage imageNamed:@"text.png"];
        [taskView addSubview:textImageView];
        textLabel.frame = CGRectMake(CGRectGetMaxX(textImageView.frame) + 5*KWidth6scale, CGRectGetMinY(textImageView.frame), recttextLabel.size.width, recttextLabel.size.height);
        [taskView addSubview:textLabel];
        recordView = view;
        
        CGRect rectCell = _incomeTaskJiLuView.frame;
        
        rectCell.size.height = CGRectGetMaxY(recordView.frame) + 50*KHeight6scale;
        
        _incomeTaskJiLuView.frame = rectCell;
        
        [_incomeTaskJiLuView  addSubview:recordView];
        _actionIncomeScrollView.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(_incomeTaskJiLuView.frame));
  
    }
  
}
// 公共弹框视图
- (void)makePopupViewTitleString:(NSString *)titleString
{
    _pupopView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-125*KWidth6scale, CGRectGetMidY(self.view.frame) - 150*KHeight6scale, 250*KWidth6scale, 150*KHeight6scale)];
    _pupopView.layer.masksToBounds = YES;
    
    _pupopView.backgroundColor = [UIColor whiteColor];
    _pupopView.layer.cornerRadius = 10;
    _pupopView.alpha = 0.0f;
    [self.view addSubview:_pupopView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor grayColor];
        _actionIncomeScrollView.userInteractionEnabled = NO;
        _actionIncomeScrollView.alpha = 0.5;
        _pupopView.alpha = 1.0f;
        
    } completion:nil];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_pupopView.frame), CGRectGetHeight(_pupopView.frame)/5.0)];
    label.text = titleString;
    label.backgroundColor = RGBCOLOR(229, 234, 235);
    [_pupopView addSubview:label];
    
    UILabel * labeltwo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame), CGRectGetWidth(label.frame), CGRectGetHeight(label.frame))];
    labeltwo.text = @"  说明(*必填)";
    [_pupopView addSubview:labeltwo];
    
    _shuoMingTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(labeltwo.frame)+10*KWidth6scale, CGRectGetMaxY(labeltwo.frame), CGRectGetWidth(_pupopView.frame) - 20*KWidth6scale, CGRectGetHeight(_pupopView.frame) - CGRectGetHeight(labeltwo.frame)*3 - 10*KHeight6scale)];
    
    _shuoMingTextView.layer.borderWidth = 1;
    [_pupopView addSubview:_shuoMingTextView];
    
    _OKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _OKButton.frame = CGRectMake(CGRectGetWidth(_pupopView.frame)/2.0-80*KWidth6scale, CGRectGetHeight(_pupopView.frame)-CGRectGetHeight(label.frame)-5*KHeight6scale, 70*KWidth6scale, CGRectGetHeight(label.frame));
    _OKButton.backgroundColor = [UIColor grayColor];
    [_OKButton setTitle:@"确定" forState:UIControlStateNormal];
    [_OKButton setTintColor:[UIColor whiteColor]];
    _OKButton.layer.masksToBounds = YES;
    _OKButton.layer.cornerRadius = 5;
    
    
    [_pupopView addSubview:_OKButton];
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cancelButton.frame = CGRectMake(CGRectGetMaxX(_OKButton.frame) + 20*KWidth6scale, CGRectGetMinY(_OKButton.frame), CGRectGetWidth(_OKButton.frame), CGRectGetHeight(_OKButton.frame));
    _cancelButton.backgroundColor = [UIColor grayColor];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTintColor:[UIColor whiteColor]];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius = 5;
    [_pupopView addSubview:_cancelButton];
    
    
}

//负责人确认任务完成（任务待审核)
- (void)reviewActionButtonClick:(UIButton *)button
{
    [self makePopupViewTitleString:@"  完成任务" ];
    [_OKButton addTarget:self action:@selector(reviewOKButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   
}
//完成待审核
- (void)reviewOKButtonClick:(UIButton *)button
{
    if (_shuoMingTextView.text.length == 0) {
        [MBProgressHUD showSuccess:@"说明不能为空"];
        
    }else{
    NSString * urlStr = [NSString stringWithFormat:ReviewActionHttp,_taskIDString,_shuoMingTextView.text];
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            
            [MBProgressHUD showSuccess:@"任务完成申请"];
            
            [self performSelector:@selector(BackView) withObject:self afterDelay:1.0f];
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
        
    }];
    }
}
//负责人接受任务
- (void)acceptActionButtonClick:(UIButton *)button
{
   
    _acceptView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-125*KWidth6scale, CGRectGetMidY(self.view.frame) - 120*KHeight6scale, 250*KWidth6scale, 120*KHeight6scale)];
    _acceptView.layer.masksToBounds = YES;
    
    _acceptView.backgroundColor = [UIColor whiteColor];
    _acceptView.layer.cornerRadius = 10;
    _acceptView.alpha = 0.0f;
    [self.view addSubview:_acceptView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor grayColor];
        _actionIncomeScrollView.userInteractionEnabled = NO;
        _actionIncomeScrollView.alpha = 0.5;
        _acceptView.alpha = 1.0f;
        
    } completion:nil];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_acceptView.frame), CGRectGetHeight(_acceptView.frame)/4.0)];
    label.text = @"  接收任务";
    label.backgroundColor = RGBCOLOR(229, 234, 235);
    [_acceptView addSubview:label];
    
    UILabel * labeltwo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame), CGRectGetWidth(label.frame), CGRectGetHeight(label.frame))];
    labeltwo.text = @"  确定接收任务？";
    [_acceptView addSubview:labeltwo];
    

    
    UIButton * OKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    OKButton.frame = CGRectMake(CGRectGetWidth(_acceptView.frame)/2.0-80*KWidth6scale, CGRectGetHeight(_acceptView.frame)-CGRectGetHeight(label.frame)-5*KHeight6scale, 70*KWidth6scale, CGRectGetHeight(label.frame));
    OKButton.backgroundColor = [UIColor grayColor];
    [OKButton setTitle:@"确定" forState:UIControlStateNormal];
    [OKButton setTintColor:[UIColor whiteColor]];
    OKButton.layer.masksToBounds = YES;
    OKButton.layer.cornerRadius = 5;
    [OKButton addTarget:self action:@selector(acceptOKButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_acceptView addSubview:OKButton];
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(CGRectGetMaxX(OKButton.frame) + 20*KWidth6scale, CGRectGetMinY(OKButton.frame), CGRectGetWidth(OKButton.frame), CGRectGetHeight(OKButton.frame));
    cancelButton.backgroundColor = [UIColor grayColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTintColor:[UIColor whiteColor]];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 5;
    [_acceptView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
   
}
- (void)acceptOKButtonClick:(UIButton *)button
{
    
    NSString * urlStr = [NSString stringWithFormat:AcceptActionHttp,_taskIDString];
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            
            [MBProgressHUD showSuccess:@"接收成功"];
            
            [self performSelector:@selector(BackView) withObject:self afterDelay:1.0f];
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
        
    }];
}


//下达人确认任务完成，下达人确认任务未完成
- (void)reviewButtonClick:(UIButton *)button{
    
    
    _ShenHeView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-125*KWidth6scale, CGRectGetMidY(self.view.frame) - 200*KHeight6scale, 250*KWidth6scale, 200*KHeight6scale)];
    _ShenHeView.backgroundColor = [UIColor whiteColor];
    _ShenHeView.layer.masksToBounds = YES;
    _ShenHeView.layer.cornerRadius = 10;
    _ShenHeView.alpha = 0.0f;

    [self.view addSubview:_ShenHeView];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor grayColor];
        _actionIncomeScrollView.userInteractionEnabled = NO;
        _actionIncomeScrollView.alpha = 0.5;
        _ShenHeView.alpha = 1.0f;
        
    } completion:nil];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_ShenHeView.frame), CGRectGetHeight(_ShenHeView.frame)/5.0)];
    label.text = @"  审核任务";
    label.backgroundColor = RGBCOLOR(229, 234, 235);

    [_ShenHeView addSubview:label];
    
    UILabel * labelStatu = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame)+10*KWidth6scale, CGRectGetMaxY(label.frame), CGRectGetWidth(label.frame)/2.0, CGRectGetHeight(label.frame)-10*KHeight6scale)];
    labelStatu.text = @"是否完成";
    [_ShenHeView addSubview:labelStatu];
    
     _yesButton= [[UIButton alloc] init];
    _yesButton.frame = CGRectMake(CGRectGetMaxX(labelStatu.frame), CGRectGetMinY(labelStatu.frame), CGRectGetWidth(labelStatu.frame)/6.0, CGRectGetHeight(labelStatu.frame));
    [_yesButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    [_ShenHeView addSubview:_yesButton];
    _yesButton.selected = YES;
    [_yesButton addTarget:self action:@selector(yesOrNoButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UILabel * yeslabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_yesButton.frame), CGRectGetMinY(_yesButton.frame), CGRectGetWidth(_yesButton.frame), CGRectGetHeight(_yesButton.frame))];
    yeslabel.text = @"是";
    [_ShenHeView addSubview:yeslabel];
    
    _noButton = [[UIButton alloc] init];
    _noButton.frame = CGRectMake(CGRectGetMaxX(yeslabel.frame), CGRectGetMinY(yeslabel.frame), CGRectGetWidth(yeslabel.frame), CGRectGetHeight(yeslabel.frame));
    [_noButton setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
    [_ShenHeView addSubview:_noButton];
    _noButton.selected = NO;
    UILabel * nolabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_noButton.frame), CGRectGetMinY(_noButton.frame), CGRectGetWidth(_noButton.frame), CGRectGetHeight(_noButton.frame))];
    nolabel.text = @"否";
    [_ShenHeView addSubview:nolabel];
    [_noButton addTarget:self action:@selector(yesOrNoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * shuoMinglabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(labelStatu.frame), CGRectGetMaxY(labelStatu.frame), CGRectGetWidth(labelStatu.frame), CGRectGetHeight(labelStatu.frame))];
    shuoMinglabel.text = @"任务说明";
    [_ShenHeView addSubview:shuoMinglabel];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(shuoMinglabel.frame), CGRectGetMaxY(shuoMinglabel.frame), CGRectGetWidth(_ShenHeView.frame) - 20*KWidth6scale, CGRectGetHeight(_ShenHeView.frame) - CGRectGetHeight(labelStatu.frame)*4 - 20*KHeight6scale)];
    
    _textView.layer.borderWidth = 1;
    [_ShenHeView addSubview:_textView];
    
    UIButton * OKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    OKButton.frame = CGRectMake(CGRectGetWidth(_ShenHeView.frame)/2.0-80*KWidth6scale, CGRectGetHeight(_ShenHeView.frame)-CGRectGetHeight(yeslabel.frame)-5*KHeight6scale, 70*KWidth6scale, CGRectGetHeight(yeslabel.frame));
    OKButton.backgroundColor = [UIColor grayColor];
    [OKButton setTintColor:[UIColor whiteColor]];
    OKButton.layer.masksToBounds = YES;
    OKButton.layer.cornerRadius = 5;
    [OKButton setTitle:@"确定" forState:UIControlStateNormal];
    [OKButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_ShenHeView addSubview:OKButton];
    UIButton * cancelButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(CGRectGetMaxX(OKButton.frame) + 20*KWidth6scale, CGRectGetMinY(OKButton.frame), CGRectGetWidth(OKButton.frame), CGRectGetHeight(OKButton.frame));
    cancelButton.backgroundColor = [UIColor grayColor];
    [cancelButton setTintColor:[UIColor whiteColor]];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 5;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_ShenHeView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
  
    
}
// 确认任务是否完成的按钮
- (void)yesOrNoButtonClick:(UIButton *)button
{
    if (button.selected == YES) {
       
        
        _yesButton.selected = NO;
        _noButton.selected = NO;
        [_yesButton setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
        [_noButton setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
        
        button.selected = NO;
        [button setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
       
    }else{
        _yesButton.selected = NO;
        _noButton.selected = NO;
        [_yesButton setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
        [_noButton setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        
        button.selected = YES;
      
    }
    
    
}

// 确认审核弹框的确认按钮
- (void)okButtonClick:(UIButton *)button
{
    
   
    if ((_yesButton.selected == YES)&&(_noButton.selected == NO)) {
        
        NSString * urlStr = [NSString stringWithFormat:FinishActionHttp,_taskIDString,_textView.text];

        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            if (responseObject != nil) {
                
                
                [MBProgressHUD showSuccess:@"已经审核，确认完成"];
                
                [self performSelector:@selector(BackView) withObject:self afterDelay:1.0f];

                
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            
        }];
        

        
    }else if((_yesButton.selected == NO)&&(_noButton.selected == YES)){
        
        if (_textView.text.length == 0) {
            [MBProgressHUD showError:@"任务说明不能为空"];

        }else{
            NSString * urlStr = [NSString stringWithFormat:UnfinishActionHttp,_taskIDString,_textView.text];
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            
            [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
                //这里可以用来显示下载进度
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (responseObject != nil) {
                    [MBProgressHUD showSuccess:@"已经审核，任务未完成"];
                    [self performSelector:@selector(BackView) withObject:self afterDelay:1.0f];

                    
                }
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //失败
                NSLog(@"failure  error ： %@",error);
                
            }];

            
        }
       
        
    }else{
        
        [MBProgressHUD showMessage:@"请选择是否完成"];
    }
    
    
}
- (void)BackView
{
    
        [[self navigationController] popViewControllerAnimated:YES];
        

}
// 负责人拒绝任务
- (void)refuseActionButtonClick:(UIButton *)button
{
    [self makePopupViewTitleString:@"  拒绝任务" ];
    
    
    [_OKButton addTarget:self action:@selector(refuseOKButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
// 拒绝任务
- (void)refuseOKButtonClick:(UIButton *)button
{
    if (_shuoMingTextView.text.length == 0) {
        [MBProgressHUD showSuccess:@"说明不能为空"];

    }else{
        
    
    NSString * urlStr = [NSString stringWithFormat:RefuseActionHttp,_taskIDString,_shuoMingTextView.text];
        
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            
            [MBProgressHUD showSuccess:@"拒绝任务成功"];
            
            [self performSelector:@selector(BackView) withObject:self afterDelay:1.0f];
 
        }
 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
        
    }];
    
    }
}
// 下达人撤销任务
- (void)CancelActionButtonClick:(UIButton *)button
{
    
    [self makePopupViewTitleString:@"  撤销任务" ];
    
   
    [_OKButton addTarget:self action:@selector(cancelOKButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];


}
// 确认撤销
- (void)cancelOKButtonClick:(UIButton *)button
{
    if (_shuoMingTextView.text.length == 0) {
        [MBProgressHUD showSuccess:@"说明不能为空"];
        
    }else{
        
        
        NSString * urlStr = [NSString stringWithFormat:CancalActionHttp,_taskIDString,_shuoMingTextView.text];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (responseObject != nil) {
                
                [MBProgressHUD showSuccess:@"撤销任务成功"];
                
                [self performSelector:@selector(BackView) withObject:self afterDelay:1.0f];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            
        }];
        
    }
}
//下达人删除任务
- (void)deleteActionButtonClick:(UIButton *)button
{
    
    [self makePopupViewTitleString:@"  删除任务" ];
    
    
    [_OKButton addTarget:self action:@selector(deleteOKButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];

}
// 确认删除任务
- (void)deleteOKButtonClick:(UIButton *)button
{
    if (_shuoMingTextView.text.length == 0) {
        [MBProgressHUD showSuccess:@"说明不能为空"];
        
    }else{
    NSString * urlStr = [NSString stringWithFormat:DeleteActionHttp,_taskIDString,_shuoMingTextView.text];
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            
            [MBProgressHUD showSuccess:@"任务删除成功"];
            
            [self performSelector:@selector(BackView) withObject:self afterDelay:1.0f];
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
        
    }];
    }
}
// 确认审核弹框的取消按钮
- (void)cancelButtonClick:(UIButton *)button
{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _actionIncomeScrollView.alpha = 1.0f;
        _actionIncomeScrollView.userInteractionEnabled = YES;
        _ShenHeView.alpha = 0.0f;
        
        _acceptView.alpha = 0.0f;
        _pupopView.alpha = 0.0f;
        
        
    } completion:nil];
    
    
    
}
// 编辑任务
- (void)EidtActionButtonClick: (UIButton *)button
{
  // 可优化－－－－－－－－－

    
    if (button.selected) {
        
        button.selected = NO;
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        _incomeFuZePeopleView.addButton.hidden = YES;
        _incomeXieZhuPeopleView.addButton.hidden = YES;
        _incomeIndexView.addButton.hidden = YES;
//        [MBProgressHUD showSuccess:@"保存"];
        _firstView.jieZhiDataStringButton.layer.borderWidth = 0;
        _firstView.jieZhiDataStringButton.backgroundColor = [UIColor whiteColor];

        // 点击保存后的任务详情cell
        [ self makeSaveTaskDetailCell];
        
        [self makeSave];

    }else{
        
        button.selected = YES;
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [MBProgressHUD showSuccess:@"开始编辑"];
        
        _incomeFuZePeopleView.addButton.hidden = NO;
        _incomeXieZhuPeopleView.addButton.hidden = NO;
        _incomeIndexView.addButton.hidden = NO;
        // 点击编辑后的topCell
        [self makeEditTopCell];

        // 点击编辑后的任务详情cell
        [self makeEditTaskDetailCell];
        [_incomeFuZePeopleView.addButton addTarget:self action:@selector(addResponsiblePersonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_incomeXieZhuPeopleView.addButton addTarget:self action:@selector(addAssistPeopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_incomeIndexView.addButton addTarget:self action:@selector(addDefaultIndexInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
   
}
// 点击编辑后的topCell

- (void)makeEditTopCell
{
    // 改变cell高度
    CGRect rectTopCell = _firstView.frame;
    rectTopCell.size.height = CGRectGetHeight(_firstView.frame)+30*KWidth6scale;
    _firstView.frame = rectTopCell;
    
    CGRect rectResponsible_personCell = _incomeFuZePeopleView.frame;
    rectResponsible_personCell.origin.y = CGRectGetMaxY(_firstView.frame);
    _incomeFuZePeopleView.frame = rectResponsible_personCell;
    
    CGRect rectAssistPeopleCell = _incomeXieZhuPeopleView.frame;
    rectAssistPeopleCell.origin.y = CGRectGetMaxY(_incomeFuZePeopleView.frame);
    _incomeXieZhuPeopleView.frame = rectAssistPeopleCell;
    
    CGRect rectIndexCell = _incomeIndexView.frame;
    rectIndexCell.origin.y = CGRectGetMaxY(_incomeXieZhuPeopleView.frame);
    _incomeIndexView.frame = rectIndexCell;
    CGRect rectActionDetailCell = _incomeTaskDetailView.frame;
    
    rectActionDetailCell.origin.y = CGRectGetMaxY(_incomeIndexView.frame);
    _incomeTaskDetailView.frame = rectActionDetailCell;
    
    
    CGRect rectTaskJiLuCell = _incomeTaskJiLuView.frame;
    rectTaskJiLuCell.origin.y = CGRectGetMaxY(_incomeTaskDetailView.frame);
    _incomeTaskJiLuView.frame = rectTaskJiLuCell;
    

    _actionIncomeScrollView.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(_incomeTaskJiLuView.frame));
    
    [_firstView   addSubview:_firstView.taskEditView];
    
    
    _firstView.jieZhiDataStringButton.backgroundColor = DEFAULT_BGCOLOR;
    _firstView.jieZhiDataStringButton.layer.borderWidth = 1;
    
    [_firstView.jieZhiDataStringButton addTarget:self action:@selector(editDateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * youXianJiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_firstView.frame)- 40*KWidth6scale, 0, 60*KWidth6scale, 20*KHeight6scale)];
    youXianJiLabel.text = @"优先级";
    youXianJiLabel.font = [UIFont systemFontOfSize:14.0f];
    [_firstView.taskEditView addSubview:youXianJiLabel];
    
    
    _gaoButton= [[UIButton alloc] init];
    _gaoButton.frame  = CGRectMake(CGRectGetMaxX(youXianJiLabel.frame), CGRectGetMinY(youXianJiLabel.frame) , 25*KWidth6scale, CGRectGetHeight(youXianJiLabel.frame));
    _gaoButton.tintColor = [UIColor  whiteColor];
    _gaoButton.layer.cornerRadius = 3;
    
    
    
    [_gaoButton setTitle:@"高" forState:UIControlStateNormal];
    _priorityIntType = 1;
    _gaoButton.backgroundColor = DEFAULT_BGCOLOR;
    [_gaoButton addTarget:self action:@selector(youXianJiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _midButton= [[UIButton alloc] init];
    _midButton.frame  = CGRectMake(CGRectGetMaxX(youXianJiLabel.frame)+(10 + 25)*KWidth6scale, CGRectGetMinY(youXianJiLabel.frame) , 25*KWidth6scale, CGRectGetHeight(youXianJiLabel.frame));
    _midButton.tintColor = [UIColor  whiteColor];
    _midButton.layer.cornerRadius = 3;
    
    
    [_midButton setTitle:@"中" forState:UIControlStateNormal];
    _midButton.backgroundColor = DEFAULT_BGCOLOR;
    [_midButton addTarget:self action:@selector(youXianJiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _diButton = [[UIButton alloc] init];
    _diButton.frame  = CGRectMake(CGRectGetMaxX(youXianJiLabel.frame)+2*(10 + 25)*KWidth6scale, CGRectGetMinY(youXianJiLabel.frame) , 25*KWidth6scale, CGRectGetHeight(youXianJiLabel.frame));
    _diButton.tintColor = [UIColor  whiteColor];
    _diButton.layer.cornerRadius = 3;
    
    
    [_diButton setTitle:@"低" forState:UIControlStateNormal];
    _diButton.selected = NO;
    _diButton.backgroundColor = DEFAULT_BGCOLOR;
    [_diButton addTarget:self action:@selector(youXianJiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([_detailModel.priority isEqualToString:@"1"]) {
        _gaoButton.selected = YES;
        _midButton.selected = NO;
        _diButton.selected = NO;
        
        _gaoButton.backgroundColor = [UIColor redColor];
    }else if([_detailModel.priority isEqualToString:@"2"]){
        
        _gaoButton.selected = NO;
        _midButton.selected = YES;
        _diButton.selected = NO;
        
        _midButton.backgroundColor = [UIColor redColor];
    }else{
        
        _gaoButton.selected = NO;
        _midButton.selected = NO;
        _diButton.selected = YES;
        
        _diButton.backgroundColor = [UIColor redColor];
        
    }
    
    UILabel * actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(youXianJiLabel.frame), CGRectGetWidth(youXianJiLabel.frame)-20*KWidth6scale, CGRectGetHeight(youXianJiLabel.frame))];
    actionLabel.text = @"任务";
    actionLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [_firstView.taskEditView addSubview:actionLabel];
    
    _puTongTaskButton = [[UIButton alloc] init];
    _puTongTaskButton.frame = CGRectMake(CGRectGetMaxX(actionLabel.frame), CGRectGetMinY(actionLabel.frame) , 40*KWidth6scale, CGRectGetHeight(actionLabel.frame));
    [_puTongTaskButton setTitle:@"普通" forState:UIControlStateNormal];
    _puTongTaskButton.layer.cornerRadius = 3;
    
    _puTongTaskButton.backgroundColor = DEFAULT_BGCOLOR;
    [_puTongTaskButton addTarget:self action:@selector(taskTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    _zhuanXiangTaskButton = [[UIButton alloc] init];
    _zhuanXiangTaskButton.frame = CGRectMake(CGRectGetMaxX(_puTongTaskButton.frame)+10*KWidth6scale, CGRectGetMinY(_puTongTaskButton.frame) , CGRectGetWidth(_puTongTaskButton.frame), CGRectGetHeight(_puTongTaskButton.frame));
    _zhuanXiangTaskButton.layer.cornerRadius = 3;
    
    [_zhuanXiangTaskButton setTitle:@"专项" forState:UIControlStateNormal];
    _zhuanXiangTaskButton.backgroundColor = DEFAULT_BGCOLOR;
    [_zhuanXiangTaskButton addTarget:self action:@selector(taskTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([_detailModel.tasktype isEqualToString:@"N"]) {
        _puTongTaskButton.selected = YES;
        _zhuanXiangTaskButton.selected = NO;
    }else{
        _puTongTaskButton.selected = NO;
        _zhuanXiangTaskButton.selected = YES;
    }
    
    if (_puTongTaskButton.selected == YES) {
        _tasktype = @"N";
        _puTongTaskButton.backgroundColor = [UIColor grayColor];

    }else if(_zhuanXiangTaskButton.selected == YES){
        _tasktype = @"S";
        _zhuanXiangTaskButton.backgroundColor = [UIColor grayColor];

    }
    [_firstView.taskEditView addSubview:_puTongTaskButton];
    [_firstView.taskEditView addSubview:_zhuanXiangTaskButton];
    
    [_firstView.taskEditView addSubview:_gaoButton];
    
    [_firstView.taskEditView addSubview:_midButton];
    
    [_firstView.taskEditView addSubview:_diButton];
}
// 日期选择
- (void)editDateButtonClick:(UIButton *)button
{
        UIDatePicker *picker = [[UIDatePicker alloc]init];
        picker.datePickerMode = UIDatePickerModeDate;
        
        picker.frame = CGRectMake(0, 40, 320, 200);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSDate *date = picker.date;
         
            NSString * dateString = [date stringWithFormat:@"yyyy-MM-dd"];
           
            [_firstView.jieZhiDataStringButton setTitle:dateString forState:UIControlStateNormal];
            
            _dateString = dateString;
            
        }];
        [alertController.view addSubview:picker];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    

}
// 优先级选择
- (void)youXianJiButtonClick:(UIButton *)button
{
    
    if (button.selected == YES) {
        
    }else{
        _midButton.selected = NO;
        _midButton.backgroundColor = DEFAULT_BGCOLOR;
        _gaoButton.selected = NO;
        _gaoButton.backgroundColor = DEFAULT_BGCOLOR;
        _diButton.selected = NO;
        _diButton.backgroundColor = DEFAULT_BGCOLOR;
        button.selected = YES;
        button.backgroundColor = [UIColor redColor];
    }
    
    if (_gaoButton.selected == YES) {
        _priorityIntType = 1;
    }else if(_midButton.selected == YES){
        _priorityIntType = 2;
    }else if(_diButton.selected == YES){
        _priorityIntType = 3;
    }
}
// 任务类型选择
- (void)taskTypeClick:(UIButton *)button
{
    
    if (button.selected == YES) {
        
    }else{
        _puTongTaskButton.selected = NO;
        _puTongTaskButton.backgroundColor = DEFAULT_BGCOLOR;
        _zhuanXiangTaskButton.selected = NO;
        _zhuanXiangTaskButton.backgroundColor = DEFAULT_BGCOLOR;
        
        button.selected = YES;
        button.backgroundColor = [UIColor grayColor];
    }
    
    if (_puTongTaskButton.selected == YES) {
        _tasktype = @"N";
    }else if(_zhuanXiangTaskButton.selected == YES){
        _tasktype = @"S";
    }
}

// 保存成功或失败
- (void)makeSave
{
    
     if(_userArray.count == 0){
        
        [MBProgressHUD showError:@"任务负责人不能为空"];
        
    }else if (_indexArray.count == 0){
        [MBProgressHUD showError:@"任务相关指标不能为空"];
        
    }else{
        NSLog(@"----_taskInfoTextView--%@",_taskInfoTextView.text);
       
        NSLog(@"--_taskIDString-%@",_taskIDString);
        NSLog(@"-_detailModel.deadtime--%@",_dateString);
        NSLog(@"---%@",_tasktype);
        NSData *userdata= [NSJSONSerialization dataWithJSONObject:_userArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *userdataStr= [[NSString alloc]initWithData:userdata encoding:NSUTF8StringEncoding];
        
        NSData *indexData = [NSJSONSerialization dataWithJSONObject:_indexArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *indexDataStr= [[NSString alloc]initWithData:indexData encoding:NSUTF8StringEncoding];
        
        NSString * priorityIntTypeStr = [NSString stringWithFormat:@"%ld",_priorityIntType];
        NSLog(@"-------%@",priorityIntTypeStr);
        NSLog(@"----_userArray ---%@",userdataStr);
        NSLog(@"----_indexArray---%@",indexDataStr);
        NSMutableDictionary * requestDic = @{
                                             
                                             @"key":@"edit",
                                             @"taskid":_taskIDString,
                                             @"dateline":_dateString,
                                             @"tasktitle":_titleString,
                                             @"priority":priorityIntTypeStr,
                                             @"tasktype":_tasktype,
                                             @"user":  userdataStr,
                                             @"index": indexDataStr,
                                             @"taskinfo":_taskInfoTextView.text
                                             
                                             }.mutableCopy;
        
        
        
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager POST:EditActionHttp parameters:requestDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"--newActionresponseObject---%@",responseObject);
            if (responseObject != nil) {
                
                [MBProgressHUD showSuccess:@"保存成功"];
                
                [self performSelector:@selector(BackView) withObject:self afterDelay:1.0f];
                
                [_indexArray removeAllObjects];
                [_userArray removeAllObjects];
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            [MBProgressHUD showSuccess:@"保存失败"];

            
        }];
        
        
    }

}
#pragma ============== 编辑界面的所有添加事件等
// 相关指标数据
- (void)makeDefaultIndexInfoData
{
    NSString * urlStr = [NSString stringWithFormat:GetDefaultIndexInfoHttp];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            
            NSMutableArray * array = responseObject[@"resdata"];
            
            for (NSDictionary * dict in array) {
                
                DefaultIndexInfoModel * defaultIndexInfoModel = [[DefaultIndexInfoModel alloc] init];
                [defaultIndexInfoModel setValuesForKeysWithDictionary:dict];
                // _xxx和self.xxx的区别：当使用self.xxx会调用xxx的get方法而_xxx并不会调用，正确的使用个方式是通过self去调用才会执行懒加载方法
                [self.defaultIndexInfoModelArray addObject:defaultIndexInfoModel];
                
            }
            for (NSMutableDictionary * dict in _indexArray) {
                for (NSMutableDictionary * indeDit in array) {
                    if ([[dict valueForKey:@"id"] isEqualToString:[indeDit valueForKey:@"index_id"]]) {
                        DefaultIndexInfoModel * model = [[DefaultIndexInfoModel alloc] init];
                        [model setValuesForKeysWithDictionary:indeDit];
                        [self.selectedDefaultIndexModelArray addObject:model];

                    }
                }
            }
            NSLog(@"p---index---%@",_selectedDefaultIndexModelArray);
            
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
        
    }];
}
// 协助人、负责人数据
- (void)makeAddActionPersonData
{
    NSString * urlStr = [NSString stringWithFormat:GetDefaultDimUserInfoHttp];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            NSMutableArray * array = responseObject[@"resdata"];
            for (int i = 0 ;i < array.count ; i++) {
                
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                
                dict = array[i];
                
                DefaultD_resModel * defaultD_resModel = [[DefaultD_resModel alloc] init];
                
                [defaultD_resModel setValuesForKeysWithDictionary:dict];
                if ([defaultD_resModel.d_res_parentid isEqualToString:@"0"]) {
                    DefaultD_resModel * model = [[DefaultD_resModel alloc] initWithParentId:defaultD_resModel.d_res_parentid nodeId:defaultD_resModel.d_res_id name:defaultD_resModel.d_res_clname res_level:defaultD_resModel.res_level expand:YES user: defaultD_resModel.user];
                    [self.defaultD_resModelArray addObject:model];
                    
                }else{
                    
                    DefaultD_resModel * model = [[DefaultD_resModel alloc] initWithParentId:defaultD_resModel.d_res_parentid nodeId:defaultD_resModel.d_res_id name:defaultD_resModel.d_res_clname res_level:defaultD_resModel.res_level expand:NO user: defaultD_resModel.user];
                    [self.defaultD_resModelArray addObject:model];
                    
                }
                NSMutableArray * userArray = dict[@"user"];
                
                NSNumber * number = [NSNumber numberWithInteger:userArray.count];
                [self.MeiGeZhuZhiDeUserCountArray addObject:number];
                
                for (int j = 0; j< userArray.count;j++) {
                    
                    NSMutableDictionary * userDict = [NSMutableDictionary dictionary];
                    userDict = userArray[j];
                    NSLog(@"--userDict--%@",userDict);
                    [self.defaultUserArray addObject:userDict];
                    
                }
                // 编辑的时候默认已经选择的user
                for (NSMutableDictionary * dict in _userArray) {
                   
                    for (NSMutableDictionary * userDict in userArray) {
                        if ([[dict valueForKey:@"id"]isEqualToString:[userDict valueForKey:@"user_id"]] &&[[dict valueForKey:@"type"] isEqualToString:@"2"]) {
                            [self.selectedUserArray addObject:userDict];
                        }else if ([[dict valueForKey:@"id"]isEqualToString:[userDict valueForKey:@"user_id"]] &&[[dict valueForKey:@"type"] isEqualToString:@"3"]){
                            [self.selectedDefaultUserArray addObject:userDict];
                        }
                        
                    }
 
                }

            }
            
        }
        NSLog(@"selsuser----%@",_selectedUserArray);
        
        
        
        NSLog(@"aspeople---%@",_selectedDefaultUserArray);
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
    }];
}
// 添加负责人
- (void)addResponsiblePersonButtonClick:(UIButton *)button
{

    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:_userArray];
    
    if (_userArray.count == 0) {
        
    }else{
        for (int i = 0 ;i < _userArray.count ; i++) {
            NSMutableDictionary * dic = _userArray[i];
            NSLog(@"---dic--%@",dic);
            if ([[dic objectForKey:@"type"] isEqualToString:@"2"]) {
                
                [tempArray removeObject:dic];
                
            }
        }
        
    }
    _userArray = [NSMutableArray arrayWithArray:tempArray];
    
    _addString = @"AddResponsiblePerson";
    
    [self makeAddPersonView];
    
}
// 添加协助人
- (void)addAssistPeopleButtonClick:(UIButton *)button
{
    _addString = @"AddAssistPeople";
    // 用来交换的数组（要不然再删除的时候有bug）
    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:_userArray];
    
    if (_userArray.count == 0) {
        
    }else{
        
        for (int i = 0 ;i < _userArray.count ; i++) {
            NSMutableDictionary * dic = _userArray[i];
            if ([[dic objectForKey:@"type"] isEqualToString:@"3"]) {
                
                [tempArray removeObject:dic];
                
            }
        }
        
    }
    _userArray = [NSMutableArray arrayWithArray:tempArray];
    
    
    [self makeAddPersonView];
    
    
}
// 添加相关指标
- (void)addDefaultIndexInfoButtonClick:(UIButton *)button
{
    _addString = @"AddDefaultIndex";
    [_indexArray removeAllObjects];
    _defaultIndexInfoView = [[UIView alloc] initWithFrame:CGRectMake(60*KWidth6scale, 120*KHeight6scale, Main_Screen_Width-120*KWidth6scale, KViewHeight-280*KHeight6scale)];
    _defaultIndexInfoView.backgroundColor = [UIColor whiteColor];
    _defaultIndexInfoView.alpha = 0.0f;
    _defaultIndexInfoView.layer.masksToBounds = YES;
    _defaultIndexInfoView.layer.cornerRadius = 10;
    _defaultIndexInfoView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_defaultIndexInfoView];
    UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_defaultIndexInfoView.frame), 40*KHeight6scale)];
    labelTitle.backgroundColor = RGBCOLOR(229, 234, 235);
    labelTitle.text = @"  相关指标";
    
    [_defaultIndexInfoView addSubview:labelTitle];
    
    UITableView * defaultIndexInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame),CGRectGetWidth(_defaultIndexInfoView.frame),CGRectGetHeight(_defaultIndexInfoView.frame)-CGRectGetHeight(labelTitle.frame)) style:UITableViewStylePlain];
    
    defaultIndexInfoTableView.tag = 1;
    defaultIndexInfoTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_defaultIndexInfoView addSubview:defaultIndexInfoTableView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor grayColor];
        _actionIncomeScrollView.userInteractionEnabled = NO;
        _actionIncomeScrollView.alpha = 0.5;
        _defaultIndexInfoView.alpha = 1.0f;
        
    } completion:nil];
    
    
    defaultIndexInfoTableView.dataSource = self;
    defaultIndexInfoTableView.delegate = self;
    
    
}
- (void)makeAddPersonView
{
    
    _addPersonView = [[UIView alloc] initWithFrame:CGRectMake(60*KWidth6scale, 120*KHeight6scale, Main_Screen_Width-120*KWidth6scale, KViewHeight-280*KHeight6scale)];
    _addPersonView.layer.masksToBounds = YES;
    _addPersonView.layer.cornerRadius = 10;
    _addPersonView.backgroundColor = [UIColor whiteColor];
    _addPersonView.alpha = 1.0f;
    
    [self.view addSubview:_addPersonView];
    UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_addPersonView.frame), 40*KHeight6scale)];
    labelTitle.backgroundColor = RGBCOLOR(229, 234, 235);
    if ([_addString isEqualToString:@"AddAssistPeople"]){
        labelTitle.text = @"  协助人";
    }else {
        labelTitle.text = @"  负责人";
    }
    _chooseZuZhiButton = [[UIButton alloc] init];
    _chooseZuZhiButton.frame = CGRectMake(20*KWidth6scale, CGRectGetMaxY(labelTitle.frame)+5*KHeight6scale, CGRectGetWidth(labelTitle.frame)-40*KWidth6scale, CGRectGetHeight(labelTitle.frame)-10*KHeight6scale);
    _chooseZuZhiButton.layer.borderWidth = 1;
    _chooseZuZhiButton.layer.masksToBounds = YES;
    _chooseZuZhiButton.layer.cornerRadius = 10;
    _chooseZuZhiButton.layer.borderColor = [UIColor grayColor].CGColor;
    [_chooseZuZhiButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _chooseZuZhiModel = _defaultD_resModelArray[0];
    [_chooseZuZhiButton setTitle:_chooseZuZhiModel.d_res_clname forState:UIControlStateNormal];
    // 添加观察者（_chooseModel发生改变时）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseModelChange) name:@"chooseModelChange" object:nil];
    [_addPersonView addSubview:_chooseZuZhiButton];
    [_chooseZuZhiButton addTarget:self action:@selector(chooseZuZhiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_addPersonView addSubview:labelTitle];
    _addPersonView.alpha = 0.0f;
    [_addPersonView addSubview:_chooseZuZhiButton];
    _defaultPersonTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_chooseZuZhiButton.frame),CGRectGetWidth(_addPersonView.frame),CGRectGetHeight(_addPersonView.frame)-CGRectGetHeight(labelTitle.frame)*2) style:UITableViewStylePlain];
    _defaultPersonTabelView.backgroundColor = [UIColor whiteColor];
    _defaultPersonTabelView.tag = 2;
    _defaultPersonTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_addPersonView addSubview:_defaultPersonTabelView];
    _defaultPersonTabelView.dataSource = self;
    _defaultPersonTabelView.delegate = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor grayColor];
        _actionIncomeScrollView.userInteractionEnabled = NO;
        _actionIncomeScrollView.alpha = 0.5;
        _addPersonView.alpha = 1.0f;
        
    } completion:nil];
    
    
    
}
- (void)chooseZuZhiButtonClick:(UIButton *)button
{
    
    [_tableview removeFromSuperview];
    
    // 每次点击组织button的时候都是默认不展开的
    for (int i = 0; i < _defaultD_resModelArray.count; i++) {
        DefaultD_resModel * d_resModel = [[DefaultD_resModel alloc] init];
        d_resModel =_defaultD_resModelArray[i];
        
        if ([d_resModel.d_res_parentid isEqualToString:@"0"]) {
            d_resModel.expand = YES;
            
        }else{
            
            d_resModel.expand = NO;
            
        }
        
        
    }
    _tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_chooseZuZhiButton.frame), CGRectGetMaxY(_chooseZuZhiButton.frame),CGRectGetWidth(_chooseZuZhiButton.frame),CGRectGetHeight(_addPersonView.frame)-CGRectGetMaxY(_chooseZuZhiButton.frame)-5*KHeight6scale) withData:_defaultD_resModelArray];
    _tableview.treeTableCellDelegate = self;
    _tableview.layer.cornerRadius = 10;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.layer.borderColor = [UIColor grayColor].CGColor;
    _tableview.layer.borderWidth =1;
    [_addPersonView addSubview:_tableview];
    
    
}
// chooseModel观察者方法
- (void)chooseModelChange
{
    if (_tableview.model == NULL) {
        _chooseZuZhiModel = _defaultD_resModelArray[0];
    }else{
        _chooseZuZhiModel =   _tableview.model;
        
    }
    [_chooseZuZhiButton setTitle:_chooseZuZhiModel.d_res_clname forState:UIControlStateNormal];
    [_tableview removeFromSuperview];
    
    [_defaultPersonTabelView reloadData];
    
}
// 选择事件
-(void)selectDefaultIndexInfoButtonClick:(UIButton *)button
{
    
    if (button.selected) {
        
        
        if ([_addString isEqualToString:@"AddDefaultIndex"]) {
            button.selected = NO;
            [button setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
            [self.selectedDefaultIndexModelArray removeObject:_defaultIndexInfoModelArray[button.tag]];
            
        }else if ([_addString isEqualToString:@"AddAssistPeople"]){
            button.selected = NO;
            [button setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
            
            [self.selectedDefaultUserArray removeObject:_defaultUserArray[button.tag]];
            
        }else{
            button.selected = NO;
            
            [button setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
            [_butArray removeAllObjects];
            [self.selectedUserArray removeObject:_defaultUserArray[button.tag]];
        }
    }else{
        
        if ([_addString isEqualToString:@"AddDefaultIndex"]) {
            button.selected = YES;
            [button setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            
            [self.selectedDefaultIndexModelArray addObject:_defaultIndexInfoModelArray[button.tag]];
            
        }else if ([_addString isEqualToString:@"AddAssistPeople"]){
            button.selected = YES;
            
            [button setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            
            [self.selectedDefaultUserArray addObject:_defaultUserArray[button.tag]];
            
        }else{
            button.selected = YES;
            
            [button setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            
            [self.selectedUserArray removeAllObjects];
            [self.selectedUserArray addObject:_defaultUserArray[button.tag]];
            
            [self.butArray addObject:button];
            
            if (_selectedUserArray.count >= 1) {
                
                
                for (int i = 0; i< _butArray.count-1;i++) {
                    
                    
                    [_butArray[i] setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
                    [_butArray[i] setSelected:NO];
                    [_butArray removeObjectAtIndex:i];
                }
                
                
            }
            
        }
        
        
    }
    
    NSLog(@"----%@",_selectedDefaultIndexModelArray);
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if ([_addString isEqualToString:@"AddDefaultIndex"]) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _defaultIndexInfoView.userInteractionEnabled = NO;
            _actionIncomeScrollView.userInteractionEnabled = YES;
            _actionIncomeScrollView.backgroundColor = [UIColor whiteColor];
            _actionIncomeScrollView.alpha = 1;
            _defaultIndexInfoView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            
            [_incomeIndexView.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            DefaultIndexInfoModel * model = [[DefaultIndexInfoModel alloc] init];
            if (_selectedDefaultIndexModelArray.count == 0) {
                
                
            }else{
                
                
                for (int i = 0; i <= _selectedDefaultIndexModelArray.count-1; i++ ){
                    NSMutableDictionary * indexDict = [NSMutableDictionary dictionary];
                    model = _selectedDefaultIndexModelArray[i];
                    [indexDict setValue:model.index_id forKey:@"id"];
                    [indexDict setValue:model.index_root_id forKey:@"rootid"];
                    [self.indexArray addObject:indexDict];
                    
                    UILabel * indexLabel = [[UILabel alloc] init];
                    
                    static UILabel *recordLab = nil;
                    
                    indexLabel.backgroundColor = DEFAULT_BGCOLOR;
                    indexLabel.layer.masksToBounds = YES;
                    indexLabel.layer.cornerRadius = 5;
                    indexLabel.textAlignment = NSTextAlignmentCenter;
                    
                    NSString * indexString =[NSString stringWithFormat:@"%@",model.title] ;
                    indexLabel.text = indexString;
                    indexLabel.font = [UIFont systemFontOfSize:14.0f];
                    CGRect rect = [indexString boundingRectWithSize:CGSizeMake(CGRectGetWidth(_incomeIndexView.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
                    
                    if (i == 0) {
                        
                        indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);
                        
                    }else{
                        
                        
                        CGFloat yuWidth = CGRectGetWidth(_incomeIndexView.actionAddView.frame) -recordLab.frame.origin.x -recordLab.frame.size.width - 50*KWidth6scale;
                        
                        if (yuWidth >= rect.size.width) {
                            
                            indexLabel.frame =CGRectMake(recordLab.frame.origin.x +recordLab.frame.size.width + 10*KWidth6scale, recordLab.frame.origin.y, rect.size.width + 5*KWidth6scale, rect.size.height +5*KHeight6scale);
                            
                        }else{
                            
                            indexLabel.frame =CGRectMake(0, recordLab.frame.origin.y+recordLab.frame.size.height+10, rect.size.width + 5*KWidth6scale, rect.size.height + 5*KHeight6scale);
                        }
                        
                    }
                    recordLab = indexLabel;
                    
                    CGRect rectCellActionAddView = _incomeIndexView.actionAddView.frame;
                    
                    rectCellActionAddView.size.height = CGRectGetMaxY(indexLabel.frame);
                    
                    _incomeIndexView.actionAddView.frame = rectCellActionAddView;
                    CGRect rectcell = _incomeIndexView.frame;
                    
                    rectcell.size.height = CGRectGetMaxY(indexLabel.frame)+(KViewHeight - 320*KHeight6scale)/3.0 - 20*KHeight6scale;
                    
                    _incomeIndexView.frame = rectcell;
                    
                    [_incomeIndexView.actionAddView  addSubview:indexLabel];
                    
                    
                    CGRect rectcelltwo = _incomeTaskDetailView.frame;
                    
                    rectcelltwo.origin.y = CGRectGetMaxY(_incomeIndexView.frame);
                    
                    _incomeTaskDetailView.frame = rectcelltwo;
                    
            
                    
                    CGRect rectcellthree = _incomeTaskJiLuView.frame;
                    
                    rectcellthree.origin.y = CGRectGetMaxY(_incomeTaskDetailView.frame);
                    
                    _incomeTaskJiLuView.frame = rectcellthree;
                 
                    _actionIncomeScrollView.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(_incomeTaskJiLuView.frame));
                    
                }
                
            }
            
        }];
        
    }else if ([_addString isEqualToString:@"AddAssistPeople"]){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _addPersonView.userInteractionEnabled = NO;
            _actionIncomeScrollView.userInteractionEnabled = YES;
            _actionIncomeScrollView.backgroundColor = [UIColor whiteColor];
            _actionIncomeScrollView.alpha = 1;
            _addPersonView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            
            [_incomeXieZhuPeopleView.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            if (_selectedDefaultUserArray.count == 0) {
            
            }else{
                
                for (int i = 0; i <= _selectedDefaultUserArray.count-1; i++ ){
                    NSMutableDictionary * userDict = [NSMutableDictionary dictionary];
                    
                    dict = _selectedDefaultUserArray[i];
                    
                    [userDict setValue:dict[@"user_id"] forKey:@"id"];
                    [userDict setValue:@"3" forKey:@"type"];
                    
                    [self.userArray addObject:userDict];
                    UILabel * indexLabel = [[UILabel alloc] init];
                    
                    
                    static UILabel *recordLab = nil;
                    
                    indexLabel.backgroundColor = DEFAULT_BGCOLOR;
                    indexLabel.layer.masksToBounds = YES;
                    indexLabel.layer.cornerRadius = 5;
                    indexLabel.textAlignment = NSTextAlignmentCenter;
                    
                    NSString * userNameString =[NSString stringWithFormat:@"%@",dict[@"user_clname"]] ;
                    
                    indexLabel.text = userNameString;
                    indexLabel.font = [UIFont systemFontOfSize:14.0f];
                    CGRect rect = [userNameString boundingRectWithSize:CGSizeMake(CGRectGetWidth(_incomeXieZhuPeopleView.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
                    
                    if (i == 0) {
                        
                        indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);
                        
                    }else{
                        
                        CGFloat yuWidth = CGRectGetWidth(_incomeXieZhuPeopleView.actionAddView.frame) -recordLab.frame.origin.x -recordLab.frame.size.width - 30*KWidth6scale;
                        
                        if (yuWidth >= rect.size.width) {
                            
                            indexLabel.frame =CGRectMake(recordLab.frame.origin.x +recordLab.frame.size.width + 10*KWidth6scale, recordLab.frame.origin.y, rect.size.width + 5*KWidth6scale, rect.size.height +5*KHeight6scale);
                            
                        }else{
                            
                            indexLabel.frame =CGRectMake(0, recordLab.frame.origin.y+recordLab.frame.size.height+10, rect.size.width + 5*KWidth6scale, rect.size.height + 5*KHeight6scale);
                        }
                        
                    }
                    recordLab = indexLabel;
                    
                    CGRect rectCellActionAddView = _incomeXieZhuPeopleView.actionAddView.frame;
                    
                    rectCellActionAddView.size.height = CGRectGetMaxY(indexLabel.frame);
                    
                    _incomeXieZhuPeopleView.actionAddView.frame = rectCellActionAddView;
                    
                    CGRect rectcell = _incomeXieZhuPeopleView.frame;
                    
                    rectcell.size.height = CGRectGetMaxY(indexLabel.frame)+(KViewHeight - 320*KHeight6scale)/3.0 - 20*KHeight6scale;
                    
                    _incomeXieZhuPeopleView.frame = rectcell;
                    
                    [_incomeXieZhuPeopleView.actionAddView  addSubview:indexLabel];
                    
                    CGRect rectcelltwo = _incomeIndexView.frame;
                    
                    rectcelltwo.origin.y = CGRectGetMaxY(_incomeXieZhuPeopleView.frame);
                    
                    _incomeIndexView.frame = rectcelltwo;
                    
                
                    CGRect rectcellthree = _incomeTaskDetailView.frame;
                    
                    rectcellthree.origin.y = CGRectGetMaxY(_incomeIndexView.frame);
                    
                    _incomeTaskDetailView.frame = rectcellthree;
                    
                   
                    CGRect rectcellfour = _incomeTaskJiLuView.frame;
                    
                    rectcellfour.origin.y = CGRectGetMaxY(_incomeTaskDetailView.frame);
                    
                    _incomeTaskJiLuView.frame = rectcellfour;
                 
                      _actionIncomeScrollView.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(_incomeTaskJiLuView.frame));
                    
                }
                
            }
            
        }];
    }else if ([_addString isEqualToString:@"AddResponsiblePerson"]){
        // 删除所有button
        [_butArray removeAllObjects];
        [UIView animateWithDuration:0.5 animations:^{
            
            _addPersonView.userInteractionEnabled = NO;
            _actionIncomeScrollView.userInteractionEnabled = YES;
            _actionIncomeScrollView.backgroundColor = [UIColor whiteColor];
            _actionIncomeScrollView.alpha = 1;
            _addPersonView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
                      [_incomeFuZePeopleView.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            if (_selectedUserArray.count == 0) {
                
                
            }else{
                
                
                dict = _selectedUserArray[0];
                NSMutableDictionary * userFuZeDict = [NSMutableDictionary dictionary];
                [userFuZeDict setObject:dict[@"user_id"] forKey:@"id"];
                [userFuZeDict setObject:@"2" forKey:@"type"];
                [self.userArray addObject:userFuZeDict];
                UILabel * indexLabel = [[UILabel alloc] init];
                
                indexLabel.backgroundColor = DEFAULT_BGCOLOR;
                indexLabel.layer.masksToBounds = YES;
                indexLabel.layer.cornerRadius = 5;
                indexLabel.textAlignment = NSTextAlignmentCenter;
                
                NSString * userNameString =[NSString stringWithFormat:@"%@",dict[@"user_clname"]] ;
                
                indexLabel.text = userNameString;
                indexLabel.font = [UIFont systemFontOfSize:14.0f];
                
                CGRect rect = [userNameString boundingRectWithSize:CGSizeMake(CGRectGetWidth(_incomeFuZePeopleView.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
                indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);
                [_incomeFuZePeopleView.actionAddView  addSubview:indexLabel];
                
            }
            
        }];
        
    }
    
}

// 点击编辑后的任务详情cell
- (void)makeEditTaskDetailCell
{
    [_incomeTaskDetailView.actionAddView removeFromSuperview];
    _taskInfoTextView = [[UITextView alloc] init];
    
    _taskInfoTextView.backgroundColor = [UIColor whiteColor];
    
    _taskInfoTextView.frame = CGRectMake(50*KWidth6scale,45*KHeight6scale, Main_Screen_Width-100*KWidth6scale, 30*KHeight6scale);
    _taskInfoTextView.text = _detailModel.taskinfo;
    _taskInfoTextView.layer.masksToBounds = YES;
    _taskInfoTextView.layer.borderWidth = 1;
    _taskInfoTextView.layer.cornerRadius = 5;
    _taskInfoTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _taskInfoTextView.font = [UIFont systemFontOfSize:14.0f];
    
    [_incomeTaskDetailView addSubview:_taskInfoTextView];
    CGRect rectTaskDetail = _incomeTaskDetailView.frame;
    rectTaskDetail.size.height= 100*KWidth6scale;
    _incomeTaskDetailView.frame = rectTaskDetail;

    
    CGRect rect = _incomeTaskJiLuView.frame;
    rect.origin.y = CGRectGetMaxY(_incomeTaskDetailView.frame);
    _incomeTaskJiLuView.frame = rect;
    
    _actionIncomeScrollView.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(_incomeTaskJiLuView.frame));

}
// 点击保存后的任务详情cell
- (void)makeSaveTaskDetailCell
{
    _taskDetaileLabel.text = _taskInfoTextView.text;
    
    CGRect rect = [_taskDetaileLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width-100*KWidth6scale, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_taskDetaileLabel.font} context:nil];
    
    _taskDetaileLabel.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    CGRect rectCellActionAddView = _incomeTaskDetailView.actionAddView.frame;
    
    rectCellActionAddView.size.height = CGRectGetMaxY(_taskDetaileLabel.frame);
    
    _incomeTaskDetailView.actionAddView.frame = rectCellActionAddView;
    
    CGRect rectcell = _incomeTaskDetailView.frame;
    
    rectcell.size.height = CGRectGetMaxY(_taskDetaileLabel.frame)+(KViewHeight - 270*KHeight6scale)/4.0 - 20*KHeight6scale;
    _incomeTaskDetailView.frame = rectcell;
    
    [_incomeTaskDetailView.actionAddView  addSubview:_taskDetaileLabel];
    
    
    [_taskInfoTextView removeFromSuperview];
    
    [_incomeTaskDetailView addSubview:_incomeTaskDetailView.actionAddView ];

}
- (void)yanchiActionButtonClick: (UIButton *)button
{
    
    [MBProgressHUD showSuccess:@"暂时没有延迟"];
    
    
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
