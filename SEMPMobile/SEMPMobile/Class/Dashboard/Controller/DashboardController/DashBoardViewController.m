//
//  DashBoardViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/15.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DashBoardViewController.h"
#import "DashCollectionReusableView.h"
#import "DashCollectionViewFlowLayout.h"
#import "DashBoardCollectionViewCell.h"
#import "SDIncomeViewController.h"
#import "DataSearchView.h"
#import "DataView.h"
#import "PNChart.h"
#import "UIColor+NSString.h"
#import "AddViewController.h"
#import "AddDashModel.h"
#import "IncomeDashModel.h"


@interface DashBoardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PNChartDelegate>
{
    DashCollectionViewFlowLayout * layout;
    AddViewController * addVC;
    // 提示没有指标的label
    UILabel * label;
}
@property (nonatomic , strong) FCXRefreshHeaderView *headerView;

//分享按钮
@property (nonatomic , strong) UIButton * shareButton;
//nav上的日期视图
@property (nonatomic ,strong) DataView * dataView;
//日期选择视图
@property (nonatomic ,strong) DataSearchView * dataSearchView;
//折线图
@property (nonatomic , strong)PNLineChart * lineChart;
//柱形图
@property (nonatomic , strong)PNBarChart * barChart;
//扇形图
@property (nonatomic) PNPieChart *pieChart;
//nav上显示的时间字符串
@property (nonatomic , strong) NSString * DataString;
//选中的cell对应的dashModel
@property (nonatomic , strong)  DashBoardModel * dashModel;
//dashBoard界面的collectionView
@property (nonatomic  , strong) UICollectionView * collectionView;
//cell上的删除按钮
@property (nonatomic , strong) UIButton  *cellDeleteButton;

//cell删除时的indexPath
@property (nonatomic , strong) NSIndexPath* cellIndexPath;

@property (nonatomic , strong) DashCollectionReusableView * topView;

#pragma 记得删除 临时的time
@property (nonatomic , strong) NSString * Time;
@property (nonatomic , strong) NSString * token;

@property (nonatomic , strong) NSMutableArray * pieColorArray;

@end

@implementation DashBoardViewController

