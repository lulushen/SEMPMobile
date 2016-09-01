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
#import "IncomeTableViewCell.h"
#import "IncomeTableViewTopCell.h"
#import "IncomeTableViewChartCell.h"
#import "PNChart.h"
#import "CFLineChartView.h"

#define PNArc4randomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
@interface SDIncomeViewController () <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,PNChartDelegate,UIAlertViewDelegate>
//nav上的日期视图
@property (nonatomic ,strong) DataView * dataView;
//日期选择视图
@property (nonatomic ,strong) DataSearchView * dataSearchView;
//画笔视图
@property (nonatomic , strong) SDHuaBiView * huabiV ;

@property (nonatomic , strong) NSString * ScreenshotsPickPath;
//文本标签
@property (nonatomic , strong) UIView * wenBenView ;
//文本
@property (nonatomic , strong) UITextView * textView;
//长按手势
@property (nonatomic , strong)  UILongPressGestureRecognizer * longPressGr;

@property (nonatomic , strong) UIButton * removebutton ;
//录音
@property (nonatomic , strong) UIImageView  *luyinImageView;

@property (nonatomic , strong) D3RecordButton * luyinButtontwo;

@property (nonatomic , strong) D3RecordButton * pofangButtontwo;

@property (nonatomic , assign) BOOL zhuangtai;
//折线图
@property (nonatomic , strong)PNLineChart * lineChart;

//柱形图
@property (nonatomic , strong)PNBarChart * barChart;
@property (nonatomic, strong) CFLineChartView *LCView;

//扇形图
@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) PNPieChart *midvalPieChart;
#warning 实验
// tableView
@property (nonatomic , strong) UITableView * IncomeTableView;

//实际数据折线上点的路径
@property (nonatomic , assign) NSInteger pointIndexPath;

@property (nonatomic , strong) UILabel * label;

@property (nonatomic , strong)NSString * Time;

@end
@implementation SDIncomeViewController

