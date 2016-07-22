//
//  SDDashboardViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDDashboardViewController.h"
//#import "CZCell.h"
#import "SDHeaderCollectionReusableView.h"
#import "SDXiangqingViewController.h"
#import "SDoneCollectionViewCell.h"
#import "XWDragCellCollectionView.h"

@interface SDDashboardViewController ()<XWDragCellCollectionViewDataSource, XWDragCellCollectionViewDelegate>
@property (strong, nonatomic)  XWDragCellCollectionView *collectionView;
@property (nonatomic , strong) SDoneCollectionViewCell *cell ;

@property (nonatomic , strong) UICollectionViewFlowLayout * layout;

@property (nonatomic , strong) NSMutableArray * array;

@property (nonatomic , strong) NSMutableArray * nArray;

@property (nonatomic , strong) NSMutableArray * cellXArray;

@property (nonatomic , strong) NSMutableArray * cellYArray;
@end

@implementation SDDashboardViewController


- (void)viewWillAppear:(BOOL)animated
{
   
    [_collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[XWDragCellCollectionView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, Kheight) collectionViewLayout:self.layout];
    _layout.minimumLineSpacing = 15;
    _layout.minimumInteritemSpacing = 20;
    _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);;
    self.layout.headerReferenceSize = CGSizeMake(Kwidth, 40);
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _array =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"tuijianArray"] mutableCopy];
   
    if (_array.count == 0) {
        
        _array = [NSMutableArray  arrayWithObjects:@"a",@"b",@"4",@"c",@"6",@"7",nil];

    }

    [_collectionView registerClass:[SDoneCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [_collectionView registerClass:[SDHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    UIBarButtonItem * rightButotn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButotn;
}
- (void)clickRightButton:(UIButton *)button
{
    
    SDAddViewController * addVC = [[SDAddViewController alloc] init];
    addVC.delegate = self;
    

    [self.navigationController pushViewController:addVC animated:YES];
    
}

- (void)chuanzhi:(NSMutableArray *)array
{
//    _array = array;
//    NSLog(@"-opopkopkp[p=-=-=-=-=-=%ld",array.count);
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuzuCount) name:@"ADDArrayChange" object:nil];
    
    return _array.count;
}
- (void)shuzuCount
{
    _array =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"tuijianArray"] mutableCopy];

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    _cell.titLabone.tag = indexPath.row;
    _cell.titLabone.text = _array[indexPath.row];
    
    
    _cell.backgroundColor = [UIColor grayColor];
    
    NSLog(@"indexPath.row:%ld",indexPath.row);
    
    
    return _cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_array[indexPath.row] isEqualToString:@"a"] || [_array[indexPath.row] isEqualToString:@"b"]) {
        
        return CGSizeMake((Kwidth - 40)/2,(Kwidth - 40)/4 );
    }else if([_array[indexPath.row] isEqualToString:@"c"] ){
        
       
        return CGSizeMake((Kwidth - 20),(Kwidth - 40)/4 );

        
    }else{
        
      return CGSizeMake((Kwidth - 40)/2,(Kwidth - 40)/4 );
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDXiangqingViewController * xiangVC = [[SDXiangqingViewController alloc] init];
     self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:xiangVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    NSLog(@"我是第%ld个",indexPath.row);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        SDHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        NSString *title = [[NSString alloc] initWithFormat:@"指标看板"];
        
        headerView.titleLabel.text = title;
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        
        //        UICollectionReusableView *footerview = [collectionView dequeueResuableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        //
        //        reusableview = footerview;
        
    }
    
    return reusableview;
    
    
    
}

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    return _array;
}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    _array = [newDataArray mutableCopy];
    NSLog(@"-=-=-=%@",_array);
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tuijianArray"];
//    
//    
    [[NSUserDefaults standardUserDefaults]setObject:_array forKey:@"tuijianArray"];
//    //发送消息
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDArrayChange" object:nil];

}
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
//    //返回YES允许其item移动
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
////    取出源item数据
//    id objc = [_array objectAtIndex:sourceIndexPath.item];
//  
//    //从资源数组中移除该数据
//    [_array removeObject:objc];
//    //将数据插入到资源数组中的目标位置上
//    [_array insertObject:objc atIndex:destinationIndexPath.item];
////
////    
////    [_array replaceObjectAtIndex:sourceIndexPath.item withObject:_array[destinationIndexPath.item]];
////    [_array replaceObjectAtIndex:destinationIndexPath.item withObject:_array[sourceIndexPath.item]];
//
//    
//    NSLog(@"-=-=--------x:%f",_cell.frame.origin.x);
//    NSLog(@"-==-=-=-=-=-y:%f",_cell.frame.origin.y);
//    
//
//    
//    _nArray = [NSMutableArray arrayWithArray:_array];
//    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tuijianArray"];
//    
// 
//    [[NSUserDefaults standardUserDefaults]setObject:_nArray forKey:@"tuijianArray"];
//    //发送消息
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDArrayChange" object:nil];
////
//    
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
