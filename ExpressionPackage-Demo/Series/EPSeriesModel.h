//
//  EPSeriesModel.h
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMtagListModel
@end

@interface FMtagListModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*id;
@property (nonatomic, strong) NSString *bisRecommend;
@property (nonatomic, strong) NSString *bisDelete;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *gifPath;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *picPath;
@property (nonatomic, strong) NSString *ts;
@property (nonatomic, strong) NSString *bisLock;
@property (nonatomic, strong) NSString *name;

@end


@protocol EPdtTypeModel
@end
@interface EPdtTypeModel : JSONModel
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString <Optional>*id;
@property (nonatomic, strong) NSString *ts;
@property (nonatomic, strong) NSString *bisShowImg;
@property (nonatomic, strong) NSString *bisDelete;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *name;
@end


@interface EPSeriesModel : JSONModel

@property (nonatomic,strong) NSArray<FMtagListModel>*tagList;

@property (nonatomic,strong) EPdtTypeModel *dtTypeModel;

@end