- (NSMutableArray *)DashModelArray
{
    if (_DashModelArray == nil) {
        _DashModelArray = [NSMutableArray array];
    }
    return _DashModelArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _topView.moreButton.selected = NO;

    // 添加界面的数据
    [self makeADDDate];
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //获取持久化数据
    NSMutableDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userResponseObject"];
    NSMutableDictionary * dict = [userDict valueForKey:@"resdata"];
    _Time = [NSString stringWithFormat:@"%@",dict[@"defaulttime"]];
    _token =  [userDict valueForKey:@"user_token"];
    
    _pieColorArray = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        [_pieColorArray addObject:PNArc4randomColor];
    }
    
    _topView = [[DashCollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30*KHeight6scale)];
    
    [_topView.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_topView];
    [self makeView];
    // 添加观察者 观察日期变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DateChange) name:@"DateChange" object:nil];
    // 添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ADDDashLabelArrayChange) name:@"ADDDashLabelArrayChange" object:nil];
    
    [self  makeNavigation];
    
    // Do any additional setup after loading the view.
}
- (void)makeView
{
    _DashModelArray = [NSMutableArray array];
    //获取持久化数据
    NSMutableArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"array"];
    
    for (NSDictionary * dict in array) {
        DashBoardModel * model = [[DashBoardModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [_DashModelArray addObject:model];
    }
    
    // model重新排序
    [self makeNewDashModelArray];
    // 创建collectionView
    [self makeCollectionView];
   
}
- (void)makeCollectionView
{
    
    layout = [[DashCollectionViewFlowLayout alloc] init];
    
    layout.DashModelArray = [_DashModelArray mutableCopy];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), Main_Screen_Width, KViewHeight-CGRectGetHeight(_topView.frame)) collectionViewLayout:layout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_collectionView];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[DashBoardCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    if(_DashModelArray.count == 0){
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_collectionView.frame), CGRectGetHeight(_collectionView.frame))];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"没有关注指标~";
        [_collectionView addSubview:label];
        
    }
    [self addRefreshView];

    //创建长按手势监听
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(myHandleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 0.5;
    //将长按手势添加到需要实现长按操作的视图里
    [self.collectionView addGestureRecognizer:longPress];
}
- (void)makeNavigation
{
    // 显示nav上的日期label和button的视图
    _dataView = [[DataView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width*2/5, 44)];
    if (_Time.length != 0) {
        // 判断默认时间，获取显示时间的样式
        if (_Time.length == 4) {
            
            _DataString = [NSString stringWithFormat:@"%@年",_Time];
            
        }else if (_Time.length == 6){
            
            NSString *  yearNumeber = [_Time substringWithRange:NSMakeRange(0, 4)] ;
            
            NSString * mouthNumber = [_Time substringWithRange:NSMakeRange(4, 2)] ;
            
            _DataString = [NSString stringWithFormat:@"%@年%@月",yearNumeber,mouthNumber];
        }else {
            
            NSString *  year = [_Time substringWithRange:NSMakeRange(0, 4)] ;
            
            NSString * mouth = [_Time substringWithRange:NSMakeRange(4, 2)] ;
            
            NSString * day = [_Time substringWithRange:NSMakeRange(6, 2)] ;
            
            _DataString = [NSString stringWithFormat:@"%@年%@月%@日",year,mouth,day];
        }
        
    }else{
        
        _DataString = [NSString stringWithFormat:@"2016年"];
        
    }
    
    // nav上日期label显示的时间
    _dataView.dateLabel.text  = _DataString;
    
    // dataView视图 相当于navigationItem.titleView
    self.navigationItem.titleView  = _dataView;
    // 点击日期按钮
    [_dataView.dateButton addTarget:self action:@selector(dataClick:) forControlEvents:UIControlEventTouchUpInside];
    _dataSearchView = [[DataSearchView alloc] initWithFrame:CGRectMake(50, 10, Main_Screen_Width-100, Main_Screen_Width-100)];
    //添加视图
    [self.view addSubview:_dataSearchView];
    _dataSearchView.alpha = 0.0f;
    // 进入日期选择视图，确定日期选择期默认的日期
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    // 日期选择视图上的关闭按钮
    [_dataSearchView.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // navigation上的分享按钮
    UIImage * shareImage = [UIImage imageNamed:@"share.png"];
    
    CGRect shareframe = CGRectMake(0, 0, 20*KWidth6scale, 25*KHeight6scale);
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_shareButton setTintColor:[UIColor whiteColor]];
    _shareButton.frame = shareframe;
    [_shareButton setImage:shareImage forState:UIControlStateNormal];
    
    [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
}
// 相当于 日期按钮的点击状态
static  BOOL Btnstatu = YES;

-(void)dataClick:(UIButton *)button
{
    
    if (button.selected == Btnstatu) {
        
        Btnstatu = YES;
        
    }else{
        // 点击日期按钮时 相当于默认点击日期选择视图中的月按钮
        [_dataSearchView mouthButtonClick:_dataSearchView.mouthButton];
        
        Btnstatu = NO;
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        _topView.backgroundColor = [UIColor blackColor];
        _topView.alpha = 0.6;
        _collectionView.alpha = 0.6;
        _collectionView.userInteractionEnabled = NO;
        _topView.userInteractionEnabled = NO;
        _dataSearchView.alpha = 1.0f;
    } completion:nil];
}
// 日期视图中的关闭事件
- (void)deleteButtonClick:(UIButton *)button
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.alpha = 1;
        _collectionView.alpha = 1;
        _collectionView.userInteractionEnabled = YES;
        _topView.userInteractionEnabled = YES;
        _dataSearchView.alpha = 0.0f;
        
    } completion:nil];
    
    Btnstatu = YES;
    
}
// 被观察者发生改变时 调用观察者方法
- (void)DateChange
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.alpha = 1;
        _collectionView.alpha = 1;
        _collectionView.userInteractionEnabled = YES;
        _topView.userInteractionEnabled = YES;
        _dataSearchView.alpha = 0.0f;
        
    } completion:nil];
    
    
    NSString * date = [[NSUserDefaults standardUserDefaults] objectForKey:@"DateChange"];
    
    _dataView.dateLabel.text = date;
    
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    _Time = [_dataSearchView.defaultDateString stringByReplacingOccurrencesOfString:@"年" withString:@""];
    
    _Time = [_Time stringByReplacingOccurrencesOfString:@"月" withString:@""];
    
    _Time = [_Time stringByReplacingOccurrencesOfString:@"日" withString:@""];
    //    _Time = _dataSearchView.timeString;
   
