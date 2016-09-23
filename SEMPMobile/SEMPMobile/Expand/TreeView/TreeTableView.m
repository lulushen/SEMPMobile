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

@property (nonatomic , strong)NSMutableArray * modelIDArray;

@property (nonatomic , assign)NSInteger maxLevel;

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
        NSMutableArray * arr = [NSMutableArray array];
        for (DefaultD_resModel *m in _data) {
            NSNumber* number = [NSNumber numberWithInteger:m.res_level];
            [arr addObject:number];
        }
        // 获得组织的最低级别，用来判断最低级别的组织没有图片
        NSNumber * max = [arr valueForKeyPath:@"@max.floatValue"];
        _maxLevel = [max integerValue];

    }
    return self;
}

/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    _modelIDArray = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        DefaultD_resModel *model = [_data objectAtIndex:i];
//   YES 1     no 0
        if (model.expand == YES) {
            [tempArray addObject:model];
        }
    }
    return tempArray;
}


#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    _imageView.frame = CGRectMake(cell.indentationWidth * cell.indentationLevel+10*KWidth6scale, 5, 20, 20);
    [cell addSubview:_imageView];
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.frame = CGRectMake(CGRectGetMaxX(_imageView.frame), CGRectGetMinY(_imageView.frame), Main_Screen_Width, CGRectGetHeight(_imageView.frame));
    [cell addSubview:_titleButton];
    [_titleButton setTitle:model.d_res_clname forState:UIControlStateNormal];
    [_titleButton setTintColor:[UIColor blackColor]];
    _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //top, left, bottom, right
    _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_titleButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _imageView.tag = indexPath.row;
    _titleButton.tag = indexPath.row;
    [_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _imageView.image = [UIImage imageNamed:@"noexpend.png"];

    //判断当组织级别最低的一层没有图片
    if (model.res_level == _maxLevel) {
        _imageView.image = [UIImage imageNamed:@""];

    }else{
        // 判断model是否被点击过，被点击过的model的图片是展开图片，否则是未展开图片
        if (_modelIDArray.count == 0) {
           
            _imageView.image = [UIImage imageNamed:@"noexpend.png"];
            
        }else{
            
            for (int i =0; i< _modelIDArray.count ;i++) {
                
                DefaultD_resModel *m =_modelIDArray[i];
                
                NSString * modelID = m.d_res_id;
                    
                    if ([model.d_res_id isEqualToString:modelID]) {
                        
                        _imageView.image = [UIImage imageNamed:@"expend.png"];
                        
                    }
                
            }
  

            
        }
        
  
    }

    
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
    // 判断图片的用途
    NSMutableArray * array = [NSMutableArray arrayWithArray:_modelIDArray];
    if (parentModel.res_level == _maxLevel) {
        
    }else{

            [_modelIDArray addObject:parentModel];

            for (int i = 0;i< array.count; i++ ) {
                
                DefaultD_resModel *m =array[i];
                
                NSString * modelID = m.d_res_id;
                NSString * modelRootID = m.d_res_parentid;
                // 判断父级节点不展示的时候删除所有旗下所有正在展示的子节点
                if ([parentModel.d_res_id isEqualToString:modelRootID]) {
                    
                      [_modelIDArray removeObject:m];
                }
                if ([parentModel.d_res_id isEqualToString:modelID]) {
                    
                    [_modelIDArray removeObject:parentModel];
                   
                }
            }
  
    }
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
