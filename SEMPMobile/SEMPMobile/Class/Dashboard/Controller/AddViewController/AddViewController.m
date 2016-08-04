//
//  AddViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "AddViewController.h"
#import "AddCollectionViewCell.h"
#import "DashBoardViewController.h"
#import "DashBoardModel.h"


@interface AddViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong)UICollectionView * DashCollectionView;

@property (nonatomic , strong)UICollectionView * AllDashCollectctionView;

@property (nonatomic , strong)NSMutableArray * dashLabelArray;

@property (nonatomic , strong)NSMutableArray * dashAllArray;

@property (nonatomic , strong)NSIndexPath * orightindexPath;

@property (nonatomic , strong)NSData * DashLabeldata;

@property (nonatomic , strong)NSData * AllDashLabeldata;


@end

@implementation AddViewController
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideTabbar];
    
    _dashLabelArray = [NSMutableArray array];
    
    _dashAllArray = [NSMutableArray array];

    self.navigationItem.title = @"ADD";

    [self makeDate];
    
    [self makeCollectionView];
    
    // 自定义返回按钮LeftButtonItme
    [self makeLeftButtonItme];
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

- (void)makeDate
{
   
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"date" ofType:@"txt"];
    NSString * filePathAll = [[NSBundle mainBundle]pathForResource:@"dateAll" ofType:@"txt"];
    
    
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    NSData * dataAll = [NSData dataWithContentsOfFile:filePathAll];
    
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray * arrayAll = [NSJSONSerialization JSONObjectWithData:dataAll options:NSJSONReadingAllowFragments error:nil];

    NSMutableArray * arrayDashLabel = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        
        DashBoardModel * m = [[DashBoardModel alloc] init];
        
        [m setValuesForKeysWithDictionary:dict];
        
        [arrayDashLabel addObject:m];
    }
    NSMutableArray * arrayAllDashLabel = [NSMutableArray array];

    for (NSDictionary * dict in arrayAll) {
        
        DashBoardModel * m = [[DashBoardModel alloc] init];
        
        [m setValuesForKeysWithDictionary:dict];
        
        [arrayAllDashLabel addObject:m];
    }

    NSMutableArray * arrayDash = [NSMutableArray array];
    arrayDash = [[NSUserDefaults standardUserDefaults] objectForKey:@"DashLabelArray"];
    
    for (NSData * data in arrayDash) {
        // 反归档
        DashBoardModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [_dashLabelArray addObject:model];
        
    }
    NSMutableArray * arrayAllDash = [NSMutableArray array];
    arrayAllDash = [[NSUserDefaults standardUserDefaults] objectForKey:@"AllDashLabelArray"];
    
    for (NSData * data in arrayAllDash) {
        // 反归档
        DashBoardModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [_dashAllArray addObject:model];
        
    }
    
    if ( _dashLabelArray.count == 0) {
        _dashLabelArray = arrayDashLabel;
        _dashAllArray = arrayAllDashLabel;
    }
    
    
}
- (void)backButtonClick:(UIButton *)button {
    NSMutableArray * array = [NSMutableArray array];

    for (DashBoardModel * model in _dashLabelArray) {
        _DashLabeldata = [NSKeyedArchiver archivedDataWithRootObject:model];
        [array addObject:_DashLabeldata];
    }
    //1.获得NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //2.向文件中写入内容
    [userDefaults setObject:array forKey:@"DashLabelArray"];
    //2.1立即同步
    [userDefaults synchronize];
    NSMutableArray * arrayAllDash = [NSMutableArray array];
    
    for (DashBoardModel * model in _dashAllArray) {
        _AllDashLabeldata = [NSKeyedArchiver archivedDataWithRootObject:model];
        [arrayAllDash addObject:_AllDashLabeldata];
    }
    [userDefaults setObject:arrayAllDash forKey:@"AllDashLabelArray"];
    [userDefaults synchronize];

    
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDDashLabelArrayChange" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)makeCollectionView
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"   我的指标";
    [self.view addSubview:label];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _DashCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), Main_Screen_Width, Main_Screen_Height/3.0-40) collectionViewLayout:layout];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    
    layout.minimumLineSpacing = 15;
    
    layout.minimumInteritemSpacing = 8;
    
    _DashCollectionView.backgroundColor = [UIColor whiteColor];
    
    _DashCollectionView.tag = 1;
    
    _DashCollectionView.delegate = self;
    
    _DashCollectionView.dataSource = self;
    
    [self.view addSubview:_DashCollectionView];
    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_DashCollectionView addGestureRecognizer:longGesture];

    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_DashCollectionView.frame), Main_Screen_Width, 40)];
    
    label2.backgroundColor = [UIColor whiteColor];
    
    label2.text = @"  推荐指标";
    
    [self.view addSubview:label2];
    
    UICollectionViewFlowLayout * layout2 = [[UICollectionViewFlowLayout alloc] init];
    
    layout2.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    
    layout2.minimumLineSpacing = 15;
    
    layout2.minimumInteritemSpacing = 8;
    
    _AllDashCollectctionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame), Main_Screen_Width, Main_Screen_Height*2/3.0-80)collectionViewLayout:layout2];
    
    _AllDashCollectctionView.backgroundColor = [UIColor whiteColor];
    
    _AllDashCollectctionView.tag = 2;
    
    _AllDashCollectctionView.delegate = self;
    
    _AllDashCollectctionView.dataSource = self;
    
    [self.view addSubview:_AllDashCollectctionView];
    
    [_DashCollectionView  registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"addcell"];
    
    [_AllDashCollectctionView registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"addcell"];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (collectionView.tag == 1) {
        
        return _dashLabelArray.count;

    } else {
        
        return _dashAllArray.count;

    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (AddCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddCollectionViewCell * addcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addcell" forIndexPath:indexPath];
    DashBoardModel * dashModel = [[DashBoardModel alloc] init];

    if (collectionView.tag == 1) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addcell.contentView.frame)-10, 0, 12, 12)];
        label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"delete.png"]];
        
        [addcell addSubview:label];
        
        
        for (int i = 0; i< _dashLabelArray.count;i++) {
            dashModel = _dashLabelArray[indexPath.row];
            addcell.titleLab.text = dashModel.title;
        }
        
    }else{
        
        for (int i = 0; i< _dashAllArray.count;i++) {
            dashModel = _dashAllArray[indexPath.row];
            addcell.titleLab.text = dashModel.title;
            addcell.titleLab.backgroundColor = [UIColor grayColor];
        }
        
        
    }
    return addcell;
}
// cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((Main_Screen_Width - 44)/4,(Main_Screen_Width - 35)/8 );
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 1) {
       
        [_dashAllArray addObject:_dashLabelArray[indexPath.row]];
        [_dashLabelArray removeObject:_dashLabelArray[indexPath.row]];
        
    }else{
        
        [_dashLabelArray addObject:_dashAllArray[indexPath.row]];
        [_dashAllArray removeObject:_dashAllArray[indexPath.row]];
        
    }
    [_DashCollectionView reloadData];
    [_AllDashCollectctionView reloadData];
    
    
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
                //判断手势落点位置是否在路径上
                _orightindexPath = [_DashCollectionView indexPathForItemAtPoint:[longGesture locationInView:_DashCollectionView]];
                if (_orightindexPath == nil) {
                    break;
                }
                //在路径上则开始移动该路径上的cell
                [_DashCollectionView beginInteractiveMovementForItemAtIndexPath:_orightindexPath];
            }
            break;
        case UIGestureRecognizerStateChanged:{

            //移动过程当中随时更新cell位置
            [_DashCollectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:_DashCollectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [_DashCollectionView endInteractiveMovement];
            break;
        default:
            [_DashCollectionView cancelInteractiveMovement];
            break;
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    DashBoardModel * dashModel = [[DashBoardModel alloc] init];
    
    dashModel = _dashLabelArray[sourceIndexPath.row];
    //  从资源数组中移除该数据
    [_dashLabelArray removeObject:dashModel];
    //  将数据插入到资源数组中的目标位置上
    [_dashLabelArray insertObject:dashModel atIndex:destinationIndexPath.item];
    

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
