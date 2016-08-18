//
//  ReportIncomeViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/18.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "ReportIncomeViewController.h"
#import <WebKit/WebKit.h>


@interface ReportIncomeViewController ()
@property(nonatomic , strong)  UIWebView * reportWebView;
@end

@implementation ReportIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeWebView];
    // Do any additional setup after loading the view.
}
- (void)makeWebView
{
    
    _reportWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight)];
    
    NSLog(@"------------------%@",_webViewHttpString);
    
    [_reportWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewHttpString]]];
    
    [self.view addSubview:_reportWebView];
    
    
    
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
