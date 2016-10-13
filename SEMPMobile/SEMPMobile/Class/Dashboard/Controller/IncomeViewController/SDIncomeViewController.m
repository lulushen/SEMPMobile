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


@interface SDIncomeViewController () <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,PNChartDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    UIButton * backButton;
}
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

@property (nonatomic , assign) BOOL status;
//折线图
@property (nonatomic , strong) PNLineChart * defaultLineChart;
@property (nonatomic , strong) PNLineChart * contrastLineChart;

//柱形图
@property (nonatomic , strong) PNBarChart * defaultBarChart;
@property (nonatomic , strong) PNBarChart * contrastBarChart;
@property (nonatomic , strong) CFLineChartView *LCView;

//扇形图
@property (nonatomic , strong) PNPieChart *defaultPieChart;
@property (nonatomic , strong) PNPieChart *contrastPieChart;
// tableView
@property (nonatomic , strong) UITableView * IncomeTableView;

//实际数据折线上点的路径
@property (nonatomic , assign) NSInteger pointIndexPath;
// show点label
@property (nonatomic , strong) UIButton * pointButton;
// 折线图上的xy数组（实际和对比）
@property (nonatomic , strong)NSMutableArray * XdefaultValValueArray;
@property (nonatomic , strong)NSMutableArray * YdefaultValValueArray;
@property (nonatomic , strong)NSMutableArray * XcontrastValValueArray;
@property (nonatomic , strong)NSMutableArray * YcontrastValValueArray;

//用来判断实际值折线图或是对比值折线图
@property (nonatomic , strong)NSString * LineString;

//右滑手势
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
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
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    [self makeTableView];
    
    [self makeNavigation];

    [self maketab];
    
    [self makeIncomeDate:_Time];
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
    [self.view addSubview:_dataSearchView];
    _dataSearchView.alpha = 0.0f;
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
    

    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        _IncomeTableView.alpha = 1;
        _IncomeTableView.userInteractionEnabled = YES;
        _dataSearchView.alpha = 0.0f;
        
    } completion:nil];

    
    [self makeIncomeDate:_Time];
    
}
// 自定义nav上的左边按钮
- (void)makeLeftButtonItme
{
    UIImage * backImage = [UIImage imageNamed:@"back.png"];
    CGRect backframe = CGRectMake(0, 0, BackButtonWidth, BackButtonHeight);
    backButton = [[UIButton alloc] initWithFrame:backframe];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}
// 返回事件
- (void)backButtonClick:(UIButton *)sender
{
    
    _dataSearchView.defaultDateString = _dataView.dateLabel.text;
    
    _dataSearchView.dateString =  _dataSearchView.defaultDateString;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        _IncomeTableView.alpha = 1;
        _IncomeTableView.userInteractionEnabled = YES;
        _dataSearchView.alpha = 0.0f;
        
    } completion:nil];
    
    Btnstatu = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}
// 相当于 日期按钮的点击状态
static  BOOL Btnstatu = YES;
// nav上日期按钮点击方法
-(void)dataClick:(UIButton *)button
{
    
    if (button.selected == Btnstatu) {

        Btnstatu = YES;
        
    }else{
        // 点击日期按钮时 相当于默认点击日期选择视图中的月按钮
        [_dataSearchView mouthButtonClick:_dataSearchView.mouthButton];
        
        Btnstatu = NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        _IncomeTableView.alpha = 0.5;
        _IncomeTableView.userInteractionEnabled = NO;
        _dataSearchView.alpha = 1.0f;
        
    } completion:nil];
    
}
// 日期视图中的关闭事件
- (void)deleteButtonClick:(UIButton *)button
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        _IncomeTableView.alpha = 1;
        _IncomeTableView.userInteractionEnabled = YES;
        _dataSearchView.alpha = 0.0f;
        
    } completion:nil];

    
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
        
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //成功
            NSLog(@"%@",responseObject);
            if (responseObject != nil) {
                // 内存问题
//                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                NSMutableDictionary * dict = nil;
                dict = responseObject[@"resdata"];
                NSLog(@"--==%@",dict);
                
                if (dict != nil) {
                    
                    
                    IncomeDashModel * model = [[IncomeDashModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dict];
                    
                    
                    
                    self.incomeDashModel = model;

                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                       [_IncomeTableView reloadData];
                    });

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
// 画笔按钮
- (void)buttonClick:(UIButton *)button
{
    [_luyinImageView removeFromSuperview];
    
    self.status = NO;
    
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
        
        [_removebutton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
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
    
    
    if (button.selected == self.status) {
        
        _luyinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/4.0  , KViewHeight  - 50, Main_Screen_Width/4.0, 50)];
        _luyinImageView.alpha = 0.8;
        _luyinImageView.image = [UIImage imageNamed:@"qipao.png"];
        _luyinButtontwo = [D3RecordButton buttonWithType:UIButtonTypeCustom];
        
        _luyinButtontwo.frame = CGRectMake(0, 0, Main_Screen_Width/8.0, CGRectGetHeight(_luyinImageView.frame)-10);
        _status = YES;
        //        [_luyinButtontwo addTarget:self action:@selector(luyinButtontwoClick:) forControlEvents:UIControlEventTouchUpInside];
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
        
        [_luyinButtontwo initRecord:self maxtime:120 title:@"按住录音"];
        
        
    }else{
        
        [_luyinImageView removeFromSuperview];
        
        _status = NO;
        
    }
    
    
    
    
}

