//
//  ReportIncomeViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/18.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ReportIncomeViewController.h"
#import <WebKit/WebKit.h>
//#import "DataSearchView.h"
#import "DatePickerView.h"


@interface ReportIncomeViewController ()<WKNavigationDelegate,WKUIDelegate,YXCustomActionSheetDelegate>
{
    UILabel * titleLabel;
    NSString * dateString;
    NSString * dateStringFormat;
    //    DataSearchView * dataSearchView;
    DatePickerView * pickerView;
    // 参数总数组
    NSMutableArray * paramsCountArray;
    
}
@property(nonatomic , strong)  WKWebView * reportWebView;
@property (nonatomic , strong) UIView * parameterView;
@property (nonatomic , strong)  UITabBar * tabView;

@end

@implementation ReportIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeWebView];
    [self makeLeftButtonItme];
    [self maketab];
    // Do any additional setup after loading the view.
}
- (void)makeWebView
{
    
    _reportWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight)];
    _reportWebView.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:_webViewHttpString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_reportWebView loadRequest:request];
    _reportWebView.navigationDelegate = self;
    _reportWebView.UIDelegate = self;
    [self.view addSubview:_reportWebView];
    [self  makeParametersView];
    
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"开始加载");
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"内容开始返回");
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"加载完成");
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"加载失败");
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"接收到服务器跳转请求之后再执行");
    //    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@" 在收到响应后，决定是否跳转");
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"在发送请求之前，决定是否跳转");
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
- (void)makeParametersView{
    _parameterView = [[UIView alloc] initWithFrame:CGRectMake(40*KWidth6scale, 50*KWidth6scale, Main_Screen_Width-80*KWidth6scale, KViewHeight-100*KHeight6scale)];
    _parameterView.alpha = 0;
    _parameterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_parameterView];

        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*KWidth6scale, 0, 100*KWidth6scale, 50*KHeight6scale)];
        titleLabel.text = @"筛选";
        [_parameterView addSubview:titleLabel];
    
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelButton.frame = CGRectMake(CGRectGetWidth(_parameterView.frame)/2.0-25*KWidth6scale, CGRectGetHeight(_parameterView.frame)-50*KHeight6scale, 50*KWidth6scale, 50*KWidth6scale);
        [cancelButton setImage:[UIImage imageNamed:@"parameterCancel.png"] forState:UIControlStateNormal];
        [cancelButton setTintColor:[UIColor blackColor]];
        [_parameterView addSubview:cancelButton];
    
        [cancelButton addTarget:self action:@selector(cancelParaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIButton * OKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        OKButton.frame = CGRectMake(CGRectGetWidth(_parameterView.frame)-70*KWidth6scale, 10*KHeight6scale , 60*KWidth6scale, 30*KHeight6scale);
        [OKButton setTitle:@"确认" forState:UIControlStateNormal];
        [OKButton setTintColor:MoreButtonColor];
        OKButton.layer.masksToBounds = YES;
        OKButton.layer.borderWidth= 1;
        OKButton.layer.borderColor = [UIColor grayColor].CGColor;
        OKButton.layer.cornerRadius = 5;
        [_parameterView addSubview:OKButton];
    
        [OKButton addTarget:self action:@selector(OKParaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)makeParametersContentView
{
//    for (UIView * view in _parameterView.subviews) {
//        [view removeFromSuperview];
//    }

    for (int i = 0; i<paramsCountArray.count; i++) {
        
        dateString = [NSString string];
        UILabel * paramsTimeNameLabel = [[UILabel alloc] init];
//        paramsTimeNameLabel.text = [paramsCountArray[i] valueForKey:@"paramName"];
        paramsTimeNameLabel.text = @"时间选择：";
        CGRect paramsTimeNameLabelRect = [paramsTimeNameLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_parameterView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:paramsTimeNameLabel.font} context:nil];
        
        paramsTimeNameLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + i* 30*KHeight6scale, paramsTimeNameLabelRect.size.width, 25*KHeight6scale);
        if (paramsTimeNameLabelRect.size.width < 50*KWidth6scale) {
              paramsTimeNameLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + i* 30*KHeight6scale, 50*KHeight6scale, 25*KHeight6scale);
        }
        [_parameterView addSubview:paramsTimeNameLabel];

        UIButton * dateParameterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        NSDate *  senddate=[NSDate date];
        NSCalendar*calendar = [NSCalendar currentCalendar];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        NSDateComponents*  comps =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitQuarter)fromDate:senddate];
        dateStringFormat = [paramsCountArray[i] valueForKey:@"paramFormat"];
        NSLog(@"%@",dateStringFormat);
        if ([dateStringFormat isEqualToString:@"yyyyMMdd"]) {
            // 年月日
            [dateformatter setDateFormat:@"YYYY-MM-dd"];
            dateString = [dateformatter stringFromDate:senddate];

        }else if ([dateStringFormat isEqualToString:@"yyyyMM"]){
            // 年月
            [dateformatter setDateFormat:@"YYYY-MM"];
            dateString = [dateformatter stringFromDate:senddate];

        }else if ([dateStringFormat isEqualToString:@"yyyy"]){
            // 年
            [dateformatter setDateFormat:@"YYYY"];
            dateString = [dateformatter stringFromDate:senddate];
            
        }else if ([dateStringFormat isEqualToString:@"yyyyQM"]){
            // 季度
            // 年
            NSInteger year = [comps year];
            // 当前日期所在季度
//            NSInteger quarter = [comps quarter];
            
            dateString = [NSString stringWithFormat:@"%ldQ1",year] ;

        }else if ([dateStringFormat isEqualToString:@""]){
            // 周
            // 年
            NSInteger year = [comps year];
            // 当前日期所在第几周
            NSInteger week = [comps weekOfYear];
            
            dateString = [NSString stringWithFormat:@"%ldW%02ld",year,week] ;
        }

        
        
        [dateParameterButton setTitle:dateString forState:UIControlStateNormal];
