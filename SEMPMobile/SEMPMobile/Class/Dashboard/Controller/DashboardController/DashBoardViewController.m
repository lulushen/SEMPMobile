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




#define PNArc4randomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
// 判断1X1的前后都不是1X1的情况
#define TiaojianOne  ((!(modelqian.size_x == 1 && modelqian.size_y == 1)) && (!(modelhou.size_x == 1 && modelhou.size_y == 1)))
// 判断1X1前面是1X1 后面不是1X1 并且前面的1X1数量的不是偶数的情况
#define TiaojianTwo ((modelqian.size_x == 1 && modelqian.size_y == 1)&&(!(modelhou.size_x == 1 && modelhou.size_y == 1)) && ((i + 1) % 2 != 0))
// 判断第一个指标是1x1 后面不是1X1的情况
#define TiaojianThree ((xiabiao == 0)&& !(modelhou.size_x == 1 && modelhou.size_y == 1))

@interface DashBoardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PNChartDelegate>

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

@end

@implementation DashBoardViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _topView.moreButton.selected = NO;
    //显示tabbar
    [self showTabBar];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    // 获得持久化的用户model
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    
    userModel * model = [[userModel alloc] init];
    // 用户model反归档
    model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableDictionary * dict = model.resdata;
    
    _Time = [NSString stringWithFormat:@"%@",dict[@"defaulttime"]];
        
   _topView = [[DashCollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30*KHeight6scale)];
    
    
    [_topView.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_topView];

    // 解析dashBoardHttp数据
    [self makeDate:_Time];
    // 添加观察者 观察日期变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DateChange) name:@"DateChange" object:nil];
    // 添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ADDDashLabelArrayChange) name:@"ADDDashLabelArrayChange" object:nil];
    
    [self  makeNavigation];

    // Do any additional setup after loading the view.
}