- (void)pofangButtontwoClick:(UIButton *)button
{
    // volume不能等于0，volume的值范围是0～1，设置音量大小
    play.volume = 1.0f;
    [play play];
}

-(void)endRecord:(NSData *)voiceData{
    NSError *error;
    
    play = [[AVAudioPlayer alloc] initWithData:voiceData error:&error];
    
    
}

- (void)wenbenbuttonClick:(UIButton *)button
{
    [_luyinImageView removeFromSuperview];
    
    self.status = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.huabiV removeFromSuperview];
    [self.wenBenView removeFromSuperview];
    
    self.wenBenView = [[UIView alloc] init];
    self.wenBenView.frame = CGRectMake(Main_Screen_Width/2.0-150, KViewHeight/2.0-100, 320, 200);
    [self.view addSubview:self.wenBenView];
    
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(0, 20, CGRectGetWidth(_wenBenView.frame)-20,CGRectGetHeight(_wenBenView.frame)-25);
    _textView.delegate = self;
    [_textView resignFirstResponder];
    _textView.font = [UIFont boldSystemFontOfSize:20];
//    [_textView addGestureRecognizer:_longPressGr];
    
    [_wenBenView addSubview:_textView];
    
    _textView.backgroundColor = [UIColor orangeColor];
    _textView.alpha = 0.7;
    _textView.textColor = [UIColor blackColor];
    _removebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _removebutton.frame = CGRectMake(CGRectGetMaxX(_textView.frame)-20, 0, 40, 40);
    [_removebutton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
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
    
    [shareButton addTarget:self action:@selector(sharebuttonClick:) forControlEvents: UIControlEventTouchUpInside];
    [view addSubview:shareButton];
    [self.view addSubview:view];
    _longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    _longPressGr.minimumPressDuration = 1.0;
    
}

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
    [_IncomeTableView registerClass:[IncomeTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_IncomeTableView registerClass:[IncomeTableViewTopCell class] forCellReuseIdentifier:@"TopCell"];
    [_IncomeTableView registerClass:[IncomeTableViewChartCell class] forCellReuseIdentifier:@"ChartCell"];

    
    [_IncomeTableView addGestureRecognizer:self.rightSwipeGestureRecognizer];

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
        
        IncomeTableViewTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
            cell.defaultvalLabel.text = _incomeDashModel.defaultval;
            cell.defaultunitLabel.text = _incomeDashModel.defaultunit;
            cell.contrastnameLabel.text = _incomeDashModel.contrastname;
            cell.contrastvalLabel.text = _incomeDashModel.contrastval;
            cell.contrastunitLable.text = _incomeDashModel.contrastunit;
            cell.othernameLabel.text = _incomeDashModel.othername;
            cell.otherval.text = _incomeDashModel.otherval;
            cell.otherunitLabel.text = _incomeDashModel.otherunit;
            cell.titleImage.image = [UIImage imageNamed:@"sanjiao.png"];
         return cell;
    }else  if(indexPath.row == 1){
        IncomeTableViewChartCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChartCell" forIndexPath:indexPath];
        cell.scrollView.delegate = self;
     
        for (UIView * view in cell.scrollView.subviews) {
                [view removeFromSuperview];
        }

        [self incomeTableViewChartCell:cell indexPath:indexPath];
        
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        IncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @"收入结构";
        return cell;
        
    }else{
        IncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [self incomeTableViewCell:cell indexPath:indexPath];
        
        return cell;
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        if (indexPath.section == 0) {
            return 100*KHeight6scale;
        }else{
            return 50*KHeight6scale;
        }
        
    }else if(indexPath.row == 1){
        return 300*KHeight6scale;
        
    }else{
        return (_IncomeTableView.frame.size.height - 400*KWidth6scale)/3.0 *KHeight6scale;
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
  
    _pointIndexPath = (int)pointIndex;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    IncomeTableViewChartCell * cell = [_IncomeTableView cellForRowAtIndexPath:indexPath];
    [_pointButton removeFromSuperview];
    _pointButton = [UIButton buttonWithType:UIButtonTypeCustom];
#warning ====偏移量判断点的交互时间（会有改动）
    if ((cell.scrollView.contentOffset.y >= 0)&&(cell.scrollView.contentOffset.y <= cell.scrollView.contentSize.height/2.0)) {
        [_defaultLineChart addSubview:_pointButton];
        [_pointButton setTitle:[NSString stringWithFormat:@"%@,%@",_incomeDashModel.defaultVal[@"x"][_pointIndexPath],_incomeDashModel.defaultVal[@"y"][_pointIndexPath]] forState:UIControlStateNormal];
        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:4 inSection:0];
        if ((cell.scrollView.contentOffset.y >= 0)&&(cell.scrollView.contentOffset.y <= cell.scrollView.contentSize.height/2.0)) {
            [_IncomeTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,indexPath2,indexPath3,nil] withRowAnimation:UITableViewRowAnimationNone];
        }else if((cell.scrollView.contentOffset.y >= cell.scrollView.contentSize.height/2.0)){
            [_IncomeTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,indexPath2,indexPath3,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }

    }else if((cell.scrollView.contentOffset.y >= cell.scrollView.contentSize.height/2.0)){
        
        [_contrastLineChart addSubview:_pointButton];
        [_pointButton setTitle:[NSString stringWithFormat:@"%@,%@",_incomeDashModel.contrastVal[@"x"][_pointIndexPath],_incomeDashModel.contrastVal[@"y"][_pointIndexPath]] forState:UIControlStateNormal];

    }
    
   
    CGRect buttonStringRect = [_pointButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-60, 40*KHeight6scale) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_pointButton.titleLabel.font} context:nil];

    _pointButton.frame = CGRectMake(point.x-(buttonStringRect.size.width)/2.0, point.y-(buttonStringRect.size.height)-10*KHeight6scale, buttonStringRect.size.width, buttonStringRect.size.height );

    _pointButton.backgroundColor = [UIColor blackColor];
    [_pointButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    _pointButton.alpha = 0.8;
    [_pointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    
    

    
    
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}
- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex
{
    _pointIndexPath = (int)pieIndex;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:3 inSection:0];
    NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:4 inSection:0];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    IncomeTableViewChartCell * cell = [_IncomeTableView cellForRowAtIndexPath:indexPath];
    
    if ((cell.scrollView.contentOffset.y >= 0)&&(cell.scrollView.contentOffset.y <= cell.scrollView.contentSize.height/2.0)) {
        [_IncomeTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,indexPath2,indexPath3,nil] withRowAnimation:UITableViewRowAnimationNone];
    }else if((cell.scrollView.contentOffset.y >= cell.scrollView.contentSize.height/2.0)){
    }
}
- (void)didUnselectPieItem{
    
    // 扇形中间的圆形
}
//
- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    _defaultBarChart.XGridLinesColor = [UIColor blackColor];
    _defaultBarChart.showXGridLines = YES;
    _pointIndexPath = (int)barIndex;
    
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:3 inSection:0];
    NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:4 inSection:0];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    IncomeTableViewChartCell * cell = [_IncomeTableView cellForRowAtIndexPath:indexPath];
    
    if ((cell.scrollView.contentOffset.y >= 0)&&(cell.scrollView.contentOffset.y <= cell.scrollView.contentSize.height/2.0)) {
        [_IncomeTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,indexPath2,indexPath3,nil] withRowAnimation:UITableViewRowAnimationNone];
    }else if((cell.scrollView.contentOffset.y >= cell.scrollView.contentSize.height/2.0)){
    }

}

