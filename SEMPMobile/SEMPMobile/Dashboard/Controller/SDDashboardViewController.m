//
//  SDDashboardViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDDashboardViewController.h"
#import "SDAddViewController.h"
#import "SDCollectionViewCell.h"
#import "SDHeaderCollectionReusableView.h"

@interface SDDashboardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic)  UICollectionView *collectionView;

@end

@implementation SDDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CZFlowLayout * layout = [[CZFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, KTableViewHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[CZCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[SDHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    UIBarButtonItem * rightButotn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButotn;
    // Do any additional setup after loading the view.
}
- (void)clickRightButton:(UIButton *)button
{
    SDAddViewController * addVC = [[SDAddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  24;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CZCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
//    NSInteger  index  =  indexPath.row % 9;
////    NSLog(@"-------index : %ld",index);
//    
    cell.numberLabel.tag = indexPath.row;
    cell.numberLabel.text = [NSString stringWithFormat:@"第%ld个",indexPath.row];
    
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"我是第%ld个",indexPath.row);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        SDHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
        
        reusableview = headerView;
    }
    
    //    if (kind == UICollectionElementKindSectionFooter)
    //    {
    //        RecipeCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    //
    //        reusableview = footerview;
    //    }
    
    reusableview.backgroundColor = [UIColor redColor];
    
    return reusableview;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={320,45};
    return size;
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
