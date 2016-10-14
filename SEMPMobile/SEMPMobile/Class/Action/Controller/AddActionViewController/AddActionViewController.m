//
//  AddActionViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AddActionViewController.h"
#import "DefaultIndexInfoModel.h"
#import "AddActionSelectTableViewCell.h"
#import "DefaultD_resModel.h"
#import "TreeTableView.h"
#import "AddActionSubView.h"

#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开

#define DIC_ARARRY @"array" //存放数组

#define DIC_TITILESTRING @"title"

@interface AddActionViewController ()<UITableViewDelegate,UITableViewDataSource,TreeTableCellDelegate>
// 新建任务界面UIScrollView
@property (nonatomic , strong) UIScrollView * addActionScrollView;
// 添加相关指标界面
@property (nonatomic , strong) UIView * defaultIndexInfoView;
// 添加协助人，负责人界面
@property (nonatomic , strong) UIView * addPersonView;
@property (nonatomic , strong) UITableView * defaultPersonTabelView;
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
// 参数任务标题信息
@property (nonatomic , strong) UITextField * actionTitleField;
// 参数截止日期年月日
@property (nonatomic , strong) UIButton * dateButton;
// 参数任务类型
@property (nonatomic , strong) NSString * tasktype;
// 参数优先级类型
@property (nonatomic , assign) NSInteger priorityIntType;
// 参数任务详情信息
@property (nonatomic , strong) UITextView * actionXiangQingTextView;
// 参数关联的指标数组
@property (nonatomic , strong) NSMutableArray * indexArray;
// 参数关联user的数组
@property (nonatomic , strong) NSMutableArray * userArray;
// 任务优先级按钮
@property (nonatomic , strong) UIButton * gaoButton;
@property (nonatomic , strong) UIButton * midButton;
@property (nonatomic , strong) UIButton * diButton;
// 任务类型button
@property (nonatomic , strong) UIButton * puTongTaskButton;
@property (nonatomic , strong) UIButton * zhuanXiangTaskButton;
// 选择组织的按钮
@property (nonatomic , strong)UIButton * chooseZuZhiButton;
// 选择的ZuZhimodel
@property (nonatomic , strong)DefaultD_resModel * chooseZuZhiModel;
// 组织树tableView
@property (nonatomic , strong)TreeTableView *tableview;

// 添加指标后指标cell的高
@property (nonatomic , assign)CGFloat indexCellHeight;
// 添加协助人之后协助人cell的高
@property (nonatomic , assign)CGFloat  AssistPeopleCellHeight;


@property (nonatomic , strong)AddActionSubView * firstView;
@property (nonatomic , strong)AddActionSubView * fuzePeopleView;
@property (nonatomic , strong)AddActionSubView * xieZhuPeopleView;
@property (nonatomic , strong)AddActionSubView * indexView;
@property (nonatomic , strong)AddActionSubView * taskDetailView;


@end

@implementation AddActionViewController
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
    _chooseZuZhiModel = [[DefaultD_resModel alloc] init];
    self.view.backgroundColor =  [UIColor grayColor];
    
    self.navigationItem.title = @"新建任务";
    
    [self makeLeftButtonItme];
    [self makeRightButtonItme];
    [self makeAddActionScorllView];

    // 解析相关指标接口数据
    [self makeDefaultIndexInfoData];
    // 解析协助人和负责任接口数据
    [self makeAddActionPersonData];
    
    
    // Do any additional setup after loading the view.
}

// 自定义返回按钮LeftButtonItme
- (void)makeLeftButtonItme
{
    UIImage * backImage = [UIImage imageNamed:@"back.png"];
    CGRect backframe = CGRectMake(0, 0, BackButtonWidth, BackButtonHeight);
    UIButton * backButton = [[UIButton alloc] initWithFrame:backframe];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}
