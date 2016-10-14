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


@interface ReportIncomeViewController ()<WKNavigationDelegate,WKUIDelegate,YXCustomActionSheetDelegate,UITextFieldDelegate>
{
    UILabel * titleLabel;
    // 解析出参数类型所展示的当前时间字符串
    NSString * dateString;
    NSString * dateStringFormat;
    //    DataSearchView * dataSearchView;
    DatePickerView * pickerView;
    // 参数总数组
    NSMutableArray * paramsCountArray;
    // 选择时间参数，要传给js的时间字符串
    NSString * parameterDateString;
    
    // 参数数组（元素字典）
    NSMutableArray * parameterDataArray;
    
    UIView * contentView;
    UITextField * otherField;
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
    /**
     在创建WKWebView之前，需要先创建配置对象，用于做一些配置：
     */
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    /**
     配置偏好设置
     偏好设置也没有必须去修改它，都使用默认的就可以了，除非你真的需要修改它：
     // 设置偏好设置
     config.preferences = [[WKPreferences alloc] init];
     // 默认为0
     config.preferences.minimumFontSize = 10;
     // 默认认为YES
     config.preferences.javaScriptEnabled = YES;
     // 在iOS上默认为NO，表示不能自动通过窗口打开
     config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
     
     */
    /**
     配置web内容处理池
     其实我们没有必要去创建它，因为它根本没有属性和方法：
     web内容处理池，由于没有属性可以设置，也没有方法可以调用，不用手动创建
     */
    config.processPool = [[WKProcessPool alloc] init];
    
    /**
     配置Js与Web内容交互
     WKUserContentController是用于给JS注入对象的，注入对象后，JS端就可以使用：
     window.webkit.messageHandlers.<name>.postMessage(<messageBody>);
     来调用发送数据给iOS端，比如：
     window.webkit.messageHandlers.AppModel.postMessage({body: '传数据'});
     
     
     AppModel就是我们要注入的名称，注入以后，就可以在JS端调用了，传数据统一通过body传，可以是多种类型，只支持NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull类型。
     
     下面我们配置给JS的main frame注入AppModel名称，对于JS端可就是对象了：
     // 通过JS与webview内容交互
     config.userContentController = [[WKUserContentController alloc] init];
     
     // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
     // 我们可以在WKScriptMessageHandler代理中接收到
     [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
     
     当JS通过AppModel发送数据到iOS端时，会在代理中收到:
     #pragma mark - WKScriptMessageHandler
     - (void)userContentController:(WKUserContentController *)userContentController
     didReceiveScriptMessage:(WKScriptMessage *)message {
     if ([message.name isEqualToString:@"AppModel"]) {
     // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
     // NSDictionary, and NSNull类型
     NSLog(@"%@", message.body);
     }
     }
     所有JS调用iOS的部分，都只可以在此处使用哦。当然我们也可以注入多个名称（JS对象），用于区分功能。
     */
    
