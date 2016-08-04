//
//  DashBoardViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "DashBoardViewController.h"
#import "SDIncomeViewController.h"
#import "AddViewController.h"
#import "DashTopView.h"
#import "DashBoardModel.h"
#import "DashView.h"
#import "UIColor+NSString.h"
#import "DataView.h"
#import "DataSearchView.h"

#import "PNChart.h"
#define PNArc4randomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
@interface DashBoardViewController ()<PNChartDelegate>
// 分享按钮
@property (nonatomic , strong) UIButton * shareButton;
//nav上的日期视图
@property (nonatomic ,strong) DataView * dataView;
//日期选择视图
@property (nonatomic ,strong) DataSearchView * dataSearchView;

@property (nonatomic , strong) NSString * DataString;

@property (nonatomic , strong) DashTopView * dashTopView;
//折线图
@property (nonatomic , strong)PNLineChart * lineChart;
//柱形图
@property (nonatomic , strong)PNBarChart * barChart;
//扇形图
@property (nonatomic) PNPieChart *pieChart;

@end

@implementation DashBoardViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示tabbar
    [self showTabBar];
    [self makeScrollView];
    
    _viewDashArray = [NSMutableArray array];
    
    _DashArray = [NSMutableArray array];
    
    _DashModelArray = [NSMutableArray array];
    
    // 添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ADDDashLabelArrayChange) name:@"ADDDashLabelArrayChange" object:nil];
    // 添加观察者 观察日期变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DateChange) name:@"DateChange" object:nil];
   
    [self  makeDate];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeNavigation];
    
  
    // Do any additional setup after loading the view.
}
- (void)makeNavigation
{
    _dataView = [[DataView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width*2/5, 44)];

    _DataString = [NSString stringWithFormat:@"%@",@"2016年7月"];
    _dataView.dateLabel.text  = _DataString;
    // dataView视图 相当于navigationItem.titleView
    self.navigationItem.titleView  = _dataView;

    [_dataView.dateButton addTarget:self action:@selector(dataClick:) forControlEvents:UIControlEventTouchUpInside];
    _dataSearchView = [[DataSearchView alloc] initWithFrame:CGRectMake(50, 10, Main_Screen_Width-100, Main_Screen_Width-100)];
    
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    
    [_dataSearchView.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // navigation上的分享按钮
    UIImage * shareImage = [UIImage imageNamed:@"share.png"];
    CGRect shareframe = CGRectMake(0, 0, 30*KWidth6scale, 30*KHeight6scale);
    _shareButton = [[UIButton alloc] initWithFrame:shareframe];
    [_shareButton setImage:shareImage forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

   
}
// 被观察者发生改变时 调用观察者方法
- (void)DateChange
{
    
    _dataView.dateLabel.text = _dataSearchView.dateString;
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;

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
// 观察者方法
- (void)ADDDashLabelArrayChange
{
    NSMutableArray * arrayDash = [NSMutableArray array];
    arrayDash = [[NSUserDefaults standardUserDefaults] objectForKey:@"DashLabelArray"];
    
    for (NSData * data in arrayDash) {
        // 反归档
        DashBoardModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [_DashModelArray addObject:model];
        
    }
}

- (void)makeScrollView
{
    
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight)];
    
    self.scrollview.backgroundColor = [UIColor whiteColor];
    
    self.scrollview.showsHorizontalScrollIndicator = NO;
    
    self.scrollview.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.scrollview];
    
    _dashTopView = [[DashTopView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40*KHeight6scale)];

    [self.scrollview addSubview:_dashTopView];
    
    [_dashTopView.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)moreButtonClick:(UIButton *)button
{
    
    for (DashView * view in self.scrollview.subviews) {
    
        [view removeFromSuperview];
        
    }
    
    [_viewDashArray removeAllObjects];
    [_DashArray removeAllObjects];
    
    [_dataSearchView removeFromSuperview];
    Btnstatu = YES;
    AddViewController * addVC = [[AddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}
- (void)makeDate
{
    
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"date" ofType:@"txt"];

    NSData * data = [NSData dataWithContentsOfFile:filePath];

    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray * arrayDashLabel = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        
        DashBoardModel * m = [[DashBoardModel alloc] init];
        
        [m setValuesForKeysWithDictionary:dict];
        
        [arrayDashLabel addObject:m];
    }
    NSMutableArray * arrayDash = [NSMutableArray array];
    arrayDash = [[NSUserDefaults standardUserDefaults] objectForKey:@"DashLabelArray"];
    
    for (NSData * data in arrayDash) {
        // 反归档
        DashBoardModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [_DashModelArray addObject:model];
        
    }
    
    if ( _DashModelArray.count == 0) {
        
        _DashModelArray = arrayDashLabel;
    }

    [self makeDashView];
   
}

// Dashview布局
- (void)makeDashView
{
    DashView * tempviewi = [[DashView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    DashView * tempviewj = [[DashView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    for (int i = 0; i < _DashModelArray.count; i++) {
        
        _viewDash = [[DashView alloc] init];
        
        int bianju = 10;
        
        if (i == 0) {
            _viewDash.frame = CGRectMake(0, 0, 0, 0);
            
            [_viewDashArray addObject:_viewDash];
            
        }else{
            
            tempviewi =  _viewDashArray[i];
            tempviewj =  _viewDashArray[i - 1];
            
        }
        
        CGRect  tempi = tempviewi.frame;
        
        CGRect tempj = tempviewj.frame;
        
        DashBoardModel * model = [[DashBoardModel alloc] init];
        
        DashBoardModel * modeltwo = [[DashBoardModel alloc] init];
        
        
        if (i == 0) {
            
            tempi.origin = CGPointMake(bianju, 40);
            model = _DashModelArray[i];
            if ((model.size_x == 1 )&& (model.size_y == 1) ) {
                
                tempi.size = CGSizeMake((Main_Screen_Width-30)/2.0, (Main_Screen_Width-100)/2.0);
                
            }else if((model.size_x == 2 )&& (model.size_y == 1) ){
                
                tempi.size = CGSizeMake(Main_Screen_Width-20, (Main_Screen_Width-100)/2.0);
                
            }else if((model.size_x == 2 )&& (model.size_y == 2) ){
                
                tempi.size = CGSizeMake(Main_Screen_Width-20, Main_Screen_Width-100);
                
            }
        }else{
            
            model = _DashModelArray[i];
            
            if ((model.size_x == 1 )&& (model.size_y == 1)) {
                
                tempi.size = CGSizeMake((Main_Screen_Width-30)/2.0, (Main_Screen_Width-100)/2.0);
                
                modeltwo = _DashModelArray[i-1];
                if ((modeltwo.size_x == 1 )&& (modeltwo.size_y == 1)) {
                    
                    if (tempj.origin.x > Main_Screen_Width*2/3) {
                        
                        tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju );
                        
                    }else{
                        tempi.origin = CGPointMake(bianju + CGRectGetMaxX(tempj), CGRectGetMinY(tempj));
                        
                    }
                }else{
                    
                    tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
                }
                
            }else if((model.size_x == 2 )&& (model.size_y == 1)){
                
                tempi.size = CGSizeMake(Main_Screen_Width-20, (Main_Screen_Width-100)/2.0);
                
                tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
                
            }else if((model.size_x == 2 )&& (model.size_y == 2) ){
                
                tempi.size = CGSizeMake(Main_Screen_Width-20, Main_Screen_Width-100);
                
                tempi.origin = CGPointMake(bianju, CGRectGetMaxY(tempj) + bianju);
                
                
            }
            
        }
        
        tempviewi.frame = tempi;
        _viewDash.frame = tempi;
        
        [_viewDashArray addObject:_viewDash];
        
        [_DashArray addObject:tempviewi];
        
         self.scrollview.contentSize = CGSizeMake(Main_Screen_Width, CGRectGetMaxY(tempviewi.frame));
    }
     [self makeDashViewData];
    
}

- (void)makeDashViewData
{
    
    for (int i = 0;i < _DashArray.count ; i++) {

        DashView * view = _DashArray[i];
        
        [self.scrollview addSubview:view];
        
        DashBoardModel * m = [[DashBoardModel alloc] init];
        
        m = _DashModelArray[i];
        
        view.backgroundColor = [UIColor colorWithString:m.bgcolor];
        
        [view.labelTitle setTextColor:[UIColor colorWithString:m.color]];
        [view.labelMidval setTextColor:[UIColor colorWithString:m.color]];
        [view.labelBottomval setTextColor:[UIColor colorWithString:m.color]];
        [view.labelBottomtilte setTextColor:[UIColor colorWithString:m.color]];
        [view.labelunit setTextColor:[UIColor colorWithString:m.color]];
        view.labelTitle.text = m.title;

        NSMutableArray * XValueArray = [NSMutableArray arrayWithArray:[m.data valueForKey:@"x"]];
        NSMutableArray * YValueArray = [NSMutableArray arrayWithArray:[m.data valueForKey:@"y"]];
        NSMutableArray * y = [NSMutableArray array];

        for (NSString*  intstr in YValueArray) {
            NSString *strUrl = [intstr stringByReplacingOccurrencesOfString:@"," withString:@""];
            [y addObject:strUrl];
        }
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 10,Main_Screen_Width-40,CGRectGetHeight(view.frame)-70)];
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lineChart.frame), CGRectGetMinY(_lineChart.frame), CGRectGetWidth(_lineChart.frame), CGRectGetHeight(_lineChart.frame))];
        if ([m.char_type isEqualToString:@"line"]) {
      
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
                
                CGFloat yValue = [y[index] floatValue];
                
                return [PNLineChartDataItem dataItemWithY:yValue/10000 andRawY:yValue];
                
            };
            self.lineChart.chartData = @[data01];
            [_lineChart strokeChart];
            [view.labelMidval addSubview:_lineChart];
        }else if([m.char_type isEqualToString:@"Bar"]){
            static NSNumberFormatter *barChartFormatter;
            if (!barChartFormatter){
                barChartFormatter = [[NSNumberFormatter alloc] init];
                // 数值类型
                barChartFormatter.numberStyle = kCFNumberFormatterNoStyle;
                barChartFormatter.allowsFloats = NO;
                barChartFormatter.maximumFractionDigits = 0;
            }
            self.barChart.yLabelFormatter = ^(CGFloat yValue){
                
                return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue/10000]];
                
            };
            [self makeBar];
            [_barChart setXLabels:XValueArray];
            [_barChart setYValues:y];
            _barChart.isGradientShow = NO;
            _barChart.isShowNumbers = NO;
            [_barChart strokeChart];
            [view.labelMidval addSubview:_barChart];
            
            
        }else if([m.char_type isEqualToString:@"shan"]){
            NSMutableArray *items  = [NSMutableArray array];
            int i = 0;
            for (NSString * value in y) {
                
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
            _pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
            
            UIView *legend = [self.pieChart getLegendWithMaxWidth:100];
            [legend setFrame:CGRectMake(CGRectGetMaxX(_pieChart.frame)+20, CGRectGetMidY(_pieChart.frame)- 80, legend.frame.size.width, legend.frame.size.height)];
            [view.labelMidval addSubview:legend];
            
            [view.labelMidval addSubview:self.pieChart];
//            self.changeValueButton.hidden = YES;

        }else{
            view.labelMidval.text = m.midval;
            view.labelunit.text = m.unit;
            view.labelBottomval.text = m.bottomval;
            view.labelBottomtilte.text = m.bottomtitle;
        }
     
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleTap)];
        //使用一根手指双击时，才触发点按手势识别器
        //         recognizer.numberOfTapsRequired = 2;
        recognizer.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:recognizer];
    }

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
    _lineChart.thousandsSeparator = YES;

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
// 手势方法（点击进入income视图）
- (void)handleTap
{
    
    [_dataSearchView removeFromSuperview];
    Btnstatu = YES;
    SDIncomeViewController * incomeVC = [[SDIncomeViewController alloc] init];
    incomeVC.IncomeDateString  = _dataView.dateLabel.text;
    incomeVC.IncomeDefaultDateString = _dataSearchView.defaultDateString;
    incomeVC.IncomeDateBlockValue = ^(NSString * IncomeDateString,NSString *DefaultDateString){
        _DataString = IncomeDateString;
        _dataSearchView.defaultDateString = DefaultDateString;
        _dataView.dateLabel.text = _DataString;
       
    };
    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:incomeVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}

// 分享按钮
- (void)shareButtonClick: (UIButton *)sender
{
    NSLog(@"分享按钮");
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
