//
//  SDDashboardViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDDashboardViewController.h"
#import "SDHeaderCollectionReusableView.h"
#import "SDXiangqingViewController.h"
#import "SDoneCollectionViewCell.h"
#import "DataView.h"
#import "UIColor+NSString.h"


@interface SDDashboardViewController ()
@property (nonatomic , strong)DataView * dataview;

@end

@implementation SDDashboardViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    self.dataview = [[DataView alloc] initWithFrame:CGRectMake(0, 0, Kwidth*2/5, 44)];
    self.navigationItem.titleView = self.dataview;
    

    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, KTableViewHeight)];
    self.scrollview.showsHorizontalScrollIndicator = NO;

    self.scrollview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollview];
    [self maketopView];
    // 添加观察者
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuzuCount) name:@"ADDArrayChange" object:nil];
    _arrayZhiBiao = [NSMutableArray array];
    if (_arrayZhiBiao.count == 0) {
        [self  makeDate];
    }else{
            _arrayZhiBiao =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"tuijianArray"] mutableCopy];
  
    }

    _buttonArray = [NSMutableArray array];
    _wanzhengbuttonArray = [NSMutableArray array];

    UIBarButtonItem * rightButotn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(clickRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButotn;
    [self makeviewmove];

}
- (void)makeDate
{
  
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"date_JSON" ofType:@"txt"];
    
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary * dict in array) {
        
        SDModelZhiBiao * m = [[SDModelZhiBiao alloc] init];
        
        [m setValuesForKeysWithDictionary:dict];
        
        [_arrayZhiBiao addObject:m];
        
    }
    NSLog(@"========array.count : %ld",_arrayZhiBiao.count);
    NSLog(@"_arrayZhiBiao %@",_arrayZhiBiao);

    
}
- (void)maketopView
{
    UIView * topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, 40)];
    [self.scrollview addSubview:topview];
    
    UILabel * labelimage = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 35, 35)];
    labelimage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhibiao.png"]];
    [topview addSubview:labelimage];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelimage.frame), CGRectGetMinY(labelimage.frame)+10, CGRectGetWidth(labelimage.frame) * 3, CGRectGetHeight(labelimage.frame))];
    label.text = @"  指标看板";
    [topview addSubview:label];
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.moreButton.frame = CGRectMake(Kwidth - 80, CGRectGetMinY(label.frame)+5, 60, CGRectGetHeight(label.frame)/2);
    [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.moreButton setTitle:@"more" forState:UIControlStateNormal];
    self.moreButton.layer.borderWidth = 1;
    self.moreButton.layer.cornerRadius = 5;
    self.moreButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [topview addSubview:self.moreButton];

    [self.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)moreButtonClick:(UIButton *)button
{
    for (UIView * view in self.scrollview.subviews) {
        
        [view removeFromSuperview];
        
    }
    
    [_buttonArray removeAllObjects];
    [_wanzhengbuttonArray removeAllObjects];
    
    SDAddViewController * addVC = [[SDAddViewController alloc] init];
    addVC.delegate = self;
    [_wanzhengbuttonArray removeAllObjects];
    [self.navigationController pushViewController:addVC animated:YES];

}
- (void)clickRightButton:(UIButton *)button
{
 
}
- (void)chuanzhi:(NSMutableArray *)array
{
    //    _array = array;
    //    NSLog(@"-opopkopkp[p=-=-=-=-=-=%ld",array.count);
    
}
- (void)makeviewmove
{
    [self maketopView];
    UIView * tempviewi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIView * tempviewj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    for (int i = 0; i < _arrayZhiBiao.count; i++) {
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
        SDModelZhiBiao * model = [[SDModelZhiBiao alloc] init];
        SDModelZhiBiao * modeltwo = [[SDModelZhiBiao alloc] init];


            if (i == 0) {
        
                tempi.origin = CGPointMake(bianju, 40);
                model = _arrayZhiBiao[i];
                NSLog(@"========model=%@",model);
                if ((model.size_x == 1 )&& (model.size_y == 1) ) {
        
                    tempi.size = CGSizeMake((Kwidth-30)/2.0, (Kwidth-100)/2.0);
                    
                }else if((model.size_x == 2 )&& (model.size_y == 1) ){
        
                    tempi.size = CGSizeMake(Kwidth-20, (Kwidth-100)/2.0);
        
                }else if((model.size_x == 2 )&& (model.size_y == 2) ){
        
                    tempi.size = CGSizeMake(Kwidth-20, Kwidth-100);
        
                }
            }else{
        
                model = _arrayZhiBiao[i];

                if ((model.size_x == 1 )&& (model.size_y == 1)) {
                    NSLog(@"========model=%@",model);

                    tempi.size = CGSizeMake((Kwidth-30)/2.0, (Kwidth-100)/2.0);
        
                    modeltwo = _arrayZhiBiao[i-1];
                    if ((modeltwo.size_x == 1 )&& (modeltwo.size_y == 1)) {
        
                        if (tempj.origin.x > Kwidth*2/3) {
        
                            tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju );
        
                        }else{
                            tempi.origin = CGPointMake(bianju + CGRectGetMaxX(tempj), CGRectGetMinY(tempj));
        
                        }
                    }else{
        
                        tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
                    }
        
                }else if((model.size_x == 2 )&& (model.size_y == 1)){
        
                    tempi.size = CGSizeMake(Kwidth-20, (Kwidth-100)/2.0);
        
                    tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
        
                }else if((model.size_x == 2 )&& (model.size_y == 2) ){
        
                    tempi.size = CGSizeMake(Kwidth-20, Kwidth-100);
        
                    tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
        
        
                }
        
            }
        
            tempviewi.frame = tempi;
            _viewmove.frame = tempi;
       
            [_buttonArray addObject:_viewmove];
        
            [_wanzhengbuttonArray addObject:tempviewi];
        
        
    }
    self.scrollview.contentSize = CGSizeMake(Kwidth, CGRectGetMaxY(tempviewi.frame));

    NSLog(@"-=-=-=-=%@",_wanzhengbuttonArray);
    NSLog(@"-=-=_wanzhengbuttonArray.count : %ld",_wanzhengbuttonArray.count);
    for (int i = 0;i < _wanzhengbuttonArray.count ; i++) {
        UIView * view = _wanzhengbuttonArray[i];
        [self.scrollview addSubview:view];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, view.frame.size.width-20, 20)];