    //创建WKWebView
    self.reportWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight) configuration:config];
    _reportWebView.backgroundColor = [UIColor whiteColor];
    // 加载网页
    NSURL *url = [NSURL URLWithString:_webViewHttpString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_reportWebView loadRequest:request];
    /**
     * 配置代理
     如果需要处理web导航条上的代理处理，比如链接是否可以跳转或者如何跳转，需要设置代理；而如果需要与在JS调用alert、confirm、prompt函数时，通过JS原生来处理，而不是调用JS的alert、confirm、prompt函数，那么需要设置UIDelegate，在得到响应后可以将结果反馈到JS端：
     self.webView.navigationDelegate = self;
     self.webView.UIDelegate = self;
     */
    // 导航代理
    _reportWebView.navigationDelegate = self;
    // 与webview UI交互代理
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
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(_parameterView.frame), CGRectGetHeight(_parameterView.frame)-CGRectGetMaxY(titleLabel.frame)-50*KWidth6scale)];
    [contentView removeFromSuperview];
    //    contentView.backgroundColor = [UIColor redColor];
    [_parameterView addSubview:contentView];
}
- (void)makeParametersContentView
{
    for (UIView * view in contentView.subviews) {
        [view removeFromSuperview];
    }
    
    // 可以创建一次，设置为透明
    
    parameterDataArray = [NSMutableArray array];
    
    for (int i = 0; i<paramsCountArray.count; i++) {
        
        dateString = [NSString string];
        UILabel * paramsTimeNameLabel = [[UILabel alloc] init];

        if ([[paramsCountArray[i] valueForKey:@"paramType"] isEqualToString:@"time"]) {
            //        paramsTimeNameLabel.text = [paramsCountArray[i] valueForKey:@"paramName"];
            paramsTimeNameLabel.text = @"时间：";
            CGRect paramsTimeNameLabelRect = [paramsTimeNameLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_parameterView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:paramsTimeNameLabel.font} context:nil];
            
            paramsTimeNameLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame),  i* 30*KHeight6scale, paramsTimeNameLabelRect.size.width, 25*KHeight6scale);
            if (paramsTimeNameLabelRect.size.width < 50*KWidth6scale) {
                paramsTimeNameLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + i* 30*KHeight6scale, 50*KHeight6scale, 25*KHeight6scale);
            }
            [contentView addSubview:paramsTimeNameLabel];
            
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
            [contentView addSubview:dateParameterButton];
            dateParameterButton.tag = i;
            [dateParameterButton addTarget:self action:@selector(dateParameterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
#warning ==========delete
            [dateParameterButton setTitle:dateString forState:UIControlStateNormal];
            NSString * string = [self parameterDateString:dateString  dateStringFormat:dateStringFormat];
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setObject:string forKey:[paramsCountArray[i] valueForKey:@"paramKey"]];
            [parameterDataArray addObject:dict];

        }else{
            
            paramsTimeNameLabel.text = @"其他：";
            CGRect paramsTimeNameLabelRect = [paramsTimeNameLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_parameterView.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:paramsTimeNameLabel.font} context:nil];
            
            paramsTimeNameLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame),  i* 30*KHeight6scale, paramsTimeNameLabelRect.size.width, 25*KHeight6scale);
            if (paramsTimeNameLabelRect.size.width < 50*KWidth6scale) {
                paramsTimeNameLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + i* 30*KHeight6scale, 50*KHeight6scale, 25*KHeight6scale);
            }
            [contentView addSubview:paramsTimeNameLabel];
            otherField = [[UITextField alloc] init];
            otherField.frame = CGRectMake(CGRectGetMaxX(paramsTimeNameLabel.frame), CGRectGetMinY(paramsTimeNameLabel.frame), 150*KWidth6scale, CGRectGetHeight(paramsTimeNameLabel.frame));
            otherField.layer.masksToBounds = YES;
            otherField.layer.borderWidth= 1;
            otherField.layer.borderColor = [UIColor grayColor].CGColor;
            otherField.layer.cornerRadius = 5;
//            otherField.delegate = self;
            otherField.tag = i;
            [contentView addSubview:otherField];
        
              // 参数字典数组
//        NSString * string = [self parameterDateString:dateString  dateStringFormat:dateStringFormat];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:otherField.text forKey:[paramsCountArray[i] valueForKey:@"paramKey"]];
        [parameterDataArray addObject:dict];
        }
        
        
    }
    
    
    //    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    //    NSMutableDictionary * dict2 = [NSMutableDictionary dictionary];
    //
    //    [dict setObject:@"20160101" forKey:@""];
    //    [dict2 setObject:@"20140501" forKey:@"time"];
    //
    //    [parameterDataArray addObject:dict];
    //    [parameterDataArray addObject:dict2];
    
    
    
}


- (NSString * )parameterDateString:(NSString *)string dateStringFormat:(NSString *)dateStrFormat
{
    NSRange rangeYear = [string rangeOfString:@"-"];//匹配得到的下标
    NSRange rangeWeek = [string rangeOfString:@"W"];//匹配得到的下标
    
    if ([dateStrFormat isEqualToString:@"yyyyMMdd"]) {
        // 年月日
        if (rangeYear.length != 0) {
            string= [string stringByReplacingCharactersInRange:rangeYear withString:@""];
            NSRange rangeYear = [string rangeOfString:@"-"];//匹配得到的下标
            if (rangeYear.length != 0) {
                string= [string stringByReplacingCharactersInRange:rangeYear withString:@""];
            }
            
        }
    }else if ([dateStrFormat isEqualToString:@"yyyyMM"]){
        // 年月
        
        string= [string stringByReplacingCharactersInRange:rangeYear withString:@""];
        string = [NSString stringWithFormat:@"%@01",string];
        
        
    }else if ([dateStrFormat isEqualToString:@"yyyy"]){
        // 年
        string = [NSString stringWithFormat:@"%@0101",string];
        
        
    }else if ([dateStrFormat isEqualToString:@"yyyyQM"]){
        
    }else if ([dateStrFormat isEqualToString:@""]){
        // 周
        string= [string stringByReplacingCharactersInRange:rangeWeek withString:@""];
        
    }
    return string;
    
}
// 取消按钮
- (void)cancelParaButtonClick: (UIButton*)sender
{
    _tabView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        _reportWebView.alpha = 1;
        _reportWebView.userInteractionEnabled = YES;
        _parameterView.alpha = 0;
    } completion:nil];
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:otherField.text  forKey:[paramsCountArray[textField.tag] valueForKey:@"paramKey"]];
    [parameterDataArray replaceObjectAtIndex:textField.tag withObject:dict];
    
}

