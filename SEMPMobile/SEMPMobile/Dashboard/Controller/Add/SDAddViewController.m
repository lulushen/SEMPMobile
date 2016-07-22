//
//  SDAddViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/11.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDAddViewController.h"
#import "SDAddCollectionViewCell.h"
#import "SDCollectionReusableView.h"

@interface SDAddViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

// collection
@property (nonatomic , strong)UICollectionView * FirstCollectionView;

@property (nonatomic , strong)UICollectionView * TwoCollectctionView;

@property (nonatomic , strong)NSMutableArray * dataArray;

@property (nonatomic , strong)NSMutableArray * array2;


@end

@implementation SDAddViewController


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //  适配
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Add";
    
    self.tabBarController.tabBar.hidden = YES;

    _dataArray =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"tuijianArray"] mutableCopy];
    _array2 =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"zhibiaoArray"] mutableCopy];
    
    
    if (_dataArray.count == 0 && _array2.count == 0) {
        
        _dataArray = [NSMutableArray  arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",nil];
        
        _array2 = [NSMutableArray  arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",nil];
        
        
    }
    
    // 自定义返回按钮LeftButtonItme
    [self makeLeftButtonItme];
    
    // 定义tabelView
    [self makeCollectionView];
    
    
}

- (void)makeLeftButtonItme
{
    UIImage * backImage = [UIImage imageNamed:@"back.png"];
    CGRect backframe = CGRectMake(0, 0, 54*KWidth6scale, 30*KHeight6scale);
    UIButton * backButton = [[UIButton alloc] initWithFrame:backframe];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)backButtonClick:(UIButton *)button {
    
    [[NSUserDefaults standardUserDefaults] setObject:_dataArray forKey:@"tuijianArray"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_array2 forKey:@"zhibiaoArray"];
    
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDArrayChange" object:nil];
    
    self.tabBarController.tabBar.hidden = NO;

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeCollectionView
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Kwidth, 40)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"   推荐指标";
    [self.view addSubview:label];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _FirstCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), Kwidth, Kheight/3.0-40) collectionViewLayout:layout];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 8;
    _FirstCollectionView.backgroundColor = [UIColor whiteColor];
    
    _FirstCollectionView.tag = 1;
    
    _FirstCollectionView.delegate = self;
    
    _FirstCollectionView.dataSource = self;
    
    [self.view addSubview:_FirstCollectionView];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_FirstCollectionView.frame), Kwidth, 40)];
    label2.backgroundColor = [UIColor whiteColor];
    label2.text = @"   指标";
    [self.view addSubview:label2];
    
    UICollectionViewFlowLayout * layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    layout2.minimumLineSpacing = 15;
    layout2.minimumInteritemSpacing = 8;
    _TwoCollectctionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame), Kwidth, Kheight*2/3.0-80)collectionViewLayout:layout2];
    
    _TwoCollectctionView.backgroundColor = [UIColor whiteColor];
    
    _TwoCollectctionView.tag = 2;
    
    _TwoCollectctionView.delegate = self;
    
    _TwoCollectctionView.dataSource = self;
    
    [self.view addSubview:_TwoCollectctionView];
    
    [_FirstCollectionView  registerClass:[SDAddCollectionViewCell class] forCellWithReuseIdentifier:@"addcell"];
    [_FirstCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerone"];
    
    [_TwoCollectctionView registerClass:[SDAddCollectionViewCell class] forCellWithReuseIdentifier:@"addcell"];
    
    [_TwoCollectctionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerone"];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView.tag == 1) {
        return _dataArray.count;
    } else {
        return _array2.count;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDAddCollectionViewCell * addcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addcell" forIndexPath:indexPath];
    if (collectionView.tag == 1) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addcell.contentView.frame)-10, 0, 10, 10)];
        label.backgroundColor = [UIColor redColor];
        [addcell addSubview:label];
        for (int i = 0; i< _dataArray.count;i++) {
            
            addcell.titleLab.text = _dataArray[indexPath.row];
        }
        
    }else{
        for (int i = 0; i< _array2.count;i++) {
            
            addcell.titleLab.text = _array2[indexPath.row];
            addcell.titleLab.backgroundColor = [UIColor grayColor];
        }
        
        
    }
    return addcell;
}
// cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((Kwidth - 44)/4,(Kwidth - 35)/8 );
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 1) {
        
        
        [_array2 addObject:_dataArray[indexPath.row]];
        [_dataArray removeObject:_dataArray[indexPath.row]];
        
        
    }else{
       
        [_dataArray addObject:_array2[indexPath.row]];
        [_array2 removeObject:_array2[indexPath.row]];
        
        
        
        
    }
    [self chuanzhi];
    [_FirstCollectionView reloadData];
    [_TwoCollectctionView reloadData];
    
    
}

- (void)chuanzhi{
    //检测代理有没有实现changeStatus:方法
    if([self.delegate respondsToSelector:@selector(chuanzhi:)]){

        [self.delegate chuanzhi:_dataArray];
    }else{
        NSLog(@"代理没有实现changeStatus:方法");
    }
    
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//
//    SDCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerone" forIndexPath:indexPath];
//    headerView.backgroundColor = [UIColor whiteColor];
//
//    if (collectionView.tag == 1) {
//        if([kind isEqualToString:UICollectionElementKindSectionHeader])
//        {
//            if(headerView == nil)
//            {
//                headerView = [[SDCollectionReusableView alloc] init];
//                headerView.titleLabel.text = @"342423423";
//            }
//
//            return headerView;
//        }
//    }else{
//
//        if([kind isEqualToString:UICollectionElementKindSectionHeader])
//        {
//
//            if(headerView == nil)
//            {
//                headerView = [[SDCollectionReusableView alloc] init];
//                headerView.titleLabel.text = @"vjkfdkj";
//            }
//
//            return headerView;
//        }
//
//
//    }
//    return nil;
//    }
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return (CGSize){Kwidth,44};
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
