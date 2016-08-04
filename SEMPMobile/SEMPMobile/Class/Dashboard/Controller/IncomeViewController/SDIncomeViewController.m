//
//  SDXiangqingViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/18.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDIncomeViewController.h"
#import "SDHuaBiView.h"
#import "RecordHUD.h"
#import "DataView.h"
#import "DataSearchView.h"


@interface SDIncomeViewController () <UITextViewDelegate>
//nav上的日期视图
@property (nonatomic ,strong) DataView * dataView;
//日期选择视图
@property (nonatomic ,strong) DataSearchView * dataSearchView;
//画笔视图
@property (nonatomic , strong) SDHuaBiView * huabiV ;

@property (nonatomic , strong) NSString * ScreenshotsPickPath;
//文本视图
@property (nonatomic , strong) UITextView * textView ;
//长按手势
@property (nonatomic , strong)  UILongPressGestureRecognizer * longPressGr;

@property (nonatomic , strong) UIButton * removebutton ;
//录音视图
@property (nonatomic , strong) UIView  *luyinView;

@property (nonatomic , strong) D3RecordButton * luyinButtontwo;

@property (nonatomic , strong) D3RecordButton * pofangButtontwo;

@property (nonatomic , assign) BOOL zhuangtai;
@end
@implementation SDIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view setUserInteractionEnabled:YES];
    [self makeNavigation];
    [self maketab];
    // Do any additional setup after loading the view.
}
- (void)makeNavigation
{
    _dataView = [[DataView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width*2/5, 44)];
    
    // dataView视图 相当于navigationItem.titleView  _dataView视图上有一个button与视图一样大，dateLabel和ImageView 添加在button上
    self.navigationItem.titleView  = _dataView;
    _dataView.dateLabel.text = _IncomeDateString;
    // 添加观察者 观察日期变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DateChange) name:@"DateIncomeChange" object:nil];
    
    [_dataView.dateButton addTarget:self action:@selector(dataClick:) forControlEvents:UIControlEventTouchUpInside];
    _dataSearchView = [[DataSearchView alloc] initWithFrame:CGRectMake(50, 10, Main_Screen_Width-100, Main_Screen_Width-100)];
    _dataSearchView.defaultDateString = _IncomeDefaultDateString;
    [_dataSearchView.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self makeLeftButtonItme];

    
}
// 被观察者发生改变时 调用观察者方法
- (void)DateChange
{
    _dataView.dateLabel.text = _dataSearchView.dateString;
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    
}
// 自定义nav上的左边按钮
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
// 返回事件
- (void)backButtonClick:(UIButton *)sender
{
    
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    // 调用block反向传值
    self.IncomeDateBlockValue(_dataView.dateLabel.text,_dataView.dateLabel.text);
    [_dataSearchView removeFromSuperview];
    Btnstatu = YES;
    [self.navigationController popViewControllerAnimated:YES];

}
// 相当于 日期按钮的点击状态
static  BOOL Btnstatu = YES;
// nav上日期按钮点击方法
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
- (void)maketab{
    
    
    
    UITabBar * view = [[UITabBar alloc] initWithFrame:CGRectMake(0, KViewHeight, Main_Screen_Width, BottomBarHeight)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, Main_Screen_Width/4.0, BottomBarHeight);
    [button setTitle:@"画笔" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIButton * luyinbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    luyinbutton.frame = CGRectMake(CGRectGetMaxX(button.frame),0 , Main_Screen_Width/4.0, BottomBarHeight);
    [luyinbutton setTitle:@"录音" forState:UIControlStateNormal];
 
    [luyinbutton addTarget:self action:@selector(luyinbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:luyinbutton];
    UIButton * wenbenbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    wenbenbutton.frame = CGRectMake(CGRectGetMaxX(luyinbutton.frame),0 , Main_Screen_Width/4.0, BottomBarHeight);
    [wenbenbutton setTitle:@"文本" forState:UIControlStateNormal];
    [wenbenbutton addTarget:self action:@selector(wenbenbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:wenbenbutton];
    UIButton * fenxiangbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fenxiangbutton.frame = CGRectMake(CGRectGetMaxX(wenbenbutton.frame), 0, Main_Screen_Width/4.0, BottomBarHeight);
    [fenxiangbutton setTitle:@"分享" forState:UIControlStateNormal];
    [fenxiangbutton addTarget:self action:@selector(fenxiangbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:fenxiangbutton];
    [self.view addSubview:view];
   _longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    _longPressGr.minimumPressDuration = 1.0;
    
}
- (void)buttonClick:(UIButton *)button
{
    [self.luyinView removeFromSuperview];

      self.zhuangtai = NO;
    
        [self.huabiV removeFromSuperview];
        [self.textView removeFromSuperview];
        self.huabiV = [[SDHuaBiView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, KViewHeight)];

        [self.huabiV addGestureRecognizer:_longPressGr];
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.huabiV removeFromSuperview];
    [self.textView removeFromSuperview];

    
    
    if (button.selected == self.zhuangtai) {
        
        _luyinView = [[UIView alloc] initWithFrame:CGRectMake(Main_Screen_Width/4.0  , KViewHeight  - 50, Main_Screen_Width/4.0, 50)];
        _luyinView.backgroundColor = [UIColor redColor];
        
        _luyinButtontwo = [D3RecordButton buttonWithType:UIButtonTypeRoundedRect];
        
        _luyinButtontwo.frame = CGRectMake(0, 0, Main_Screen_Width/8.0, 50);
        
        _luyinButtontwo.backgroundColor = [UIColor grayColor];
        [_luyinButtontwo setTitle:@"录音" forState:UIControlStateNormal];
        
        [_luyinView addSubview:_luyinButtontwo];
        
        _pofangButtontwo = [D3RecordButton buttonWithType:UIButtonTypeRoundedRect];
        
        _pofangButtontwo.frame = CGRectMake(Main_Screen_Width/8.0, 0, Main_Screen_Width/8.0, 50);
        
        _pofangButtontwo.backgroundColor = [UIColor yellowColor];
        [_pofangButtontwo setTitle:@"播放" forState:UIControlStateNormal];
        
        [_luyinView addSubview:_pofangButtontwo];
        [_pofangButtontwo addTarget:self action:@selector(pofangButtontwoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_luyinView];
        
        _zhuangtai = YES;
        [_luyinButtontwo initRecord:self maxtime:60 title:@"按住录音"];

    }else{
        
        [self.luyinView removeFromSuperview];
        _zhuangtai = NO;

    }
    
    
    

}
- (void)pofangButtontwoClick:(UIButton *)button
{
    play.volume = 1.0f;
    [play play];
}

-(void)endRecord:(NSData *)voiceData{
    NSError *error;
    play = [[AVAudioPlayer alloc]initWithData:voiceData error:&error];

}

- (void)wenbenbuttonClick:(UIButton *)button
{
        [self.luyinView removeFromSuperview];
    
        self.zhuangtai = NO;
    
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.huabiV removeFromSuperview];
        [self.textView removeFromSuperview];
    
        self.textView = [[UITextView alloc] init];
        self.textView.frame = CGRectMake(Main_Screen_Width/2.0-150, KViewHeight/2.0-100, 300, 200);
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

//    self.textView.clipsToBounds = YES;

    

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
    self.textView.transform = CGAffineTransformMakeTranslation(0, -(keyboardH - (Main_Screen_Height -  CGRectGetMaxY(self.textView.frame))) - 100);

    
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
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(Main_Screen_Width, KViewHeight), YES, 0);     //设置截屏大小
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    //    CGRect rect = CGRectMake(166, 211, 426, 320);//这里可以设置想要截图的区域
    CGRect rect = CGRectMake(0, NavgationHeight, Main_Screen_Height * 2, (Main_Screen_Height)*2);//这里可以设置想要截图的区域
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
