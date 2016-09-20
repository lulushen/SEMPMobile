//
//  SDInfoViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/11.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDInfoViewController.h"
#import "NoReadInfoTableViewCell.h"
#import "ReadedTableViewCell.h"
#import "InfoModel.h"

@interface SDInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) FCXRefreshHeaderView *headerView;

@property (nonatomic,strong) UITableView * infoTableView;
//全部消息
@property (nonatomic , strong)UIButton * allInfoButton;
//未读消息
@property (nonatomic , strong)UIButton * noReadButton;
//已读消息
@property (nonatomic , strong)UIButton * readedButton;
// 未读信息的cell
@property (nonatomic , strong)NoReadInfoTableViewCell * noReadCell;
// 已读信息的cell
@property (nonatomic , strong)ReadedTableViewCell * readedCell;

@property (nonatomic , strong)InfoModel * makeReadModel;


@end

@implementation SDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息中心";
    // topView
    [self makeTopView];
    if (_allInfoArray.count == 0) {
        
    }else{
        // tableView
        [self makeInfoTableView];
        _infoTableView.tag = 0;

    }

    
    // Do any additional setup after loading the view.
}
- (void)makeTopView
{
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40*KHeight6scale)];
    topView.backgroundColor = DEFAULT_BGCOLOR;
    [self.view addSubview:topView];
    _allInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _noReadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _readedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _allInfoButton.frame = CGRectMake(20*KWidth6scale, 10*KHeight6scale, (Main_Screen_Width-40*KWidth6scale)/3.0, 30*KHeight6scale);
    _noReadButton.frame = CGRectMake(CGRectGetMaxX(_allInfoButton.frame), CGRectGetMinY(_allInfoButton.frame), CGRectGetWidth(_allInfoButton.frame), CGRectGetHeight(_allInfoButton.frame));
    _readedButton.frame = CGRectMake(CGRectGetMaxX(_noReadButton.frame), CGRectGetMinY(_noReadButton.frame), CGRectGetWidth(_noReadButton.frame), CGRectGetHeight(_noReadButton.frame));
    
    [topView addSubview:_allInfoButton];
    [topView addSubview:_noReadButton];
    [topView addSubview:_readedButton];
    _allInfoButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _noReadButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _readedButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    _allInfoButton.layer.masksToBounds = YES;
    _allInfoButton.layer.cornerRadius = 5;
    _noReadButton.layer.masksToBounds = YES;
    _noReadButton.layer.cornerRadius = 5;
    _readedButton.layer.masksToBounds = YES;
    _readedButton.layer.cornerRadius = 5;

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DataCountChange) name:@"DataCountChange" object:nil];
    [_allInfoButton setTitle:[NSString stringWithFormat:@"全部消息(%ld)",_allInfoArray.count] forState:UIControlStateNormal];
    [_allInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_noReadButton setTitle:[NSString stringWithFormat:@"未读消息(%ld)",_noReadInfoArray.count] forState:UIControlStateNormal];
    [_noReadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_readedButton setTitle:[NSString stringWithFormat:@"已读消息(%ld)",_readedInfoArray.count] forState:UIControlStateNormal];
    [_readedButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [_allInfoButton addTarget:self action:@selector(allInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_noReadButton addTarget:self action:@selector(noReadInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_readedButton addTarget:self action:@selector(readedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _allInfoButton.backgroundColor = ActionButtonColor;
    _allInfoButton.selected = YES;


    
    
    
    
}
- (void)DataCountChange
{
    [_allInfoButton setTitle:[NSString stringWithFormat:@"全部消息(%ld)",_allInfoArray.count] forState:UIControlStateNormal];
    NSMutableArray * tempArray = [NSMutableArray array];
    for (InfoModel * model in _noReadInfoArray) {
        if (model.readflag == 0) {
            [tempArray addObject:model];
        }
    }
    [_noReadButton setTitle:[NSString stringWithFormat:@"未读消息(%ld)",tempArray.count] forState:UIControlStateNormal];
    [_readedButton setTitle:[NSString stringWithFormat:@"已读消息(%ld)",_readedInfoArray.count] forState:UIControlStateNormal];

}
- (void)allInfoButtonClick:(UIButton * )button
{
    
    if (button.selected != YES) {
        //   四个任务按钮的公共属性
        [self makeSelectedButton:button];
        
        [self makeInfoTableView];
        
        _infoTableView.tag =0;

    }

    
}
- (void)noReadInfoButtonClick:(UIButton * )button
{
    
    if (button.selected != YES) {
        [self makeSelectedButton:button];
        
        NSMutableArray * tempArray = [NSMutableArray array];
        for (InfoModel * model in _noReadInfoArray) {
            if (model.readflag == 0) {
                [tempArray addObject:model];
            }
        }
        _noReadInfoArray = tempArray;
        
        [self makeInfoTableView];
        _infoTableView.tag = 1;

    }
}
- (void)readedButtonClick:(UIButton * )button
{
    if (button.selected != YES) {
        [self makeSelectedButton:button];
        
    
        [self makeInfoTableView];
        _infoTableView.tag = 2;

    }

}
- (void)makeSelectedButton:(UIButton *)button
{
    _allInfoButton.selected = NO;
    _noReadButton.selected = NO;
    _readedButton.selected = NO;
   
    [_infoTableView removeFromSuperview];
    [_headerView removeFromSuperview];
    button.selected = YES;
    
    _allInfoButton.backgroundColor = [UIColor clearColor];
    _noReadButton.backgroundColor = [UIColor clearColor];
    _readedButton.backgroundColor = [UIColor clearColor];
    
    [_allInfoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_noReadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_readedButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:ActionButtonColor];
    
    
    
}
- (void)makeInfoTableView
{
    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_allInfoButton.frame), Main_Screen_Width,KViewHeight - CGRectGetHeight(_allInfoButton.frame)) style:UITableViewStylePlain];
    
    _infoTableView.backgroundColor = [UIColor whiteColor];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    [self.view addSubview:_infoTableView];
    //刷新
    [self addRefreshView];
    _infoTableView.rowHeight = UITableViewAutomaticDimension;

    // 去掉分割线
    _infoTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_infoTableView registerClass:[NoReadInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_infoTableView registerClass:[ReadedTableViewCell class] forCellReuseIdentifier:@"ReadCell"];


}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return _allInfoArray.count;

    }else if (tableView.tag == 1){
       
        return _noReadInfoArray.count;

    }else if (tableView.tag == 2){
        return _readedInfoArray.count;

    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        InfoModel * model = _allInfoArray[indexPath.row];
     
        if (model.readflag == 0) {
            if (_noReadCell.frame.size.height == 0) {
                return 100;
            }else{
                return _noReadCell.frame.size.height;
            }
        }else if (model.readflag == 1){
            if (_readedCell.frame.size.height == 0) {
                return 100;
            }else{
                return _readedCell.frame.size.height;
            }
        }else{
            return 300;
        }

        
    }else if (tableView.tag == 1){
        
        InfoModel * model = _noReadInfoArray[indexPath.row];
        
        if (model.readflag == 0) {
            if (_noReadCell.frame.size.height == 0) {
                return 100;
            }else{
                return _noReadCell.frame.size.height;
            }
        }else if (model.readflag == 1){
            if (_readedCell.frame.size.height == 0) {
                return 100;
            }else{
                return _readedCell.frame.size.height;
            }
        }else{
            return 300;
        }
        
        
    }else if (tableView.tag == 2){
        if (_readedCell.frame.size.height == 0) {
            return 200;
        }else{
            return _readedCell.frame.size.height;
        }
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        
        InfoModel * model = _allInfoArray[indexPath.row];
        if (model.readflag == 0) {
            
            _noReadCell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
            _noReadCell.infoTitleLabel.text = model.title;
            _noReadCell.infoDateLabel.text = model.time;
            _noReadCell.infoImageView.image = [UIImage imageNamed:@"noread.png"];
            CGRect rect = _noReadCell.frame;
            rect.size.height = KViewHeight;
            _noReadCell.frame = rect;
            // 先给出一个高多就可以得到label可变的高度 （暂时还不明白为什么？？）
            NSLog(@"----%f",self.noReadCell.rectTitle.size.height);
            NSLog(@"----%f",self.noReadCell.rectDate.size.height);
            CGRect cellrect = _noReadCell.frame;
            cellrect.size.height = _noReadCell.infoLabel.frame.size.height + 10*KHeight6scale;
            _noReadCell.frame = cellrect;
            return _noReadCell;
        }else if(model.readflag == 1){

                _readedCell = [tableView dequeueReusableCellWithIdentifier:@"ReadCell" forIndexPath:indexPath];
            
            if (_readedInfoArray.count == 0  ) {
                
            }else{
                InfoModel * model = _allInfoArray[indexPath.row];
                _readedCell.infoTitleLabel.text = model.title;
                _readedCell.infoDateLabel.text = model.time;
                _readedCell.senderLabel.text = model.send_user;
                _readedCell.receiveLabel.text = model.receive_user;
                _readedCell.contentLabel.text = model.text;
                _readedCell.infoImageView.image = [UIImage imageNamed:@"readed.png"];

            }
            CGRect rect = _readedCell.frame;
            rect.size.height = KViewHeight;
            _readedCell.frame = rect;
            // 先给出一个高多就可以得到label可变的高度 （暂时还不明白为什么？？）
            NSLog(@"----%f",self.readedCell.rectTitle.size.height);
            NSLog(@"----%f",self.readedCell.rectDate.size.height);
            CGRect cellrect = _readedCell.frame;
            cellrect.size.height = _readedCell.infoLabel.frame.size.height +_readedCell.readedView.frame.size.height+ 10*KHeight6scale;
            _readedCell.frame = cellrect;
            return _readedCell;
            
        }else{
            return nil;

        }
       

    }else if (tableView.tag == 1){
        
       
        InfoModel * model = _noReadInfoArray[indexPath.row];

        if (model.readflag == 0) {
            
            _noReadCell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            _noReadCell.infoTitleLabel.text = model.title;
            _noReadCell.infoDateLabel.text = model.time;
            _noReadCell.infoImageView.image = [UIImage imageNamed:@"noread.png"];
            CGRect rect = _noReadCell.frame;
            rect.size.height = KViewHeight;
            _noReadCell.frame = rect;
            // 先给出一个高多就可以得到label可变的高度 （暂时还不明白为什么？？）
            NSLog(@"----%f",self.noReadCell.rectTitle.size.height);
            NSLog(@"----%f",self.noReadCell.rectDate.size.height);
            CGRect cellrect = _noReadCell.frame;
            cellrect.size.height = _noReadCell.infoLabel.frame.size.height + 10*KHeight6scale;
            _noReadCell.frame = cellrect;
            return _noReadCell;
            
        }else if(model.readflag == 1){
            
            _readedCell = [tableView dequeueReusableCellWithIdentifier:@"ReadCell" forIndexPath:indexPath];
            
            if (_readedInfoArray.count == 0  ) {
                
            }else{
                InfoModel * model = _allInfoArray[indexPath.row];
                _readedCell.infoTitleLabel.text = model.title;
                _readedCell.infoDateLabel.text = model.time;
                _readedCell.senderLabel.text = model.send_user;
                _readedCell.receiveLabel.text = model.receive_user;
                _readedCell.contentLabel.text = model.text;
                _readedCell.infoImageView.image = [UIImage imageNamed:@"readed.png"];
                
            }
            CGRect rect = _readedCell.frame;
            rect.size.height = KViewHeight;
            _readedCell.frame = rect;
            // 先给出一个高多就可以得到label可变的高度 （暂时还不明白为什么？？）
            NSLog(@"----%f",self.readedCell.rectTitle.size.height);
            NSLog(@"----%f",self.readedCell.rectDate.size.height);
            CGRect cellrect = _readedCell.frame;
            cellrect.size.height = _readedCell.infoLabel.frame.size.height +_readedCell.readedView.frame.size.height+ 10*KHeight6scale;
            _readedCell.frame = cellrect;
            return _readedCell;
            
        }else{
            return nil;
            
        }
        

        

    }else if (tableView.tag == 2){
        
        
        _readedCell = [tableView dequeueReusableCellWithIdentifier:@"ReadCell" forIndexPath:indexPath];
        
        if (_readedInfoArray.count  == 0  ) {
            
            
        }else{
            InfoModel * model = _readedInfoArray[indexPath.row];
            _readedCell.infoTitleLabel.text = model.title;
            _readedCell.infoDateLabel.text = model.time;
            _readedCell.senderLabel.text = model.send_user;
            _readedCell.receiveLabel.text = model.receive_user;
            _readedCell.contentLabel.text = model.text;
            _readedCell.infoImageView.image = [UIImage imageNamed:@"readed.png"];

        }
        
        CGRect rect = _readedCell.frame;
        rect.size.height = KViewHeight;
        _readedCell.frame = rect;
        // 先给出一个高多就可以得到label可变的高度 （暂时还不明白为什么？？）
      
        CGRect cellrect = _readedCell.frame;
        cellrect.size.height = _readedCell.infoLabel.frame.size.height +_readedCell.readedView.frame.size.height+ 10*KHeight6scale;
        _readedCell.frame = cellrect;
        return _readedCell;

    }else{
        
        
        return nil;
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if (tableView.tag == 0) {
        
        InfoModel * model = _allInfoArray[indexPath.row];

        if (model.readflag == 0) {
            
            NSLog(@"%@",model.message_id);
            
            NSString * urlStr = [NSString stringWithFormat:userReadInfoHttp,model.message_id];
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];

            [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
                //这里可以用来显示下载进度
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog( @"--%@",responseObject);
                
                if (responseObject != nil) {
                    
                    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                    
                    dict = responseObject[@"resdata"];

                    _makeReadModel = [[InfoModel alloc] init];
                    
                    [_makeReadModel setValuesForKeysWithDictionary:dict];
                    
                    [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
                    
                    [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
                    
                }
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //失败
                NSLog(@"failure  error ： %@",error);
            }];
  
        }else if (model.readflag == 1){
 
        }
  
    }else if (tableView.tag == 1){
      
        InfoModel * model = _noReadInfoArray[indexPath.row];
        NSString * urlStr = [NSString stringWithFormat:userReadInfoHttp,model.message_id];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (responseObject != nil) {
                
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                dict = responseObject[@"resdata"];
                
                _makeReadModel = [[InfoModel alloc] init];
                
                [_makeReadModel setValuesForKeysWithDictionary:dict];

                [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
                
                [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
                
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
        }];

    }else if (tableView.tag == 2){
        
    }else{
        
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView.tag == 0) {
        
        [tableView beginUpdates];

            if (editingStyle ==UITableViewCellEditingStyleDelete) {
                NSLog(@"删除");
                InfoModel * model = _allInfoArray[indexPath.row];
                //第一,删除数据源,
                [ _allInfoArray removeObject:model];
                [_noReadInfoArray removeObject:model];
                [_readedInfoArray addObject:_makeReadModel];

                [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation: NO];

                // 发送通知数据个数改变
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DataCountChange" object:nil];
                
            }else{
                //第一,插入数据源
                [_allInfoArray insertObject:_makeReadModel atIndex:indexPath.row];
                //第二,插入cell.
                
                [tableView insertRowsAtIndexPaths:@[indexPath]withRowAnimation:NO];
                
                NSLog(@"添加");

            }

        [tableView endUpdates];

    }else if (tableView.tag == 1){
        
        [tableView beginUpdates];
            if (editingStyle ==UITableViewCellEditingStyleDelete) {
                NSLog(@"删除");
                InfoModel * model = _noReadInfoArray[indexPath.row];

                //第一,删除数据源,
                [_noReadInfoArray removeObject:model];
                [_allInfoArray removeObject:model];
                [_allInfoArray addObject:_makeReadModel];
                [_readedInfoArray addObject:_makeReadModel];
                
                //第二,删除表格cell
                [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:NO];
                
            }else{
              
                    //第一,插入数据源
                [_noReadInfoArray insertObject:_makeReadModel atIndex:indexPath.row];
                
                
                NSLog(@"插入");

              //第二,插入cell.
                [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
            }
    
        [tableView endUpdates];

    }else if (tableView.tag == 2){
        
    }else{
        
    }

    // 发送通知数据个数改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataCountChange" object:nil];
    
    
}
- (void)makeInfoData
{
   
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString * urlStr = [NSString stringWithFormat:userInfoHttp];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (responseObject != nil) {
                
                [_allInfoArray removeAllObjects];
                [_noReadInfoArray removeAllObjects];
                [_readedInfoArray removeAllObjects];
                _allInfoArray = [NSMutableArray array];
                _noReadInfoArray = [NSMutableArray array];
                _readedInfoArray = [NSMutableArray array];
                NSMutableArray * infoArray = [NSMutableArray array];
                infoArray = responseObject[@"resdata"];
                for (NSDictionary * dict in infoArray) {
                    
                    InfoModel * model = [[InfoModel alloc] init];
                    if ([dict[@"app_read_flag"] isEqualToString:@""]) {
                        
                    }else{
                        
                        [model setValuesForKeysWithDictionary:dict];
                        
                        [_allInfoArray addObject:model];
                        if (model.readflag == 0) {
                            [_noReadInfoArray addObject:model];
                        }else if(model.readflag == 1){
                            [_readedInfoArray addObject:model];
                        }
                    }
                    
                }
                [_infoTableView reloadData];
                // 发送通知数据个数改变
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DataCountChange" object:nil];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            
        }];
        
    });
    
}

- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    _headerView = [_infoTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
    
    //上拉加载更多
//    footerView = [_infoTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
//        [weakSelf loadMoreAction];
//    }];
    
    //自动刷新
//    footerView.autoLoadMore = self.autoLoadMore;
}

- (void)refreshAction {
    __weak FCXRefreshHeaderView *weakHeaderView = _headerView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakHeaderView endRefresh];
        [self makeInfoData];
    });
}

//- (void)loadMoreAction {
//    __weak UITableView *weakTableView = mTableView;
//    __weak FCXRefreshFooterView *weakFooterView = footerView;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        rows += 12;
//        [weakTableView reloadData];
//        [weakFooterView endRefresh];
//    });
//}
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
