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
{
    UIAlertController * _alert;
    UIAlertController * _alertLoginFail;
    UIAlertController * _alertDidRegiest;
    NSMutableDictionary *_temDic;

}

@property (nonatomic , strong)NSString * info;

@end

@implementation SDUserLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
}

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
        
        if ([statusInfo isEqualToString: @"SUC-1001"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //数据持久化
                //1.获得NSUserDefaults文件
                NSUserDefaults * currentUser = [NSUserDefaults standardUserDefaults];
                //2.向文件中写入内容
                [currentUser setValue:@"SUC-1001" forKey:@"LoginSuc"];
                [currentUser setValue:self.userTextField.text forKey:@"userName"];
                [currentUser setValue:self.passWordTextField.text forKey:@"passWord"];

                
                //2.1立即同步
                [currentUser synchronize];

//                [[NSUserDefaults standardUserDefaults] setObject:currentUser forKey:@"userLogin"];

                NSLog(@"jdsj-=-=-=-=-=-=-;;;;;;;;;;%@",currentUser);

                //3.读取文件
                NSString * currentUserName = [currentUser objectForKey:@"userName"];
                NSString * currentPassWord = [currentUser objectForKey:@"passWord"];
                NSLog(@"-=-=-=-=-=%@,-=-=-=-=-=%@",currentUserName,currentPassWord);
                
    //                    //创建一个消息对象
//                    NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil userInfo:@{@"1":@"123"}];
                    //发送消息
                    [MBProgressHUD showSuccess:self.info];

                    // 延迟1.5秒跳转页面
                    [self performSelector:@selector(GoToMainView) withObject:self afterDelay:1.5f];
//                [self presentViewController:_alert animated:YES completion:^{
//
//
//                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLogin" object:nil];

                

                
            });
          
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:self.info];
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
