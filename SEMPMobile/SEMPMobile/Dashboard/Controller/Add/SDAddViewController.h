//
//  SDAddViewController.h
//  SempMobile
//
//  Created by 上海数聚 on 16/7/11.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChuanzhiDelegate <NSObject>

- (void)chuanzhi:(NSMutableArray *)array;

@end

@interface SDAddViewController : UIViewController

@property (nonatomic , weak) id<ChuanzhiDelegate> delegate;

@end