// 自定义返回按钮LeftButtonItme
- (void)makeRightButtonItme
{
    
    UIButton * faBuButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 30*KWidth6scale, 30*KHeight6scale)];
    [faBuButton setTitle:@"发布" forState:UIControlStateNormal];
    [faBuButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [faBuButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [faBuButton addTarget:self action:@selector(faBuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:faBuButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    //   [self.navigationController.navigationBar addSubview:faBuButton];
}

- (void)makeAddActionScorllView
{
    
    _addActionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight)];
    _addActionScrollView.backgroundColor = [UIColor  whiteColor];
    [self.view addSubview:_addActionScrollView];
    _addActionScrollView.userInteractionEnabled = YES;
//    _addActionScrollView.contentSize = CGSizeMake(Main_Screen_Width, KHeight6scale*2);
    //添加的第一个视图
    [self makeIndexPathFirstView];
    //负责人视图
    [self makeFuZePeopleView];
    //协助人视图
    [self makeXieZhuPeopleView];
    //相关指标视图
    [self makeIndexView];
    //任务详情视图
    [self makeTaskDetailView];
    
}

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
           // 内存问题
//            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            NSMutableDictionary * dict = nil;

            for (int i = 0 ;i < array.count ; i++) {
                
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
                 // 内存问题
                NSMutableDictionary * userDict = nil;
                for (int j = 0; j< userArray.count;j++) {
                    
//                    NSMutableDictionary * userDict = [NSMutableDictionary dictionary];
                   
                    userDict = userArray[j];
                    [self.defaultUserArray addObject:userDict];
                    userDict = nil;
                }
             
                dict = nil;
            }
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
        
    }];
    
    
}

