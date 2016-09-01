//
//  TreeTableView.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TreeTableView.h"
#import "DefaultD_resModel.h"

@interface TreeTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSMutableArray *data;//传递过来已经组织好的数据（全量数据）

@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）

@property (nonatomic , strong) UIImageView * imageView;


@property (nonatomic , strong)NSMutableArray * array;


@property (nonatomic , strong)UIButton * titleButton;

@end

@implementation TreeTableView
- (NSMutableArray *)array
{
    if (_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
-(instancetype)initWithFrame:(CGRect)frame withData : (NSMutableArray *)data{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        //去除分割线
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        _data = data;
        _tempData = [self createTempData:data];
    }
    return self;
}

/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        DefaultD_resModel *model = [_data objectAtIndex:i];
       
        if (model.expand == YES) {
            [tempArray addObject:model];
        }
    }
    return tempArray;
}


#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_tempData.count--%ld",_tempData.count);
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *NODE_CELL_ID = @"node_cell_id";
    
//    UITableViewCell*   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    // cell 不重用
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    DefaultD_resModel *model = [_tempData objectAtIndex:indexPath.row];
    
 
    // cell有缩进的方法
    cell.indentationLevel = model.res_level; // 缩进级别
    cell.indentationWidth = 15.0f; // 每个缩进级别的距离
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(cell.indentationWidth * cell.indentationLevel, 0, 30, 30);
    [cell addSubview:_imageView];
   
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.frame = CGRectMake(CGRectGetMaxX(_imageView.frame), CGRectGetMinY(_imageView.frame), Main_Screen_Width, CGRectGetHeight(_imageView.frame));
    [cell addSubview:_titleButton];
    [_titleButton setTitle:model.d_res_clname forState:UIControlStateNormal];
    [_titleButton setTintColor:[UIColor blackColor]];
    _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_titleButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _imageView.image = [UIImage imageNamed:@"expend.png"];
    _titleButton.tag = indexPath.row;

    [_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSMutableString *name = [NSMutableString string];
//    for (int i=0; i<node.depth; i++) {
//        [name appendString:@"     "];
//    }
//    [name appendString:node.name];
    
//    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
//    cell.textLabel.text = model.d_res_clname;
//    if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(cellClick:)]) {
//       
//        [_treeTableCellDelegate cellClick:model];
//    }
    return cell;
}


#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate

#pragma mark - Optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先修改数据源
    DefaultD_resModel *parentModel = [_tempData objectAtIndex:indexPath.row];
    if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(cellClick:)]) {
        [_treeTableCellDelegate cellClick:parentModel];
    }
    
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;

    BOOL expand = NO;
    for (int i=0; i<_data.count; i++) {
        DefaultD_resModel *model = [_data objectAtIndex:i];
        if (model.d_res_parentid == parentModel.d_res_id) {
            model.expand = !model.expand;
            
            if (model.expand) {
                [_tempData insertObject:model atIndex:endPosition];
                expand = YES;
              
                endPosition++;
            }else{
                expand = NO;
                endPosition = [self removeAllNodesAtParentNode:parentModel];
                break;
            }
        }
    }

    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
        for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    //插入或者删除相关节点
    if (expand) {
        [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
    [tableView reloadData];
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (DefaultD_resModel *)parentNode{
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        DefaultD_resModel *model = [_tempData objectAtIndex:i];
        endPosition++;
        if (model.res_level <= parentNode.res_level) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            model.expand = NO;
            break;
        }
        model.expand = NO;

    }
   
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}
- (void)titleButtonClick:(UIButton *)button
{
    DefaultD_resModel * Pmodel = [_tempData objectAtIndex:button.tag];
    
    _model = Pmodel;
    NSUInteger startPosition = button.tag+1;
    NSUInteger endPosition = startPosition;

    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseModelChange" object:nil];
    
}
@end
