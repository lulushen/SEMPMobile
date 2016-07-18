//
//  SDXiangqingViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/18.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDXiangqingViewController.h"
#import "SDHuaBiView.h"

@interface SDXiangqingViewController () <UITextViewDelegate>

@property (nonatomic , strong)SDHuaBiView * huabiV ;

@property (nonatomic , strong)NSString * ScreenshotsPickPath;

@property (nonatomic , strong) UITextView * textView ;

@property (nonatomic , strong)  UILongPressGestureRecognizer * longPressGr;
@property (nonatomic , strong) UIButton * removebutton ;
@end

@implementation SDXiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view setUserInteractionEnabled:YES];
    [self maketab];
    // Do any additional setup after loading the view.
}
- (void)maketab{
    
    
    
    UITabBar * view = [[UITabBar alloc] initWithFrame:CGRectMake(0, KTableViewHeight-KTabBarFrameHeight, Kwidth, KTabBarFrameHeight)];
    NSLog(@"-=-=-=-=-=%f",KTableViewHeight-KTabBarFrameHeight);
    view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, Kwidth/4.0, KTabBarFrameHeight);
    //    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"画笔" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIButton * luyinbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    luyinbutton.frame = CGRectMake(CGRectGetMaxX(button.frame),0 , Kwidth/4.0, KTabBarFrameHeight);
    //    luyinbutton.backgroundColor = [UIColor grayColor];
    [luyinbutton setTitle:@"录音" forState:UIControlStateNormal];
    [luyinbutton addTarget:self action:@selector(luyinbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:luyinbutton];
    UIButton * wenbenbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    wenbenbutton.frame = CGRectMake(CGRectGetMaxX(luyinbutton.frame),0 , Kwidth/4.0, KTabBarFrameHeight);
    //    wenbenbutton.backgroundColor = [UIColor grayColor];
    [wenbenbutton setTitle:@"文本" forState:UIControlStateNormal];
    [wenbenbutton addTarget:self action:@selector(wenbenbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:wenbenbutton];
    UIButton * fenxiangbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fenxiangbutton.frame = CGRectMake(CGRectGetMaxX(wenbenbutton.frame), 0, Kwidth/4.0, KTabBarFrameHeight);
    //    fenxiangbutton.backgroundColor = [UIColor grayColor];
    [fenxiangbutton setTitle:@"分享" forState:UIControlStateNormal];
    [fenxiangbutton addTarget:self action:@selector(fenxiangbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:fenxiangbutton];
    [self.view addSubview:view];
   _longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    _longPressGr.minimumPressDuration = 1.0;
    
}
- (void)buttonClick:(UIButton *)button
{
    
        [self.huabiV removeFromSuperview];
        [self.textView removeFromSuperview];
        self.huabiV = [[SDHuaBiView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, KTableViewHeight - KTabBarFrameHeight)];
    
        [self.huabiV addGestureRecognizer:_longPressGr];
//        [self.huabiV setUserInteractionEnabled:YES];
    
        [self.view addSubview:self.huabiV];
    
    
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        _removebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _removebutton.frame = CGRectMake(0, 0, 50, 50);
        _removebutton.backgroundColor = [UIColor redColor];
        [_removebutton addTarget:self action:@selector(removebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.huabiV addSubview:_removebutton];
        
        //add your code here
    }
}
- (void)removebuttonClick:(UIButton *)button
{
    [self.huabiV removeFromSuperview];
    [self.textView removeFromSuperview];
    [_removebutton removeFromSuperview];
}
- (void)luyinbuttonClick:(UIButton *)button
{
    
}
- (void)wenbenbuttonClick:(UIButton *)button
{
    
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.huabiV removeFromSuperview];
        [self.textView removeFromSuperview];
    
        self.textView = [[UITextView alloc] init];
        self.textView.frame = CGRectMake(Kwidth/2.0-150, KTableViewHeight/2.0-100, 300, 200);
        self.textView.backgroundColor = [UIColor grayColor];
        self.textView.font = [UIFont boldSystemFontOfSize:28];
        self.textView.delegate = self;[self.textView resignFirstResponder];
        [self.textView addGestureRecognizer:_longPressGr];
    
     [self.view addSubview:self.textView];
    _removebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _removebutton.frame = CGRectMake(- 25, - 25, 50, 50);
    _removebutton.backgroundColor = [UIColor redColor];
    [_removebutton addTarget:self action:@selector(removebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.textView addSubview:_removebutton];
    _removebutton.clipsToBounds = YES;
    _removebutton.autoresizesSubviews=YES;

    self.textView.clipsToBounds = YES;

    

    if (self.textView != nil) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
        

       
    
}
//键盘将要出现
- (void)handleKeyboardWillShow:(NSNotification *)paramNotification
{
    NSLog(@"键盘即将出现");
    NSValue *value = [[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];//使用UIKeyboardFrameBeginUserInfoKey,会出现切换输入法时获取的搜狗键盘不对.
    CGRect keyboardRect = [value CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    self.textView.transform = CGAffineTransformMakeTranslation(0, -(keyboardH - (Kheight -  CGRectGetMaxY(self.textView.frame))) - 100);

    
}

//键盘将要隐藏
- (void)handleKeyboardWillHide:(NSNotification *)paramNotification
{
    NSLog(@"键盘即将隐藏");
    self.textView.transform = CGAffineTransformIdentity;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.view endEditing:YES];
}

- (void)fenxiangbuttonClick:(UIButton *)button
{
    
    [self ScreenShot];
}
static int ScreenshotIndex = 0;
-(void)ScreenShot{
    
    //这里因为我需要全屏接图所以直接改了，宏定义iPadWithd为1024，iPadHeight为768，
    //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);     //设置截屏大小
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(Kwidth, Kheight), YES, 0);     //设置截屏大小
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    //    CGRect rect = CGRectMake(166, 211, 426, 320);//这里可以设置想要截图的区域
    CGRect rect = CGRectMake(0, 0, Kwidth * 2, (KTableViewHeight-KTabBarFrameHeight)*2);//这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= [NSString stringWithFormat:@"screenShow_%d.png",ScreenshotIndex];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    NSLog(@"截屏路径打印: %@", savedImagePath);
    //这里我将路径设置为一个全局String，这里做的不好，我自己是为了用而已，希望大家别这么写
    [self SetPickPath:savedImagePath];
    
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    CGImageRelease(imageRefRect);
    ScreenshotIndex++;
}
//设置路径
- (void)SetPickPath:(NSString *)PickImage {
    _ScreenshotsPickPath = PickImage;
}
//获取路径<这里我就直接用于邮件推送的代码中去了，能达到效果，但肯定有更好的写法>
- (NSString *)GetPickPath {
    return _ScreenshotsPickPath;
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
