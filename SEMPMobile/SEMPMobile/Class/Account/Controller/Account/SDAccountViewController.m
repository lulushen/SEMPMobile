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
#import "UIColor+NSString.h"
#import "LoginViewController.h"
#import "infoModel.h"

@interface SDAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic , strong)UITableView * userTableView;
// UITableView头部视图
@property (nonatomic , strong)UIView * userTableHeaderView;
//UITableView头部视图的头像button
@property (nonatomic , strong)UIButton * headerImageButton;

@property (nonatomic , strong)SDInfoViewController * infoVC;

// 未读消息数量的label
@property (nonatomic , strong)UILabel * noReadInfoCountLabel;

@property (nonatomic , strong)NSString * token;
@end

@implementation SDAccountViewController
- (void)viewWillAppear:(BOOL)animated
{
    //消息中心的数据解析
    [self makeInfoData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Account";
    NSMutableDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userResponseObject"];
    
    _token =  [userDict valueForKey:@"user_token"];
    
    [self makeHeadImage];
    [self makeTableView];
    // Do any additional setup after loading the view.
    
    
}
- (void)makeHeadImage
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString * urlStr = [NSString stringWithFormat:headImageHttp];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg", nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //            NSLog(@"%@",responseObject);
            //            NSString * string = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            //
            if (responseObject != nil) {
                //                NSString *base64Decoded = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                //                NSString * encodedImageStr = [responseObject base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                //                NSLog(@"%@",encodedImageStr);
                //                NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                UIImage *headImage = [UIImage imageWithData:responseObject];
                NSData * data = UIImageJPEGRepresentation(headImage, 1);
                NSLog(@"%f",(float)data.length/1024);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data.length/1024 == 0) {
                        
                    }else{
                        
                        [self.headerImageButton setBackgroundImage:headImage forState:UIControlStateNormal];
                        
                    }
                    
                });
                
                
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            
        }];
        
    });
    
}