// 确认按钮
- (void)OKParaButtonClick: (UIButton*)sender
{
    [self textFieldDidEndEditing:otherField];
    _tabView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        _reportWebView.alpha = 1;
        _reportWebView.userInteractionEnabled = YES;
        _parameterView.alpha = 0;
        
    } completion:nil];
//    for (int i= 0;i<parameterDataArray.count;i++) {
//        NSMutableDictionary * dic = parameterDataArray[i];
//        
//        if (![dic.allKeys[0] isEqualToString:@"time"]) {
//            NSLog(@"'''''''''''''''''%@",otherField.text);
//            [dic setObject:otherField.text forKey:dic.allKeys[0]];
//            [parameterDataArray replaceObjectAtIndex:i withObject:dic];
//            
//        }
//    }
    
    NSData *data =[NSJSONSerialization dataWithJSONObject:parameterDataArray options:0 error:nil];
    NSString *dataStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //    NSString *str = [strArray componentsJoinedByString:@","];
    //    NSString * string = @"[{\"time\":\"20161001\"},{\"ORG\":\"\"}]";
    NSLog(@"=======%@",dataStr);
    if (!self.reportWebView.loading) {
        
        [self.reportWebView evaluateJavaScript:[NSString stringWithFormat:@"%@(\'%@\')",@"window.refreshReport", dataStr] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            //TODO
            NSLog(@"%@ %@",response,error);
        }];
    } else {
        NSLog(@"the view is currently loading content");
    }
    
    
}
// 选择时间按钮
- (void)dateParameterButtonClick: (UIButton*)button
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        dateString = @"";
        parameterDateString = [NSString stringWithFormat:@"%@",[pickerView saveDateString]];
        [button setTitle:parameterDateString forState:UIControlStateNormal];
        parameterDateString = [self parameterDateString:parameterDateString dateStringFormat:dateStringFormat];
        NSLog(@"%@",parameterDateString);
        
        // 参数
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:parameterDateString  forKey:[paramsCountArray[button.tag] valueForKey:@"paramKey"]];
        [parameterDataArray replaceObjectAtIndex:button.tag withObject:dict];
        
        NSLog(@"p[][][][%@",dict);
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
            //         NSMutableArray * paramsMutableArray = [NSMutableArray array];
            NSMutableArray * paramsMutableArray = nil;
            paramsMutableArray = dic[@"params"] ;
            NSLog(@"==%@",paramsMutableArray);
            paramsCountArray = [NSMutableArray array];
            if (responseObject != nil) {
                // key值为time的情况下比较infos中type，如果type为time 添加到keyTypeTimeArray数组中
                NSMutableArray * infosMutableArray = nil;
                
                for (NSMutableDictionary * dict in paramsMutableArray) {
                    //内存问题
                    //                    NSMutableArray * infosMutableArray = [NSMutableArray array];
                    infosMutableArray = dict[@"infos"];
                    //                    NSLog(@"---%@",infosMutableArray);
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
                    if (typeOtherArray.count == 1) {
                        [paramsDict setValue:[typeOtherArray[0] valueForKey:@"format"] forKey:@"paramFormat"];
                        [paramsDict setValue:[typeOtherArray[0] valueForKey:@"type"] forKey:@"paramType"];
                        [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                        [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                        NSLog(@"%@",paramsDict);
                        [paramsCountArray addObject:paramsDict];
                    }else{
                        
                    }
                    if (typeTimeArray.count == 1) {
                        
                        [paramsDict setValue:[typeTimeArray[0] valueForKey:@"format"] forKey:@"paramFormat"];
                        [paramsDict setValue:[typeTimeArray[0] valueForKey:@"type"] forKey:@"paramType"];
                        [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                        [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                        NSLog(@"%@",paramsDict);
                        [paramsCountArray addObject:paramsDict];
                    }else if(typeTimeArray.count > 1){
                        
                        NSMutableArray * formatArray = [NSMutableArray array];
                        NSLog(@"%@",typeTimeArray);
                        
                        for (NSMutableDictionary * dict in typeTimeArray) {
                            NSLog(@"%@",formatArray);
                            [formatArray addObject:[dict valueForKey:@"format"]];
                            
                        }
                        NSString *yyyyMMddstr = @"yyyyMMdd";
                        NSString *yyyyMMstr = @"yyyyMM";
                        NSString *yyyystr = @"yyyy";
                        NSString *yyyyQWstr = @"yyyyQW";
                        NSString *str = @"";
                        //i＝1；数组包含某个元素  i＝0；数组不包含某个元素
                        BOOL isboolyyyyMMdd = [formatArray containsObject: yyyyMMddstr];
                        BOOL isboolyyyyMM = [formatArray containsObject: yyyyMMstr];
                        BOOL isboolyyyy = [formatArray containsObject: yyyystr];
                        BOOL isboolyyyyQW = [formatArray containsObject: yyyyQWstr];
                        BOOL isbool = [formatArray containsObject: str];
                        
                        if (isboolyyyyMMdd == 1) {
                            //如果存在格式yyyyMMdd 合并成yyyyMMdd
                            [paramsDict setValue:@"yyyyMMdd" forKey:@"paramFormat"];
                            [paramsDict setValue:@"time" forKey:@"paramType"];
                            [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                            [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                            [paramsCountArray addObject:paramsDict];
                        }else{
                            if ((isboolyyyyMM==1)&&(isboolyyyyQW==0)&&(isbool == 0)) {
                                //有yyyyMM格式没有yyyyQW格式和空
                                [paramsDict setValue:@"yyyyMM" forKey:@"paramFormat"];
                                [paramsDict setValue:@"time" forKey:@"paramType"];
                                [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                                [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                                [paramsCountArray addObject:paramsDict];
                                
                            }else{
                                if (isboolyyyyMM==1) {
                                    if ((isboolyyyy==1)&&(isboolyyyyQW==0)&&(isbool == 0)) {
                                        //只有yyyyMM和yyyy格式
                                        [paramsDict setValue:@"yyyyMM" forKey:@"paramFormat"];
                                        [paramsDict setValue:@"time" forKey:@"paramType"];
                                        [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                                        [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                                        [paramsCountArray addObject:paramsDict];
                                    }else {
                                        //存在yyyyMM 或yyyy 或yyyyQW 或空
                                        [paramsDict setValue:@"yyyyMMdd" forKey:@"paramFormat"];
                                        [paramsDict setValue:@"time" forKey:@"paramType"];
                                        [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                                        [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                                        [paramsCountArray addObject:paramsDict];
                                    }
                                }else{
                                    
                                    if ((isboolyyyy==1)&&(isboolyyyyQW==0)&&(isbool == 0)) {
                                        //只有yyyy格式
                                        [paramsDict setValue:@"yyyyMM" forKey:@"paramFormat"];
                                        [paramsDict setValue:@"time" forKey:@"paramType"];
                                        [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                                        [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                                        [paramsCountArray addObject:paramsDict];
                                    }else {
                                        if (isboolyyyy == 1) {
                                            //存在yyyy    和（yyyyQW和空中的其中一个）
                                            [paramsDict setValue:@"yyyyMMdd" forKey:@"paramFormat"];
                                            [paramsDict setValue:@"time" forKey:@"paramType"];
                                            [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                                            [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                                            [paramsCountArray addObject:paramsDict];
                                            
                                        }else{
                                            if ((isboolyyyyQW==1)&&(isbool == 0)) {
                                                // 只含有yyyyQW格式
                                                [paramsDict setValue:@"yyyyQW" forKey:@"paramFormat"];
                                                [paramsDict setValue:@"time" forKey:@"paramType"];
                                                [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                                                [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                                                [paramsCountArray addObject:paramsDict];
                                                
                                            }else if((isboolyyyyQW==0)&&(isbool == 1)){
                                                //只含有空格式
                                                [paramsDict setValue:@"" forKey:@"paramFormat"];
                                                [paramsDict setValue:@"time" forKey:@"paramType"];
                                                [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                                                [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                                                [paramsCountArray addObject:paramsDict];
                                                
                                            }else if ((isboolyyyyQW==1)&&(isbool == 1)){
                                                // 只含有yyyyQW 和 空
                                                [paramsDict setValue:@"yyyyMMdd" forKey:@"paramFormat"];
                                                [paramsDict setValue:@"time" forKey:@"paramType"];
                                                [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                                                [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                                                [paramsCountArray addObject:paramsDict];
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        //                        if ([[dict valueForKey:@"paramFormat"] isEqualToString:@"yyyyMMdd"]) {
                        //
                        //                            [paramsDict setValue:@"yyyyMMdd" forKey:@"paramFormat"];
                        //                            [paramsDict setValue:@"time" forKey:@"paramType"];
                        //                            [paramsDict setValue:dict[@"key"] forKey:@"paramKey"];
                        //                            [paramsDict setValue:dict[@"name"] forKey:@"paramName"];
                        //                            [paramsCountArray addObject:paramsDict];
                        //
                        //                        }
                        
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
                    
                    infosMutableArray = nil;
                    
                }
                
                NSLog(@"----%@",paramsCountArray);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self makeParametersContentView];
                    
                });
            }
            paramsMutableArray = nil;
            
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
