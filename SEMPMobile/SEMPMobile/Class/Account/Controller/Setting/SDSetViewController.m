//
//  SDSetViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/11.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDSetViewController.h"
#import "SetTableViewCell.h"
#import "MBProgressHUD+MJ.h"

@interface SDSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * setTableView;
}

@end

@implementation SDSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    [self makeSettingView];
    
    // Do any additional setup after loading the view.
}

- (void)makeSettingView
{
    
    setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
    setTableView.backgroundColor = DEFAULT_BGCOLOR;
    setTableView.delegate = self;
    setTableView.dataSource = self;
    [self.view addSubview:setTableView];
    // 去除分割线
    setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [setTableView registerClass:[SetTableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma ----tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.setImageView.image = [UIImage imageNamed:@"pass.png"];
        cell.setTitleLabel.text = @"设置锁密码";
    }else if (indexPath.row == 1){
        cell.setImageView.image = [UIImage imageNamed:@"deleteCache.png"];
        cell.setTitleLabel.text = @"清除缓存";
        cell.setDetailLabel.text = [NSString stringWithFormat:@"%0.2fM", [self filePath]];
    
    }else if (indexPath.row == 2){
        cell.setImageView.image = [UIImage imageNamed:@"edition.png"];
        cell.setTitleLabel.text = @"版本更新";
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*KHeight6scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self clearFile];

    }
    
}

#pragma ==清除缓存
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
        
    }
    
    return 0 ;
    
}
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}
// 显示缓存大小

- ( float )filePath

{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    
    NSLog(@"%@",cachPath);
    
    return [ self folderSizeAtPath :cachPath];
    
}

- ( void )clearFile

{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    [self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}

-(void)clearCachSuccess

{
    [MBProgressHUD showError:@"清除成功"];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    SetTableViewCell * cell = [setTableView cellForRowAtIndexPath: indexPath];
    cell.setDetailLabel.text = @"";

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
