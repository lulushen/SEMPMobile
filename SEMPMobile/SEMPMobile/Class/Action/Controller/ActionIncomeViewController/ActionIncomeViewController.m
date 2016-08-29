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
#import "ActionDetailModel.h"
#import "AddActionTableViewCell.h"
#import "MBProgressHUD+MJ.h"

@interface ActionIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)UITableView * actionIncomeTableView;
@property (nonatomic , strong)ActionDetailModel * detailModel;
@property (nonatomic ,assign)    CGRect rectFuZeRenCell;

@property (nonatomic ,assign)    CGRect rectXieZhuRenCell;
@property (nonatomic ,assign)    CGRect rectXiangGuanIndexCell;
@property (nonatomic ,assign)    CGRect rectXiangQingCell;
@property (nonatomic ,assign)    CGRect rectJiLuCell;

@end

@implementation ActionIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _titleString;
    
    [self makeLeftButtonItme];
    
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
- (void)makeActionIncomeTableView
{
    
    _actionIncomeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight) style:UITableViewStylePlain];
    
    [self.view addSubview:_actionIncomeTableView];
    _actionIncomeTableView.delegate = self;
    _actionIncomeTableView.dataSource = self;
    _actionIncomeTableView.backgroundColor = [UIColor whiteColor];
    
    _actionIncomeTableView.rowHeight = UITableViewAutomaticDimension;
    
    //去除分割线
    _actionIncomeTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_actionIncomeTableView registerClass:[AddActionTableViewCell class] forCellReuseIdentifier:@"ADDCELL"];
    
    
}
- (void)makeActionIncomeData
{
    
    
    NSString * urlStr = [NSString stringWithFormat:GetTaskInfoHttp,_taskIDString];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            
            NSMutableDictionary * dict = responseObject[@"resdata"];
            
            _detailModel = [[ActionDetailModel alloc] init];
            
            [_detailModel setValuesForKeysWithDictionary:dict];
            //有数据后再添加表
            [self makeActionIncomeTableView];
            
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
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (indexPath.row == 0) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], [indexPath row]];
        ActionIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        if(cell == nil)
        {
            cell = [[ActionIncomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        [self makeTableViewFirstCell:cell indexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 1){
        AddActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ADDCELL" forIndexPath:indexPath];
        _rectFuZeRenCell = cell.frame;
        
        [self makeTableViewTwoCell:cell indexPath:indexPath];
        return cell;
    }else if (indexPath.row == 2){
        AddActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ADDCELL" forIndexPath:indexPath];
        [self makeTableViewThreeCell:cell indexPath:indexPath];
        
        _rectXieZhuRenCell.origin.x = cell.frame.origin.x;
        _rectXieZhuRenCell.origin.y = _rectFuZeRenCell.origin.y + _rectFuZeRenCell.size.height;
        _rectXieZhuRenCell.size.height = cell.frame.size.height;
        _rectXieZhuRenCell.size.width = cell.frame.size.width;
        cell.frame = _rectXieZhuRenCell;
        
        
        return cell;
    }else if (indexPath.row == 3){
        
        
        AddActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ADDCELL" forIndexPath:indexPath];
        // 确定cell的内容
        [self makeTableViewFourCell:cell indexPath:indexPath];
        // 确定cell的frame
        _rectXiangGuanIndexCell.origin.x = cell.frame.origin.x;
        _rectXiangGuanIndexCell.origin.y = CGRectGetMaxY(_rectXieZhuRenCell);
        _rectXiangGuanIndexCell.size.height = cell.frame.size.height;
        _rectXiangGuanIndexCell.size.width = cell.frame.size.width;
        
        cell.frame = _rectXiangGuanIndexCell;
        
        return cell;
    }else if (indexPath.row == 4){
        AddActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ADDCELL" forIndexPath:indexPath];
        
        cell.imageActionView.image  = [UIImage imageNamed:@"4.png"];
        cell.actionTitleLabel.text = @"任务详情";
        cell.addButton.hidden = YES;
        UILabel * detailLabel = [[UILabel alloc] init];
        
        detailLabel.text = _detailModel.taskinfo;
        detailLabel.numberOfLines = 0;
        
        detailLabel.font = [UIFont systemFontOfSize:14.0f];
        
        CGRect rect = [detailLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(cell.actionAddView.frame)-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:detailLabel.font} context:nil];
        
        detailLabel.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        
        CGRect rectCellActionAddView = cell.actionAddView.frame;
        
        rectCellActionAddView.size.height = CGRectGetMaxY(detailLabel.frame);
        
        cell.actionAddView.frame = rectCellActionAddView;
        
        CGRect rectcell = cell.frame;
        
        rectcell.size.height = CGRectGetMaxY(detailLabel.frame)+(KViewHeight - 270*KHeight6scale)/4.0 - 20*KHeight6scale;
        cell.frame = rectcell;
        
        [cell.actionAddView  addSubview:detailLabel];
        
        _rectXiangQingCell.origin.x = cell.frame.origin.x;
        _rectXiangQingCell.origin.y = CGRectGetMaxY(_rectXiangGuanIndexCell);
        _rectXiangQingCell.size.height = cell.frame.size.height;
        _rectXiangQingCell.size.width = cell.frame.size.width;
        
        cell.frame = _rectXiangQingCell;
        
        
        return cell;
        
    }else{
        
        AddActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ADDCELL" forIndexPath:indexPath];
        [self makeTableViewLastCell:cell indexPath:indexPath];
        _rectJiLuCell.origin.x = cell.frame.origin.x;
        _rectJiLuCell.origin.y = CGRectGetMaxY(_rectXiangQingCell);
        _rectJiLuCell.size.height = cell.frame.size.height;
        _rectJiLuCell.size.width = cell.frame.size.width;
        
        cell.frame = _rectJiLuCell;
        
        
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        return 120*KHeight6scale;
        
    }else if (indexPath.row == 5){
        
        if (_rectJiLuCell.size.height == 0) {
            
            return 150*KHeight6scale;
        }else{
            
            return _rectJiLuCell.size.height;
            
        }
        
    }else if(indexPath.row == 1){
        
        
        if (_rectFuZeRenCell.size.height == 0) {
            return (KViewHeight- 270*KHeight6scale)/4.0;
            
        }else{
            
            return _rectFuZeRenCell.size.height;
            
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
            return (KViewHeight- 270*KHeight6scale)/4.0;
            
        }else{
            
            return _rectXiangQingCell.size.height;
            
        }
        
    }else {
        
        return (KViewHeight- 270*KHeight6scale)/4.0;
        
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ActionIncomeFootView * view = [[ActionIncomeFootView alloc] init];
    view.backgroundColor = DEFAULT_BGCOLOR;
    return view;
    
}

- (void)makeTableViewFirstCell:(ActionIncomeTableViewCell *)cell indexPath:(NSIndexPath*)indexPath
{
    cell.chuangJianDataStringLabel.text = _detailModel.createtime ;
    cell.jieZhiDataStringLabel.text = _detailModel.createtime;
    cell.actionFuBuPersonLabel.text = _detailModel.createuser;
    cell.imageIncomeActionView.image  = [UIImage imageNamed:@"1.png"];
    if ([_detailModel.priority isEqualToString:@"1"]) {
        cell.actionStatuLabel.text = @"高";
        cell.actionStatuLabel.backgroundColor = RGBCOLOR(250.0, 110.0, 114.0);
    }else if ([_detailModel.priority isEqualToString:@"2"]) {
        cell.actionStatuLabel.text = @"中";
        cell.actionStatuLabel.backgroundColor = [UIColor orangeColor];
    }else{
        cell.actionStatuLabel.text = @"低";
        cell.actionStatuLabel.backgroundColor = [UIColor grayColor];
        
        
    }
    
    cell.actionFuBuTitleLabel.text = @"任务发布：";
    if ([_loginUserString isEqualToString:_detailModel.createuser]) {
        
        if ([_task_stateString isEqualToString:@"1"] | [_task_stateString isEqualToString:@"2"] |[_task_stateString isEqualToString:@"3"] | [_task_stateString isEqualToString:@"5"]) {
            
            [cell.oneButton setTitle:@"编辑" forState:UIControlStateNormal];
            [cell.twoButton setTitle:@"撤销" forState:UIControlStateNormal];
            
        }else if ([_task_stateString isEqualToString:@"6"] ){
            
            cell.oneButton.hidden = YES;
            [cell.twoButton setTitle:@"审核确认" forState:UIControlStateNormal];
            
            
        }else if ([_task_stateString isEqualToString:@"4"] ){
            
            cell.oneButton.hidden = YES;
            [cell.twoButton setTitle:@"删除" forState:UIControlStateNormal];
            
            
        }else if( [_task_stateString isEqualToString:@"7"] |[_task_stateString isEqualToString:@"8"] | [_task_stateString isEqualToString:@"9"]){
            NSLog(@"dap-----退回没有编辑");
            cell.oneButton.hidden = YES;
            cell.twoButton.hidden = YES;
            
        }else{
            
            cell.oneButton.hidden = YES;
            cell.twoButton.hidden = YES;
            
        }
        
    }else{
        
        if ([_task_stateString isEqualToString:@"1"]){
            
            [cell.oneButton setTitle:@"接收" forState:UIControlStateNormal];
            [cell.twoButton setTitle:@"拒绝" forState:UIControlStateNormal];
        }else if ([_task_stateString isEqualToString:@"3"]){
            
            [cell.oneButton setTitle:@"完成" forState:UIControlStateNormal];
            [cell.twoButton setTitle:@"申请延迟" forState:UIControlStateNormal];
            
        }else if ([_task_stateString isEqualToString:@"5"]){
            
            cell.oneButton.hidden = YES;
            [cell.twoButton setTitle:@"完成" forState:UIControlStateNormal];
            
            
        }else{
            
            //退回的暂时不可编辑
            
            cell.oneButton.hidden = YES;
            cell.twoButton.hidden = YES;
            
        }
        
    }
    
    
}
#warning =======cell,2,3,4的方法可以合并 －－后期修改
- (void)makeTableViewTwoCell:(AddActionTableViewCell*)cell indexPath:(NSIndexPath *)indexPath{
    
    
    
    [cell.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_detailModel.responsiblePerson == nil) {
        
    }else{
        
        UILabel * indexLabel = [[UILabel alloc] init];
        
        indexLabel.backgroundColor = DEFAULT_BGCOLOR;
        indexLabel.layer.masksToBounds = YES;
        indexLabel.layer.cornerRadius = 5;
        indexLabel.textAlignment = NSTextAlignmentCenter;
        
        indexLabel.text = _detailModel.responsiblePerson;
        
        indexLabel.font = [UIFont systemFontOfSize:14.0f];
        
        CGRect rect = [indexLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(cell.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
        
        indexLabel.frame = CGRectMake(0, 0, rect.size.width+5*KWidth6scale, rect.size.height+5*KHeight6scale);
        [cell.actionAddView  addSubview:indexLabel];
        
    }
    cell.imageActionView.image  = [UIImage imageNamed:@"1.png"];
    cell.actionTitleLabel.text = @"负责人";
    cell.addButton.hidden = YES;
    
    
    
}
- (void)makeTableViewThreeCell:(AddActionTableViewCell*)cell indexPath:(NSIndexPath *)indexPath
{
    
    [cell.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_detailModel.assistPeople.count != 0) {
        
        for (int i = 0; i <= _detailModel.assistPeople.count-1; i++ ){
            
            
            UILabel * indexLabel = [[UILabel alloc] init];
            
            
            static UILabel *recordLab = nil;
            
            indexLabel.backgroundColor = DEFAULT_BGCOLOR;
            indexLabel.layer.masksToBounds = YES;
            indexLabel.layer.cornerRadius = 5;
            indexLabel.textAlignment = NSTextAlignmentCenter;
            
            
            indexLabel.text = _detailModel.assistPeople[i];
            indexLabel.font = [UIFont systemFontOfSize:14.0f];
            CGRect rect = [indexLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(cell.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
            
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
            
            CGRect rectCellActionAddView = cell.actionAddView.frame;
            
            rectCellActionAddView.size.height = CGRectGetMaxY(indexLabel.frame);
            
            cell.actionAddView.frame = rectCellActionAddView;
            CGRect rectcell = cell.frame;
            
            rectcell.size.height = CGRectGetMaxY(indexLabel.frame)+(KViewHeight - 270*KHeight6scale)/4.0 - 20*KHeight6scale;
            
            cell.frame = rectcell;
            
            [cell.actionAddView  addSubview:indexLabel];
            
        }
        
    }
    cell.imageActionView.image  = [UIImage imageNamed:@"2.png"];
    cell.actionTitleLabel.text = @"协助人";
    cell.addButton.hidden = YES;
    
    
    
}
- (void)makeTableViewFourCell:(AddActionTableViewCell*)cell indexPath:(NSIndexPath *)indexPath
{
    
    
    [cell.actionAddView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    if (_detailModel.index.count == 0) {
        
        
    }else{
        
        
        for (int i = 0; i <= _detailModel.index.count-1; i++ ){
            
            
            UILabel * indexLabel = [[UILabel alloc] init];
            
            static UILabel *recordLab = nil;
            
            indexLabel.backgroundColor = DEFAULT_BGCOLOR;
            indexLabel.layer.masksToBounds = YES;
            indexLabel.layer.cornerRadius = 5;
            indexLabel.textAlignment = NSTextAlignmentCenter;
            
            indexLabel.text = _detailModel.index[i];
            indexLabel.font = [UIFont systemFontOfSize:14.0f];
            CGRect rect = [indexLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(cell.actionAddView.frame)-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:indexLabel.font} context:nil];
            
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
            
            CGRect rectCellActionAddView = cell.actionAddView.frame;
            
            rectCellActionAddView.size.height = CGRectGetMaxY(indexLabel.frame);
            
            cell.actionAddView.frame = rectCellActionAddView;
            CGRect rectcell = cell.frame;
            
            rectcell.size.height = CGRectGetMaxY(indexLabel.frame)+(KViewHeight - 270*KHeight6scale)/4.0 - 20*KHeight6scale;
            
            cell.frame = rectcell;
            
            [cell.actionAddView  addSubview:indexLabel];
            
            
        }
        
    }
    
    cell.imageActionView.image  = [UIImage imageNamed:@"3.png"];
    
    cell.actionTitleLabel.text = @"相关指标";
    cell.addButton.hidden = YES;
}
- (void)makeTableViewLastCell:(AddActionTableViewCell*)cell indexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor = DEFAULT_BGCOLOR;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*KWidth6scale, 10*KWidth6scale, cell.frame.size.width - 40*KWidth6scale, 40*KWidth6scale)];
    titleLabel.text = @"任务状态记录";
    titleLabel.textColor = MoreButtonColor;
    [cell.contentView addSubview:titleLabel];
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
        textLabel.text = [NSString stringWithFormat:@"任务详情: %@",[_detailModel.deatil[i] valueForKey:@"type"]];
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
        
        CGRect rectCell = cell.contentView.frame;
        
        rectCell.size.height = CGRectGetMaxY(recordView.frame) + 50*KHeight6scale;
        
        cell.frame = rectCell;
        
        [cell.contentView  addSubview:recordView];
  
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