- (void)makeCollectionView
{
    [self.collectionView removeFromSuperview];
    
    DashCollectionViewFlowLayout * layout = [[DashCollectionViewFlowLayout alloc] init];
    
    layout.DashModelArray = [NSMutableArray array];
    
    layout.DashModelArray = [_DashModelArray mutableCopy];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), Main_Screen_Width, KViewHeight-CGRectGetHeight(_topView.frame)) collectionViewLayout:layout];
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_collectionView];
    
    _collectionView.dataSource = self;
    
    _collectionView.delegate = self;
    
    for (int i = 0; i < _DashModelArray.count; i++) {
        
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d",i];
        
        [_collectionView registerClass:[DashBoardCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    
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
    // 进入日期选择视图，确定日期选择期默认的日期
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    // 日期选择视图上的关闭按钮
    [_dataSearchView.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // navigation上的分享按钮
    UIImage * shareImage = [UIImage imageNamed:@"share.png"];
    
    CGRect shareframe = CGRectMake(0, 0, 20*KWidth6scale, 25*KHeight6scale);
    
    _shareButton = [[UIButton alloc] initWithFrame:shareframe];
    
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
        
        // 移除视图
        [_dataSearchView removeFromSuperview];
        
        Btnstatu = YES;
        
    }else{
        //添加视图
        [self.view addSubview:_dataSearchView];
        // 点击日期按钮时 相当于默认点击日期选择视图中的月按钮
        [_dataSearchView mouthButtonClick:_dataSearchView.mouthButton];
        
        Btnstatu = NO;
    }
}
// 日期视图中的关闭事件
- (void)deleteButtonClick:(UIButton *)button
{
    
    [_dataSearchView removeFromSuperview];
    
    Btnstatu = YES;
    
}
// 被观察者发生改变时 调用观察者方法
- (void)DateChange
{
    [_dataSearchView removeFromSuperview];

    
    NSString * date = [[NSUserDefaults standardUserDefaults] objectForKey:@"DateChange"];

    NSLog(@"--------zhibiaojiemiandeshijian  -----%@",date);

    _dataView.dateLabel.text = date;
    
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    
    _Time = [_dataSearchView.defaultDateString stringByReplacingOccurrencesOfString:@"年" withString:@""];
    
    _Time = [_Time stringByReplacingOccurrencesOfString:@"月" withString:@""];
    
    _Time = [_Time stringByReplacingOccurrencesOfString:@"日" withString:@""];

#warning 刷新 ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

    // 刷新数据
    [self makeDate:_Time];
    

    
}

// 观察者方法
- (void)ADDDashLabelArrayChange
{
#warning 刷新 ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    // 刷新数据
    [self makeDate:_Time];
    
    
}
// 分享按钮
- (void)shareButtonClick: (UIButton *)sender
{
    
    NSLog(@"分享按钮");
}

- (void)makeDate:(NSString *)time
{
    _DashModelArray = [NSMutableArray array];

    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        // 获得持久化的用户model
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
        
        _userModel = [[userModel alloc] init];
        // 用户model反归档
        _userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        // 转化成字符串
        _token = [NSString stringWithFormat:@"%@",_userModel.user_token];
        NSLog(@"-----%@",time);
        
        // 指标界面的接口
        NSString * urlStr = [NSString stringWithFormat:DashBoardHttp,_token,time];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"-----%@",responseObject);
            //成功
            if (responseObject != nil) {
                
                NSMutableArray * array = [NSMutableArray array];
                
                array = responseObject[@"resdata"];
                
                // 如果array不为空
                if (array.count != 0) {
                    
                    for (NSDictionary * dict in array) {
                        
                        DashBoardModel * m = [[DashBoardModel alloc] init];
                        
                        [m setValuesForKeysWithDictionary:dict];
                        
                        
                        [_DashModelArray addObject:m];
                    }

                    // 指标重新排序
                    [self  makeNewDashModelArray];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 回到主线程,执⾏UI刷新操作
                        [self makeCollectionView];
                        
                    });
                }else{
                    
                    NSLog(@"解析出的数组为空");
                    
                    [self makeCollectionView];
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
                    label.text = @"没有关注指标or网略连接错误～";
                    [_collectionView addSubview:label];
                    
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
                    DashBoardModel * biandongModel = _DashModelArray[[sizeoneindexArray[i+1] integerValue]];
                    
                    [_DashModelArray removeObject:biandongModel];
                    // 插入指标
                    [_DashModelArray insertObject:biandongModel atIndex:xiabiao+1];
                    
                    NSNumber * insertNumber = [NSNumber numberWithInteger:(xiabiao + 1)];
                    
                    [sizeoneindexArray  replaceObjectAtIndex:i+1 withObject:insertNumber];
                    
                }else{
                    
                    NSLog(@"什么都不做");
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

- (DashBoardCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    DashBoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    //    if (!cell) {
    
    DashBoardModel * m = [[DashBoardModel alloc] init];
    
    for (int i = 0;i < _DashModelArray.count ; i++) {
        
        m = _DashModelArray[indexPath.row];
        
        cell.backgroundColor = [UIColor colorWithString:m.bgcolor];
        [cell.labelTitle setTextColor:[UIColor colorWithString:m.color]];
        [cell.labelMidval setTextColor:[UIColor colorWithString:m.color]];
        [cell.labelBottomval setTextColor:[UIColor colorWithString:m.color]];
        [cell.labelBottomtilte setTextColor:[UIColor colorWithString:m.color]];
        [cell.labelunit setTextColor:[UIColor colorWithString:m.color]];
        cell.labelTitle.text = m.title;
        
        NSMutableArray * XValueArray = [NSMutableArray arrayWithArray:[m.data valueForKey:@"x"]];
        NSMutableArray * YValueArray = [NSMutableArray arrayWithArray:[m.data valueForKey:@"y"]];
        
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 10,Main_Screen_Width-40,CGRectGetHeight(cell.frame)-50)];
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lineChart.frame), CGRectGetMinY(_lineChart.frame), CGRectGetWidth(_lineChart.frame), CGRectGetHeight(_lineChart.frame))];
        
        
        
        if ([m.chart_type isEqualToString:@"line_chart"]) {
            
            _lineChart.backgroundColor = [UIColor redColor];
            [self makeLine];
            _lineChart.yUnit = m.unit;
            [_lineChart setXLabels:XValueArray];
            PNLineChartData * data01 = [PNLineChartData new];
            data01.color = [UIColor whiteColor];
            data01.itemCount = self.lineChart.xLabels.count;
            data01.inflexionPointWidth = 4;
            data01.inflexionPointStyle = PNLineChartPointStyleCircle;
            data01.getData = ^(NSUInteger index){
                
                CGFloat yValue = [YValueArray[index] floatValue];
                
                return [PNLineChartDataItem dataItemWithY:yValue andRawY:yValue];
                
            };
            self.lineChart.chartData = @[data01];
            [_lineChart strokeChart];
            [cell.labelMidval addSubview:_lineChart];
            
        }else if([m.chart_type isEqualToString:@"bar_chart"]){
            
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
            [self makeBar];
            [_barChart setXLabels:XValueArray];
            [_barChart setYValues:YValueArray];
            _barChart.isGradientShow = NO;
            _barChart.isShowNumbers = NO;
            [_barChart strokeChart];
            [cell.labelMidval addSubview:_barChart];
            
            
        }else if([m.chart_type isEqualToString:@"pie_chart"]){
            
            NSMutableArray *items  = [NSMutableArray array];
            
            int i = 0;
            
            for (NSString * value in YValueArray) {
                
                PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:PNArc4randomColor description:XValueArray[i]];
                [items addObject:item];
                i++;
            }
            
            _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(CGRectGetMidX(_lineChart.frame)- 150, CGRectGetMinY(_lineChart.frame), CGRectGetHeight(_lineChart.frame), CGRectGetHeight(_lineChart.frame)) items:items];
            _pieChart.descriptionTextColor = [UIColor whiteColor];
            _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
            _pieChart.descriptionTextShadowColor = [UIColor clearColor];
            _pieChart.showAbsoluteValues = NO;
            _pieChart.showOnlyValues = YES;
            [_pieChart strokeChart];
            _pieChart.legendStyle = PNLegendItemStyleStacked;
            _pieChart.legendFont = [UIFont systemFontOfSize:12.0f];
            _pieChart.legendFontColor = [UIColor whiteColor];
            
            
            UIView *legend = [self.pieChart getLegendWithMaxWidth:100];
            
            [legend setFrame:CGRectMake(CGRectGetMaxX(_pieChart.frame)+20, CGRectGetMidY(_pieChart.frame)- 80, legend.frame.size.width, legend.frame.size.height)];
            
            [cell.labelMidval addSubview:legend];
            
            [cell.labelMidval addSubview:self.pieChart];
            
        }else if([m.chart_type isEqualToString:@"text"]){
            
            cell.labelMidval.text = m.midval;
            cell.labelunit.text = m.unit;
            cell.labelBottomval.text = m.bottomval;
            cell.labelBottomtilte.text = m.bottomtitle;
            [cell addSubview:cell.labelBottomtilte];
            [cell addSubview:cell.labelBottomval];
            [cell addSubview:cell.label];
            [cell addSubview:cell.labelunit];
            
        }else if([m.chart_type isEqualToString:@"long_text"]){
            
            cell.labelMidval.text = m.midval;
            cell.labelunit.text = m.unit;
            cell.labelBottomval.text = m.bottomval;
            cell.labelBottomtilte.text = m.bottomtitle;
            [cell addSubview:cell.labelBottomtilte];
            [cell addSubview:cell.labelBottomval];
            [cell addSubview:cell.label];
            [cell addSubview:cell.labelunit];
            
            
        }
        
    }
    
    _cellDeleteButton = [[UIButton alloc] init];
    _cellDeleteButton.tag = indexPath.row;
    
    
    return cell;
}
// 选中cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataSearchView removeFromSuperview];
    
    Btnstatu = YES;
    
    _dashModel = [[DashBoardModel alloc] init];
    
    _dashModel = _DashModelArray[indexPath.row];

    [self makeIncomeDate];
    
    
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
    
    
    self.lineChart.yLabelColor =[UIColor whiteColor];
    self.lineChart.xLabelColor = [UIColor whiteColor];
    
    // 小数点