//        lab.backgroundColor = [UIColor grayColor];
        UILabel * lab6 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lab.frame), CGRectGetHeight(view.frame)-30, CGRectGetWidth(lab.frame),  20)];
        UILabel * lab3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lab.frame), CGRectGetMinY(lab6.frame)-20, CGRectGetWidth(lab.frame)/4.0,20)];
        UILabel * lab4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab3.frame), CGRectGetMinY(lab3.frame), CGRectGetWidth(lab3.frame), CGRectGetHeight(lab3.frame))];
        UILabel * lab5 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab4.frame), CGRectGetMinY(lab3.frame), CGRectGetWidth(lab3.frame)*2, CGRectGetHeight(lab3.frame))];
        UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab.frame), CGRectGetWidth(lab.frame), CGRectGetHeight(view.frame)-CGRectGetHeight(lab.frame) - CGRectGetHeight(lab3.frame) - CGRectGetHeight(lab6.frame))];
        [lab2 setTextAlignment:NSTextAlignmentRight];

        [lab6 setTextAlignment:NSTextAlignmentRight];

        SDModelZhiBiao * m = [[SDModelZhiBiao alloc] init];
        m = _arrayZhiBiao[i];
        view.backgroundColor = [UIColor colorWithString:m.bgcolor];
        [lab setTextColor:[UIColor colorWithString:m.color]];
        lab.text = m.title;
lab2.adjustsFontSizeToFitWidth = YES;
        lab2.font = [UIFont systemFontOfSize:24];
        if ([m.char_type isEqualToString:@"line"]) {
            
        
        }else if([m.char_type isEqualToString:@"longtext"]){
            lab2.text = m.midval;
            lab6.text = m.unit;
            lab4.text = m.bottomval;
            lab3.text = m.bottomtitle;
        }else{
            lab2.text = m.midval;
            lab6.text = m.unit;
            lab4.text = m.bottomval;

            lab3.text = m.bottomtitle;
            
        }
        [view addSubview:lab];
        [view addSubview:lab2];
        [view addSubview:lab3];
        [view addSubview:lab4];
        [view addSubview:lab5];
        [view addSubview:lab6];
//                lab.backgroundColor = [UIColor grayColor];
//                lab2.backgroundColor = [UIColor whiteColor];
//                lab3.backgroundColor = [UIColor redColor];
//                lab4.backgroundColor = [UIColor orangeColor];
//                lab5.backgroundColor = [UIColor blueColor];
//                lab6.backgroundColor = [UIColor cyanColor];

        
//        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                     action:@selector(handleTap)];
//        //使用一根手指双击时，才触发点按手势识别器
//        //         recognizer.numberOfTapsRequired = 2;
//        recognizer.numberOfTouchesRequired = 1;
//        [view addGestureRecognizer:recognizer];
    }
    
}
- (void)shuzuCount

{

    _arrayZhiBiao =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"tuijianArray"] mutableCopy];



    [self makeviewmove];

}
- (void)handleTap
{
    SDXiangqingViewController * xiangqing = [[SDXiangqingViewController alloc] init];
    
    self.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:xiangqing animated:YES];
    self.hidesBottomBarWhenPushed=NO;

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
