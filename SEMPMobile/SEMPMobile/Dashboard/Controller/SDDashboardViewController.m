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
//#import "XWDragCellCollectionView.h"

@interface SDDashboardViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
//@property (strong, nonatomic)  UICollectionView *collectionView;
//@property (nonatomic , strong) SDoneCollectionViewCell *tempcelli ;
//@property (nonatomic , strong) SDoneCollectionViewCell *cell ;
//@property (nonatomic , strong) SDoneCollectionViewCell *tempcellj ;

@property (nonatomic , strong) NSIndexPath * orightindexPath;

@property (nonatomic , strong) UICollectionViewFlowLayout * layout;

@property (nonatomic , strong) NSMutableArray * array;

@property (nonatomic , strong) NSMutableArray * nArray;

@property (nonatomic , strong) NSMutableArray * buttonArray;

@property (nonatomic , strong) NSMutableArray * wanzhengbuttonArray;

@property (nonatomic , strong) UIView * viewmove;

@property (nonatomic , strong) UIScrollView * scrollview;
@end

@implementation SDDashboardViewController


- (void)viewWillAppear:(BOOL)animated
{
    
//    [_collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
//    self.layout = [[UICollectionViewFlowLayout alloc] init];
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, KTableViewHeight) collectionViewLayout:self.layout];
//    _collectionView.userInteractionEnabled = YES;
////    _layout.minimumLineSpacing = 15;
////    _layout.minimumInteritemSpacing = 20;
//    _layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);;
//    _collectionView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.collectionView];
//
//    _collectionView.delegate = self;
//    _collectionView.dataSource = self;
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, KTableViewHeight)];
    self.scrollview.contentSize = CGSizeMake(Kwidth, Kheight*2);
    [self.view addSubview:self.scrollview];
    _array =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"tuijianArray"] mutableCopy];
    
//    if (_array.count == 0) {
    
    _array = [NSMutableArray  arrayWithObjects:@"a",@"c",@"d",@"b",@"e",@"f",nil];
    
//        }
    _buttonArray = [NSMutableArray array];
    _wanzhengbuttonArray = [NSMutableArray array];
    
//    [_collectionView registerClass:[SDoneCollectionViewCell class] forCellWithReuseIdentifier:@"cellui"];
//
//    [_collectionView registerClass:[SDHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    UIBarButtonItem * rightButotn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButotn;
    [self makeviewmove];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
