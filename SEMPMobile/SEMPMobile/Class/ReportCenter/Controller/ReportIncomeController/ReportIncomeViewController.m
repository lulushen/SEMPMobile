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
    [self makeLeftButtonItme];
    [self maketab];
    // Do any additional setup after loading the view.
}
- (void)makeWebView
{
    
    _reportWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight)];
    
    
    [_reportWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewHttpString]]];
    
    [self.view addSubview:_reportWebView];
    
    
    
}
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
- (void)backButtonClick:(UIButton *)button {
    
      [self.navigationController popViewControllerAnimated:YES];

}



- (void)maketab{

    UITabBar * view = [[UITabBar alloc] initWithFrame:CGRectMake(0, KViewHeight, Main_Screen_Width, BottomBarHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton * searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchButton.frame = CGRectMake(0, 0, Main_Screen_Width/3.0, BottomBarHeight);
    [searchButton setImage:[[UIImage imageNamed:@"reportIncomesearch.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchButton];
    UIButton * guanZhuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    guanZhuButton.frame = CGRectMake(CGRectGetMaxX(searchButton.frame),0 , Main_Screen_Width/3.0, BottomBarHeight);
    [guanZhuButton setImage:[[UIImage imageNamed:@"reportIncomeguanzhu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [guanZhuButton addTarget:self action:@selector(guanZhuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:guanZhuButton];
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame = CGRectMake(CGRectGetMaxX(guanZhuButton.frame),0 , Main_Screen_Width/3.0, BottomBarHeight);
    [shareButton setImage:[[UIImage imageNamed:@"reportIncomeShare.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shareButton];
    [self.view addSubview:view];
}
// 筛选按钮点击事件
- (void)searchButtonClick:(UIButton *)button
{
    
}
// 关注按钮点击事件
-(void)guanZhuButtonClick:(UIButton *)button
{
    
}
//分享按钮点击事件
-(void)shareButtonClick:(UIButton *)button
{
    
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