- (void)incomeTableViewChartCell:(IncomeTableViewChartCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    [cell.defaultvalButton setTitle:_incomeDashModel.defaultVal[@"valuename"] forState:UIControlStateNormal];
    [cell.contrastvalButton setTitle:_incomeDashModel.contrastVal[@"valuename"] forState:UIControlStateNormal];
    _XdefaultValValueArray = [NSMutableArray arrayWithArray:[_incomeDashModel.defaultVal valueForKey:@"x"]];
    _YdefaultValValueArray = [NSMutableArray arrayWithArray:[_incomeDashModel.defaultVal valueForKey:@"y"]];
    _XcontrastValValueArray = [NSMutableArray arrayWithArray:[_incomeDashModel.contrastVal valueForKey:@"x"]];
    _YcontrastValValueArray = [NSMutableArray arrayWithArray:[_incomeDashModel.contrastVal valueForKey:@"y"]];
    // 判断实际值或对比值颜色
    if ((_XdefaultValValueArray.count == 0) && (_YdefaultValValueArray.count == 0)&& !((_XcontrastValValueArray.count == 0) && (_YcontrastValValueArray.count == 0))) {
        //对比按钮
//        [cell.contrastvalButton addTarget:self action:@selector(contrastvalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.contrastvalColorLabel.backgroundColor = MoreButtonColor;
    }else if(!((_XdefaultValValueArray.count == 0) && (_YdefaultValValueArray.count == 0))&& ((_XcontrastValValueArray.count == 0) && (_YcontrastValValueArray.count == 0))){
        //实际按钮
//        [cell.defaultvalButton addTarget:self action:@selector(defaultvalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        cell.defaultvalButton.selected = YES;
        cell.defaultvalColorLabel.backgroundColor = [UIColor orangeColor];
    }else if (!((_XdefaultValValueArray.count == 0) && (_YdefaultValValueArray.count == 0))&&!((_XcontrastValValueArray.count == 0) && (_YcontrastValValueArray.count == 0)) ){
        //实际按钮
//        [cell.defaultvalButton addTarget:self action:@selector(defaultvalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        cell.defaultvalButton.selected = YES;
        //对比按钮
//        [cell.contrastvalButton addTarget:self action:@selector(contrastvalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.defaultvalColorLabel.backgroundColor = [UIColor orangeColor];
        cell.contrastvalColorLabel.backgroundColor = MoreButtonColor;
    }else{
       
        
    }
 //判断数据是否为空
    if ((_XdefaultValValueArray.count == 0) && (_YdefaultValValueArray.count == 0)) {
        [_XdefaultValValueArray addObject:@""];
        [_YdefaultValValueArray addObject:@""];
    }else if ((_XdefaultValValueArray.count == 0) && (_YdefaultValValueArray.count != 0)){
        [_XdefaultValValueArray addObject:@""];
    }else if ((_XdefaultValValueArray.count != 0) && (_YdefaultValValueArray.count == 0)){
        [_YdefaultValValueArray addObject:@""];
    }
    if ((_XcontrastValValueArray.count == 0) && (_YcontrastValValueArray.count == 0)) {
        [_XcontrastValValueArray addObject:@""];
        [_YcontrastValValueArray addObject:@""];
    }else if ((_XcontrastValValueArray.count == 0) && (_YcontrastValValueArray.count != 0)){
        [_XcontrastValValueArray addObject:@""];
    }else if ((_XcontrastValValueArray.count != 0) && (_YcontrastValValueArray.count == 0)){
        [_YcontrastValValueArray addObject:@""];
    }
    
 

//    if (_incomeDashModel.defaultunit == _incomeDashModel.contrastunit) {
    
        //        if ((XdefaultValValueArray.count == 0) && (YdefaultValValueArray.count == 0) && (XcontrastValValueArray.count ==0) && (YcontrastValValueArray.count == 0)) {
        //
        //        }else{
        //
        //            _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0,Main_Screen_Width-40*KWidth6scale,220*KHeight6scale)];
        //            _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lineChart.frame), CGRectGetMinY(_lineChart.frame), CGRectGetWidth(_lineChart.frame), CGRectGetHeight(_lineChart.frame))];
        //
        //            if ([_incomeDashModel.charttype isEqualToString:@"line_chart"]) {
        //                _lineChart.backgroundColor = [UIColor redColor];
        //                [self makeLine];
        //                _lineChart.yUnit = _incomeDashModel.defaultunit;
        //
        //                [_lineChart setXLabels:XdefaultValValueArray];
        //
        //                PNLineChartData * data01 = [PNLineChartData new];
        //                data01.color = [UIColor orangeColor];
        //                data01.itemCount = self.lineChart.xLabels.count;
        //                data01.alpha = 0.8f;
        //                data01.lineWidth = 2.f;
        //                data01.inflexionPointWidth = 4;
        //                data01.inflexionPointStyle = PNLineChartPointStyleCircle;
        //                data01.getData = ^(NSUInteger index){
        //
        //                    CGFloat yValue = [YdefaultValValueArray[index] floatValue];
        //
        //                    return [PNLineChartDataItem dataItemWithY:yValue andRawY:yValue];
        //
        //                };
        //                if (_incomeDashModel.contrastVal.count == 0) {
        //
        //                    self.lineChart.chartData = @[data01];
        //
        //                }else{
        //                    // Line Chart #2
        //                    [_lineChart setXLabels:XcontrastValValueArray];
        //
        //                    PNLineChartData *data02 = [PNLineChartData new];
        //
        //                    data02.color = MoreButtonColor;
        //
        //                    data02.alpha = 0.8f;
        //
        //                    data02.itemCount = self.lineChart.xLabels.count;
        //
        //                    data02.inflexionPointWidth = 4;
        //
        //                    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
        //
        //                    data02.getData = ^(NSUInteger index) {
        //
        //                        CGFloat yValue = [YcontrastValValueArray[index] floatValue];
        //                        return [PNLineChartDataItem dataItemWithY:yValue];
        //                    };
        //
        //                    self.lineChart.chartData = @[data01, data02];
        //
        //                }
        //                _lineChart.delegate = self;
        //
        //                [_lineChart strokeChart];
        //                [cell.chartView addSubview:_lineChart];
        //
        //            }else if ([_incomeDashModel.charttype isEqualToString:@"pie_chart"]){
        //
        //#warning ====存不存在实际值为空，对比值不为空的情况＝＝＝＝
        //                if (_incomeDashModel.contrastVal.count == 0) {
        //                    NSMutableArray *items  = [NSMutableArray array];
        //                    int i = 0;
        //
        //                    for (NSString * value in YdefaultValValueArray) {
        //
        //                        PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:PNArc4randomColor description:XdefaultValValueArray[i]];
        //                        [items addObject:item];
        //                        i++;
        //                    }
        //
        //                    _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(50*KWidth6scale,10*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale) items:items];
        //                    _pieChart.descriptionTextColor = [UIColor whiteColor];
        //                    _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        //                    _pieChart.descriptionTextShadowColor = [UIColor clearColor];
        //                    _pieChart.showAbsoluteValues = NO;
        //                    _pieChart.showOnlyValues = YES;
        //                    [_pieChart strokeChart];
        //                    _pieChart.legendStyle = PNLegendItemStyleSerial;
        //                    _pieChart.legendFont = [UIFont systemFontOfSize:12.0f];
        //                    _pieChart.legendFontColor = [UIColor grayColor];
        //                    _pieChart.delegate = self;
        //
        //                    UIView *legend = [self.pieChart getLegendWithMaxWidth:10];
        //
        //                    [legend setFrame:CGRectMake(CGRectGetMaxX(_pieChart.frame)+10*KWidth6scale, CGRectGetMinY(_pieChart.frame), legend.frame.size.width, legend.frame.size.height)];
        //
        //                    [cell.chartView addSubview:legend];
        //
        //                    [cell.chartView addSubview:self.pieChart];
        //
        //
        //                }else{
        //                    if (_incomeDashModel.contrastVal.count == 0) {
        //
        //                    }else{
        //                        [cell.chartView addSubview:cell.scrollView];
        //                        //            cell.scrollView.directionalLockEnabled=YES;//定向锁定
        //                        NSMutableArray *items  = [NSMutableArray array];
        //                        int i = 0;
        //
        //                        for (NSString * value in YdefaultValValueArray) {
        //
        //                            PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:PNArc4randomColor description:XdefaultValValueArray[i]];
        //                            [items addObject:item];
        //                            i++;
        //                        }
        //                        _midvalPieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(50*KWidth6scale, 10*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale) items:items];
        //                        _midvalPieChart.descriptionTextColor = [UIColor whiteColor];
        //                        _midvalPieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        //                        _midvalPieChart.descriptionTextShadowColor = [UIColor clearColor];
        //                        _midvalPieChart.showAbsoluteValues = NO;
        //                        _midvalPieChart.showOnlyValues = YES;
        //                        _midvalPieChart.delegate = self;
        //
        //                        [_midvalPieChart strokeChart];
        //                        _midvalPieChart.legendStyle = PNLegendItemStyleStacked;
        //                        _midvalPieChart.legendFont = [UIFont systemFontOfSize:12.0f];
        //                        _midvalPieChart.legendFontColor = [UIColor grayColor];
        //
        //
        //                        UIView *legend = [self.midvalPieChart getLegendWithMaxWidth:60*KWidth6scale];
        //
        //                        [legend setFrame:CGRectMake(CGRectGetMaxX(_midvalPieChart.frame)+10*KWidth6scale, CGRectGetMinY(_midvalPieChart.frame), legend.frame.size.width, legend.frame.size.height)];
        //
        //                        [cell.scrollView addSubview:legend];
        //
        //                        [cell.scrollView addSubview:self.midvalPieChart];
        //
        //
        //                        NSMutableArray *items2  = [NSMutableArray array];
        //                        int j = 0;
        //
        //                        for (NSString * value in YcontrastValValueArray) {
        //
        //                            PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:PNArc4randomColor description:XcontrastValValueArray[j]];
        //                            [items2 addObject:item];
        //                            i++;
        //                        }
        //
        //                        _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(Main_Screen_Width + 10*KWidth6scale, 10*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale, CGRectGetHeight(_lineChart.frame)-20*KHeight6scale) items:items2];
        //                        _pieChart.descriptionTextColor = [UIColor whiteColor];
        //                        _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        //                        _pieChart.showAbsoluteValues = NO;
        //                        _pieChart.showOnlyValues = YES;
        //                        _pieChart.delegate = self;
        //                        _pieChart.descriptionTextShadowColor = [UIColor clearColor];
        //
        //                        [_pieChart strokeChart];
        //                        _pieChart.legendStyle = PNLegendItemStyleStacked;
        //                        _pieChart.legendFont = [UIFont systemFontOfSize:12.0f];
        //                        _pieChart.legendFontColor = [UIColor grayColor];
        //
        //
        //                        UIView *legend2 = [self.pieChart getLegendWithMaxWidth:60*KWidth6scale];
        //
        //                        [legend2 setFrame:CGRectMake(CGRectGetMaxX(_pieChart.frame)+10*KWidth6scale, CGRectGetMinY(_pieChart.frame), legend.frame.size.width, legend.frame.size.height)];
        //
        //                        [cell.scrollView addSubview:legend2];
        //
        //                        [cell.scrollView addSubview:self.pieChart];
        //
        //
        //                    }
        //                }
        //            }else if([_incomeDashModel.charttype isEqualToString:@"text"] | [_incomeDashModel.charttype isEqualToString:@"long_text"] | [_incomeDashModel.charttype isEqualToString:@"bar_chart"]){
        //
        //                CFLineChartView * LCView = [CFLineChartView lineChartViewWithFrame:CGRectMake(0,0, CGRectGetWidth(_lineChart.frame), CGRectGetHeight(_lineChart.frame))];
        //                [cell.chartView addSubview:LCView];
        //
        //
        //                // 画图
        //                if ((_incomeDashModel.defaultVal.count !=0 )&& (_incomeDashModel.contrastVal.count !=0)) {
        //                    // 如果实际值和对比值的数据都不为空
        //                    if ((XdefaultValValueArray.count != 0) && (YdefaultValValueArray.count != 0) && (XcontrastValValueArray.count != 0)&&(YcontrastValValueArray.count != 0) ) {
        //
        //                        // 数组中最大值
        //                        NSNumber* defaultValMaxValue = [YdefaultValValueArray valueForKeyPath:@"@max.floatValue"];
        //                        NSNumber* contrastValMaxValue = [YcontrastValValueArray valueForKeyPath:@"@max.floatValue"];
        //                        if ([defaultValMaxValue floatValue]> [contrastValMaxValue floatValue]) {
        //
        //                            LCView.yValues = YdefaultValValueArray;
        //                            LCView.xValues = XdefaultValValueArray;
        //
        //                        }else{
        //
        //                            LCView.yValues = YcontrastValValueArray;
        //                            LCView.xValues = XcontrastValValueArray;
        //                        }
        //
        //                        // 绘制图的基本
        //                        [LCView drawChartWithLineChartType:0 pointType:1];
        //                        // 画柱状图
        //                        [LCView drawPillarYvalues:YdefaultValValueArray];
        //                        // 画折线图
        //                        [LCView drawFoldLineWithLineChartType:0 Yvalues:YcontrastValValueArray];
        //
        //                    }else if ((( XdefaultValValueArray.count == 0 ) && ( YdefaultValValueArray.count == 0 )) && (( XcontrastValValueArray.count != 0 )&& (YcontrastValValueArray.count != 0))){
        //                        // 如果实际值为空，对比值不为空
        //
        //                        LCView.xValues = XcontrastValValueArray;
        //                        LCView.yValues = YcontrastValValueArray;
        //                        // 绘制图的基本
        //                        [LCView drawChartWithLineChartType:0 pointType:1];
        //
        //                        // 画折线图
        //                        [LCView drawFoldLineWithLineChartType:0 Yvalues:YcontrastValValueArray];
        //
        //
        //
        //                    }else if ((( XdefaultValValueArray.count != 0 ) && ( YdefaultValValueArray.count != 0 )) && (( XcontrastValValueArray.count == 0 )&& (YcontrastValValueArray.count == 0))){
        //                        // 如果实际值不为空，对比值为空
        //                        LCView.xValues = XdefaultValValueArray;
        //                        LCView.yValues = YdefaultValValueArray;
        //
        //                        // 绘制图的基本
        //                        [LCView drawChartWithLineChartType:0 pointType:1];
        //                        // 画柱状图
        //                        [LCView drawPillarYvalues:YdefaultValValueArray];
        //
        //
        //                    }else{
        //
        //
        //
        //                    }
        //
        //
        //                }else if((_incomeDashModel.defaultVal.count ==0 )&& (_incomeDashModel.contrastVal.count !=0)){
        //                    // 如果实际值为空，对比值不为空
        //
        //                    LCView.xValues = XcontrastValValueArray;
        //                    LCView.yValues = YcontrastValValueArray;
        //                    // 绘制图的基本
        //                    [LCView drawChartWithLineChartType:0 pointType:1];
        //
        //                    // 画折线图
        //                    [LCView drawFoldLineWithLineChartType:0 Yvalues:YcontrastValValueArray];
        //
        //                }else if((_incomeDashModel.defaultVal.count !=0 )&& (_incomeDashModel.contrastVal.count ==0)){
        //                    // 如果实际值不为空，对比值为空
        //                    LCView.xValues = XdefaultValValueArray;
        //                    LCView.yValues = YdefaultValValueArray;
        //
        //                    // 绘制图的基本
        //                    [LCView drawChartWithLineChartType:0 pointType:1];
        //                    // 画柱状图
        //                    [LCView drawPillarYvalues:YdefaultValValueArray];
        //
        //                }else{
        //                    // 如果实际值和对比值都为空
        //                }
        //
        //            }
        //
        //        }
        
//    }else{
        if ((_XdefaultValValueArray.count == 0) && (_YdefaultValValueArray.count == 0) && (_XcontrastValValueArray.count ==0) && (_YcontrastValValueArray.count == 0)) {
            
        }else{
            
            _defaultLineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0,Main_Screen_Width-40*KWidth6scale,220*KHeight6scale)];
            _contrastLineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_defaultLineChart.frame)+40*KWidth6scale,CGRectGetWidth(_defaultLineChart.frame),CGRectGetHeight(_defaultLineChart.frame))];
            _defaultBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(CGRectGetMinX(_defaultLineChart.frame), CGRectGetMinY(_defaultLineChart.frame),CGRectGetWidth(_defaultLineChart.frame),CGRectGetHeight(_defaultLineChart.frame))];
            _contrastBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(CGRectGetMinX(_contrastLineChart.frame), CGRectGetMinY(_contrastLineChart.frame),CGRectGetWidth(_defaultBarChart.frame),CGRectGetHeight(_defaultBarChart.frame))];
            
            
               [cell.scrollView  removeFromSuperview];
               [cell.chartView addSubview:cell.scrollView];

            if ([_incomeDashModel.charttype isEqualToString:@"line_chart"] | [_incomeDashModel.charttype isEqualToString:@"text"] | [_incomeDashModel.charttype isEqualToString:@"long_text"]) {
                [self makeLine];
                [cell.scrollView addSubview:_defaultLineChart];
                [cell.scrollView addSubview:_contrastLineChart];
               
            }else if ([_incomeDashModel.charttype isEqualToString:@"pie_chart"]){
                cell.defaultvalButton.hidden = YES;
                cell.contrastvalButton.hidden = YES;
                cell.defaultvalColorLabel.hidden = YES;
                cell.contrastvalColorLabel.hidden = YES;
                [self makePieChart];
                UIView *legend = [self.defaultPieChart getLegendWithMaxWidth:10];
                
                [legend setFrame:CGRectMake(CGRectGetMaxX(_defaultPieChart.frame)+10*KWidth6scale, CGRectGetMinY(_defaultPieChart.frame), legend.frame.size.width, legend.frame.size.height)];
                
                [cell.scrollView addSubview:legend];
                
                [cell.scrollView addSubview:self.defaultPieChart];

                UIView *legend2 = [self.contrastPieChart getLegendWithMaxWidth:60*KWidth6scale];
                
                [legend2 setFrame:CGRectMake(CGRectGetMaxX(_contrastPieChart.frame)+10*KWidth6scale, CGRectGetMinY(_contrastPieChart.frame), legend.frame.size.width, legend.frame.size.height)];
                
                [cell.scrollView addSubview:legend2];
                
                [cell.scrollView addSubview:self.contrastPieChart];
                
            }else if ([_incomeDashModel.charttype isEqualToString:@"bar_chart"]){
               
               
                    [self makeBar];
                    [cell.scrollView addSubview:_defaultBarChart];
                    [cell.scrollView addSubview:_contrastBarChart];

            }
       }

}
- (void)defaultvalButtonClick:(UIButton *)button
{
    NSIndexPath * indexPath = [NSIndexPath  indexPathForRow:1 inSection:0];
    IncomeTableViewChartCell * cell = [_IncomeTableView cellForRowAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.3 // 动画时长
                     animations:^{
                         cell.scrollView.contentOffset = CGPointMake(0, 0);
                     }];
    
    
}
- (void)contrastvalButtonClick:(UIButton *)button
{
    NSIndexPath * indexPath = [NSIndexPath  indexPathForRow:1 inSection:0];
    IncomeTableViewChartCell * cell = [_IncomeTableView cellForRowAtIndexPath:indexPath];
    cell.defaultvalButton.selected = NO;
    [UIView animateWithDuration:0.3 // 动画时长
                     animations:^{
                         cell.scrollView.contentOffset = CGPointMake(Main_Screen_Width-40*KWidth6scale, 0);
                     }];
    
    
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
        cell.titleLabel.text = @"实际值：x";
        NSMutableArray * arrY = [NSMutableArray arrayWithArray:_incomeDashModel.defaultVal[@"x"]];
        if ( (arrY.count == 0 )) {
            
            cell.ValueLabel.text = [NSString stringWithFormat:@"%@",@""];
            
        }else{
            cell.ValueLabel.text = _incomeDashModel.defaultVal[@"x"][_pointIndexPath];
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
    if ((_XdefaultValValueArray.count == 0) | (_YdefaultValValueArray.count == 0)) {
        
    }else{
      
        _defaultLineChart.userInteractionEnabled = YES;
        _defaultLineChart.backgroundColor = [UIColor clearColor];
        _defaultLineChart.legendStyle =  PNLegendItemStyleSerial;
        _defaultLineChart.showCoordinateAxis = YES;
        _defaultLineChart.showGenYLabels = YES;
        _defaultLineChart.showLabel = YES;
        _defaultLineChart.showYGridLines = YES;
        _defaultLineChart.yUnit = _incomeDashModel.defaultunit;
        _defaultLineChart.yUnitColor = [UIColor blackColor];
        [_defaultLineChart setXLabels:_XdefaultValValueArray];
        PNLineChartData * defaultData = [PNLineChartData new];
        defaultData.color = [UIColor orangeColor];
        defaultData.itemCount = self.defaultLineChart.xLabels.count;
        defaultData.lineWidth = 2.0f;
        defaultData.inflexionPointWidth = 4;
        defaultData.inflexionPointStyle = PNLineChartPointStyleCircle;
        defaultData.getData = ^(NSUInteger index){
            
            CGFloat yValue = [_YdefaultValValueArray[index] floatValue];
            
            return [PNLineChartDataItem dataItemWithY:yValue andRawY:yValue];
        };
        _defaultLineChart.delegate = self;
        self.defaultLineChart.chartData = @[defaultData];
        
        [_defaultLineChart strokeChart];

    }
      if ((_XcontrastValValueArray.count == 0) | (_YcontrastValValueArray.count == 0)) {
        
          
    }else{
        _contrastLineChart.userInteractionEnabled = YES;
        _contrastLineChart.backgroundColor = [UIColor clearColor];
        _contrastLineChart.legendStyle =  PNLegendItemStyleSerial;
        _contrastLineChart.showCoordinateAxis = YES;
        _contrastLineChart.showGenYLabels = YES;
        _contrastLineChart.showLabel = YES;
        _contrastLineChart.showYGridLines = YES;
      
        _contrastLineChart.yUnit = _incomeDashModel.contrastunit;
        _contrastLineChart.yUnitColor = [UIColor blackColor];

        [_contrastLineChart setXLabels:_XcontrastValValueArray];
        PNLineChartData * contrastData = [PNLineChartData new];
        contrastData.color = MoreButtonColor;
        contrastData.itemCount = self.contrastLineChart.xLabels.count;
        contrastData.lineWidth = 2.f;
        contrastData.inflexionPointWidth = 4;
        contrastData.inflexionPointStyle = PNLineChartPointStyleCircle;
        contrastData.getData = ^(NSUInteger index){
        
            CGFloat yValue = [_YcontrastValValueArray[index] floatValue];
            
            return [PNLineChartDataItem dataItemWithY:yValue andRawY:yValue];
        };
        self.contrastLineChart.chartData = @[contrastData];
        
        _contrastLineChart.delegate = self;
        [_contrastLineChart strokeChart];

    }
    
//        self.defaultLineChart.yLabelColor =[UIColor blackColor];
//        self.defaultLineChart.xLabelColor = [UIColor blackColor];
    
    // 小数点
    //    _lineChart.thousandsSeparator = YES;
    
}
- (void)makePieChart
{
    NSMutableArray *items  = [NSMutableArray array];
    int i = 0;
    for (NSString * value in _YdefaultValValueArray) {
        
        PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:_pieColorArray[i] description:_XdefaultValValueArray[i]];
        [items addObject:item];
        
        i++;
    }
    
    _defaultPieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(50*KWidth6scale,10*KHeight6scale, CGRectGetHeight(_defaultLineChart.frame)-20*KHeight6scale, CGRectGetHeight(_defaultLineChart.frame)-20*KHeight6scale) items:items];
    _defaultPieChart.descriptionTextColor = [UIColor whiteColor];
    _defaultPieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    _defaultPieChart.descriptionTextShadowColor = [UIColor clearColor];
    _defaultPieChart.showAbsoluteValues = NO;
    _defaultPieChart.showOnlyValues = YES;
    [_defaultPieChart strokeChart];
    _defaultPieChart.legendStyle = PNLegendItemStyleSerial;
    _defaultPieChart.legendFont = [UIFont systemFontOfSize:12.0f];
    _defaultPieChart.legendFontColor = [UIColor grayColor];
    _defaultPieChart.delegate = self;
    
    NSMutableArray *items2  = [NSMutableArray array];
    int j = 0;
    
    for (NSString * value in _YcontrastValValueArray) {
        
        PNPieChartDataItem * item = [PNPieChartDataItem dataItemWithValue:[value floatValue] color:_pieColorArray[i] description:_XcontrastValValueArray[j]];
        [items2 addObject:item];
        j++;
    }
    
    _contrastPieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(CGRectGetMinX(_defaultPieChart.frame), CGRectGetMaxY(_defaultPieChart.frame)+30*KHeight6scale, CGRectGetHeight(_defaultLineChart.frame)-20*KHeight6scale, CGRectGetHeight(_defaultLineChart.frame)-20*KHeight6scale) items:items2];
    _contrastPieChart.descriptionTextColor = [UIColor whiteColor];
    _contrastPieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    _contrastPieChart.showAbsoluteValues = NO;
    _contrastPieChart.showOnlyValues = YES;
    _contrastPieChart.delegate = self;
    _contrastPieChart.descriptionTextShadowColor = [UIColor clearColor];
    
    [_contrastPieChart strokeChart];
    _contrastPieChart.legendStyle = PNLegendItemStyleStacked;
    _contrastPieChart.legendFont = [UIFont systemFontOfSize:12.0f];
    _contrastPieChart.legendFontColor = [UIColor grayColor];
    
    
    
}

