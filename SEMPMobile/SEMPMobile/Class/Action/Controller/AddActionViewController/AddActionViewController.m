//
//  AddActionViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/21.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AddActionViewController.h"
#import "AddActionTableViewCell.h"
#import "userModel.h"
#import "DefaultIndexInfoModel.h"
#import "AddActionSelectTableViewCell.h"
#import "DefaultD_resModel.h"


#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开

#define DIC_ARARRY @"array" //存放数组

#define DIC_TITILESTRING @"title"

@interface AddActionViewController ()<UITableViewDelegate,UITableViewDataSource>
// 新建任务界面tableView
@property (nonatomic , strong) UITableView * addActionTableView;
// 添加相关指标界面
@property (nonatomic , strong) UIView * defaultIndexInfoView;
// 添加协助人，负责人界面
@property (nonatomic , strong) UIView * addPersonView;

@property (nonatomic , strong) UITableView * addPersonTabelView;

@property (nonatomic , strong) userModel * userModel;
@property (nonatomic , strong) NSMutableArray * DataArray;

// 全部相关指标数组
@property (nonatomic , strong) NSMutableArray * defaultIndexInfoModelArray;
// 被选中的相关指标数组
@property (nonatomic , strong) NSMutableArray * selectedDefaultIndexModelArray;
// 全部人员所在组织的数组
@property (nonatomic , strong) NSMutableArray * defaultD_resModelArray;

// 每个组织内人员数组
@property (nonatomic , strong) NSMutableArray * defaultD_resPersonArray;

// 被选中的协助人的数组

// 全局变量 （判断点击的那个添加按钮，相应按钮出现相应界面并且在touchBegan时做出相应的事件）
@property (nonatomic , strong) NSString * addString;
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
// 组织中人员数组懒加载  ( 调用懒加载用self.xx)
-(NSMutableArray *)defaultD_resPersonArray
{
    if (_defaultD_resPersonArray == nil) {
        _defaultD_resPersonArray = [NSMutableArray array];
    }
    return _defaultD_resPersonArray;
}
-(NSMutableArray *)DataArray
{
    if (_DataArray == nil) {
        _DataArray = [NSMutableArray array];
    }
    return _DataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor grayColor];
    
    self.navigationItem.title = @"新建任务";
    
    [self makeLeftButtonItme];
    [self makeRightButtonItme];
    [self makeAddActionTableView];
    
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    _userModel = [[userModel alloc] init];
    _userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
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
    CGRect backframe = CGRectMake(0, 0, 35*KWidth6scale, 25*KHeight6scale);
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

