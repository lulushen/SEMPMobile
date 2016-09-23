//
//  DefaultD_resModel.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/24.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultD_resModel : NSObject
//父节点的id
@property (nonatomic , copy) NSString * d_res_parentid;
//本届点的ID
@property (nonatomic , copy) NSString * d_res_id;
@property (nonatomic , copy) NSString * d_res_rootid;
@property (nonatomic , copy) NSString * d_res_pkid;

@property (nonatomic , copy) NSString * d_res_flname;
//组织名称
@property (nonatomic , copy) NSString * d_res_clname;
// 组织下的用户
@property (nonatomic , copy) NSMutableArray * user;

@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态
@property (nonatomic , assign) NSInteger res_level;//该节点的深度
/**
 *快速实例化该对象模型
 */
- (instancetype)initWithParentId : (NSString *)parentId nodeId : (NSString*)nodeId name : (NSString *)name  res_level : (NSInteger)res_level expand : (BOOL)expand user: (NSMutableArray *)user;

@end
