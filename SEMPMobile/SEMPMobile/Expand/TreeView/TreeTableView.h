//
//  TreeTableView.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DefaultD_resModel;

@protocol TreeTableCellDelegate <NSObject>

-(void)cellClick : (DefaultD_resModel *)model;

@end

@interface TreeTableView : UITableView
@property (nonatomic , strong)DefaultD_resModel * model;

@property (nonatomic , weak) id<TreeTableCellDelegate> treeTableCellDelegate;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data;

@end
