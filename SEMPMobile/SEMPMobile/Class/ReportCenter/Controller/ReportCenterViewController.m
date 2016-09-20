//
//  ReportCenterViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/10.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ReportCenterViewController.h"
#import "AllReportCollectionViewCell.h"
#import "ReportTableViewCell.h"
#import "HeaderView.h"
#import "ReportIncomeViewController.h"

@interface ReportCenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
// 搜索按钮
@property (nonatomic , strong) UIButton * searchButton;
// 样式按钮
@property (nonatomic , strong) UIButton * styleButton;
// 全部报表按钮
@property (nonatomic , strong) UIButton * allReportButton;
// 我的关注报表按钮
@property (nonatomic , strong) UIButton * myReportButton;
// 全部报表collectionView
@property (nonatomic , strong) UICollectionView * allReportCollectionView;
// 全部报表tableView
@property (nonatomic , strong) UITableView * allReportTableView;
// 我的关注collectionView
@property (nonatomic , strong) UICollectionView * myReportCollectionView;
// 我的关注tableView
@property (nonatomic , strong) UITableView * myReportTableView;
// 表头视图
@property (nonatomic , strong) HeaderView * headerView;

@end
#define NotSelectedColor [UIColor colorWithRed:107/255.0 green:108/255.0 blue:109/255.0 alpha:1]
@implementation ReportCenterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self showTabBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 修改视图上navigation的样式
    [self makeNavigation];
    
    // 全部报表collectionView样式
    [self makeAllReportCollectionView];
    
}
// 修改视图上navigation的样式
- (void)makeNavigation
{
    // navigation上的标题视图
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width/2.0, 40*KHeight6scale)];
    
    self.navigationItem.titleView = titleView;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(titleView.frame), CGRectGetMinY(titleView.frame)+10*KHeight6scale, 1, CGRectGetHeight(titleView.frame)-20*KHeight6scale)];
    
    label.backgroundColor = [UIColor whiteColor];
    
    [titleView addSubview:label];
    _myReportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame)/2.0, CGRectGetHeight(titleView.frame))];
    [_myReportButton setTitle:@"我的关注" forState:UIControlStateNormal];
    [_myReportButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [_myReportButton setTitleColor:NotSelectedColor forState:UIControlStateNormal];
    [_myReportButton addTarget:self action:@selector(myReportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_myReportButton];
    
    _allReportButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame),CGRectGetMinY(_allReportButton.frame),CGRectGetWidth(_myReportButton.frame),CGRectGetHeight(_myReportButton.frame))];
    [_allReportButton setTitle:@"全部报表" forState:UIControlStateNormal];
    [_allReportButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [_allReportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_allReportButton addTarget:self action:@selector(allReportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _allReportButton.selected = YES;
    [titleView addSubview:_allReportButton];
    
    
    // navigation上的搜索按钮
    CGRect searchframe = CGRectMake(0, 0, 25*KWidth6scale, 25*KHeight6scale);
    
    _searchButton = [[UIButton alloc] initWithFrame:searchframe];
    
    [_searchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    
    [_searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // navigation上的样式按钮
    CGRect styleframe = CGRectMake(0, 0, 25*KWidth6scale, 25*KHeight6scale);
    
    _styleButton = [[UIButton alloc] initWithFrame:styleframe];
    _styleButton.selected = NO;
    [_styleButton addTarget:self action:@selector(styleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_styleButton setImage:[UIImage imageNamed:@"style_normal.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_styleButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40*KHeight6scale)];

}
// 搜索按钮点击方法
- (void)searchButtonClick:(UIButton *)button
{
    
}
// 样式按钮点击方法
- (void)styleButtonClick:(UIButton *)button
{
    if (button.selected == YES) {
        
        [_styleButton setImage:[UIImage imageNamed:@"style_normal.png"] forState:UIControlStateNormal];
        button.selected = NO;
        if (_myReportButton.selected == YES) {
            // 我的关注collectionView
            [self  makeMyReportCollectView];
        }else{
            // 全部报表collectionView样式
            [self makeAllReportCollectionView];
            
        }
        
        
    }else{
        [_styleButton setImage:[UIImage imageNamed:@"style_highligh.png"] forState:UIControlStateNormal];
        button.selected = YES;
        if (_myReportButton.selected == YES) {
            // 我的关注tableView
            [self makeMyReportTableView];
        }else{
            // 全部报表tableView样式
            [self makeAllReportTableView];
        }
        
        
        
        
    }
    
}
// 我的关注按钮的点击事件
- (void)myReportButtonClick:(UIButton *)button
{
    
    if (button.selected == YES) {
        
        
    }else{
       
        [self  makeSelectedButton:button];

        if (_styleButton.selected == NO) {
           
            // 我的关注collectionView
            [self  makeMyReportCollectView];
        }else{
            // 我的关注tableView
            [self makeMyReportTableView];
           
 
        }
    }
    
}
// 全部报表按钮的点击事件
- (void)allReportButtonClick:(UIButton *)button
{
   
    if (button.selected == YES) {
        
    }else{
        
        [self  makeSelectedButton:button];
        if (_styleButton.selected == NO) {
            
            // 全部报表collectionView样式
            [self makeAllReportCollectionView];

           
        }else{
            // 全部报表tableView样式
            
            [self makeAllReportTableView];
            
           
            
        }
           }
    
}
// 两个报表button的公共属性
- (void)makeSelectedButton:(UIButton *)button
{
   _allReportButton.selected = NO;
   _myReportButton.selected = NO;
    button.selected = YES;
    [_allReportButton setTitleColor:NotSelectedColor forState:UIControlStateNormal];
    [_myReportButton setTitleColor:NotSelectedColor forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
}

// 全部报表collectionView
- (void)makeAllReportCollectionView
{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    _allReportCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight) collectionViewLayout:layout];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    layout.sectionInset = UIEdgeInsetsMake(10*KHeight6scale, 10*KWidth6scale, 0, 10*KWidth6scale);
    
    [self makeCollectionView:_allReportCollectionView];
    
    _allReportCollectionView.tag = 1;
    
    [self.view addSubview:_allReportCollectionView];
    
    //    [_allReportCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
}
// 我的关注CollectionView
- (void)makeMyReportCollectView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    _myReportCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight) collectionViewLayout:layout];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    layout.sectionInset = UIEdgeInsetsMake(10*KHeight6scale, 10*KWidth6scale, 0, 10*KWidth6scale);
    
    [self makeCollectionView:_myReportCollectionView];
    _myReportCollectionView.tag = 2;
    [self.view addSubview:_myReportCollectionView];
    
    // 注册cell、sectionHeader、sectionFooter
    [_myReportCollectionView registerClass:[AllReportCollectionViewCell class] forCellWithReuseIdentifier:@"AllCollectionCell"];
    [_myReportCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
}
// 两个collectionView的公共属性
- (void)makeCollectionView:(UICollectionView *)collectionView
{
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [_allReportCollectionView removeFromSuperview];
    [_myReportTableView removeFromSuperview];
    [_allReportTableView removeFromSuperview];
    [_myReportCollectionView removeFromSuperview];
    
    // 注册cell、sectionHeader、sectionFooter
    [collectionView registerClass:[AllReportCollectionViewCell class] forCellWithReuseIdentifier:@"AllCollectionCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
}
// 全部报表tableView
- (void)makeAllReportTableView
{
    _allReportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight) style:UITableViewStyleGrouped];
    _allReportTableView.tag = 1;
    [self makeTableView:_allReportTableView];
    [self.view addSubview:_allReportTableView];
    _allReportTableView.tableHeaderView = _headerView;
    _headerView.titleLabel.text = @"零售管理";
}
// 我的关注tableView
- (void)makeMyReportTableView
{
    _myReportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight) style:UITableViewStyleGrouped];
    [self makeTableView:_myReportTableView];
    
    _myReportTableView.tag = 2;
    
    [self.view addSubview:_myReportTableView];
    _myReportTableView.tableHeaderView = _headerView;
    _headerView.titleLabel.text = @"管理";
    
    
}
// 两个tableView的公共属性
- (void)makeTableView:(UITableView *)tableView
{
    tableView.delegate = self;
    tableView.dataSource  = self;
    [_allReportCollectionView removeFromSuperview];
    [_allReportTableView removeFromSuperview];
    [_myReportCollectionView removeFromSuperview];
    [_myReportTableView removeFromSuperview];
    
    // 去掉分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [tableView registerClass:[ReportTableViewCell class] forCellReuseIdentifier:@"reportTableCell"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  --------collectionView代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView.tag == 1) {
        
        return 2;
        
    }else{
        
        return 1;
        
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView.tag == 1) {
        
        return 6;
        
    }else{
        
        return 3;
        
    }
    
}