//    NSMutableDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userResponseObject"];
//    
//    _token =  [userDict valueForKey:@"user_token"];
    // 刷新数据
    [self makeDate:_Time];
    
    
    
}

// 观察者方法
- (void)ADDDashLabelArrayChange
{
#warning 刷新 ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//    NSMutableDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userResponseObject"];
//    
//    _token =  [userDict valueForKey:@"user_token"];
    _Time = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADDBackTime"];
    // 刷新数据
    [self makeDate:_Time];
    
    
}
// 分享按钮
- (void)shareButtonClick: (UIButton *)sender
{
    [super ScreenShot];
}

- (void)makeDate:(NSString *)time
{
    NSMutableDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userResponseObject"];
    _token =  [userDict valueForKey:@"user_token"];
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        // 指标界面的接口
        NSString * urlStr = [NSString stringWithFormat:DashBoardHttp,_token,time];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            _DashModelArray = [NSMutableArray array];
            [_DashModelArray removeAllObjects];
            //成功
            if (responseObject != nil) {
                
                NSMutableArray * array = [NSMutableArray array];
                
                array = [responseObject[@"resdata"] mutableCopy];
                
                if (array.count != 0) {
                    
                    for (NSDictionary * dict in array) {
                        
                        DashBoardModel * m = [[DashBoardModel alloc] init];
                        
                        [m setValuesForKeysWithDictionary:dict];
                        
                        
                        [_DashModelArray addObject:m];
                    }
                    // 指标重新排序
                    [self  makeNewDashModelArray];
                    layout.DashModelArray = [_DashModelArray mutableCopy];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // 返回主线程刷新ui
                        [_collectionView reloadData];
                        
                        
                    });
                    if(_DashModelArray.count == 0){
                        
                        NSLog(@"解析出的数组为空");
                        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_collectionView.frame), CGRectGetHeight(_collectionView.frame))];
                        label.textAlignment = NSTextAlignmentCenter;
                        label.text = @"没有关注指标~";
                        [_collectionView addSubview:label];
                        
                    }
                }else{
                    NSLog(@"----没有数据");
                }
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
        }];
        
    });
    
    
}
#pragma ＝＝＝＝＝＝＝＝＝ （重新排列指标model 使1X1指标 没有空缺 ，之后一个空缺指标放到最后 ）