//    
//    [self.collectionView addGestureRecognizer:longPress];
//
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
- (void)makeviewmove
{
    UIView * tempviewi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIView * tempviewj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
     [self.scrollview addSubview:tempviewi];
     [self.scrollview addSubview:tempviewj];
    
    for (int i = 0; i < _array.count; i++) {
        _viewmove = [[UIView alloc] init];
        int bianju = 10;
            if (i == 0) {
                  _viewmove.frame = CGRectMake(0, 0, 0, 0);
               
                [_buttonArray addObject:_viewmove];
        
            }else{
                tempviewi =  _buttonArray[i];
                tempviewj=  _buttonArray[i - 1];
        
            }
        
            CGRect  tempi = tempviewi.frame;
            CGRect tempj = tempviewj.frame;
        
            if (i == 0) {
        
                tempi.origin = CGPointMake(bianju, 0);
                if ([_array[i] isEqualToString:@"a"] || [_array[i] isEqualToString:@"d"]) {
        
                    tempi.size = CGSizeMake((Kwidth-30)/2.0, 100);
                    
                }else if([_array[i] isEqualToString:@"b"] || [_array[i] isEqualToString:@"c"]){
        
                    tempi.size = CGSizeMake(Kwidth-20, 100);
        
                }else if([_array[i] isEqualToString:@"e"] || [_array[i] isEqualToString:@"f"]){
        
                    tempi.size = CGSizeMake(Kwidth-20, 200);
        
                }
            }else{
        
                if ([_array[i] isEqualToString:@"a"] || [_array[i] isEqualToString:@"d"]) {
        
                    tempi.size = CGSizeMake((Kwidth-30)/2.0, 100);
        
        
                    if ([_array[i-1] isEqualToString:@"a"] || [_array[i-1] isEqualToString:@"d"]) {
        
                        if (tempj.origin.x > Kwidth*2/3) {
        
                            tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
        
                        }else{
                            tempi.origin = CGPointMake(bianju + CGRectGetMaxX(tempj), CGRectGetMinY(tempj));
        
                        }
                    }else{
        
                        tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
                    }
        
                }else if([_array[i] isEqualToString:@"b"] || [_array[i] isEqualToString:@"c"]){
        
                    tempi.size = CGSizeMake(Kwidth-20, 100);
        
                    tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
        
                }else if([_array[i] isEqualToString:@"e"] || [_array[i] isEqualToString:@"f"]){
        
                    tempi.size = CGSizeMake(Kwidth-20, 200);
        
                    tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
        
        
                }
        
            }
        
            tempviewi.frame = tempi;
            _viewmove.frame = tempi;
       
            [_buttonArray addObject:_viewmove];
        
            [_wanzhengbuttonArray addObject:tempviewi];
         tempviewi.backgroundColor = [UIColor redColor];
        
        
    }
    
    int i = 0;
    for (UIView * view in _wanzhengbuttonArray) {
        [self.scrollview addSubview:view];
        UILabel * lab = [[UILabel alloc] initWithFrame:view.bounds];
        lab.backgroundColor = [UIColor grayColor];
        lab.text = _array[i];
        [view addSubview:lab];
        NSLog(@"-=-=-=-=-_viewmove : %@" ,view);
        i++;

    }


    
}
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    //添加观察者
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuzuCount) name:@"ADDArrayChange" object:nil];
//    
//    return _array.count;
//}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//- (void)shuzuCount
//{
//    _array =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"tuijianArray"] mutableCopy];
//    
//}
//
//
//- (SDoneCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//    _tempcelli = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellui" forIndexPath:indexPath];
//    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellui" forIndexPath:indexPath];
//    _tempcellj = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellui" forIndexPath:indexPath];
//
//    _tempcelli.userInteractionEnabled = YES;
//    _tempcelli.titLabone.userInteractionEnabled = YES;
//
//  
//    int bianju = 10;
//    if (indexPath.row == 0) {
//
//        _cell.frame = CGRectMake(0, 0, 0, 0);
//        
//        NSLog(@"_cell  : %@",_cell);
//        
//        [_buttonArray addObject:_cell];
//        NSLog(@"=-=-=-%@",_buttonArray);
//        
//    }else{
//        _tempcelli =  _buttonArray[indexPath.row];
//        _tempcellj = _buttonArray[indexPath.row - 1];
//        
//    }
//    
//    CGRect  tempi = _tempcelli.frame;
//    CGRect tempj = _tempcellj.frame;
//    
//    
//    if (indexPath.row == 0) {
//        
//        tempi.origin = CGPointMake(bianju, 0);
//        if ([_array[indexPath.row] isEqualToString:@"a"] || [_array[indexPath.row] isEqualToString:@"d"]) {
//            
//            tempi.size = CGSizeMake((Kwidth-40)/2.0, 100);
//        }else if([_array[indexPath.row] isEqualToString:@"b"] || [_array[indexPath.row] isEqualToString:@"c"]){
//            
//            tempi.size = CGSizeMake(Kwidth-20, 100);
//            
//        }else if([_array[indexPath.row] isEqualToString:@"e"] || [_array[indexPath.row] isEqualToString:@"f"]){
//            
//            tempi.size = CGSizeMake(Kwidth-20, 200);
//            
//        }
//    }else{
//        
//        if ([_array[indexPath.row] isEqualToString:@"a"] || [_array[indexPath.row] isEqualToString:@"d"]) {
//            
//            tempi.size = CGSizeMake((Kwidth-40)/2.0, 100);
//            
//            
//            if ([_array[indexPath.row-1] isEqualToString:@"a"] || [_array[indexPath.row-1] isEqualToString:@"d"]) {
//                
//                if (tempj.origin.x > Kwidth*2/3+100) {
//                    
//                    tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
//                    
//                }else{
//                    tempi.origin = CGPointMake(bianju + CGRectGetMaxX(tempj), CGRectGetMinY(tempj));
//                    
//                }
//            }else{
//                
//                tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
//            }
//            
//        }else if([_array[indexPath.row] isEqualToString:@"b"] || [_array[indexPath.row] isEqualToString:@"c"]){
//            
//            tempi.size = CGSizeMake(Kwidth-20, 100);
//            
//            tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
//            
//        }else if([_array[indexPath.row] isEqualToString:@"e"] || [_array[indexPath.row] isEqualToString:@"f"]){
//            
//            tempi.size = CGSizeMake(Kwidth-20, 200);
//            
//            tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
//            
//            
//        }
//        
//    }
//
//    _tempcelli.frame = tempi;
//    NSLog(@"-=-=-=-%@",_tempcelli);
//    
//    [_wanzhengbuttonArray addObject:_tempcelli];
//    
//    _cell.frame = tempi;
//
//    [_buttonArray addObject:_cell];
//
//   
//    _tempcelli.titLabone.text = _array[indexPath.row];
//    _tempcelli.titLabone.backgroundColor = [UIColor grayColor];
//    
//    return _tempcelli;
//}
//
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_array[indexPath.row] isEqualToString:@"a"] || [_array[indexPath.row] isEqualToString:@"d"]) {
//        
//        return CGSizeMake((Kwidth - 30)/2.0,100);
//    }else if([_array[indexPath.row] isEqualToString:@"b"] || [_array[indexPath.row] isEqualToString:@"c"] ){
//        
//        
//        return CGSizeMake((Kwidth - 20),100);
//        
//        
//    }else if([_array[indexPath.row] isEqualToString:@"e"] || [_array[indexPath.row] isEqualToString:@"f"]){
//        
//        return CGSizeMake((Kwidth - 20),200);
//    }else{
//        
//        return CGSizeMake(0, 0);
//        
//    }
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    SDXiangqingViewController * xiangVC = [[SDXiangqingViewController alloc] init];
//    self.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:xiangVC animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
//    NSLog(@"我是第%ld个",indexPath.row);
//}
////- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
////
////{
////
////    UICollectionReusableView *reusableview = nil;
////
////    if (kind == UICollectionElementKindSectionHeader){
////
////        SDHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
////
////        NSString *title = [[NSString alloc] initWithFormat:@"指标看板"];
////
////        headerView.titleLabel.text = title;
////
////        reusableview = headerView;
////    }
////
////    if (kind == UICollectionElementKindSectionFooter){
////
////        //        UICollectionReusableView *footerview = [collectionView dequeueResuableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
////        //
////        //        reusableview = footerview;
////
////    }
////
////    return reusableview;
////
////
////
////}
//
////- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
////    return _array;
////}
////
////- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
////    _array = [newDataArray mutableCopy];
////    NSLog(@"-=-=-=%@",_array);
////    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tuijianArray"];
//    //
//    //
////    [[NSUserDefaults standardUserDefaults]setObject:_array forKey:@"tuijianArray"];
////    //    //发送消息
////    [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDArrayChange" object:nil];
////
////}
//- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
//    //判断手势状态
//    switch (longGesture.state) {
//        case UIGestureRecognizerStateBegan:{
//                //判断手势落点位置是否在路径上
//                _orightindexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
//                if (_orightindexPath == nil) {
//                    break;
//                }
//                //在路径上则开始移动该路径上的cell
//                [self.collectionView beginInteractiveMovementForItemAtIndexPath:_orightindexPath];
//            }
//            break;
//        case UIGestureRecognizerStateChanged:{
//
//            //移动过程当中随时更新cell位置
//            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
//            
// 
//            
////            NSLog(@"update %@",[longGesture locationInView:self.collectionView]);
//            
//        }
//            break;
//        case UIGestureRecognizerStateEnded:
//            //移动结束后关闭cell移动
//            [self.collectionView endInteractiveMovement];
//            NSLog(@"end");
//            break;
//        default:
//            [self.collectionView cancelInteractiveMovement];
//            NSLog(@"cancel");
//            break;
//    }
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
//    //返回YES允许其item移动
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
//    UICollectionViewCell * celldian = [collectionView cellForItemAtIndexPath:sourceIndexPath];
//    NSLog(@"=-=-=-=-=-=-=-=-=cellpath : %@",celldian);
//    UICollectionViewCell * celldes = [collectionView cellForItemAtIndexPath:destinationIndexPath];
//    NSLog(@"=-=-=-=-=-=-=-=-=cellpathtwo : %@",celldes);
//    
////    CGRect frame = celldian.frame;
////    UICollectionViewCell * cell = [collectionView cel];
//    
//    
////    NSIndexPath * index = [NSIndexPath indexPathForRow:(destinationIndexPath.row - 1) inSection:destinationIndexPath.section];
////    UICollectionViewCell * celldesqian = [collectionView cellForItemAtIndexPath:index];
//
////    NSMutableArray * array = [NSMutableArray arrayWithObject:sourceIndexPath];
////    NSMutableArray * arraytwo = [NSMutableArray arrayWithObject:sourceIndexPath];
////
////    [collectionView deleteItemsAtIndexPaths:array];
////    [collectionView insertItemsAtIndexPaths:arraytwo];
//    
//    
////    NSLog(@"=-=-=--indexpath :%@ ",_orightindexPath);
//    if (celldian.frame.size.width < celldes.frame.size.width) {
////        celldes.frame = celldian.frame;
//        [collectionView moveItemAtIndexPath:destinationIndexPath toIndexPath:sourceIndexPath];
//        [collectionView cancelInteractiveMovement];
//        
//    }else if (celldian.frame.size.width > celldes.frame.size.width){
////        if (celldes.frame.origin.x > 100) {
////            celldes.frame = celldian.frame;
//
////            [collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:index];
//            [collectionView moveItemAtIndexPath:destinationIndexPath toIndexPath:sourceIndexPath];
//
////        }
////        [collectionView moveItemAtIndexPath:destinationIndexPath toIndexPath:sourceIndexPath];
//        [collectionView cancelInteractiveMovement];
//        
//    }else {
////        celldian.frame = celldes.frame;
////        celldes.frame = frame;
//        
//
//    }
////    [collectionView cancelInteractiveMovement];
////    id cell = [_wanzhengbuttonArray objectAtIndex:sourceIndexPath.row];
////        NSLog(@"=-=-=-=-=-=-=-=-=cell : %@",cell);
////
////    id objc = [_array objectAtIndex:sourceIndexPath.item];
//    
////    //从资源数组中移除该数据
////    [_array removeObject:objc];
////    //将数据插入到资源数组中的目标位置上
////    [_array insertObject:objc atIndex:destinationIndexPath.item];
////    
////    
////    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:_orightindexPath];
//////UICollectionViewCell * movetoCell = [collectionView cellForItemAtIndexPath:destinationIndexPath];
////
//////    UICollectionViewCell* tempMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
////    
//////    NSLog(@"=-=-=-=-=-=-=-=-=cell : %@",cell);
////    UIView * cellview =[[UIView alloc] init];
////    UIView *tempMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
////    cell.hidden = YES;
////    cellview = tempMoveCell;
////    cellview.frame = cell.frame;
////    [cell addSubview:cellview];
////
////    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:sourceIndexPath];
////    UICollectionViewCell * movetoCell = [collectionView cellForItemAtIndexPath:destinationIndexPath];
////    CGRect temp = cell.frame;
////    cell.frame = movetoCell.frame;
////    movetoCell.frame = temp;
//    
////    NSLog(@"-==--=cell ; %@",cell);
////    NSLog(@"-==--=cellmove ; %@",movetoCell);
////
////    if (movetoCell.frame.size.width > cell.frame.size.width) {
////        [collectionView moveItemAtIndexPath:destinationIndexPath toIndexPath:sourceIndexPath];
////
//////                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
////
////        [self.collectionView cancelInteractiveMovement];
//////        id objc = [_array objectAtIndex:destinationIndexPath.item];
//////        
//////        //从资源数组中移除该数据
//////        [_array removeObject:objc];
//////        //将数据插入到资源数组中的目标位置上
//////        [_array insertObject:objc atIndex:sourceIndexPath.item];
////        
////        
////
////    }else{
////        
////        id objc = [_array objectAtIndex:destinationIndexPath.item];
////        
////        //从资源数组中移除该数据
////        [_array removeObject:objc];
////        //将数据插入到资源数组中的目标位置上
////        [_array insertObject:objc atIndex:destinationIndexPath.item];
////
////
////        
////    }
////    [self.collectionView deleteItemsAtIndexPaths:sourceIndexPath];
////    [self.collectionView insertItemsAtIndexPaths:destinationIndexPath];
//    
////        取出源item数据
//       //    [_array replaceObjectAtIndex:sourceIndexPath.item withObject:_array[destinationIndexPath.item]];
//    //    [_array replaceObjectAtIndex:destinationIndexPath.item withObject:_array[sourceIndexPath.item]];
//    
//    
////    NSLog(@"-=-=--------x:%f",_cell.frame.origin.x);
////    NSLog(@"-==-=-=-=-=-y:%f",_cell.frame.origin.y);
//    
//    
//    
////    _nArray = [NSMutableArray arrayWithArray:_wanzhengbuttonArray];
////    
////    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tuijianArray"];
////    
////    
////    [[NSUserDefaults standardUserDefaults]setObject:_nArray forKey:@"tuijianArray"];
////    //发送消息
////    [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDArrayChange" object:nil];
////    //
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
