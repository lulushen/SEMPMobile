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

@interface SDDashboardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic)  UICollectionView *collectionView;

@property (nonatomic , strong) UICollectionViewFlowLayout * layout;

@property (nonatomic , strong) NSMutableArray * array;

@property (nonatomic , strong) NSMutableArray * cellFrameArray;
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
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, KTableViewHeight) collectionViewLayout:self.layout];
    _layout.minimumLineSpacing = 15;
    _layout.minimumInteritemSpacing = 20;
    _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);;
    self.layout.headerReferenceSize = CGSizeMake(Kwidth, 40);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];

    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_collectionView addGestureRecognizer:longGesture];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    _array = [NSMutableArray  arrayWithObjects:@"a",@"b",@"4",@"c",@"6",@"7",nil];

    [self.collectionView registerClass:[SDoneCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.collectionView registerClass:[SDHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
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
    _array = array;
    NSLog(@"-opopkopkp[p=-=-=-=-=-=%ld",array.count);
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDoneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
 
//    UIView * view = (UIView *)[cell.contentView viewWithTag:indexPath.row];
//    for (view in cell.contentView.subviews) {
//       
//        [view removeFromSuperview];
//        
//    }

    cell.titLabone.tag = indexPath.row;
    cell.titLabone.text = _array[indexPath.row];
    
    
    cell.backgroundColor = [UIColor grayColor];
    
    _cellFrameArray = [NSMutableArray array];
    
    for (int i = 0; i < indexPath.row; i++) {
        NSLog(@"nksnfkjsnfjnskjnfjsnkfjnjs");

//        NSString * str = NSStringFromCGRect(cell.frame);
//        
//        
//        _cellFrameArray = [NSMutableArray  arrayWithObject: str];
        
//        NSLog( @"-=-=-=-cellframe : %@", CGRectFromString(_cellFrameArray[i]));
        
    }
  
    
    
    
    return cell;
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
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;



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

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
//    取出源item数据
    id objc = [_array objectAtIndex:sourceIndexPath.item];
    NSLog(@";;;;;;;;;;;;;;;%ld",sourceIndexPath.item);
    
//    NSString * frame = [_cellFrameArray objectAtIndex:sourceIndexPath.item];
//    
//    NSString * frame2 = [_cellFrameArray objectAtIndex:destinationIndexPath.item];
//    CGSize size = CGSizeFromString(frame);
//    CGSize size2 = CGSizeFromString(frame2);
//    
//    NSLog(@"kpoo-=-=-=-=-=-=-=-size : %@",size);
//    NSLog(@"kpoo-=-=-=-=-=-=-=-size2 : %@",size);

    NSLog(@";;;;;;;;--=-=-=-;;;;;;;%ld",destinationIndexPath.item);

//
    //从资源数组中移除该数据
    [_array removeObject:objc];
//    size2 = size;
    //将数据插入到资源数组中的目标位置上
    
    [_array insertObject:objc atIndex:destinationIndexPath.item];
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