//懒加载
- (IncomeDashModel *)incomeDashModel
{
    if (_incomeDashModel) {
        _incomeDashModel = [[IncomeDashModel alloc] init];
    }
    return _incomeDashModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
#pragma ==nav方法 头
    [self makeNavigation];
    
#warning tableView方法
    [self makeTableView];
    
#pragma ==tab方法 尾
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DateChange) name:@"DateChange" object:nil];
    
    [_dataView.dateButton addTarget:self action:@selector(dataClick:) forControlEvents:UIControlEventTouchUpInside];
    _dataSearchView = [[DataSearchView alloc] initWithFrame:CGRectMake(50, 10, Main_Screen_Width-100, Main_Screen_Width-100)];
    _dataSearchView.defaultDateString = _IncomeDefaultDateString;
    [_dataSearchView.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self makeLeftButtonItme];
    
    
}
// 被观察者发生改变时 调用观察者方法
- (void)DateChange
{
    NSString * date = [[NSUserDefaults standardUserDefaults] objectForKey:@"DateChange"];
    
    _dataView.dateLabel.text = date;
    
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    
    _Time = [_dataSearchView.defaultDateString stringByReplacingOccurrencesOfString:@"年" withString:@""];
    
    _Time = [_Time stringByReplacingOccurrencesOfString:@"月" withString:@""];
    
    _Time = [_Time stringByReplacingOccurrencesOfString:@"日" withString:@""];

    
    NSLog(@"------_time---%@",_Time);
    
    [_dataSearchView removeFromSuperview];
    [self makeIncomeDate:_Time];

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
    
    //    NSString * date = [[NSUserDefaults standardUserDefaults] objectForKey:@"dateChange"];
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    
    _dataSearchView.dateString =  _dataSearchView.defaultDateString;
    
    
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

- (void)makeIncomeDate:(NSString *)Time
{
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        

        // 指标界面的接口
        NSString * urlStr = [NSString stringWithFormat:IncomeHttp,_IndexID,_Time];
        
        NSLog(@"--------urlstr---%@",urlStr);
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //成功
            
            NSLog(@"----index--%@",responseObject);
            if (responseObject != nil) {
                
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                dict = responseObject[@"resdata"];
                
                if (dict != nil) {
                    
                  
                    IncomeDashModel * model = [[IncomeDashModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dict];
                    
                  
                    self.incomeDashModel = model;
                    
//                    // tabbar的显示和隐藏
//                    self.hidesBottomBarWhenPushed=YES;
//                    
//                    [self.navigationController pushViewController:incomeVC animated:YES];
//                    
//                    self.hidesBottomBarWhenPushed=NO;
                    
                    [_IncomeTableView reloadData];
                    
                }
                
            }else{
                
                NSLog(@"数据为空");
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
        }];
        
    });
    
}
- (void)buttonClick:(UIButton *)button
{
    [_luyinImageView removeFromSuperview];
    
    self.zhuangtai = NO;
    
    [self.huabiV removeFromSuperview];
    [_wenBenView removeFromSuperview];
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
    [self.wenBenView removeFromSuperview];
    [_removebutton removeFromSuperview];
}
- (void)luyinbuttonClick:(UIButton *)button
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.huabiV removeFromSuperview];
    [self.wenBenView removeFromSuperview];
    
    
    
    if (button.selected == self.zhuangtai) {
        
        _luyinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/4.0  , KViewHeight  - 50, Main_Screen_Width/4.0, 50)];
        _luyinImageView.alpha = 0.8;
        _luyinImageView.image = [UIImage imageNamed:@"qipao.png"];
        _luyinButtontwo = [D3RecordButton buttonWithType:UIButtonTypeCustom];
        
        _luyinButtontwo.frame = CGRectMake(0, 0, Main_Screen_Width/8.0, CGRectGetHeight(_luyinImageView.frame)-10);
        
        [_luyinButtontwo setImage:[UIImage imageNamed:@"luyin.png"] forState:UIControlStateNormal];
        
        [_luyinImageView addSubview:_luyinButtontwo];
        
        _luyinButtontwo.userInteractionEnabled = YES;
        _luyinImageView.userInteractionEnabled = YES;
        
        _pofangButtontwo = [D3RecordButton buttonWithType:UIButtonTypeCustom];
        
        _pofangButtontwo.frame = CGRectMake(CGRectGetMaxX(_luyinButtontwo.frame), 0, Main_Screen_Width/8.0, CGRectGetHeight(_luyinButtontwo.frame));
        
        [_pofangButtontwo setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
        [_luyinImageView addSubview:_pofangButtontwo];
        [_pofangButtontwo addTarget:self action:@selector(pofangButtontwoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_luyinImageView];
        
        _zhuangtai = YES;
        
        [_luyinButtontwo initRecord:self maxtime:60 title:@"按住录音"];
        
    }else{
        
        [_luyinImageView removeFromSuperview];
        
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
    [_luyinImageView removeFromSuperview];
    
    self.zhuangtai = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.huabiV removeFromSuperview];
    [self.wenBenView removeFromSuperview];
    
    self.wenBenView = [[UIView alloc] init];
    self.wenBenView.frame = CGRectMake(Main_Screen_Width/2.0-150, KViewHeight/2.0-100, 300, 200);
    [self.view addSubview:self.wenBenView];
    
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(0, 20, CGRectGetWidth(_wenBenView.frame),CGRectGetHeight(_wenBenView.frame)-25);
    _textView.delegate = self;
    [_textView resignFirstResponder];
    _textView.font = [UIFont boldSystemFontOfSize:28];
    [_textView addGestureRecognizer:_longPressGr];
    
    [_wenBenView addSubview:_textView];
    
    _textView.backgroundColor = [UIColor orangeColor];
    _textView.alpha = 0.5;
    _removebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _removebutton.frame = CGRectMake(CGRectGetMaxX(_textView.frame)-20, 0, 40, 40);
    [_removebutton setImage:[UIImage imageNamed:@"wenBenDelete.png"] forState:UIControlStateNormal];
    [_removebutton addTarget:self action:@selector(removebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_wenBenView addSubview:_removebutton];
    _removebutton.clipsToBounds = YES;
    _removebutton.autoresizesSubviews=YES;
    
    if (_textView != nil) {
        
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
    _wenBenView.transform = CGAffineTransformMakeTranslation(0, -(keyboardH - (Main_Screen_Height -  CGRectGetMaxY(_wenBenView.frame))) - 100);
}

//键盘将要隐藏
- (void)handleKeyboardWillHide:(NSNotification *)paramNotification
{
    NSLog(@"键盘即将隐藏");
    _wenBenView.transform = CGAffineTransformIdentity;
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
- (void)maketab{
    UITabBar * view = [[UITabBar alloc] initWithFrame:CGRectMake(0, KViewHeight, Main_Screen_Width, BottomBarHeight)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, Main_Screen_Width/4.0, BottomBarHeight);
    [button setImage:[[UIImage imageNamed:@"IncomeHuaBi.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIButton * luyinbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    luyinbutton.frame = CGRectMake(CGRectGetMaxX(button.frame),0 , Main_Screen_Width/4.0, BottomBarHeight);
    [luyinbutton setImage:[[UIImage imageNamed:@"IncomeLunYin.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [luyinbutton addTarget:self action:@selector(luyinbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:luyinbutton];
    UIButton * textButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    textButton.frame = CGRectMake(CGRectGetMaxX(luyinbutton.frame),0 , Main_Screen_Width/4.0, BottomBarHeight);
    [textButton setImage:[[UIImage imageNamed:@"IncomeText.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [textButton addTarget:self action:@selector(wenbenbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:textButton];
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame = CGRectMake(CGRectGetMaxX(textButton.frame), 0, Main_Screen_Width/4.0, BottomBarHeight);
    [shareButton setImage:[[UIImage imageNamed:@"IncomeShare.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [shareButton addTarget:self action:@selector(fenxiangbuttonClick:) forControlEvents: UIControlEventTouchUpInside];
    [view addSubview:shareButton];
    [self.view addSubview:view];
    _longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    _longPressGr.minimumPressDuration = 1.0;
    
}


#warning tableView

- (void)makeTableView
{
    _IncomeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KViewHeight) style:UITableViewStyleGrouped];
    _IncomeTableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_IncomeTableView];
    //去掉分割线
    _IncomeTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _IncomeTableView.delegate = self;
    
    _IncomeTableView.dataSource = self;
    // cell重用标示
    //    [_IncomeTableView registerClass:[IncomeTableViewCell class] forCellReuseIdentifier:@"IncomeCell"];
    //    [_IncomeTableView registerClass:[IncomeTableViewTopCell class] forCellReuseIdentifier:@"IncomeTopCell"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0 && indexPath.row == 0) {
        
        IncomeTableViewTopCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            
            cell =  [[IncomeTableViewTopCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"TopCell"] ;
            NSLog(@"-----model   -- %@",_incomeDashModel);
            
            
            cell.titleLabel.text = _incomeDashModel.midval;
            cell.bottomtitleLabel.text = _incomeDashModel.contrastVal[@"name"];
            cell.bottomvalLabel.text = _incomeDashModel.bottomval;
            cell.bottomunitLable.text = _incomeDashModel.bottomunit;
            //            cell.bottomtitleTwoLabel.text = @"环比";
            //            cell.bottomvalTwoLabel.text = @"7%";
            cell.titleImage.image = [UIImage imageNamed:@"sanjiao.png"];
        }
        
        
        return cell;
    }else  if(indexPath.row == 1){
        
        IncomeTableViewChartCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell =  [[IncomeTableViewChartCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"ChartCell"] ;
        
        
        [self incomeTableViewChartCell:cell indexPath:indexPath];
        
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell =  [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell2"] ;
        cell.textLabel.text = @"收入结构";
        return cell;
        
    }else{
        
        IncomeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell =  [[IncomeTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"] ;
        [self incomeTableViewCell:cell indexPath:indexPath];
        
        return cell;
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        if (indexPath.section == 0) {
            return 100;
        }else{
            return 50;
        }
        
    }else if(indexPath.row == 1){
        return 300;
        
    }else{
        return (_IncomeTableView.frame.size.height - 400)/3.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 图表代理方法PNChartDelegate
- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"----Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
    _lineChart.showCoordinateAxis = NO;
    
    //    if (lineIndex == 0) {
    
    
    _pointIndexPath = (int)pointIndex;
    
    //    }else{
    //
    //        _pointIndexPath = (int)pointIndex;
    //    }
    
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:3 inSection:0];
    NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:4 inSection:0];
    
    [_IncomeTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,indexPath2,indexPath3,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}
- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex
{
    NSLog(@"12-------pieIndex--%ld",pieIndex);
    _pointIndexPath = (int)pieIndex;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:3 inSection:0];
    NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:4 inSection:0];
    
    [_IncomeTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,indexPath2,indexPath3,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)didUnselectPieItem{
    
    // 扇形中间的圆形
}
//

- (void)incomeTableViewChartCell:(IncomeTableViewChartCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    
    cell.midvalTitleLabel.text = _incomeDashModel.defaultVal[@"name"];
    cell.bottomTitleLabel.text = _incomeDashModel.contrastVal[@"name"];
    cell.midvalColorLabel.backgroundColor = [UIColor orangeColor];
    cell.bottomvalColorLabel.backgroundColor = MoreButtonColor;
    NSMutableArray * XdefaultValValueArray = [NSMutableArray arrayWithArray:[_incomeDashModel.defaultVal valueForKey:@"x"]];
    NSMutableArray * YdefaultValValueArray = [NSMutableArray arrayWithArray:[_incomeDashModel.defaultVal valueForKey:@"y"]];
    NSMutableArray * XcontrastValValueArray = [NSMutableArray arrayWithArray:[_incomeDashModel.contrastVal valueForKey:@"x"]];
    NSMutableArray * YcontrastValValueArray = [NSMutableArray arrayWithArray:[_incomeDashModel.contrastVal valueForKey:@"y"]];
    
    if ((XdefaultValValueArray.count == 0) && (YdefaultValValueArray.count == 0) && (XcontrastValValueArray.count ==0) && (YcontrastValValueArray.count == 0)) {
        
    }else{
        
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0,Main_Screen_Width-40*KWidth6scale,220*KHeight6scale)];
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lineChart.frame), CGRectGetMinY(_lineChart.frame), CGRectGetWidth(_lineChart.frame), CGRectGetHeight(_lineChart.frame))];
        
        if ([_incomeDashModel.charttype isEqualToString:@"line_chart"]) {
            
            
            _lineChart.backgroundColor = [UIColor redColor];
            [self makeLine];
            _lineChart.yUnit = _incomeDashModel.unit;
            [_lineChart setXLabels:XdefaultValValueArray];
            
            PNLineChartData * data01 = [PNLineChartData new];
            data01.color = [UIColor orangeColor];
            data01.itemCount = self.lineChart.xLabels.count;
            data01.alpha = 0.8f;
            data01.lineWidth = 2.f;
            //        data01.showPointLabel = YES;
            
            data01.inflexionPointWidth = 4;
            data01.inflexionPointStyle = PNLineChartPointStyleCircle;
            data01.getData = ^(NSUInteger index){
                
                CGFloat yValue = [YdefaultValValueArray[index] floatValue];
                
                return [PNLineChartDataItem dataItemWithY:yValue andRawY:yValue];
                
            };
            if (_incomeDashModel.contrastVal.count == 0) {
                
                self.lineChart.chartData = @[data01];
                
            }else{
                // Line Chart #2
                [_lineChart setXLabels:XcontrastValValueArray];
                
                PNLineChartData *data02 = [PNLineChartData new];
                
                data02.color = MoreButtonColor;
                
                data02.alpha = 0.8f;
                
                data02.itemCount = self.lineChart.xLabels.count;
                
                data02.inflexionPointWidth = 4;
                
                data02.inflexionPointStyle = PNLineChartPointStyleCircle;
                
                data02.getData = ^(NSUInteger index) {
                    
                    CGFloat yValue = [YcontrastValValueArray[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                
                self.lineChart.chartData = @[data01, data02];
                
            }
            _lineChart.delegate = self;
            
            [_lineChart strokeChart];
            [cell.chartView addSubview:_lineChart];
            
        }else if ([_incomeDashModel.charttype isEqualToString:@"pie_chart"]){
            
#warning ====存不存在实际值为空，对比值不为空的情况＝＝＝＝
            if (_incomeDashModel.contrastVal.count == 0) {
                NSMutableArray *items  = [NSMutableArray array];
                int i = 0;
                
                for (NSString * value in YdefaultValValueArray) {
                    
                    PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:PNArc4randomColor description:XdefaultValValueArray[i]];
                    [items addObject:item];
                    i++;
                }
                
                _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(50*KWidth6scale,10*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale) items:items];
                _pieChart.descriptionTextColor = [UIColor whiteColor];
                _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                _pieChart.descriptionTextShadowColor = [UIColor clearColor];
                _pieChart.showAbsoluteValues = NO;
                _pieChart.showOnlyValues = YES;
                [_pieChart strokeChart];
                _pieChart.legendStyle = PNLegendItemStyleSerial;
                _pieChart.legendFont = [UIFont systemFontOfSize:12.0f];
                _pieChart.legendFontColor = [UIColor grayColor];
                _pieChart.delegate = self;
                
                UIView *legend = [self.pieChart getLegendWithMaxWidth:10];
                
                [legend setFrame:CGRectMake(CGRectGetMaxX(_pieChart.frame)+10*KWidth6scale, CGRectGetMinY(_pieChart.frame), legend.frame.size.width, legend.frame.size.height)];
                
                [cell.chartView addSubview:legend];
                
                [cell.chartView addSubview:self.pieChart];
                
                
            }else{
                if (_incomeDashModel.contrastVal.count == 0) {
                    
                }else{
                    [cell.chartView addSubview:cell.scrollView];
                    //            cell.scrollView.directionalLockEnabled=YES;//定向锁定
                    NSMutableArray *items  = [NSMutableArray array];
                    int i = 0;
                    
                    for (NSString * value in YdefaultValValueArray) {
                        
                        PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:PNArc4randomColor description:XdefaultValValueArray[i]];
                        [items addObject:item];
                        i++;
                    }
                    _midvalPieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(50*KWidth6scale, 10*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale) items:items];
                    _midvalPieChart.descriptionTextColor = [UIColor whiteColor];
                    _midvalPieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                    _midvalPieChart.descriptionTextShadowColor = [UIColor clearColor];
                    _midvalPieChart.showAbsoluteValues = NO;
                    _midvalPieChart.showOnlyValues = YES;
                    _midvalPieChart.delegate = self;
                    
                    [_midvalPieChart strokeChart];
                    _midvalPieChart.legendStyle = PNLegendItemStyleStacked;
                    _midvalPieChart.legendFont = [UIFont systemFontOfSize:12.0f];
                    _midvalPieChart.legendFontColor = [UIColor grayColor];
                    
                    
                    UIView *legend = [self.midvalPieChart getLegendWithMaxWidth:60*KWidth6scale];
                    
                    [legend setFrame:CGRectMake(CGRectGetMaxX(_midvalPieChart.frame)+10*KWidth6scale, CGRectGetMinY(_midvalPieChart.frame), legend.frame.size.width, legend.frame.size.height)];
                    
                    [cell.scrollView addSubview:legend];
                    
                    [cell.scrollView addSubview:self.midvalPieChart];
                    
                    
                    NSMutableArray *items2  = [NSMutableArray array];
                    int j = 0;
                    
                    for (NSString * value in YcontrastValValueArray) {
                        
                        PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:PNArc4randomColor description:XcontrastValValueArray[j]];
                        [items2 addObject:item];
                        i++;
                    }
                    
                    _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(Main_Screen_Width + 10*KWidth6scale, 10*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale) items:items2];
                    _pieChart.descriptionTextColor = [UIColor whiteColor];
                    _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                    _pieChart.showAbsoluteValues = NO;
                    _pieChart.showOnlyValues = YES;
                    _pieChart.delegate = self;
                    _pieChart.descriptionTextShadowColor = [UIColor clearColor];
                    
                    [_pieChart strokeChart];
                    _pieChart.legendStyle = PNLegendItemStyleStacked;
                    _pieChart.legendFont = [UIFont systemFontOfSize:12.0f];
                    _pieChart.legendFontColor = [UIColor grayColor];
                    
                    
                    UIView *legend2 = [self.pieChart getLegendWithMaxWidth:60*KWidth6scale];
                    
                    [legend2 setFrame:CGRectMake(CGRectGetMaxX(_pieChart.frame)+10*KWidth6scale, CGRectGetMinY(_pieChart.frame), legend.frame.size.width, legend.frame.size.height)];
                    
                    [cell.scrollView addSubview:legend2];
                    
                    [cell.scrollView addSubview:self.pieChart];
                    
                    
                }
            }
        }else if([_incomeDashModel.charttype isEqualToString:@"text"] | [_incomeDashModel.charttype isEqualToString:@"long_text"] | [_incomeDashModel.charttype isEqualToString:@"bar_chart"]){
            
            CFLineChartView * LCView = [CFLineChartView lineChartViewWithFrame:CGRectMake(0,0, CGRectGetWidth(_lineChart.frame), CGRectGetHeight(_lineChart.frame))];
            [cell.chartView addSubview:LCView];
            
         
            // 画图
            if ((_incomeDashModel.defaultVal.count !=0 )&& (_incomeDashModel.contrastVal.count !=0)) {
                // 如果实际值和对比值的数据都不为空
                if ((XdefaultValValueArray.count != 0) && (YdefaultValValueArray.count != 0) && (XcontrastValValueArray.count != 0)&&(YcontrastValValueArray.count != 0) ) {
                    
                    // 数组中最大值
                    NSNumber* defaultValMaxValue = [YdefaultValValueArray valueForKeyPath:@"@max.floatValue"];
                    NSNumber* contrastValMaxValue = [YcontrastValValueArray valueForKeyPath:@"@max.floatValue"];
                    if ([defaultValMaxValue floatValue]> [contrastValMaxValue floatValue]) {
                        
                        LCView.yValues = YdefaultValValueArray;
                        LCView.xValues = XdefaultValValueArray;
                        
                    }else{
                        
                        LCView.yValues = YcontrastValValueArray;
                        LCView.xValues = XcontrastValValueArray;
                    }
                    
                    // 绘制图的基本
                    [LCView drawChartWithLineChartType:0 pointType:1];
                    // 画柱状图
                    [LCView drawPillarYvalues:YdefaultValValueArray];
                    // 画折线图
                    [LCView drawFoldLineWithLineChartType:0 Yvalues:YcontrastValValueArray];
                    
                }else if ((( XdefaultValValueArray.count == 0 ) && ( YdefaultValValueArray.count == 0 )) && (( XcontrastValValueArray.count != 0 )&& (YcontrastValValueArray.count != 0))){
                    // 如果实际值为空，对比值不为空
                    
                    LCView.xValues = XcontrastValValueArray;
                    LCView.yValues = YcontrastValValueArray;
                    // 绘制图的基本
                    [LCView drawChartWithLineChartType:0 pointType:1];
                    
                    // 画折线图
                    [LCView drawFoldLineWithLineChartType:0 Yvalues:YcontrastValValueArray];
                    

                    
                }else if ((( XdefaultValValueArray.count != 0 ) && ( YdefaultValValueArray.count != 0 )) && (( XcontrastValValueArray.count == 0 )&& (YcontrastValValueArray.count == 0))){
                    // 如果实际值不为空，对比值为空
                    LCView.xValues = XdefaultValValueArray;
                    LCView.yValues = YdefaultValValueArray;
                    
                    // 绘制图的基本
                    [LCView drawChartWithLineChartType:0 pointType:1];
                    // 画柱状图
                    [LCView drawPillarYvalues:YdefaultValValueArray];
                    

                }else{
                    
                    
                    
                }
                
                
            }else if((_incomeDashModel.defaultVal.count ==0 )&& (_incomeDashModel.contrastVal.count !=0)){
                // 如果实际值为空，对比值不为空
                
                LCView.xValues = XcontrastValValueArray;
                LCView.yValues = YcontrastValValueArray;
                // 绘制图的基本
                [LCView drawChartWithLineChartType:0 pointType:1];
                
                // 画折线图
                [LCView drawFoldLineWithLineChartType:0 Yvalues:YcontrastValValueArray];

            }else if((_incomeDashModel.defaultVal.count !=0 )&& (_incomeDashModel.contrastVal.count ==0)){
                // 如果实际值不为空，对比值为空
                LCView.xValues = XdefaultValValueArray;
                LCView.yValues = YdefaultValValueArray;
                
                // 绘制图的基本
                [LCView drawChartWithLineChartType:0 pointType:1];
                // 画柱状图
                [LCView drawPillarYvalues:YdefaultValValueArray];
            
            }else{
                // 如果实际值和对比值都为空
            }
            
        }
        
    }
    
}
// 此方法把下面三个cell和cell的indexPath出来
- (void)incomeTableViewCell:(IncomeTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 2) {
        cell.titleLabel.text = @"实际值：x,y";
        NSMutableArray * arrX = [NSMutableArray arrayWithArray:_incomeDashModel.defaultVal[@"x"]];
        NSMutableArray * arrY = [NSMutableArray arrayWithArray:_incomeDashModel.defaultVal[@"y"]];
        if ((arrX.count == 0  ) | (arrY.count == 0 )) {
            
            cell.ValueLabel.text = [NSString stringWithFormat:@"%@,%@",@"",@""];
            
        }else{
            
            cell.ValueLabel.text =[NSString stringWithFormat:@"%@,%@",_incomeDashModel.defaultVal[@"x"][_pointIndexPath],_incomeDashModel.defaultVal[@"y"][_pointIndexPath]] ;
        }
        
        
        
        
    }else if (indexPath.row == 3)
    {
        cell.titleLabel.text = @"对比值：x,y";
        
        
        NSMutableArray * arrX = [NSMutableArray arrayWithArray:_incomeDashModel.contrastVal[@"x"]];
        NSMutableArray * arrY = [NSMutableArray arrayWithArray:_incomeDashModel.contrastVal[@"y"]];
        
        if ((arrX.count == 0  ) | (arrY.count == 0 )) {
            
            cell.ValueLabel.text = [NSString stringWithFormat:@"%@,%@",@"",@""];
            
        }else{
            cell.ValueLabel.text = [NSString stringWithFormat:@"%@,%@",_incomeDashModel.contrastVal[@"x"][_pointIndexPath],_incomeDashModel.contrastVal[@"y"][_pointIndexPath]];
        }
        
    }else{
        
        cell.titleLabel.text = @"实际值：y";
        NSMutableArray * arrY = [NSMutableArray arrayWithArray:_incomeDashModel.defaultVal[@"y"]];
        if ( (arrY.count == 0 )) {
            
            cell.ValueLabel.text = [NSString stringWithFormat:@"%@",@""];
            
        }else{
            cell.ValueLabel.text = _incomeDashModel.defaultVal[@"y"][_pointIndexPath];        }
        
        
    }
    
    
}
// 折线图
- (void)makeLine
{
    _lineChart.userInteractionEnabled = YES;
    _lineChart.backgroundColor = [UIColor clearColor];
    _lineChart.legendStyle =  PNLegendItemStyleSerial;
    _lineChart.showCoordinateAxis = YES;
    _lineChart.showGenYLabels = YES;
    _lineChart.showLabel = YES;
    _lineChart.delegate = self;
    
    
    //    self.lineChart.yLabelColor =[UIColor whiteColor];
    //    self.lineChart.xLabelColor = [UIColor whiteColor];
    
    // 小数点
    //    _lineChart.thousandsSeparator = YES;
    
}

// 柱状图
- (void)makeBar
{
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.yChartLabelWidth = 20.0;
    //    _barChart.chartBorderColor = [UIColor whiteColor];
    //    _barChart.strokeColor = [UIColor whiteColor];
    _barChart.chartMarginLeft = 30.0;
    _barChart.chartMarginRight = 10.0;
    _barChart.chartMarginTop = 5.0;
    _barChart.chartMarginBottom = 10.0;
    _barChart.barBackgroundColor = [UIColor clearColor];
    _barChart.delegate = self;
    //    _barChart.labelTextColor = [UIColor whiteColor];
    _barChart.labelFont = [UIFont systemFontOfSize:12];
    _barChart.labelMarginTop = 5.0;
    _barChart.showChartBorder = YES;
    _barChart.delegate = self;
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
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
