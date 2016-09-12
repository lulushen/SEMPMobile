//
//  SDFeedBackViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/11.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDFeedBackViewController.h"
#import "userModel.h"
#import "MBProgressHUD+MJ.h"

@interface SDFeedBackViewController ()<UITextViewDelegate>

@property (nonatomic , strong)userModel * userModel;
@property (nonatomic , strong)UILabel * placeholderLabel;
@end

@implementation SDFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"意见反馈";
    [self makeView];
    // Do any additional setup after loading the view.
}
- (void)makeView
{
    
    
    
    _feedBackInfoTextView = [[UITextView alloc] init];
    _feedBackInfoTextView.frame = CGRectMake(20*KWidth6scale, 20*KHeight6scale, Main_Screen_Width-40*KWidth6scale, 200*KHeight6scale);
    _feedBackInfoTextView.layer.borderWidth = 1;
    _feedBackInfoTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _feedBackInfoTextView.layer.cornerRadius = 5;
//    _feedBackInfoTextField.placeholder = @"在此输入反馈内容";
    [self.view addSubview:_feedBackInfoTextView];
       _feedBackButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _feedBackInfoTextView.delegate = self;
//   _placeholderLabel = [[UILabel alloc] init];
//    _placeholderLabel.frame =CGRectMake(10, 10, CGRectGetWidth(_feedBackInfoTextView.frame), 20);
//    _placeholderLabel.enabled = NO;//lable必须设置为不可用
    _feedBackInfoTextView.font = [UIFont systemFontOfSize:15.0f];
    _feedBackInfoTextView.textColor = [ UIColor grayColor];
    _feedBackInfoTextView.text = @"请在此处输入反馈内容";
//    _placeholderLabel.backgroundColor = [UIColor clearColor];
//    [_feedBackInfoTextView addSubview:_placeholderLabel];
    
    _feedBackButton.frame = CGRectMake(CGRectGetMinX(_feedBackInfoTextView.frame), CGRectGetMaxY(_feedBackInfoTextView.frame) + 50*KHeight6scale, CGRectGetWidth(_feedBackInfoTextView.frame), 30*KHeight6scale);
    [_feedBackButton setTitle:@"提交反馈" forState:UIControlStateNormal];
    _feedBackButton.tintColor = [UIColor whiteColor];
    [_feedBackButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
   
    
 [_feedBackButton addTarget:self action:@selector(feedBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _feedBackButton.backgroundColor = [UIColor grayColor];
    _feedBackButton.layer.cornerRadius = 5;

    [self.view addSubview:_feedBackButton];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请在此处输入反馈内容"]) {
        _feedBackInfoTextView.textColor = [ UIColor blackColor];

        textView.text = @"";
    }
}
//3.在结束编辑的代理方法中进行如下操作
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length<1) {
        _feedBackInfoTextView.textColor = [ UIColor grayColor];

        textView.text = @"请在此处输入反馈内容";
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
   
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }else{
        
        return YES;
    }
    
    
}
- (void)feedBackButtonClick:(UIButton *)button
{
    if ([_feedBackInfoTextView.text isEqualToString:@"请在此处输入反馈内容"] | ([[_feedBackInfoTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)) {
        
        
            [MBProgressHUD showSuccess:@"意见不能为空"];
        
        
    }else{
        
//        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
//        _userModel = [[userModel alloc] init];
//        _userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //  转化成字符串
        NSString *   token = [NSString stringWithFormat:@"%@",_userModel.user_token];
        
        NSLog(@"----%@",token);
        
        NSString * inf = [NSString stringWithFormat:@"%@",_feedBackInfoTextView.text];
        
        NSString * urlStr = [NSString stringWithFormat:FeedbackHttp,inf,token];
        
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
#warning  内容有空格的时候崩溃
            _feedBackInfoTextView.text = @"";

            [MBProgressHUD showSuccess:@"提交成功"];
            
            NSLog(@"responseObject------%@",responseObject);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            [MBProgressHUD showError:@"提交失败"];
            
        }];
        
      
        
        

    }
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