- (void)makeNewDashModelArray
{
    NSNumber * index = 0;
    // 1X1 指标数组
    NSMutableArray * sizeoneArray = [NSMutableArray array];
    // 1X1 指标在全部指标数组中的下标
    NSMutableArray * sizeoneindexArray = [NSMutableArray array];
    
    for (DashBoardModel * m in _DashModelArray) {
        
        if (m.size_x == 1 && m.size_y == 1) {
            
            index = [NSNumber numberWithInteger:[_DashModelArray indexOfObject:m]];
            // 把所有1X1的指标存储到数组中
            [sizeoneArray addObject:m];
            // 把所有1X1指标在全部指标中的下标存储到数组中
            [sizeoneindexArray addObject:index];
            
        }
    }
    if (sizeoneindexArray.count != 0) {
        
        for (int i = 0; i <= sizeoneindexArray.count-1;i++) {
            //1X1 指标在全部指标数组中的下标
            NSInteger xiabiao = [sizeoneindexArray[i] integerValue];
            
            DashBoardModel * modelqian = [[DashBoardModel alloc] init];
            DashBoardModel * modelhou =[[DashBoardModel alloc] init];
            
            if ( ((i+1)%2 != 0) && (i == sizeoneindexArray.count -1)) {
                
                // 删除最后一个1X1指标
                DashBoardModel * biandongModel = _DashModelArray[[sizeoneindexArray[i] integerValue]];
                
                [_DashModelArray removeObject:biandongModel];
                
                // 添加到全部指标的最后指标
                [_DashModelArray addObject:biandongModel];
                
                NSNumber * insertNumber = [NSNumber numberWithInteger:[_DashModelArray indexOfObject:_DashModelArray.lastObject]];
                
                [sizeoneindexArray  replaceObjectAtIndex:i withObject:insertNumber];
                
            }else if(i != sizeoneindexArray.count -1){
                
                if ((xiabiao == 0) && (sizeoneindexArray.count > 1)) {
                    
                    modelhou = _DashModelArray[xiabiao + 1];
                    
                }else{
                    
                    modelqian = _DashModelArray[xiabiao - 1];
                    modelhou = _DashModelArray[xiabiao + 1];
                }
                
                if (TiaojianOne | TiaojianTwo | TiaojianThree){
                    // 删除指标
                    DashBoardModel * changeModel = _DashModelArray[[sizeoneindexArray[i+1] integerValue]];
                    
                    [_DashModelArray removeObject:changeModel];
                    // 插入指标
                    [_DashModelArray insertObject:changeModel atIndex:xiabiao+1];
                    
                    NSNumber * insertNumber = [NSNumber numberWithInteger:(xiabiao + 1)];
                    
                    [sizeoneindexArray  replaceObjectAtIndex:i+1 withObject:insertNumber];
                    
                }else{
                    
                    //                    NSLog(@"什么都不做");
                }
                
            }
            
        }
    }else{
        
        NSLog(@"被选中的指标没有一程一大小的指标");
    }
    
}
#pragma collectionView代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _DashModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell"];
    
    DashBoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DashBoardModel * m = [[DashBoardModel alloc] init];
    m = _DashModelArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithString:m.bgcolor];
    [cell setTextColor:[UIColor colorWithString:m.color]];
    
    cell.labelTitle.text = m.title;
    
    [cell.label removeFromSuperview];
    [cell.labelBottomval removeFromSuperview];
    [cell.labelBottomtilte removeFromSuperview];
    [cell.labelunit removeFromSuperview];
    [cell.labelMidval removeFromSuperview];
    [_cellDeleteButton removeFromSuperview];
    
    if ([m.chart_type isEqualToString:@"line_chart"]|[m.chart_type isEqualToString:@"bar_chart"]|[m.chart_type isEqualToString:@"pie_chart"]) {
        NSMutableArray * XValueArray = [NSMutableArray arrayWithArray:[m.data valueForKey:@"x"]];
        NSMutableArray * YValueArray = [NSMutableArray arrayWithArray:[m.data valueForKey:@"y"]];
        if ((XValueArray.count == 0) && (YValueArray.count == 0)) {
            
            [XValueArray addObject:@""];
            [YValueArray addObject:@""];
            
        }else if ((XValueArray.count == 0) && (YValueArray.count != 0)){
            [XValueArray addObject:@""];
            
        }else if ((XValueArray.count != 0) && (YValueArray.count == 0)){
            [YValueArray addObject:@""];
            
        }
        
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(10, 20,Main_Screen_Width-50,CGRectGetHeight(cell.frame)-60)];
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lineChart.frame), CGRectGetMinY(_lineChart.frame), CGRectGetWidth(_lineChart.frame), CGRectGetHeight(_lineChart.frame))];
        
        [cell.contentView addSubview:cell.midvalView];
        cell.midvalView.userInteractionEnabled = NO;
        if (cell.midvalView.subviews.count !=0) {
            [cell.midvalView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        if ([m.chart_type isEqualToString:@"line_chart"]) {
            
            [self makeLine];
            
            _lineChart.yUnit = m.unit;
            _lineChart.yUnitColor = [UIColor whiteColor];
            [_lineChart setXLabels:XValueArray];
            _lineChart.showYGridLines = YES;
            _lineChart.displayAnimated = NO;
            
            _lineChart.yGridLinesColor = [UIColor whiteColor];
            PNLineChartData * data01 = [PNLineChartData new];
            data01.color = [UIColor whiteColor];
            data01.itemCount = self.lineChart.xLabels.count;
            data01.inflexionPointWidth = 4;
            data01.lineWidth = 1.5f;
            data01.inflexionPointStyle = PNLineChartPointStyleCircle;
            data01.getData = ^(NSUInteger index){
                
                CGFloat yValue = [YValueArray[index] floatValue];
                
                return [PNLineChartDataItem dataItemWithY:yValue andRawY:yValue];
                
            };
            self.lineChart.chartData = @[data01];
            [_lineChart strokeChart];
            [cell.midvalView addSubview:_lineChart];
            
            
            
        }else if([m.chart_type isEqualToString:@"bar_chart"]){
            [self makeBar];
            
//            _barChart.yLabelSuffix = m.unit;
            
            static NSNumberFormatter *barChartFormatter;
            if (!barChartFormatter){
                barChartFormatter = [[NSNumberFormatter alloc] init];
                // 数值类型
                barChartFormatter.numberStyle = kCFNumberFormatterNoStyle;
                barChartFormatter.allowsFloats = NO;
                barChartFormatter.maximumFractionDigits = 0;
            }
            self.barChart.yLabelFormatter = ^(CGFloat yValue){
                
                return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
                
            };
            //                 _barChart.yUnit = m.unit;
            [_barChart setXLabels:XValueArray];
            [_barChart setYValues:YValueArray];
            _barChart.showYGridLines = YES;
            _barChart.yGridLinesColor = [UIColor whiteColor];
            _barChart.isGradientShow = YES;
            _barChart.isShowNumbers = NO;
            _barChart.showLevelLine = NO;
            _barChart.displayAnimated = NO;
            [_barChart strokeChart];
            [cell.midvalView addSubview:_barChart];
            
            UILabel * yunitLabel = [[UILabel alloc] init];
            yunitLabel.text = m.unit;
            yunitLabel.textColor = [UIColor colorWithString:m.color];
            yunitLabel.font = [UIFont systemFontOfSize:12.0f];
            CGRect yUnitLabelRect = [yunitLabel.text boundingRectWithSize:CGSizeMake(Main_Screen_Width-80*KWidth6scale, KViewHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:yunitLabel.font} context:nil];
            yunitLabel.frame = CGRectMake(CGRectGetMinX(_barChart.frame)+ _barChart.chartMarginLeft, CGRectGetMinY(_barChart.frame)-yUnitLabelRect.size.height, yUnitLabelRect.size.width, yUnitLabelRect.size.height);
            [cell.midvalView addSubview:yunitLabel];
            
            
        }else if([m.chart_type isEqualToString:@"pie_chart"]){
            
            NSMutableArray *items  = [NSMutableArray array];
            
            int i = 0;
            for (NSString * value in YValueArray) {
                PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:_pieColorArray[i] description:XValueArray[i]];
                [items addObject:item];
                i++;
            }
            
            _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(CGRectGetMidX(_lineChart.frame)- 150, CGRectGetMinY(_lineChart.frame), CGRectGetHeight(_lineChart.frame), CGRectGetHeight(_lineChart.frame)) items:items];
            _pieChart.descriptionTextColor = [UIColor whiteColor];
            _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
            _pieChart.descriptionTextShadowColor = [UIColor clearColor];
            _pieChart.showAbsoluteValues = NO;
            _pieChart.showOnlyValues = YES;
            _pieChart.displayAnimated = NO;
            [_pieChart strokeChart];
            _pieChart.legendStyle = PNLegendItemStyleStacked;
            _pieChart.legendFont = [UIFont systemFontOfSize:12.0f];
            _pieChart.legendFontColor = [UIColor whiteColor];
            
            
            UIView *legend = [self.pieChart getLegendWithMaxWidth:100];
            
            [legend setFrame:CGRectMake(CGRectGetMaxX(_pieChart.frame)+20, CGRectGetMidY(_pieChart.frame)- 80, legend.frame.size.width, legend.frame.size.height)];
            
            [cell.midvalView addSubview:legend];
            
            [cell.midvalView addSubview:self.pieChart];
            
        }
    }else{
        [cell.midvalView removeFromSuperview];
        [cell.contentView addSubview:cell.labelBottomval];
        [cell.contentView addSubview:cell.labelBottomtilte];
        [cell.contentView addSubview:cell.labelMidval];
        [cell.contentView addSubview:cell.labelunit];
        [cell.contentView addSubview:cell.label];
        cell.labelMidval.text = m.defaultval;
        cell.labelunit.text = m.unit;
        cell.labelBottomval.text = m.contrastval;
        cell.labelBottomtilte.text = m.contrastname;
    }
    
    
    _cellDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cellDeleteButton.tag = indexPath.row;
    
    return cell;
    
}
// 选中cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_cellDeleteButton removeFromSuperview];
    Btnstatu = YES;
    
    _dashModel = [[DashBoardModel alloc] init];
    
    _dashModel = _DashModelArray[indexPath.row];
    
    SDIncomeViewController * incomeVC = [[SDIncomeViewController alloc] init];
    
    
    incomeVC.IncomeDateString  = _dataView.dateLabel.text;
    
    incomeVC.IncomeDefaultDateString = _dataSearchView.defaultDateString;
    
    incomeVC.IndexID = _dashModel.Did;
    incomeVC.pieColorArray = _pieColorArray;
    incomeVC.Time = _Time;
    
    
    // tabbar的显示和隐藏
    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:incomeVC animated:YES];
    
    self.hidesBottomBarWhenPushed=NO;
    
    
    
    //    incomeVC.IncomeDateBlockValue = ^(NSString * IncomeDateString,NSString *DefaultDateString){
    //        // 传日期
    //        _DataString = IncomeDateString;
    //
    //        _dataSearchView.defaultDateString = DefaultDateString;
    //
    //        _dataView.dateLabel.text = _DataString;
    //
    //    };
    
}