//        CGRect dateParatemerRect = [dateParameterButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_parameterView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:dateParameterButton.titleLabel.font} context:nil];
        
        dateParameterButton.frame = CGRectMake(CGRectGetMaxX(paramsTimeNameLabel.frame), CGRectGetMinY(paramsTimeNameLabel.frame), 150*KWidth6scale, CGRectGetHeight(paramsTimeNameLabel.frame));
        dateParameterButton.layer.masksToBounds = YES;
        dateParameterButton.layer.borderWidth= 1;
        dateParameterButton.layer.borderColor = [UIColor grayColor].CGColor;
        dateParameterButton.layer.cornerRadius = 5;
        [_parameterView addSubview:dateParameterButton];
        dateParameterButton.tag = i;
        [dateParameterButton addTarget:self action:@selector(dateParameterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
#warning ==========delete
        [dateParameterButton setTitle:dateString forState:UIControlStateNormal];
        

    }
}
// 取消按钮
- (void)cancelParaButtonClick: (UIButton*)button
{
    _tabView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        _reportWebView.alpha = 1;
        _reportWebView.userInteractionEnabled = YES;
        _parameterView.alpha = 0;
    } completion:nil];
    
    
}
// 确认按钮
- (void)OKParaButtonClick: (UIButton*)button
{
    _tabView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        _reportWebView.alpha = 1;
        _reportWebView.userInteractionEnabled = YES;
        _parameterView.alpha = 0;
    } completion:nil];
    
    
}
// 选择时间按钮
- (void)dateParameterButtonClick: (UIButton*)button
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        NSString * string = [NSString stringWithFormat:@"%@",[pickerView saveDateString]];
        [button setTitle:string forState:UIControlStateNormal];
        
    }];
    
    pickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 40, Main_Screen_Width-20, 200)];
    
    dateStringFormat = [paramsCountArray[button.tag] valueForKey:@"paramFormat"];

    pickerView.defaultDateString = button.titleLabel.text;
    [alertController.view addSubview:pickerView];
    
    if ([dateStringFormat isEqualToString:@"yyyyMMdd"]) {
        
        [pickerView makeYearMouthDayPicker];
        
        
    }else if ([dateStringFormat isEqualToString:@"yyyyMM"]){
        
        [pickerView makeYearMouthPicker];
        
    }else if ([dateStringFormat isEqualToString:@"yyyy"]){
        
        [pickerView makeYearPicker];
    }else if ([dateStringFormat isEqualToString:@"yyyyQM"]){
        
        [pickerView makeQuarterPicker];
    }else if([dateStringFormat isEqualToString:@""]){
        
        [pickerView makeYearWeekPicker];
    }
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
- (void)makeLeftButtonItme
{
    UIImage * backImage = [UIImage imageNamed:@"back.png"];
    CGRect backframe = CGRectMake(0, 0, BackButtonWidth, BackButtonHeight);
    UIButton * backButton = [[UIButton alloc] initWithFrame:backframe];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}