- (AllReportCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllReportCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllCollectionCell" forIndexPath:indexPath];
    
    if (collectionView.tag == 1) {
        
        
        cell.titleLabel.text = @"123";
        cell.imageView.image = [UIImage imageNamed:@"report.png"];
        [cell.concernButton addTarget:self action:@selector(concernButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        
        cell.titleLabel.text = @"A101";
        cell.imageView.image = [UIImage imageNamed:@"report.png"];
        [cell.concernButton addTarget:self action:@selector(concernButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
    return cell;
}
#warning  两个collectionView 头部数据又不同所以先分开写
// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 1) {
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
            
            headerView.backgroundColor = DEFAULT_BGCOLOR;
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(20*KWidth6scale, 15*KHeight6scale, 20*KWidth6scale, 20*KHeight6scale)];
            image.image = [UIImage imageNamed:@"shu.png"];
            [headerView addSubview:image];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + 10*KWidth6scale, CGRectGetMinY(image.frame)-10*KHeight6scale, headerView.frame.size.width, headerView.frame.size.height)];
            label.text = @"零售管理";
            [headerView addSubview:label];
            label.font = [UIFont systemFontOfSize:16];
            
            return headerView;
        }
        
    }else{
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
            
            headerView.backgroundColor = DEFAULT_BGCOLOR;
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(20*KWidth6scale, 15*KHeight6scale, 20*KWidth6scale, 20*KHeight6scale)];
            image.image = [UIImage imageNamed:@"shu.png"];
            [headerView addSubview:image];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + 10*KWidth6scale, CGRectGetMinY(image.frame)-10*KHeight6scale, headerView.frame.size.width, headerView.frame.size.height)];
            label.text = @"管理";
            [headerView addSubview:label];
            label.font = [UIFont systemFontOfSize:16];
            
            return headerView;
        }
    }
    
    
    
    return nil;
}
// 如果不写这个方法 加载view时也不会走设置头部的方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){Main_Screen_Width,40*KHeight6scale};
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        
    }else{
        
    }
    
    ReportIncomeViewController * reportIncomeVC = [[ReportIncomeViewController alloc] init];
    
    NSMutableDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userResponseObject"];

    NSString * token =  [userDict valueForKey:@"user_token"];
    
    reportIncomeVC.webViewHttpString = [NSString stringWithFormat:ReportIncomeWebHttp,token];
    
    self.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:reportIncomeVC animated:YES];
    
    self.hidesBottomBarWhenPushed=NO;

    
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(Main_Screen_Width- 30*KWidth6scale)/2.0,Main_Screen_Height/5.5};
}
// 关注按钮的点击事件
- (void)concernButtonClick:(UIButton *)button
{
    
    [button setImage:[UIImage imageNamed:@"concern_highligh.png"] forState:UIControlStateNormal];
    
}
#pragma  --------tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return 2;
    }else{
        
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView.tag == 1) {
        return 6;
    }else{
        return 3;
    }
}
-(ReportTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"reportTableCell" forIndexPath:indexPath];
    
    if (tableView.tag == 1) {
        cell.titleLabel.text = @"123";
        cell.dateLabel.text = @"2016-08-01";
        
    }else{
        cell.titleLabel.text = @"A101";
        cell.dateLabel.text = @"2016-08-01";
    }
    return cell;
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