// 折线图
- (void)makeLine
{
    _lineChart.userInteractionEnabled = YES;
    _lineChart.backgroundColor = [UIColor clearColor];
    _lineChart.legendStyle =  PNLegendItemStyleSerial;
    _lineChart.delegate = self;
    _lineChart.showCoordinateAxis = YES;
    _lineChart.showGenYLabels = YES;
    _lineChart.showLabel = YES;
    _lineChart.axisWidth = 2;
    _lineChart.yLabelFont = [UIFont boldSystemFontOfSize:14.0f];
    _lineChart.xLabelFont = [UIFont boldSystemFontOfSize:12.0f];

    _lineChart.axisColor = [UIColor whiteColor];
    self.lineChart.yLabelColor =[UIColor whiteColor];
    self.lineChart.xLabelColor = [UIColor whiteColor];
    
    // 小数点
    //    _lineChart.thousandsSeparator = YES;
    
}
// 柱状图
- (void)makeBar
{
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.yChartLabelWidth = 35.0;
    _barChart.chartBorderColor = [UIColor whiteColor];
    _barChart.strokeColor = [UIColor whiteColor];
    _barChart.chartMarginLeft = 40.0;
    _barChart.chartMarginRight = 10.0;
    _barChart.chartMarginTop = 5.0;
    _barChart.chartMarginBottom = 10.0;
    _barChart.barBackgroundColor = [UIColor clearColor];
    _barChart.labelTextColor = [UIColor whiteColor];
    _barChart.labelFont = [UIFont boldSystemFontOfSize:11.0f];
    _barChart.labelMarginTop = 5.0;
    _barChart.showChartBorder = YES;
    _barChart.delegate = self;
    
}