- (void)makeAddActionTableView
{
    
    _addActionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight) style:UITableViewStylePlain];
    
    _addActionTableView.backgroundColor = [UIColor  whiteColor];
    _addActionTableView.tag = 0;
    [self.view addSubview:_addActionTableView];
    _addActionTableView.rowHeight = UITableViewAutomaticDimension;
    
    _addActionTableView.dataSource = self;
    _addActionTableView.delegate = self;
    
    [_addActionTableView registerClass:[AddActionTableViewCell class] forCellReuseIdentifier:@"ADDCELL"];
    
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
            
            NSLog(@"----responseObject-- %@",responseObject);
            NSMutableArray * array = responseObject[@"resdata"];
            
            for (NSDictionary * dict in array) {
                
                DefaultD_resModel * defaultD_resModel = [[DefaultD_resModel alloc] init];
                [defaultD_resModel setValuesForKeysWithDictionary:dict];
                // _xxx和self.xxx的区别：当使用self.xxx会调用xxx的get方法而_xxx并不会调用，正确的使用个方式是通过self去调用才会执行懒加载方法
                [self.defaultD_resModelArray addObject:defaultD_resModel];
                NSMutableArray * userArray = dict[@"user"];
                for (NSDictionary * userDict in userArray) {
                   
                    [self.defaultD_resPersonArray addObject:userDict[@"user_clname"]];

                }
                
                //创建一个字典 包含数组，分组名，是否展开的标示
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.defaultD_resModelArray,DIC_ARARRY,dict[@"d_res_clname"],DIC_TITILESTRING,[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
                
                //将字典加入数组
                [self.DataArray addObject:dic];

                
            }
            NSLog(@"---pppp-_DataArray------%ld",_DataArray.count);
            

            
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
    
}
#pragma ========tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 0) {
        return 1;
        
    }else if(tableView.tag == 1){
        return 1;
        
    }else{
        NSLog(@"----_DataArray------%ld",_DataArray.count);

        return _DataArray.count;
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return 5;
        
    }else if(tableView.tag == 1){
        return _defaultIndexInfoModelArray.count;
        
    }else if(tableView.tag == 2){
        
        NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
        
        NSArray *array=[dic objectForKey:DIC_ARARRY];
        
        //判断是收缩还是展开
        
        if ([[dic objectForKey:DIC_EXPANDED] intValue]) {
            NSLog(@"----array--- ziji---%ld",array.count);

            return array.count;
            
        }else{
            return 0;
        }

        
    }else{
        return 10;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        AddActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ADDCELL" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.actionAddView.hidden = YES;
            cell.addButton.hidden = YES;
            cell.actionTitleLabel.text = @"截止日期";
            cell.imageActionView.image  = [UIImage imageNamed:@"0.png"];
            [self makeIndexPathFirstCell:cell indexPath:indexPath];
            return cell;
        }else if (indexPath.row == 1){
            cell.imageActionView.image  = [UIImage imageNamed:@"1.png"];
            
            cell.actionTitleLabel.text = @"负责人";
            [cell.addButton addTarget:self action:@selector(addResponsiblePersonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }else if (indexPath.row == 2){
            cell.imageActionView.image  = [UIImage imageNamed:@"2.png"];
            
            cell.actionTitleLabel.text = @"协助人";
            [cell.addButton addTarget:self action:@selector(addAssistPeopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }else if (indexPath.row == 3){
            cell.imageActionView.image  = [UIImage imageNamed:@"3.png"];
            
            cell.actionTitleLabel.text = @"相关指标";
            [cell.addButton addTarget:self action:@selector(addDefaultIndexInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }else{
            cell.imageActionView.image  = [UIImage imageNamed:@"4.png"];
            
            cell.actionTitleLabel.text = @"任务详情";
            cell.actionAddView.hidden = YES;
            cell.addButton.hidden = YES;
            UITextView * textview =[[UITextView alloc] initWithFrame:CGRectMake(30*KWidth6scale, 50*KWidth6scale, Main_Screen_Width-60*KWidth6scale, 100*KHeight6scale)] ;
            textview.layer.borderWidth = 1;
            textview.layer.masksToBounds = YES;
            textview.layer.borderColor = [UIColor grayColor].CGColor;
            [cell.contentView addSubview:textview];
            return cell;
            
        }
        
        
    }else if(tableView.tag == 1){
        
        AddActionSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCell" forIndexPath:indexPath];
        DefaultIndexInfoModel * defaultIndexInfoModel = [[DefaultIndexInfoModel alloc] init];
        defaultIndexInfoModel = _defaultIndexInfoModelArray[indexPath.row];
        cell.titleLabel.text = defaultIndexInfoModel.title;
        cell.selectButton .tag = indexPath.row;
        [cell.selectButton addTarget:self action:@selector(selectDefaultIndexInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else{
        
        AddActionSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCell" forIndexPath:indexPath];

//        if (!cell) {
//            cell = [[AddActionSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectCell"
//                    ];
//        }
        NSArray *array=[[_DataArray objectAtIndex:indexPath.section] objectForKey:DIC_ARARRY];
      
        cell.titleLabel.text= [array objectAtIndex:indexPath.row];
        
        NSLog(@"- cell.titleLabel.text----%@", cell.titleLabel.text);
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.textColor = [UIColor redColor];
        
        
        return cell;
        
        
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 30*KHeight6scale)];
    
    hView.backgroundColor=[UIColor whiteColor];
    
    UIButton* eButton = [[UIButton alloc] init];
    
    //按钮填充整个视图
    eButton.frame = hView.frame;
    
    [eButton addTarget:self action:@selector(expandButtonClicked:)
     
      forControlEvents:UIControlEventTouchUpInside];
    
    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
    
    eButton.tag = section;
    
    //设置图标
    
    //根据是否展开，切换按钮显示图片
    
    if ([self isExpanded:section]){
        
        [eButton setImage: [UIImage imageNamed: @"arrow_right_grey" ]forState:UIControlStateNormal];
    } else {
        
        [eButton setImage: [UIImage imageNamed: @"arrow_down_grey" ]forState:UIControlStateNormal];
    }
    //设置分组标题
    
    [eButton setTitle:[[_DataArray objectAtIndex:section] objectForKey:DIC_TITILESTRING] forState:UIControlStateNormal];
    
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    
    //4个参数是到上边界，左边界，下边界，右边界的距离
    
    eButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,-5, 0,0)];
    
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,self.view.bounds.size.width - 25, 0,0)];
    
    //下显示线
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, hView.frame.size.height-1, hView.frame.size.width,1)];
    
    label.backgroundColor = [UIColor grayColor];
    [hView addSubview:label];
    
    [hView addSubview: eButton];
    
    return hView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        
        if (indexPath.row == 0) {
            
            return 150*KHeight6scale;
            
        }else if (indexPath.row == 4){
            
            return 170*KHeight6scale;
        }else{
            
            return (KViewHeight - 320*KHeight6scale)/3.0;
        }
    }else if (tableView.tag == 1){
        return 30*KHeight6scale;
    }else{
        
        return 30*KHeight6scale;
        
    }
    
}
- (void)makeIndexPathFirstCell:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath
{
    
    UIButton * yearButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    yearButton.frame = CGRectMake(CGRectGetMidX(self.view.frame)-40*KWidth6scale, 15*KHeight6scale, 60*KWidth6scale, 25*KWidth6scale);
    yearButton.backgroundColor = DEFAULT_BGCOLOR;
    [cell addSubview:yearButton];
    UILabel * yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yearButton.frame), CGRectGetMinY(yearButton.frame), 20*KWidth6scale, CGRectGetHeight(yearButton.frame))];
    yearLabel.text = @"年";
    yearLabel.font = [UIFont systemFontOfSize:14.0f];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    
    [cell addSubview:yearLabel];
    
    UIButton * mouthButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mouthButton.frame = CGRectMake(CGRectGetMaxX(yearLabel.frame), CGRectGetMinY(yearLabel.frame), 40*KWidth6scale, CGRectGetHeight(yearButton.frame));
    mouthButton.backgroundColor = DEFAULT_BGCOLOR;
    [cell addSubview:mouthButton];
    UILabel * mouthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mouthButton.frame), CGRectGetMinY(mouthButton.frame), CGRectGetWidth(yearLabel.frame), CGRectGetHeight(mouthButton.frame))];
    mouthLabel.text = @"月";
    mouthLabel.font = [UIFont systemFontOfSize:14.0f];
    mouthLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:mouthLabel];
    
    UIButton * dayButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dayButton.frame = CGRectMake(CGRectGetMaxX(mouthLabel.frame), CGRectGetMinY(mouthButton.frame), CGRectGetWidth(mouthButton.frame), CGRectGetHeight(mouthButton.frame));
    dayButton.backgroundColor = DEFAULT_BGCOLOR;
    [cell addSubview:dayButton];
    UILabel * dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dayButton.frame), CGRectGetMinY(dayButton.frame), CGRectGetWidth(mouthLabel.frame), CGRectGetHeight(mouthLabel.frame))];
    dayLabel.text = @"日";
    dayLabel.font = [UIFont systemFontOfSize:14.0f];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    
    [cell addSubview:dayLabel];
    
    
    
    
    
    
    
    UITextField * actionTitleField = [[UITextField alloc] initWithFrame:CGRectMake(20*KWidth6scale, 50*KHeight6scale, Main_Screen_Width-40*KWidth6scale, 50*KHeight6scale)];
    actionTitleField.layer.borderWidth = 1;
    
    actionTitleField.layer.borderColor  = [UIColor grayColor].CGColor;
    actionTitleField.textAlignment = NSTextAlignmentCenter ;
    actionTitleField.font = [UIFont systemFontOfSize:16.0f];
    actionTitleField.placeholder = @"点击编辑任务标题(限16个字)";
    
    [cell addSubview:actionTitleField];
    
    UILabel * youXianJiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(actionTitleField.frame), CGRectGetMaxY(actionTitleField.frame)+15*KHeight6scale, 60*KWidth6scale, 25*KHeight6scale)];
    youXianJiLabel.text = @"优先级";
    youXianJiLabel.font = [UIFont systemFontOfSize:14.0f];
    [cell addSubview:youXianJiLabel];
    
    
    for (int i = 0; i < 3; i++) {
        UIButton * Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        Button.tag = i;
        Button.frame  = CGRectMake(CGRectGetMaxX(youXianJiLabel.frame)+i*(10 + 25)*KWidth6scale, CGRectGetMinY(youXianJiLabel.frame) , 25*KWidth6scale, CGRectGetHeight(youXianJiLabel.frame));
        Button.backgroundColor = [UIColor grayColor];
        Button.tintColor = [UIColor  whiteColor];
        Button.layer.cornerRadius = 3;
        
        if (i==0) {
            [Button setTitle:@"高" forState:UIControlStateNormal];
            
        }else if (i == 1){
            [Button setTitle:@"中" forState:UIControlStateNormal];
            
        }else{
            [Button setTitle:@"低" forState:UIControlStateNormal];
            
        }
        [cell addSubview:Button];
        
    }
    //    UIButton * gaoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //
    //    gaoButton.frame  = CGRectMake(CGRectGetMaxX(youXianJiLabel.frame), CGRectGetMinY(youXianJiLabel.frame), 25*KWidth6scale, CGRectGetHeight(youXianJiLabel.frame));
    //    gaoButton.backgroundColor = [UIColor grayColor];
    //    gaoButton.tintColor = [UIColor  whiteColor];
    //    gaoButton.layer.cornerRadius = 3;
    //    [gaoButton setTitle:@"高" forState:UIControlStateNormal];
    //    [cell addSubview:gaoButton];
    //    UIButton * midButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //
    //    midButton.frame  = CGRectMake(CGRectGetMaxX(gaoButton.frame) + 10*KWidth6scale, CGRectGetMinY(gaoButton.frame), CGRectGetWidth(gaoButton.frame), CGRectGetHeight(gaoButton.frame));
    //    midButton.backgroundColor = [UIColor grayColor];
    //    midButton.tintColor = [UIColor  whiteColor];
    //    midButton.layer.cornerRadius = 3;
    //    [midButton setTitle:@"中" forState:UIControlStateNormal];
    //    [cell addSubview:midButton];
    //
    //    UIButton * diButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //
    //    diButton.frame  = CGRectMake(CGRectGetMaxX(midButton.frame) + 10*KWidth6scale , CGRectGetMinY(midButton.frame), CGRectGetWidth(midButton.frame), CGRectGetHeight(midButton.frame));
    //    diButton.backgroundColor = [UIColor grayColor];
    //    diButton.tintColor = [UIColor  whiteColor];
    //    diButton.layer.cornerRadius = 3;
    //    [diButton setTitle:@"低" forState:UIControlStateNormal];
    //    [cell addSubview:diButton];
    
    
    
}
// 添加负责人
- (void)addResponsiblePersonButtonClick:(UIButton *)button
{
    _addString = @"AddResponsiblePerson";
}
// 添加协助人
- (void)addAssistPeopleButtonClick:(UIButton *)button
{
    _addString = @"AddAssistPeople";
    
    [self makeAddPersonView];


}
// 添加相关指标
- (void)addDefaultIndexInfoButtonClick:(UIButton *)button
{
    _addString = @"AddDefaultIndex";
    [_selectedDefaultIndexModelArray removeAllObjects];
    
    _defaultIndexInfoView = [[UIView alloc] initWithFrame:CGRectMake(60*KWidth6scale, 120*KHeight6scale, Main_Screen_Width-120*KWidth6scale, KViewHeight-260*KHeight6scale)];
    _defaultIndexInfoView.backgroundColor = [UIColor whiteColor];
    _defaultIndexInfoView.alpha = 1.0f;
    
    [self.view addSubview:_defaultIndexInfoView];
    UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20*KWidth6scale, 0, CGRectGetWidth(_defaultIndexInfoView.frame), 30*KHeight6scale)];
    labelTitle.text = @"相关指标";
    
    [_defaultIndexInfoView addSubview:labelTitle];
    UITableView * defaultIndexInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame),CGRectGetWidth(_defaultIndexInfoView.frame),CGRectGetHeight(_defaultIndexInfoView.frame)-CGRectGetHeight(labelTitle.frame)) style:UITableViewStylePlain];
    
    defaultIndexInfoTableView.tag = 1;
    defaultIndexInfoTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_defaultIndexInfoView addSubview:defaultIndexInfoTableView];
    
    [UIView animateWithDuration:0.5 animations:^{
        _addActionTableView.backgroundColor = [UIColor grayColor];
        _addActionTableView.userInteractionEnabled = NO;
        _addActionTableView.alpha = 0.5;
        _defaultIndexInfoView.alpha = 1.0f;
        
    } completion:nil];
    
    
    defaultIndexInfoTableView.dataSource = self;
    defaultIndexInfoTableView.delegate = self;
    
    [defaultIndexInfoTableView registerClass:[AddActionSelectTableViewCell class] forCellReuseIdentifier:@"SelectCell"];
    
    
}
- (void)makeAddPersonView
{
    
    _addPersonView = [[UIView alloc] initWithFrame:CGRectMake(60*KWidth6scale, 120*KHeight6scale, Main_Screen_Width-120*KWidth6scale, KViewHeight-260*KHeight6scale)];
    _addPersonView.backgroundColor = [UIColor orangeColor];
    _addPersonView.alpha = 1.0f;
    
    [self.view addSubview:_addPersonView];
    
    UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20*KWidth6scale, 0, CGRectGetWidth(_addPersonView.frame), 30*KHeight6scale)];
    labelTitle.text = @"协助人";
    
    [_addPersonView addSubview:labelTitle];
    
    _addPersonTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame),CGRectGetWidth(_addPersonView.frame),CGRectGetHeight(_addPersonView.frame)-CGRectGetHeight(labelTitle.frame)) style:UITableViewStylePlain];

    _addActionTableView.backgroundColor = [UIColor redColor];
    
    _addPersonTabelView.tag = 2;
    
    _addPersonTabelView.separatorStyle = UITableViewCellSelectionStyleNone;

    [_addPersonView addSubview:_addPersonTabelView];

    _addPersonTabelView.dataSource = self;
    _addPersonTabelView.delegate = self;
    

    [UIView animateWithDuration:0.5 animations:^{
        _addActionTableView.backgroundColor = [UIColor grayColor];
        _addActionTableView.userInteractionEnabled = NO;
        _addActionTableView.alpha = 0.5;
        _addPersonView.alpha = 1.0f;
        
    } completion:nil];
    
    
      [_addPersonTabelView registerClass:[AddActionSelectTableViewCell class] forCellReuseIdentifier:@"SelectCell"];
    

    
    
    
}
// 相关指标的选择事件
-(void)selectDefaultIndexInfoButtonClick:(UIButton *)button
{
    
    
    if (button.selected) {
        
        button.selected = NO;
        [button setImage:[UIImage imageNamed:@"noSelected.png"] forState:UIControlStateNormal];
        [self.selectedDefaultIndexModelArray removeObject:_defaultIndexInfoModelArray[button.tag]];
    }else{
        button.selected = YES;
        [button setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        [self.selectedDefaultIndexModelArray addObject:_defaultIndexInfoModelArray[button.tag]];
    }
    
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if ([_addString isEqualToString:@"AddDefaultIndex"]) {
        [UIView animateWithDuration:0.5 animations:^{
            
            _defaultIndexInfoView.userInteractionEnabled = NO;
            _addActionTableView.userInteractionEnabled = YES;
            _addActionTableView.backgroundColor = [UIColor whiteColor];
            _addActionTableView.alpha = 1;
            _defaultIndexInfoView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            
            AddActionTableViewCell * cell = [_addActionTableView cellForRowAtIndexPath:indexPath ];
            
            [cell.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            DefaultIndexInfoModel * model = [[DefaultIndexInfoModel alloc] init];
            if (_selectedDefaultIndexModelArray.count == 0) {
                
                [_addActionTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
                
            }else{
                
                
                for (int i = 0; i <= _selectedDefaultIndexModelArray.count-1; i++ ){
                    
                    model = _selectedDefaultIndexModelArray[i];
                    
                    UILabel * indexLabel = [[UILabel alloc] init];
                    
                    
                    static UILabel *recordLab = nil;
                    
                    indexLabel.backgroundColor = [UIColor grayColor];
                    
                    NSString * indexString =[NSString stringWithFormat:@"%@",model.title] ;
                    indexLabel.text = indexString;
                    indexLabel.font = [UIFont systemFontOfSize:14.0f];
                    CGRect rect = [indexString boundingRectWithSize:CGSizeMake(CGRectGetWidth(cell.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
                    
                    if (i == 0) {
                        
                        indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);
                        
                    }else{
                        
                        
                        CGFloat yuWidth = CGRectGetWidth(cell.actionAddView.frame) -recordLab.frame.origin.x -recordLab.frame.size.width;
                        
                        if (yuWidth >= rect.size.width) {
                            
                            indexLabel.frame =CGRectMake(recordLab.frame.origin.x +recordLab.frame.size.width + 10*KWidth6scale, recordLab.frame.origin.y, rect.size.width + 5*KWidth6scale, rect.size.height +5*KHeight6scale);
                            
                        }else{
                            
                            indexLabel.frame =CGRectMake(0, recordLab.frame.origin.y+recordLab.frame.size.height+10, rect.size.width + 5*KWidth6scale, rect.size.height + 5*KHeight6scale);
                        }
                        
                    }
                    recordLab = indexLabel;
                    
                    CGRect rectCellActionAddView = cell.actionAddView.frame;
                    
                    rectCellActionAddView.size.height = CGRectGetMaxY(indexLabel.frame);
                    
                    cell.actionAddView.frame = rectCellActionAddView;
                    CGRect rectcell = cell.frame;
                    
                    rectcell.size.height = CGRectGetMaxY(indexLabel.frame)+(KViewHeight - 320*KHeight6scale)/3.0 - 20*KHeight6scale;
                    
                    cell.frame = rectcell;
                    
                    [cell.actionAddView  addSubview:indexLabel];
                    
                    NSIndexPath *xiaYigeIndexPathtwo = [NSIndexPath indexPathForRow:4 inSection:0];
                    
                    AddActionTableViewCell * celltwo = [_addActionTableView cellForRowAtIndexPath:xiaYigeIndexPathtwo];
                    CGRect rectcelltwo = celltwo.frame;
                    
                    rectcelltwo.origin.y = CGRectGetMaxY(cell.frame);
                    
                    celltwo.frame = rectcelltwo;
                    
                }
                
            }
            
        }];
        
    }else if ([_addString isEqualToString:@"AddAssistPeople"]){
        
        NSLog(@"AddAssistPeople");
    }else if ([_addString isEqualToString:@"AddResponsiblePerson"]){
        
        NSLog(@"AddResponsiblePerson");

    }
  
}
#pragma mark - Action

-(int)isExpanded:(NSInteger)section{
    
    NSDictionary *dic=[_DataArray objectAtIndex:section];
    
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    
    return expanded;
    
}

-(void)expandButtonClicked:(id)sender{
    
    UIButton* btn = (UIButton *)sender;
    
    NSInteger section= btn.tag;//取得tag知道点击对应哪个块
    
    [self collapseOrExpand:section];
    
    //刷新tableview
    
    [_addPersonTabelView reloadData];
    
}

//对指定的节进行“展开/折叠”操作,若原来是折叠的则展开，若原来是展开的则折叠

-(void)collapseOrExpand:(NSInteger)section{
    
    NSMutableDictionary *dic = [_DataArray objectAtIndex:section];
    
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    
    if (expanded) {
        
        [dic setValue:[NSNumber numberWithInt:0] forKey:DIC_EXPANDED];
        
    }else {
        [dic setValue:[NSNumber numberWithInt:1] forKey:DIC_EXPANDED];
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
