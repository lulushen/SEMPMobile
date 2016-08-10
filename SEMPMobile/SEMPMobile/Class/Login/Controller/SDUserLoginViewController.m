//
//  SDUserLoginViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "SDUserLoginViewController.h"
#import "TabBarControllerConfig.h"
#import "MBProgressHUD+MJ.h"
#import "userModel.h"


@interface SDUserLoginViewController ()<UITextFieldDelegate>
{
    UIAlertController * _alert;
    UIAlertController * _alertLoginFail;
    UIAlertController * _alertDidRegiest;
    NSMutableDictionary *_temDic;
    userModel * model;
}

@property (nonatomic , strong)NSString * info;

@end

@implementation SDUserLoginViewController
#pragma mrak 声明一个md5加密方法
- (NSString *)md5HexDigest:(NSString*)password
{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02x", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    
    NSLog(@"Encryption Result = %@",mdfiveString);
    return mdfiveString;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userlogin.png"]];
    // 调用设置控件的方法
    [self makeUI];
}
- (void)makeUI{
    
    
    self.biaoshiTextField  = [[UITextField alloc] initWithFrame:CGRectMake(100*KWidth6scale, 235*KHeight6scale, 200*KWidth6scale, 35*KHeight6scale)];
    self.biaoshiTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.biaoshiTextField];
    
    
    self.userTextField  = [[UITextField alloc] initWithFrame:CGRectMake(100*KWidth6scale, CGRectGetMaxY(self.biaoshiTextField.frame) + 27*KHeight6scale, 200*KWidth6scale, CGRectGetHeight(self.biaoshiTextField.frame))];
    self.userTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.userTextField];
    
    self.passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userTextField.frame), CGRectGetMaxY(self.userTextField.frame)+27*KHeight6scale, CGRectGetWidth(self.userTextField.frame), CGRectGetHeight(self.userTextField.frame))];
    self.passWordTextField.backgroundColor = [UIColor whiteColor];
    self.passWordTextField.secureTextEntry = YES;
    [self.view addSubview:self.passWordTextField];
    
    
    self.LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LoginButton.frame = CGRectMake(Main_Screen_Width/2 - 75*KWidth6scale,CGRectGetMaxY(self.passWordTextField.frame) + 30*KHeight6scale, 150*KWidth6scale, CGRectGetHeight(self.passWordTextField.frame));
    [self.LoginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.LoginButton.backgroundColor = [UIColor grayColor];
    [self.LoginButton addTarget:self action:@selector(LoginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.LoginButton];
    UIButton * backbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backbutton.frame = CGRectMake(10, 20, 80, 50);
    [self.view addSubview:backbutton];
    [backbutton addTarget:self action:@selector(backbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backbuttonClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)LoginButtonClick:(UIButton *)button{
    // 1.设置请求路径
    NSString * urlStr = [NSString stringWithFormat:LoginHttp];
    NSLog(@"login --=  url %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    
    // 2.创建请求对象,同时设置缓存策略和超时时间
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
    
    // 3.发送Post请求
    request.HTTPMethod = @"POST";
//    NSString * bodyStr = [NSString stringWithFormat:LoginHttpBody,self.userTextField.text,self.passWordTextField.text];
    NSString * bodyStr = [NSString stringWithFormat:LoginHttpBody,@"mobile",@"111111"];
    NSData * bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data --- %@",data);
        if (data != nil) {
            
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"dict -- %@",dict);
            
            model = [[userModel alloc] init];
            
            
            [model setValuesForKeysWithDictionary:dict];
            
            NSLog(@"model . usertoken %@",model.user_token);
            
            NSInteger status = model.status;
            
            if (status == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    [dic setObject:_userTextField.text forKey:@"userName"];
                    [dic setObject:_passWordTextField.text forKey:@"passWord"];
                    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userLogin"];
                    [MBProgressHUD showSuccess:model.message];
                    
                    
                    // 延迟1.5秒跳转页面
                    [self performSelector:@selector(GoToMainView) withObject:self afterDelay:1.5f];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"login"];
                    
                    //  AppDelegate * app = [[AppDelegate alloc] init];
                    //  [app mainTab];
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // [MBProgressHUD showSuccess:self.info];
                    
                    [MBProgressHUD showSuccess:@"登录失败"];
                    
                    
                });
                
                
            }

        }else{
            
            NSLog(@"login -- data为空");
        }
        
    }];
    
    [task resume];
    
}
- (void)GoToMainView
{
    NSLog(@"model   -----    : %@",model.user_token);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"] != nil) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userModel"];
        
    }
    
    NSData * userModelData = [NSData data];
    
    userModelData = [NSKeyedArchiver archivedDataWithRootObject:model];
    
    [[NSUserDefaults standardUserDefaults] setObject:userModelData forKey:@"userModel"];
    
    TabBarControllerConfig *tabBarConfig = [[TabBarControllerConfig alloc]init];
    [self presentViewController:tabBarConfig.tabBarController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
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