//    _lineChart.thousandsSeparator = YES;
    
}
// 柱状图
- (void)makeBar
{
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.yChartLabelWidth = 20.0;
    _barChart.chartBorderColor = [UIColor whiteColor];
    _barChart.strokeColor = [UIColor whiteColor];
    _barChart.chartMarginLeft = 30.0;
    _barChart.chartMarginRight = 10.0;
    _barChart.chartMarginTop = 5.0;
    _barChart.chartMarginBottom = 10.0;
    _barChart.barBackgroundColor = [UIColor clearColor];
    _barChart.labelTextColor = [UIColor whiteColor];
    _barChart.labelFont = [UIFont systemFontOfSize:12];
    _barChart.labelMarginTop = 5.0;
    _barChart.showChartBorder = YES;
    _barChart.delegate = self;
    
}


#warning collectionView头部视图 如果是系统的layout就会走此方法，但是如果是自定义的layout就不走此方法   问题没有解决

- (void)moreButtonClick:(UIButton *)button
{
    if (button.selected == NO) {
        button.selected = YES;
        // 添加界面的数据
        [self makeADDDate];

    }else{
        
    }
    
}


- (void)makeIncomeDate
{
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        // 转化成字符串
        _token = [NSString stringWithFormat:@"%@",_userModel.user_token];
        
        
        NSMutableDictionary * dict = _userModel.resdata;
        // 进入指标界面的默认时间
        NSString * time = [NSString stringWithFormat:@"%@",dict[@"defaulttime"]];
        
        _Time = time ;
        // 指标界面的接口
        NSString * urlStr = [NSString stringWithFormat:IncomeHttp,_dashModel.Did,_Time];
        
        NSLog(@"url       ----   %@",urlStr);
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //成功
            NSLog(@"responseObjectresponseObjectresponseObject--%@",responseObject);
            if (responseObject != nil) {
                
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                 dict = responseObject;
                // 防止是参数不是数组
//                id poi = dict[@"contrastVal"];
//                
//                if ([poi isKindOfClass:[NSDictionary class]]) {
                    IncomeDashModel * model = [[IncomeDashModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dict];
                    
                    
                    SDIncomeViewController * incomeVC = [[SDIncomeViewController alloc] init];
                    
                    incomeVC.IncomeDateString  = _dataView.dateLabel.text;
                    
                    incomeVC.IncomeDefaultDateString = _dataSearchView.defaultDateString;
                    
                    
                    incomeVC.incomeDashModel = model;
                    
                    self.hidesBottomBarWhenPushed=YES;
                    
                    [self.navigationController pushViewController:incomeVC animated:YES];
                    
                    self.hidesBottomBarWhenPushed=NO;

                    NSLog(@"---------modelmodelmodel----%@",model.midval);
                    NSLog(@"---------modelmodelmodel----%@",model.bottomunit);
                    NSLog(@"---------modelmodelmodel----%@",model.bottomval);
                    NSLog(@"---------modelmodelmodel----%@",model.threshold_flag);
                    NSLog(@"---------modelmodelmodel----%@",model.unit);
                    NSLog(@"---------modelmodelmodel----%@",model.color);
                    NSLog(@"---------modelmodelmodel----%@",model.contrastVal);
                    NSLog(@"---------modelmodelmodel----%@",model.defaultVal);
                    


//                }else {
//                    NSLog(@"its a other class");
//                }
                
            
             
            }else{
                
                NSLog(@"数据为空");
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
        }];
        
    });
    
}