// 柱状图
- (void)makeBar
{
    static NSNumberFormatter *barChartFormatter;
    
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        // 数值类型
        barChartFormatter.numberStyle = kCFNumberFormatterNoStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    self.defaultBarChart.yLabelFormatter = ^(CGFloat yValue){
        
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
        
    };
    if ((_XdefaultValValueArray.count == 0) | (_YdefaultValValueArray.count == 0)) {
       
        
    }else{
        _defaultBarChart.yChartLabelWidth = 20.0;
        _defaultBarChart.chartMarginLeft = 30.0;
        _defaultBarChart.chartMarginRight = 10.0;
        _defaultBarChart.chartMarginTop = 5.0;
        _defaultBarChart.chartMarginBottom = 10.0;
        _defaultBarChart.barBackgroundColor = [UIColor clearColor];
        _defaultBarChart.chartBorderColor = DEFAULT_BGCOLOR;
        _defaultBarChart.strokeColor = [UIColor orangeColor];
        _defaultBarChart.labelFont = [UIFont systemFontOfSize:12];
        _defaultBarChart.labelMarginTop = 5.0;
        _defaultBarChart.showChartBorder = YES;
        _defaultBarChart.delegate = self;
        [_defaultBarChart setXLabels:_XdefaultValValueArray];
        [_defaultBarChart setYValues:_YdefaultValValueArray];
        _defaultBarChart.isGradientShow = NO;
        _defaultBarChart.isShowNumbers = NO;
        [_defaultBarChart strokeChart];
        

    }
    if ((_XcontrastValValueArray.count == 0) |(_YcontrastValValueArray.count == 0)) {
        
    }else{
        
        _contrastBarChart.yChartLabelWidth = 20.0;
        _contrastBarChart.strokeColor = MoreButtonColor;
        _contrastBarChart.chartBorderColor = DEFAULT_BGCOLOR;
        _contrastBarChart.barBackgroundColor = [UIColor clearColor];
        _contrastBarChart.chartMarginLeft = 30.0;
        _contrastBarChart.chartMarginRight = 10.0;
        _contrastBarChart.chartMarginTop = 5.0;
        _contrastBarChart.chartMarginBottom = 10.0;
        _contrastBarChart.delegate = self;
        _contrastBarChart.labelFont = [UIFont systemFontOfSize:12];
        _contrastBarChart.labelMarginTop = 5.0;
        _contrastBarChart.showChartBorder = YES;
        _contrastBarChart.delegate = self;
        [_contrastBarChart setXLabels:_XcontrastValValueArray];
        [_contrastBarChart setYValues:_YcontrastValValueArray];
        _contrastBarChart.isGradientShow = NO;
        _contrastBarChart.isShowNumbers = NO;
        [_contrastBarChart strokeChart];

    }
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    NSIndexPath * indexPath = [NSIndexPath  indexPathForRow:1 inSection:0];
//    IncomeTableViewChartCell * cell = [_IncomeTableView cellForRowAtIndexPath:indexPath];
//    if ((cell.scrollView.contentOffset.x > 0)) {
//        [UIView animateWithDuration:0.5 // 动画时长
//                         animations:^{
//                             cell.scrollView.contentOffset = CGPointMake(Main_Screen_Width-40*KWidth6scale, 0);
//
//                         }];
//        
//    }else{
//        
//        [UIView animateWithDuration:0.5 // 动画时长
//                         animations:^{
//                             cell.scrollView.contentOffset = CGPointMake(0, 0);
//
//                         }];
//    }
//
//    
//    
//}

- (void)sharebuttonClick:(UIButton *)sender
{
    
     [super ScreenShot];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
//        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 100.0, self.swipeLabel.frame.origin.y);
//        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
//        self.swipeLabel.text = @"尼玛的, 你在往左边跑啊....";
        
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
//        [UIView animateWithDuration:1.0 // 动画时长
//                         animations:^{
                              [self backButtonClick:backButton];
//                         }];
       

        
    }
}
-(void)dealloc{
    NSLog(@"DashIncomDealloc");
    self.view = nil;
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