#warning collectionView头部视图 如果是系统的layout就会走此方法，但是如果是自定义的layout就不走此方法   问题没有解决

- (void)moreButtonClick:(UIButton *)button
{
    if (button.selected == NO) {
        button.selected = YES;
        // 指标model清空
        [_DashModelArray removeAllObjects];
        
        // 提示label
        [label removeFromSuperview];
        
        Btnstatu = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:_Time forKey:@"ADDBackTime"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:addVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;

        
    }else{
        
    }
    
}


- (void)makeIncomeDate:(NSString *)Time
{
    SDIncomeViewController * incomeVC = [[SDIncomeViewController alloc] init];
    // 指标详情界面的接口
    NSString * urlStr = [NSString stringWithFormat:IncomeHttp,_dashModel.Did,Time];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
//        NSLog(@"--%@",responseObject);
        
        if (responseObject != nil) {
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict = responseObject[@"resdata"];
            
            if (dict != nil) {
                
                // 防止是参数不是数组
                //                id poi = dict[@"contrastVal"];
                //
                //                if ([poi isKindOfClass:[NSDictionary class]]) {
                IncomeDashModel * model = [[IncomeDashModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                incomeVC.IncomeDateString  = _dataView.dateLabel.text;
                
                incomeVC.IncomeDefaultDateString = _dataSearchView.defaultDateString;
                
                incomeVC.IndexID = _dashModel.Did;
                
                incomeVC.incomeDashModel = model;
                
                incomeVC.pieColorArray = _pieColorArray;
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                // tabbar的显示和隐藏
                self.hidesBottomBarWhenPushed=YES;
                
                [self.navigationController pushViewController:incomeVC animated:YES];
                
                self.hidesBottomBarWhenPushed=NO;
                
                //                    });
            }
            
        }else{
            
            NSLog(@"数据为空");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            // tabbar的显示和隐藏
            self.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:incomeVC animated:YES];
            
            self.hidesBottomBarWhenPushed=NO;
            
            
        });
        
    }];
    
    //
}