- (void)backButtonClick:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)maketab{
    
    _tabView = [[UITabBar alloc] initWithFrame:CGRectMake(0, KViewHeight, Main_Screen_Width, BottomBarHeight)];
    _tabView.backgroundColor = [UIColor whiteColor];
    
    UIButton * searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchButton.frame = CGRectMake(0, 0, Main_Screen_Width/3.0, BottomBarHeight);
    [searchButton setImage:[[UIImage imageNamed:@"reportIncomesearch.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tabView addSubview:searchButton];
    UIButton * guanZhuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    guanZhuButton.frame = CGRectMake(CGRectGetMaxX(searchButton.frame),0 , Main_Screen_Width/3.0, BottomBarHeight);
    [guanZhuButton setImage:[[UIImage imageNamed:@"reportIncomeguanzhu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [guanZhuButton addTarget:self action:@selector(guanZhuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tabView addSubview:guanZhuButton];
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame = CGRectMake(CGRectGetMaxX(guanZhuButton.frame),0 , Main_Screen_Width/3.0, BottomBarHeight);
    [shareButton setImage:[[UIImage imageNamed:@"reportIncomeShare.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tabView addSubview:shareButton];
    [self.view addSubview:_tabView];
}
// 筛选按钮点击事件
- (void)searchButtonClick:(UIButton *)button
{
    [self getReportParameters];
    
    _tabView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        _reportWebView.alpha = 0.5;
        _reportWebView.userInteractionEnabled = NO;
        _parameterView.alpha = 1.0f;
        
    } completion:nil];
    
    
    
    
}
- (void)getReportParameters
{
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        // 指标界面的接口
        NSString * urlStr = [NSString stringWithFormat:getReportParametersHttp];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic=   [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            
            
            NSMutableArray * paramsMutableArray = [NSMutableArray array];
            paramsMutableArray = dic[@"params"] ;
            
            paramsCountArray = [NSMutableArray array];
            
            if (responseObject != nil) {
                // key值为time的情况下比较infos中type，如果type为time 添加到keyTypeTimeArray数组中
                for (NSMutableDictionary * dict in paramsMutableArray) {
                    
                    NSMutableArray * infosMutableArray = [NSMutableArray array];
                    infosMutableArray = dict[@"infos"];
                    // infos数组中type＝time的字典
                    NSMutableArray * typeTimeArray =[NSMutableArray array];
                    // infos数组中type＝other的字典
                    NSMutableArray * typeOtherArray = [NSMutableArray array];
                    
                    NSMutableDictionary * paramsDict = [NSMutableDictionary dictionary];
                    
                    
                    for (NSMutableDictionary * infoDict in infosMutableArray) {
                        
                        if ([infoDict[@"type"] isEqualToString:@"time"]) {
                            
                            [typeTimeArray addObject:infoDict];
                            
                        }else if ([infoDict[@"type"] isEqualToString:@"other"]){
                            
                            [typeOtherArray addObject:infoDict];
                        }
                        
                    }
                    if (typeTimeArray.count == 1) {
                        
                        [paramsDict setValue:[typeTimeArray[0] valueForKey:@"format"] forKey:@"paramFormat"];
                        [paramsDict setValue:[typeTimeArray[0] valueForKey:@"type"] forKey:@"paramType"];
                        [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                        [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                        NSLog(@"%@",paramsDict);
                        
                        [paramsCountArray addObject:paramsDict];
                    }else if(typeTimeArray.count > 1){
                        
                        [paramsDict setValue:@"yyyyMMdd" forKey:@"paramFormat"];
                        [paramsDict setValue:@"time" forKey:@"paramType"];
                        [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                        [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                        [paramsCountArray addObject:paramsDict];
                        
                    }
                    //                if (typeOtherArray.count == 1) {
                    //
                    //                    [paramsDict setValue:[typeTimeArray[0] valueForKey:@"format"] forKey:@"paramFormat"];
                    //                    [paramsDict setValue:[typeTimeArray[0] valueForKey:@"type"] forKey:@"paramType"];
                    //                    [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                    //                    [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                    //                    [paramsCountArray addObject:paramsDict];
                    //                }else{
                    //
                    //                    [paramsDict setValue:@"yyyyMMdd" forKey:@"paramFormat"];
                    //                    [paramsDict setValue:@"time" forKey:@"paramType"];
                    //                    [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                    //                    [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                    //                    [paramsCountArray addObject:paramsDict];
                    //
                    //                }
                    
                    
                }
                
                NSLog(@"%@",paramsCountArray);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
              
                    [self makeParametersContentView];
                    
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
           

        }];
        
    });
}

// 关注按钮点击事件
-(void)guanZhuButtonClick:(UIButton *)button
{
    
}
//分享按钮点击事件
-(void)shareButtonClick:(UIButton *)button
{
    
    [super ScreenShot];
    
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
 }*/

@end