//长按事件的手势监听实现方法
- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"UIGestureRecognizerStateBegan");
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
    
    [_DashModelArray removeObjectAtIndex:_cellIndexPath.row];
    
    
    NSString * indexCheckedString = [NSString string];
    
    if (_DashModelArray.count > 0) {
        
        for (int i = 0; i < _DashModelArray.count;i++) {
            
            DashBoardModel * model = [[DashBoardModel alloc] init];
            
            model = _DashModelArray[i];
            
            if (i > 0) {
                NSString * string = [NSString stringWithFormat:@",%@",model.Did];
                
                indexCheckedString = [indexCheckedString  stringByAppendingString:string];
                
            }else{
                
                indexCheckedString = [NSString stringWithFormat:@"%@",model.Did];
                
            }
        }
        
    }else{
        
        indexCheckedString = [NSString stringWithFormat:@""];
    }
    
    NSString * urlStr = [NSString stringWithFormat:indexCheckedHttp,_token,indexCheckedString];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //这里可以用来显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //指标重新排序
        [self makeNewDashModelArray];
        //加载collectionView
        [self makeCollectionView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        NSLog(@"failure  error ： %@",error);
    }];
    
    
    
}


- (void)makeADDDate
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执⾏耗时的异步操作...
        NSString * urlStr = [NSString stringWithFormat:ADDHttp,_token];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"[-----------responseObject---%@",responseObject);
            //成功
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict = responseObject[@"resdata"];
            NSMutableArray * array = [NSMutableArray array];
            array = dict[@"checked"];
            NSMutableArray * arrayAll = [NSMutableArray array];
            arrayAll = dict[@"waitcheck"];
            NSMutableArray * arrayDashLabel = [NSMutableArray array];
            
            if (dict != nil) {
                
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
                
                AddViewController * addVC = [[AddViewController alloc] init];
                
                if ( addVC.dashLabelArray.count == 0) {
                    
                    addVC.dashLabelArray = arrayDashLabel;
                    
                    addVC.dashAllArray = arrayAllDashLabel;
                    
                    // 指标model清空
                    [_DashModelArray removeAllObjects];
                    
                    // 移除日期视图
                    [_dataSearchView removeFromSuperview];
                    
                    Btnstatu = YES;
                    
                    
                    [self.navigationController pushViewController:addVC animated:YES];

                }
            }
          

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
        }];
        
        
        
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