//长按事件的手势监听实现方法
- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        
        if (indexPath == nil) {
            NSLog(@"空");
        }else{
            
            UICollectionViewCell * cell = [_collectionView cellForItemAtIndexPath:indexPath];
            
            NSLog(@"Section = %ld,Row = %ld",(long)indexPath.section,(long)indexPath.row);
            _cellIndexPath = indexPath;
            _cellDeleteButton.tag = indexPath.row;
            _cellDeleteButton.frame = CGRectMake(CGRectGetMaxX(cell.contentView.frame)-40, 0, 40, 40);
            [_cellDeleteButton setImage:[UIImage imageNamed:@"cellDelete.png"] forState:UIControlStateNormal];
            
            [cell addSubview:_cellDeleteButton];
            [_cellDeleteButton addTarget:self action:@selector(cellDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
}
- (void)cellDeleteButtonClick:(UIButton *)button
{
    
    if (button.selected) {
        
        
        
    }else{
        
        button.selected = YES;
        
        DashBoardModel * model = [[DashBoardModel alloc] init];
        
        model = _DashModelArray[button.tag];
        NSString * urlStr = [NSString stringWithFormat:DeleteIndexHttp,model.Did];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [_DashModelArray removeObject:model];
            [layout.DashModelArray removeObject:model];
            //指标重新排序
            [self makeNewDashModelArray];
            // 添加界面的数据
            [self makeADDDate];
            [UIView animateWithDuration:0.3 // 动画时长
                             animations:^{
                                 
                                 // 返回主线程刷新ui
                                 button.superview.frame = CGRectMake(button.superview.center.x, button.superview.center.y, 0, 0);
                                
                                 
                                 
                             }
                             completion:^(BOOL finished) {
                                 [_collectionView removeFromSuperview];
                                 [self makeCollectionView];
                                 // 将日期选择视图放在所有视图的最上方（否则视图会被遮挡呈现半透明状态）
                                 [self.view bringSubviewToFront:_dataSearchView];
                                 // 动画完成后执行
//                                 [self makeDate:_Time];(直接刷新有bug)
                             }];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
//            [self makeDate:_Time];
        }];
        
        
    }
    
}


- (void)makeADDDate
{
    addVC = [[AddViewController alloc] init];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执⾏耗时的异步操作...
        NSString * urlStr = [NSString stringWithFormat:ADDHttp,_token];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //成功
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict = responseObject[@"resdata"];
            NSMutableArray * array = [NSMutableArray array];
            array = dict[@"checked"];
            NSMutableArray * arrayAll = [NSMutableArray array];
            arrayAll = dict[@"waitcheck"];
            NSMutableArray * arrayDashLabel = [NSMutableArray array];
            
            NSLog(@"%@",responseObject);
            
            if (dict != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (NSDictionary * dict in array) {
                        
                        AddDashModel * m = [[AddDashModel alloc] init];
                        
                        [m setValuesForKeysWithDictionary:dict];
                        
                        [arrayDashLabel addObject:m];
                    }
                    NSMutableArray * arrayAllDashLabel = [NSMutableArray array];
                    
                    for (NSDictionary * dict in arrayAll) {
                        
                        AddDashModel * m = [[AddDashModel alloc] init];
                        
                        [m setValuesForKeysWithDictionary:dict];
                        
                        [arrayAllDashLabel addObject:m];
                    }
                    
                    
                    if ( addVC.dashLabelArray.count == 0) {
                        
                        addVC.dashLabelArray = arrayDashLabel;
                        
                        addVC.dashAllArray = arrayAllDashLabel;
                        
                        
                    }
                });
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            
        }];
        
        
        
    });
    
    
}

// 图表代理方法PNChartDelegate
- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    
    NSLog(@"----Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
    
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    
    //    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(point.x,0, 1, 200)];
    //    label.backgroundColor = [UIColor grayColor];
    //    [_lineChart addSubview:label];
    
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}





#pragma ====下拉刷新

- (void)addRefreshView{
    
    __weak __typeof(self)weakSelf = self;
    
    
    //下拉刷新
    _headerView = [_collectionView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        
        [weakSelf refreshAction];
    }];
    
    //上拉加载更多
    //    footerView = [_allActionTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
    //        [weakSelf loadMoreAction];
    //    }];
    
    
}



- (void)refreshAction {
    
    __weak UICollectionView *weakTableView;
    weakTableView  = _collectionView;
    
    __weak FCXRefreshHeaderView *weakHeaderView = _headerView;
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self makeDate:_Time];
        
        [weakHeaderView endRefresh];
        
        
    });
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