- (void)makeTableView{
    
    self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) style:(UITableViewStyleGrouped)];
    
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
    
    self.userTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, Main_Screen_Width, Main_Screen_Height/3.0)];
    
    //    self.userTableHeaderView.backgroundColor = [UIColor colorWithString:@"#bfbfbf"];
    self.userTableHeaderView.backgroundColor = RGBCOLOR(240, 240, 240);
    
    self.headerImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.headerImageButton.frame = CGRectMake(Main_Screen_Width/2 - Main_Screen_Width/8.0, 30*KHeight6scale, Main_Screen_Width/4.0, Main_Screen_Width/4.0);
    [self.headerImageButton setBackgroundImage:[UIImage imageNamed:@"header.png"] forState:UIControlStateNormal];
    self.headerImageButton.layer.cornerRadius = Main_Screen_Width/8.0;
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
    
    
    
    
    // 注册观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBack) name:@"userExit" object:nil];
    UILabel * userNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_headerImageButton.frame)-80*KWidth6scale, CGRectGetMaxY(self.headerImageButton.frame) + 10*KWidth6scale, 80*KWidth6scale, 30*KHeight6scale)];
    userNameTitle.text = @"用户名 :";
    [userNameTitle setTextAlignment:NSTextAlignmentRight];
    
    [self.userTableHeaderView addSubview:userNameTitle];
    
    
    _userLabel = [[UILabel alloc] init];
    
    
    [_userLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.userTableHeaderView addSubview:_userLabel];
    
    UILabel * orgTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(userNameTitle.frame), CGRectGetMaxY(userNameTitle.frame), CGRectGetWidth(userNameTitle.frame), CGRectGetHeight(userNameTitle.frame) )];
    
    orgTitleLabel.text = @"职    位 :";
    [orgTitleLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.userTableHeaderView addSubview:orgTitleLabel];
    
    _orgLabel = [[UILabel alloc] init];
    NSMutableDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userResponseObject"];
    
    NSMutableDictionary * dict = [userDict valueForKey:@"resdata"];
    
    if (_token == nil) {
        
        _userLabel.text =@"";
        _orgLabel.text = @"";
        
    }else{
        
        _userLabel.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"userName"]];
        _orgLabel.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"orgName"]];
        
    }
    _orgLabel.numberOfLines = 0;
    _userLabel.numberOfLines = 0;
    CGRect userLabelRect = [_userLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)/2.0, 60) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_userLabel.font} context:nil];
    
    CGRect orgLabelRect = [_orgLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)/2.0, 60) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_orgLabel.font} context:nil];
    
    _userLabel.frame = CGRectMake(CGRectGetMaxX(userNameTitle.frame)+5*KWidth6scale, CGRectGetMinY(userNameTitle.frame), userLabelRect.size.width, CGRectGetHeight(userNameTitle.frame));
    _orgLabel.frame = CGRectMake(CGRectGetMinX(_userLabel.frame), CGRectGetMinY(orgTitleLabel.frame), orgLabelRect.size.width, CGRectGetHeight(orgTitleLabel.frame));
    
    [_orgLabel setTextAlignment:NSTextAlignmentLeft];
    userNameTitle.font = [UIFont systemFontOfSize:15.0f];
    orgTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    _userLabel.font = [UIFont systemFontOfSize:15.0f];
    _orgLabel.font = [UIFont systemFontOfSize:15.0f];
    
    [self.userTableHeaderView addSubview:_orgLabel];
    
    self.userTableView.tableHeaderView = self.userTableHeaderView;
    
    self.userTableHeaderView.layer.borderWidth = 1;
    
    self.userTableHeaderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    
    
}
// 用户退出时观察者方法
- (void)callBack
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userResponseObject"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _userLabel.text =[NSString stringWithFormat:@""];
    _orgLabel.text = @"";
    //    [MBProgressHUD showSuccess:@"退出成功"];
    
    
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
    
    
    //    [self saveImage:image withName:@"currentImage.png"];
    NSData * data = UIImageJPEGRepresentation(image, 1);
    // KB的计算方法
    NSLog(@"%f",(float)data.length/1024);
    
    UIImage *imageNew = [self scaleToSize:image size:CGSizeMake(100, 100)];
    [self.headerImageButton setBackgroundImage:imageNew forState:UIControlStateNormal];
    NSLog(@"%@",imageNew);
    //照片上传
    [self upDateHeadIcon:imageNew];
    
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
//照片上传
- (void)upDateHeadIcon:(UIImage *)photo
{
    //两种方式上传头像
    /*方式二：使用Base64字符串传图片*/
    
    NSData *data = UIImageJPEGRepresentation(photo,1);
    NSLog(@"%f",(float)data.length/1024);
    if ((data.length/1024) >= 500) {
        [MBProgressHUD showSuccess:@"图片大小超过500k,不能上传"];
    }else{
        
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];
        NSLog(@"%@",encodedImageStr);
        
        //    NSData *decodedImageData = [[NSData alloc]
        //
        //                                initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        //
        //    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
        //
        //    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        //
        //    imgView.backgroundColor = [UIColor redColor];
        //    [imgView setImage:decodedImage];
        //
        //    [self.view addSubview:imgView];
        
        
        
        NSString * urlStr = [NSString stringWithFormat:upLoadHeadImageHttp];
        
        
        NSMutableDictionary * requestDic = @{
                                             
                                             @"image":encodedImageStr
                                             
                                             }.mutableCopy;
        
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            // 不加这句话上传的base64字符串换发生变化
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:urlStr parameters:requestDic progress:^(NSProgress * _Nonnull downloadProgress) {
                
                //这里可以用来显示下载进度
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //            NSLog(@"--%@",responseObject);
                
                if (responseObject != nil) {
                    [MBProgressHUD showSuccess:@"上传成功"];
                    
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //失败
                NSLog(@"failure  error ： %@",error);
                
            }];
            
        });
        
    }
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
        
        cell.image.image = [UIImage imageNamed:@"info.png"];
        cell.titleLabel.text = @"消息中心";
        _noReadInfoCountLabel = [[UILabel alloc] init];
        _noReadInfoCountLabel.frame = CGRectMake(cell.frame.size.width/2,cell.frame.size.height/2-cell.frame.size.height/4.0, cell.frame.size.height/2.0,cell.frame.size.height/2.0);
        
        [_noReadInfoCountLabel setTextColor:[UIColor whiteColor]];
        [cell.contentView addSubview:_noReadInfoCountLabel];
        // 设置label的圆角
        _noReadInfoCountLabel.layer.cornerRadius = cell.frame.size.height/4.0;
        _noReadInfoCountLabel.clipsToBounds = YES;
        _noReadInfoCountLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        // 观察者 观察消息中心未读消息的数量
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noReadInfoCount) name:@"noReadInfoCount" object:nil];
        
    }else if ( indexPath.section == 1) {
        cell.image.image = [UIImage imageNamed:@"setting.png"];
        cell.titleLabel.text = @"设置";
    }else if ( indexPath.section == 2) {
        cell.image.image = [UIImage imageNamed:@"feedBack.png"];
        cell.titleLabel.text = @"意见反馈";
    }else if ( indexPath.section == 3) {
        cell.image.image = [UIImage imageNamed:@"exit.png"];
        cell.titleLabel.text = @"退出登录";
    }
    
    return cell;
}
// 观察者方法
- (void)noReadInfoCount{
    
    if (_infoVC.noReadInfoArray.count != 0) {
        _noReadInfoCountLabel.backgroundColor = [UIColor redColor];
        [_noReadInfoCountLabel setTextAlignment:NSTextAlignmentCenter];
        _noReadInfoCountLabel.text = [NSString stringWithFormat:@"%ld",_infoVC.noReadInfoArray.count];
    }else{
        _noReadInfoCountLabel.backgroundColor = [UIColor whiteColor];
        _noReadInfoCountLabel.text = @"";
        
        
    }
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
        self.hidesBottomBarWhenPushed=YES;

        if (_infoVC.allInfoArray.count == 0) {
            SDInfoViewController * info = [[SDInfoViewController alloc] init];
            [self.navigationController pushViewController:info animated:YES];
        }else{
            [self.navigationController pushViewController:_infoVC animated:YES];
 
            
        }
        self.hidesBottomBarWhenPushed=NO;

        
    }else if (indexPath.section == 1){
        
        SDSetViewController * setVC = [[SDSetViewController alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:setVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else if (indexPath.section == 2){
        
        SDFeedBackViewController * feedBackVC = [[SDFeedBackViewController alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:feedBackVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        
        
    }else if(indexPath.section == 3){
        
        if (_token  == nil) {
            
            [MBProgressHUD showError:@"用户还未登录，请登录"];
            
            [self performSelector:@selector(GoToMainView) withObject:self afterDelay:0.8f];
            
        }else{
            
            NSString * urlStr = [NSString stringWithFormat:userLoginOutHttp];
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            
            [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
                //这里可以用来显示下载进度
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (responseObject != nil) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userExit" object:self];
                    [MBProgressHUD showSuccess:@"退出成功"];
                    
                    [self performSelector:@selector(GoToMainView) withObject:self afterDelay:0.8f];
                    
                }
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //失败
                NSLog(@"failure  error ： %@",error);
                [MBProgressHUD showError:@"退出失败"];
                
                
            }];
            
            
        }
        
        
        
    }
    
}
- (void)GoToMainView
{
    LoginViewController *  laginVC =  [[LoginViewController alloc] init];
    
    [self presentViewController:laginVC animated:YES completion:nil];
    
}

// 消息中心数据
- (void)makeInfoData
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString * urlStr = [NSString stringWithFormat:userInfoHttp];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (responseObject != nil) {
                _infoVC= [[SDInfoViewController alloc] init];
                _infoVC.allInfoArray = [NSMutableArray array];
                _infoVC.noReadInfoArray = [NSMutableArray array];
                _infoVC.readedInfoArray = [NSMutableArray array];
                
                
                
                NSMutableArray * infoArray = [NSMutableArray array];
                infoArray = responseObject[@"resdata"];
                NSLog(@"%@",responseObject);
                for (NSDictionary * dict in infoArray) {
                    
                    InfoModel * model = [[InfoModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dict];
                    
                    [_infoVC.allInfoArray addObject:model];
                    if (model.readflag == 0 ) {
                        [_infoVC.noReadInfoArray addObject:model];
                    }else if(model.readflag == 1){
                        [_infoVC.readedInfoArray addObject:model];
                    }
                    
                }
                
                // 发送通知 未读消息的数量
                [[NSNotificationCenter defaultCenter] postNotificationName:@"noReadInfoCount" object:nil];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            
        }];
        
    });
    
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
