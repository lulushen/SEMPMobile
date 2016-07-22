//
//  SDAccountViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDAccountViewController.h"
#import "SDUserTableViewCell.h"
#import "SDSetViewController.h"
#import "SDInfoViewController.h"
#import "SDFeedBackViewController.h"
#import "MBProgressHUD+NJ.h"

@interface SDAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic , strong)UITableView * userTableView;
// UITableView头部视图
@property (nonatomic , strong)UIView * userTableHeaderView;
//UITableView头部视图的头像button
@property (nonatomic , strong)UIButton * headerImageButton;

@end

@implementation SDAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeTableView];
    // Do any additional setup after loading the view.
}

- (void)makeTableView{
    
    self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, KTableViewHeight) style:(UITableViewStyleGrouped)];
    
    self.userTableView.delegate = self;
    
    self.userTableView.dataSource = self;
    
    [self.view addSubview:self.userTableView];
    
    self.userTableView.separatorStyle = NO;
    
    // UITableView头部
    [self makeTableHeaderView];
    
    [self.userTableView registerClass:[SDUserTableViewCell class] forCellReuseIdentifier:@"CELL"];
}
- (void)makeTableHeaderView
{

    self.userTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, Kwidth, Kheight/3.0)];
    
    self.userTableHeaderView.backgroundColor = [UIColor grayColor];
    
    self.headerImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.headerImageButton.frame = CGRectMake(Kwidth/2 - Kwidth/8.0, 30*KHeight6scale, Kwidth/4.0, Kwidth/4.0);
    
    self.headerImageButton.backgroundColor = [UIColor whiteColor];
    
    self.headerImageButton.layer.cornerRadius = Kwidth/8.0;
    //设置超过子图层的部分裁减掉
    self.headerImageButton.layer.masksToBounds = YES;
    
    [self.userTableHeaderView addSubview:self.headerImageButton];
    
    [self.headerImageButton addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    //加载首先访问本地沙盒是否存在相关图片
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
//    UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
    
//    if (!savedImage)
//    {
//        //默认头像
//        [self.headerImageButton setBackgroundImage:[UIImage imageNamed:@"head"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.headerImageButton setBackgroundImage:[UIImage imageNamed:@"head"] forState:UIControlStateNormal];
//    }
    NSMutableDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLogin"];

    

    // 注册观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBack) name:@"userExit" object:nil];

    _userLabel = [[UILabel alloc] initWithFrame:CGRectMake(Kwidth/2-100*KWidth6scale, CGRectGetMaxY(self.headerImageButton.frame) + 10*KWidth6scale, 200*KWidth6scale, 30*KWidth6scale)];
    
    _userLabel.text =[NSString stringWithFormat:@"用户名 : %@",[dic objectForKey:@"userName"]];
    
    _userLabel.textColor = [UIColor whiteColor];
    
    [_userLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.userTableHeaderView addSubview:_userLabel];
    
    UILabel * jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userLabel.frame), CGRectGetMaxY(_userLabel.frame), CGRectGetWidth(_userLabel.frame), CGRectGetHeight(_userLabel.frame))];
    
    jobLabel.text = @"职  位 :";
    
    jobLabel.textColor = [UIColor whiteColor];
    
    [jobLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.userTableHeaderView addSubview:jobLabel];
    
    self.userTableView.tableHeaderView = self.userTableHeaderView;
    
    self.userTableHeaderView.layer.borderWidth = 1;
    
    self.userTableHeaderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    
    
}
- (void)callBack
{
    NSMutableDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLogin"];
    
    _userLabel.text =[NSString stringWithFormat:@"用户名 : %@",[dic objectForKey:@"userName"]];

    
}
- (void)headerImageButtonClick: (UIButton * )button
{
    UIAlertController *alertController;
    
    __block NSUInteger blockSourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //支持访问相机与相册情况
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //相机
            blockSourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        //只支持访问相册情况
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark - 选择图片后,回调选择

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    /* 此处info 有六个可选类型
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    [self.headerImageButton setBackgroundImage:image forState:UIControlStateNormal];
    
//    [self saveImage:image withName:@"currentImage.png"];
}


#pragma mark - 保存图片至本地沙盒

//- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
//{
//    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.8);
//    
//    // 获取沙盒目录
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    NSLog(@"------%@",fullPath);
//    // 将图片写入文件
//    [imageData writeToFile:fullPath atomically:NO];
//}
#pragma mark --- tableView 实现代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"four.png"];
    cell.textLabel.textColor = [UIColor grayColor];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"消息中心";
        UILabel * la = [[UILabel alloc] init];
        la.frame = CGRectMake(cell.frame.size.width/2,cell.frame.size.height/2-cell.frame.size.height/4.0, cell.frame.size.height/2.0,cell.frame.size.height/2.0);
     
        [la setTextColor:[UIColor whiteColor]];
        la.backgroundColor = [UIColor redColor];
        [la setTextAlignment:NSTextAlignmentCenter];
        la.text = @"1";
        [cell.contentView addSubview:la];
        // 设置label的圆角
        la.layer.cornerRadius = cell.frame.size.height/4.0;
        la.clipsToBounds = YES;
        
    }else if ( indexPath.section == 1) {
        cell.textLabel.text = @"设置";
    }else if ( indexPath.section == 2) {
        cell.textLabel.text = @"意见反馈";
    }else if ( indexPath.section == 3) {
        cell.textLabel.text = @"退出登录";
    }
    
    return cell;
}
// heightforheaderinsection不起作用时 同时设置heightForFooterInSection即可（不能为0）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 10*KHeight6scale;
    }else
    {
        return 5*KHeight6scale;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5*KHeight6scale;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        SDInfoViewController * infoVC = [[SDInfoViewController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }else if (indexPath.section == 1){
        
        SDSetViewController * setVC = [[SDSetViewController alloc] init];
        [self.navigationController pushViewController:setVC animated:YES];

    }else if (indexPath.section == 2){
        
        SDFeedBackViewController * feedBackVC = [[SDFeedBackViewController alloc] init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
        
        
    }else if(indexPath.section == 3){
        
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"login"];
        [defaults removeObjectForKey:@"userLogin"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userExit" object:self];
        [MBProgressHUD showSuccess:@"退出成功"];
    
        

        
        
        
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
