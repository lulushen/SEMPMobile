//
//  SDInfoViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/11.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDInfoViewController.h"
#import "userModel.h"
#import "NoReadInfoTableViewCell.h"

@interface SDInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * infoTableView;
//全部消息
@property (nonatomic , strong)UIButton * allInfoButton;
//未读消息
@property (nonatomic , strong)UIButton * noReadButton;
//已读消息
@property (nonatomic , strong)UIButton * readedButton;

@end

@implementation SDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息中心";
    // topView
    [self makeTopView];
    // tableView
    [self makeInfoTableView];
    
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

    
    [_allInfoButton setTitle:[NSString stringWithFormat:@"全部消息(%@)",@"0"] forState:UIControlStateNormal];
    [_allInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_noReadButton setTitle:[NSString stringWithFormat:@"未读消息(%@)",@"0"] forState:UIControlStateNormal];
    [_noReadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_readedButton setTitle:[NSString stringWithFormat:@"已读消息(%@)",@"0"] forState:UIControlStateNormal];
    [_readedButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [_allInfoButton addTarget:self action:@selector(allInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_noReadButton addTarget:self action:@selector(noReadInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_readedButton addTarget:self action:@selector(readedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _allInfoButton.backgroundColor = ActionButtonColor;
    _allInfoButton.selected = YES;


    
    
    
    
}
- (void)allInfoButtonClick:(UIButton * )button
{
    
    if (button.selected != YES) {
        //   四个任务按钮的公共属性
        [self makeSelectedButton:button];
        [self.view addSubview:_infoTableView];

    }

    
}
- (void)noReadInfoButtonClick:(UIButton * )button
{
    
    if (button.selected != YES) {
        [self makeSelectedButton:button];
        [self.view addSubview:_infoTableView];

    }
}
- (void)readedButtonClick:(UIButton * )button
{
    if (button.selected != YES) {
        [self makeSelectedButton:button];
        [self.view addSubview:_infoTableView];

    }

}
- (void)makeSelectedButton:(UIButton *)button
{
    _allInfoButton.selected = NO;
    _noReadButton.selected = NO;
    _readedButton.selected = NO;
    [_infoTableView removeFromSuperview];
   
    
    
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
    // 去掉分割线
    _infoTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_infoTableView registerClass:[NoReadInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoReadInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    
    if (indexPath.row == 0) {
        cell.infoTitleLabel.text = @"123123123123123123123123123123123123123123123123123123123123123123123123123123123123123";
        cell.infoDateLabel.text = @"2ew2ew2ew2ew2ew2ew2ew2ew";
        
    }else{
        cell.infoTitleLabel.text = @"123";
        cell.infoDateLabel.text = @"2ew";
    }
   
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoReadInfoTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect cellRect = cell.frame;
    cellRect.size.height = cell.infoLabel.frame.size.height + 20*KHeight6scale;
    cell.frame = cellRect;
    
    return cell.frame.size.height;
    
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
