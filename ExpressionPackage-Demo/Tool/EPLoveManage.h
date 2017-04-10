//
//  EPLoveManage.h
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/23.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EPTextModel;
@interface EPLoveManage : NSObject

+ (instancetype)shareManager;

- (BOOL)insertDataWithModel:(EPTextModel *)model;

// 查询一条数据是否存在
- (BOOL)searchIsExistWithID:(NSString *)ID;

- (BOOL)deleteDataWithID:(NSString *)ID;

- (NSArray *)searchAllData;

@end
