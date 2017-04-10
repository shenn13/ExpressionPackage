//
//  EPLoveManage.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/23.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPLoveManage.h"
#import "EPTextModel.h"



@interface EPLoveManage(){
    FMDatabase          *_fmdb;
    NSLock              *_lock;
}
@end

@implementation EPLoveManage

static EPLoveManage *manager = nil;
+ (instancetype)shareManager {
    if (!manager) {
        manager = [[EPLoveManage alloc] init];
    }
    
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        manager = [super allocWithZone:zone];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = [[NSLock alloc] init];
        
        NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/app.db"];
        
        _fmdb = [FMDatabase databaseWithPath:dbPath];
        
        // 如果数据库没有创建，那么会先创建，然后open
        if ([_fmdb open]) {
            NSString *sql = @"create table if not exists app(appID varchar(50), appIcon varchar(1024), appName varchar(1024))";
            BOOL isSuccess = [_fmdb executeUpdate:sql];
            if (isSuccess) {
                //                NSLog(@"建表成功");
            } else {
                //                NSLog(@"建表失败:%@", _fmdb.lastErrorMessage);
            }
        }
    }
    
    return self;
}
- (BOOL)insertDataWithModel:(EPTextModel *)model {
    [_lock lock];
    
    NSString *sql = @"insert into app values(?, ?, ?)";
    
    BOOL isSuccess = [_fmdb executeUpdate:sql, model.id, model.gifPath, model.name];
    
    if (isSuccess) {
         [[EPProgressShow showHUDManager] showSuccessWithStatus:@"收藏成功！！！"];
    } else {
         [[EPProgressShow showHUDManager] showErrorWithStatus:@"收藏失败！！！"];
    }
    [SVProgressHUD dismissWithDelay:1.0];
    
    [_lock unlock];
    
    return isSuccess;
}

- (BOOL)searchIsExistWithID:(NSString *)ID {
    
    NSString *sql = @"select * from app where appID = ?";
    FMResultSet *set = [_fmdb executeQuery:sql, ID];
    return [set next];
}


- (BOOL)deleteDataWithID:(NSString *)ID {
    [_lock lock];
    
    NSString *sql = @"delete from app where appID = ?";
    
    BOOL isSuccess = [_fmdb executeUpdate:sql, ID];
    
 
    
    if (isSuccess) {
        
        [[EPProgressShow showHUDManager] showSuccessWithStatus:@"取消收藏成功！！！"];
        
    } else {
        
         [[EPProgressShow showHUDManager] showErrorWithStatus:@"取消收藏失败！！！"];
    }

    
    [_lock unlock];
    
    return isSuccess;
}
- (NSArray *)searchAllData {
    NSString *sql = @"select * from app";
    
    NSMutableArray *appArr = [NSMutableArray arrayWithCapacity:0];
    
    FMResultSet *set = [_fmdb executeQuery:sql];
    
    while ([set next]) {
        EPTextModel *model = [[EPTextModel alloc] init];

        model.id = [set stringForColumn:@"appID"];
        model.gifPath = [set stringForColumn:@"appIcon"];
        model.name = [set stringForColumn:@"appName"];
        
        [appArr addObject:model];
    }
    
    return appArr;
}


@end
