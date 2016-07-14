//
//  SDUserLoginViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDUserLoginViewController.h"
#import "SDTabBarViewController.h"
#import "MBProgressHUD+NJ.h"


@interface SDUserLoginViewController ()
@property (nonatomic , strong)NSString * info;

@end

@implementation SDUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userLogin.png"]];
    // 调用设置控件的方法
    [self makeUI];
}
- (void)makeUI{
    
    self.userTextField  = [[UITextField alloc] initWithFrame:CGRectMake(100*KWidth6scale, 200*KHeight6scale, 200*KWidth6scale, 40*KHeight6scale)];
    self.userTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.userTextField];
    
    self.passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userTextField.frame), CGRectGetMaxY(self.userTextField.frame)+10*KHeight6scale, CGRectGetWidth(self.userTextField.frame), CGRectGetHeight(self.userTextField.frame))];
    self.passWordTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.passWordTextField];
    
    
    self.LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LoginButton.frame = CGRectMake(Kwidth/2 - 75*KWidth6scale,Kheight - 200*KHeight6scale, 150*KWidth6scale, 40*KHeight6scale);
    [self.LoginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.LoginButton.backgroundColor = [UIColor grayColor];
    [self.LoginButton addTarget:self action:@selector(LoginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.LoginButton];
    
}
- (void)LoginButtonClick:(UIButton *)button{
    

    // 1.设置请求路径
    NSString * urlStr = [NSString stringWithFormat:LoginHttp];
    NSURL * url = [NSURL URLWithString:urlStr];
    
    // 2.创建请求对象,同时设置缓存策略和超时时间
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
    
    // 3.发送Post请求
    request.HTTPMethod = @"POST";
    NSString * bodyStr = [NSString stringWithFormat:LoginHttpBody,self.userTextField.text,self.passWordTextField.text];
    NSData * bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary * iosExpDict = dict[@"iosExp"];
        self.info = iosExpDict[@"expMsg"];
        NSString * statusInfo = iosExpDict[@"expCode"];
        if ([statusInfo isEqualToString: @"ERR-5026"]) {

            dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD showSuccess:self.info];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showSuccess:self.info];
                
                // 延迟1.5秒跳转页面
                [self performSelector:@selector(GoToMainView) withObject:nil afterDelay:1.5f];
                
            });
            
        }
        
    }];
    
    [task resume];
    
}
- (void)GoToMainView
{
    SDTabBarViewController * TabBarVC = [[SDTabBarViewController alloc] init];
    
    [self presentViewController:TabBarVC animated:YES completion:nil];
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