// 返回按钮点击事件
- (void)backButtonClick:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
// 发布按钮点击事件
-(void)faBuButtonClick:(UIButton*)button
{
    
    
    
    if (_actionTitleField.text.length > 16) {
        
        [MBProgressHUD showError:@"任务标题不能超过16个字"];
    }else if (_actionTitleField.text.length == 0){
        
        [MBProgressHUD showError:@"任务标题不能为空"];
        
    }else if (_dateButton.titleLabel.text.length == 0){
        [MBProgressHUD showError:@"截止日期不能为空"];
        
    }else if(_userArray.count == 0){
        
        [MBProgressHUD showError:@"任务负责人不能为空"];
        
    }else if (_indexArray.count == 0){
        [MBProgressHUD showError:@"任务相关指标不能为空"];
        
    }else if (_actionXiangQingTextView.text.length == 0){
        [MBProgressHUD showError:@"任务详情不能为空"];
        
    }else{
        
        NSString *priorityIntType = [NSString stringWithFormat:@"%ld",_priorityIntType];
        
        NSData *userdata=[NSJSONSerialization dataWithJSONObject:_userArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *userdataStr=[[NSString alloc]initWithData:userdata encoding:NSUTF8StringEncoding];
        
        NSData *indexData =[NSJSONSerialization dataWithJSONObject:_indexArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *indexDataStr=[[NSString alloc]initWithData:indexData encoding:NSUTF8StringEncoding];
        
        
        
        
        NSMutableDictionary * requestDic = @{
                                             
                                             @"key":@"new",
                                             @"taskid":@"",
                                             @"dateline":_dateButton.titleLabel.text,
                                             @"tasktitle":_actionTitleField.text,
                                             @"priority":priorityIntType,
                                             @"tasktype":_tasktype,
                                             @"user":  userdataStr,
                                             @"index": indexDataStr,
                                             @"taskinfo":_actionXiangQingTextView.text
                                             
                                             }.mutableCopy;
        
        
        if (requestDic==nil) {
            
            NSLog(@"请求参数为空");
        }else{
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            
            [manager POST:NewActionHttp parameters:requestDic progress:^(NSProgress * _Nonnull downloadProgress) {
                
                //这里可以用来显示下载进度
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (responseObject != nil) {
                    
                    [MBProgressHUD showSuccess:@"发布成功"];
                    
                    [self performSelector:@selector(BackView) withObject:self afterDelay:1.0f];
                    
                    [_indexArray removeAllObjects];
                    [_userArray removeAllObjects];
                }
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //失败
                NSLog(@"failure  error ： %@",error);
                
            }];
            
        }
        
        
        
    }
    
}
- (void)BackView
{
    
    [[self navigationController] popViewControllerAnimated:YES];
    
    
}
#pragma ========tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   if(tableView.tag == 1){
        
        return 1;
        
    }else{
        
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1){
        
        return _defaultIndexInfoModelArray.count;
        
    }else if(tableView.tag == 2){
        
        
        return self.chooseZuZhiModel.user.count;
        
    }else{
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
//        DefaultIndexInfoModel * defaultIndexInfoModel = [[DefaultIndexInfoModel alloc] init];
        DefaultIndexInfoModel * defaultIndexInfoModel = nil;
        defaultIndexInfoModel = _defaultIndexInfoModelArray[indexPath.row];
        cell.titleLabel.text = defaultIndexInfoModel.title;
        cell.selectButton.tag = indexPath.row;
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
        
    }else{
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
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1){
        
        return 30*KHeight6scale;
    }else{
        
        return 30*KHeight6scale;
        
    }
    
}
- (void)makeIndexPathFirstView
{
    _firstView = [[AddActionSubView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 150*KHeight6scale)];
    [_addActionScrollView addSubview:_firstView];
    _firstView.actionAddView.hidden = YES;
    _firstView.addButton.hidden = YES;
    _firstView.actionTitleLabel.text = @"截止日期";
    _firstView.imageActionView.image  = [UIImage imageNamed:@"0.png"];
    _dateButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _dateButton.frame = CGRectMake(CGRectGetMidX(self.view.frame) + 20*KWidth6scale, 15*KHeight6scale, CGRectGetMidX(self.view.frame) - 80*KWidth6scale, 20*KWidth6scale);
    _dateButton.backgroundColor = DEFAULT_BGCOLOR;
    [_firstView addSubview:_dateButton];
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    [_dateButton setTitle:locationString forState:UIControlStateNormal];
    [_dateButton addTarget:self action:@selector(dateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateButton.frame), CGRectGetMinY(_dateButton.frame), 40*KWidth6scale, CGRectGetHeight(_dateButton.frame))];
    yearLabel.text = @"日期";
    yearLabel.font = [UIFont systemFontOfSize:14.0f];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    [_firstView addSubview:yearLabel];
    
    
    _actionTitleField = [[UITextField alloc] initWithFrame:CGRectMake(20*KWidth6scale, 50*KHeight6scale, Main_Screen_Width-40*KWidth6scale, 50*KHeight6scale)];
    _actionTitleField.layer.borderWidth = 1;
    _actionTitleField.layer.borderColor  = [UIColor grayColor].CGColor;
    _actionTitleField.textAlignment = NSTextAlignmentCenter ;
    _actionTitleField.text = _actionTitleField.text;
    _actionTitleField.font = [UIFont systemFontOfSize:16.0f];
    if (_actionTitleField.text.length == 0) {
        _actionTitleField.placeholder = @"点击编辑任务标题(限16个字)";
        
    }
    [_firstView addSubview:_actionTitleField];
    
    UILabel * youXianJiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_actionTitleField.frame), CGRectGetMaxY(_actionTitleField.frame)+15*KHeight6scale, 60*KWidth6scale, 25*KHeight6scale)];
    youXianJiLabel.text = @"优先级";
    youXianJiLabel.font = [UIFont systemFontOfSize:14.0f];
    [_firstView addSubview:youXianJiLabel];
    
    
    _gaoButton= [[UIButton alloc] init];
    _gaoButton.frame  = CGRectMake(CGRectGetMaxX(youXianJiLabel.frame), CGRectGetMinY(youXianJiLabel.frame) , 25*KWidth6scale, CGRectGetHeight(youXianJiLabel.frame));
    _gaoButton.tintColor = [UIColor  whiteColor];
    _gaoButton.layer.cornerRadius = 3;
    
    
    [_gaoButton setTitle:@"高" forState:UIControlStateNormal];
    _gaoButton.selected = YES;
    _priorityIntType = 1;
    _gaoButton.backgroundColor = [UIColor redColor];
    [_gaoButton addTarget:self action:@selector(youXianJiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _midButton= [[UIButton alloc] init];
    _midButton.frame  = CGRectMake(CGRectGetMaxX(youXianJiLabel.frame)+(10 + 25)*KWidth6scale, CGRectGetMinY(youXianJiLabel.frame) , 25*KWidth6scale, CGRectGetHeight(youXianJiLabel.frame));
    _midButton.tintColor = [UIColor  whiteColor];
    _midButton.layer.cornerRadius = 3;
    
    
    [_midButton setTitle:@"中" forState:UIControlStateNormal];
    _midButton.selected = NO;
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
    
    
    UILabel * actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_actionTitleField.frame), CGRectGetMinY(youXianJiLabel.frame), CGRectGetWidth(youXianJiLabel.frame)-20*KWidth6scale, CGRectGetHeight(youXianJiLabel.frame))];
    actionLabel.text = @"任务";
    actionLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [_firstView addSubview:actionLabel];
    
    _puTongTaskButton = [[UIButton alloc] init];
    _puTongTaskButton.frame = CGRectMake(CGRectGetMaxX(actionLabel.frame), CGRectGetMinY(actionLabel.frame) , 40*KWidth6scale, CGRectGetHeight(actionLabel.frame));
    [_puTongTaskButton setTitle:@"普通" forState:UIControlStateNormal];
    _puTongTaskButton.layer.cornerRadius = 3;
    
    _tasktype = @"N";
    _puTongTaskButton.backgroundColor = [UIColor grayColor];
    [_puTongTaskButton addTarget:self action:@selector(taskTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    _zhuanXiangTaskButton = [[UIButton alloc] init];
    _zhuanXiangTaskButton.frame = CGRectMake(CGRectGetMaxX(_puTongTaskButton.frame)+10*KWidth6scale, CGRectGetMinY(_puTongTaskButton.frame) , CGRectGetWidth(_puTongTaskButton.frame), CGRectGetHeight(_puTongTaskButton.frame));
    _zhuanXiangTaskButton.layer.cornerRadius = 3;
    
    [_zhuanXiangTaskButton setTitle:@"专项" forState:UIControlStateNormal];
    _zhuanXiangTaskButton.backgroundColor = DEFAULT_BGCOLOR;
    [_zhuanXiangTaskButton addTarget:self action:@selector(taskTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_firstView addSubview:_puTongTaskButton];
    [_firstView addSubview:_zhuanXiangTaskButton];
    
    [_firstView addSubview:_gaoButton];
    
    [_firstView addSubview:_midButton];
    
    [_firstView addSubview:_diButton];
    
}
- (void)makeFuZePeopleView
{
   _fuzePeopleView = [[AddActionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_firstView.frame), Main_Screen_Width,80*KHeight6scale)];
    [_addActionScrollView addSubview:_fuzePeopleView];
    _fuzePeopleView.imageActionView.image  = [UIImage imageNamed:@"1.png"];
    _fuzePeopleView.actionTitleLabel.text = @"负责人";
    [_fuzePeopleView.addButton addTarget:self action:@selector(addResponsiblePersonClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)makeXieZhuPeopleView
{
    _xieZhuPeopleView = [[AddActionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_fuzePeopleView.frame), Main_Screen_Width,CGRectGetHeight(_fuzePeopleView.frame))];
    [_addActionScrollView addSubview:_xieZhuPeopleView];
    _xieZhuPeopleView.imageActionView.image  = [UIImage imageNamed:@"2.png"];
    _xieZhuPeopleView.actionTitleLabel.text = @"协助人";
    _xieZhuPeopleView.addButton.hidden = NO;
   [_xieZhuPeopleView.addButton addTarget:self action:@selector(addAssistPeopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)makeIndexView
{
    _indexView = [[AddActionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_xieZhuPeopleView.frame), Main_Screen_Width,CGRectGetHeight(_xieZhuPeopleView.frame))];
    [_addActionScrollView addSubview:_indexView];
    _indexView.imageActionView.image  = [UIImage imageNamed:@"3.png"];
     _indexView.actionTitleLabel.text = @"相关指标";
     [_indexView.addButton addTarget:self action:@selector(addDefaultIndexInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)makeTaskDetailView
{
    _taskDetailView = [[AddActionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_indexView.frame), Main_Screen_Width,200*KWidth6scale)];
    [_addActionScrollView addSubview:_taskDetailView];
    _taskDetailView.imageActionView.image  = [UIImage imageNamed:@"4.png"];

                _taskDetailView.actionTitleLabel.text = @"任务详情";
                _taskDetailView.actionAddView.hidden = YES;
                _taskDetailView.addButton.hidden = YES;
                _actionXiangQingTextView =[[UITextView alloc] initWithFrame:CGRectMake(30*KWidth6scale, 50*KWidth6scale, Main_Screen_Width-60*KWidth6scale, 100*KHeight6scale)] ;
                _actionXiangQingTextView.layer.borderWidth = 1;
                _actionXiangQingTextView.layer.masksToBounds = YES;
                _actionXiangQingTextView.layer.borderColor = [UIColor grayColor].CGColor;
                [_taskDetailView addSubview:_actionXiangQingTextView];
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

// 年月日
- (void)dateButtonClick:(UIButton *)button
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    
    picker.frame = CGRectMake(0, 40, Main_Screen_Width-20, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        NSString * dateString = [date stringWithFormat:@"yyyy-MM-dd"];
        [_dateButton setTitle:dateString forState:UIControlStateNormal];
        
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 添加负责人
- (void)addResponsiblePersonClick:(UIButton *)button
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
    
    [self makeAddDefalutPersonView];
    
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
            NSLog(@"---dic--%@",dic);
            if ([[dic objectForKey:@"type"] isEqualToString:@"3"]) {
                
                [tempArray removeObject:dic];
                
            }
        }
        
    }
    _userArray = [NSMutableArray arrayWithArray:tempArray];
    NSLog(@"----%@",_userArray);
    [self makeAddDefalutPersonView];
    
    
}
// 添加相关指标
- (void)addDefaultIndexInfoButtonClick:(UIButton *)button
{
    _addString = @"AddDefaultIndex";

    [_indexArray removeAllObjects];
    
    _defaultIndexInfoView = [[UIView alloc] initWithFrame:CGRectMake(40*KWidth6scale, 60*KHeight6scale, Main_Screen_Width-80*KWidth6scale, KViewHeight-120*KHeight6scale)];
    _defaultIndexInfoView.backgroundColor = [UIColor whiteColor];
    _defaultIndexInfoView.alpha = 1.0f;
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
        _addActionScrollView.backgroundColor = [UIColor grayColor];
        _addActionScrollView.userInteractionEnabled = NO;
        _addActionScrollView.alpha = 0.5;
        _defaultIndexInfoView.alpha = 1.0f;
        
    } completion:nil];
    
    
    defaultIndexInfoTableView.dataSource = self;
    defaultIndexInfoTableView.delegate = self;
    
    
}
- (void)makeAddDefalutPersonView
{
    
    _addPersonView = [[UIView alloc] initWithFrame:CGRectMake(40*KWidth6scale, 60*KHeight6scale, Main_Screen_Width-80*KWidth6scale, KViewHeight-120*KHeight6scale)];
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
    
    [_addPersonView addSubview:_chooseZuZhiButton];
    
    _defaultPersonTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_chooseZuZhiButton.frame),CGRectGetWidth(_addPersonView.frame),CGRectGetHeight(_addPersonView.frame)-CGRectGetHeight(labelTitle.frame)*2) style:UITableViewStylePlain];
    
    _defaultPersonTabelView.backgroundColor = [UIColor whiteColor];
    
    _defaultPersonTabelView.tag = 2;
    
    _defaultPersonTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_addPersonView addSubview:_defaultPersonTabelView];
    
    _defaultPersonTabelView.dataSource = self;
    _defaultPersonTabelView.delegate = self;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _addActionScrollView.backgroundColor = [UIColor grayColor];
        _addActionScrollView.userInteractionEnabled = NO;
        _addActionScrollView.alpha = 0.5f;
        _addPersonView.alpha = 1.0f;
        
    } completion:nil];
    
    
    
}
- (void)chooseZuZhiButtonClick:(UIButton *)button
{
    
    [_tableview removeFromSuperview];
    
    // 每次点击组织button的时候都是默认不展开的
    for (int i = 0; i < _defaultD_resModelArray.count; i++) {
//        DefaultD_resModel * d_resModel = [[DefaultD_resModel alloc] init];
        DefaultD_resModel * d_resModel = nil;
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
            NSLog(@"---%@",_selectedUserArray);
            if (_selectedUserArray.count >= 1) {
                
                
                for (int i = 0; i< _butArray.count-1;i++) {
                    
                    
                    [_butArray[i] setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
                    [_butArray[i] setSelected:NO];
                    [_butArray removeObjectAtIndex:i];
                }
                
                
            }
            
        }
        
        
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{


    if ([_addString isEqualToString:@"AddDefaultIndex"]) {

        [UIView animateWithDuration:0.5 animations:^{

            _defaultIndexInfoView.userInteractionEnabled = NO;
            _addActionScrollView.userInteractionEnabled = YES;
            _addActionScrollView.backgroundColor = [UIColor whiteColor];
            _addActionScrollView.alpha = 1;
            _defaultIndexInfoView.alpha = 0;

        } completion:^(BOOL finished) {


            [_indexView.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

//            DefaultIndexInfoModel * model = [[DefaultIndexInfoModel alloc] init];
            DefaultIndexInfoModel * model = nil;
            if (_selectedDefaultIndexModelArray.count == 0) {

                _indexView.frame =  CGRectMake(0, CGRectGetMaxY(_xieZhuPeopleView.frame), Main_Screen_Width,80*KHeight6scale);
                // 更新contentSize
                _addActionScrollView.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(_taskDetailView.frame)); //至关重要
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
                    CGRect rect = [indexString boundingRectWithSize:CGSizeMake(CGRectGetWidth(_indexView.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];

                    if (i == 0) {

                        indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);

                    }else{


                        CGFloat yuWidth = CGRectGetWidth(_indexView.actionAddView.frame) -recordLab.frame.origin.x -recordLab.frame.size.width - 50*KWidth6scale;

                        if (yuWidth >= rect.size.width) {

                            indexLabel.frame =CGRectMake(recordLab.frame.origin.x +recordLab.frame.size.width + 10*KWidth6scale, recordLab.frame.origin.y, rect.size.width + 5*KWidth6scale, rect.size.height +5*KHeight6scale);

                        }else{

                            indexLabel.frame =CGRectMake(0, recordLab.frame.origin.y+recordLab.frame.size.height+10, rect.size.width + 5*KWidth6scale, rect.size.height + 5*KHeight6scale);
                        }

                    }
                    recordLab = indexLabel;

                    CGRect rectCellActionAddView = _indexView.actionAddView.frame;

                    rectCellActionAddView.size.height = CGRectGetMaxY(indexLabel.frame);

                    _indexView.actionAddView.frame = rectCellActionAddView;
                    
                    CGRect rectcell = _indexView.frame;

                    rectcell.size.height = CGRectGetMaxY(indexLabel.frame)+(KViewHeight - 320*KHeight6scale)/3.0 - 20*KHeight6scale;
                    _indexCellHeight = rectcell.size.height;

                    _indexView.frame = rectcell;

                    [_indexView.actionAddView  addSubview:indexLabel];


                    CGRect rectcelltwo = _taskDetailView.frame;

                    rectcelltwo.origin.y = CGRectGetMaxY(_indexView.frame);

                    _taskDetailView.frame = rectcelltwo;
                    // 更新contentSize
                    _addActionScrollView.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(_taskDetailView.frame)); //至关重要

                }

            }

        }];


    }else if ([_addString isEqualToString:@"AddAssistPeople"]){

        [UIView animateWithDuration:0.5 animations:^{

            _addPersonView.userInteractionEnabled = NO;
            _addActionScrollView.userInteractionEnabled = YES;
            _addActionScrollView.backgroundColor = [UIColor whiteColor];
            _addActionScrollView.alpha = 1;
            _addPersonView.alpha = 0;

        } completion:^(BOOL finished) {


            [_xieZhuPeopleView.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

//            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            NSMutableDictionary * dict = nil;
            if (_selectedDefaultUserArray.count == 0) {

               _xieZhuPeopleView.frame =  CGRectMake(0, CGRectGetMaxY(_fuzePeopleView.frame), Main_Screen_Width,80*KHeight6scale);
                // 更新contentSize
                _addActionScrollView.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(_taskDetailView.frame)); //至关重要
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
                    CGRect rect = [userNameString boundingRectWithSize:CGSizeMake(CGRectGetWidth(_xieZhuPeopleView.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];

                    if (i == 0) {

                        indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);

                    }else{

                        CGFloat yuWidth = CGRectGetWidth(_xieZhuPeopleView.actionAddView.frame) -recordLab.frame.origin.x -recordLab.frame.size.width - 30*KWidth6scale;

                        if (yuWidth >= rect.size.width) {

                            indexLabel.frame =CGRectMake(recordLab.frame.origin.x +recordLab.frame.size.width + 10*KWidth6scale, recordLab.frame.origin.y, rect.size.width + 5*KWidth6scale, rect.size.height +5*KHeight6scale);

                        }else{

                            indexLabel.frame =CGRectMake(0, recordLab.frame.origin.y+recordLab.frame.size.height+10, rect.size.width + 5*KWidth6scale, rect.size.height + 5*KHeight6scale);
                        }

                    }
                    recordLab = indexLabel;

                    CGRect rectCellActionAddView = _xieZhuPeopleView.actionAddView.frame;

                    rectCellActionAddView.size.height = CGRectGetMaxY(indexLabel.frame);

                    _xieZhuPeopleView.actionAddView.frame = rectCellActionAddView;

                    [_xieZhuPeopleView.actionAddView  addSubview:indexLabel];

                    CGRect rectXieZhuRen = _xieZhuPeopleView.frame;

                    rectXieZhuRen.size.height = CGRectGetMaxY(indexLabel.frame)+(KViewHeight - 320*KHeight6scale)/3.0 - 20*KHeight6scale;

                    _AssistPeopleCellHeight = rectXieZhuRen.size.height;
                    _xieZhuPeopleView.frame = rectXieZhuRen;

                    CGRect recttwo = _indexView.frame;

                    recttwo.origin.y = CGRectGetMaxY(_xieZhuPeopleView.frame);

                    _indexView.frame = recttwo;

                   
                    CGRect rectthree = _taskDetailView.frame;

                    rectthree.origin.y = CGRectGetMaxY(_indexView.frame);

                    _taskDetailView.frame = rectthree;
                    
                    // 更新contentSize
                    _addActionScrollView.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(_taskDetailView.frame)); //至关重要


                }

            }

        }];


    }else if ([_addString isEqualToString:@"AddResponsiblePerson"]){
        // 删除所有button
        [_butArray removeAllObjects];
        [UIView animateWithDuration:0.5 animations:^{

            _addPersonView.userInteractionEnabled = NO;
            _addActionScrollView.userInteractionEnabled = YES;
            _addActionScrollView.backgroundColor = [UIColor whiteColor];
            _addActionScrollView.alpha = 1;
            _addPersonView.alpha = 0;

        } completion:^(BOOL finished) {

            [_fuzePeopleView.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

//            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            NSMutableDictionary * dict = nil;
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

                CGRect rect = [userNameString boundingRectWithSize:CGSizeMake(CGRectGetWidth(_fuzePeopleView.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
                indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);
                
                [_fuzePeopleView.actionAddView  addSubview:indexLabel];

            }
            
        }];
        
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
