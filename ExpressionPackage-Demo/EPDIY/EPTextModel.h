//
//  EPTextModel.h
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/21.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPTextModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *gifPath;
@property (nonatomic, strong) NSString *picPath;
@property (nonatomic, strong) NSString *recommendTime;
@property (nonatomic, strong) NSString *bisLock;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *clickNum;
@property (nonatomic, strong) NSString *clickWeight;
@property (nonatomic, strong) NSString *bisRecommend;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bisDelete;
@property (nonatomic, strong) NSString *ts;

@end







//@protocol EPList2Model
//@end
//
//@interface EPList2Model : JSONModel
//
//@property (nonatomic, strong) NSString *bisDelete;
//@property (nonatomic, strong) NSString *clickNum;
//@property (nonatomic, strong) NSString *clickWeight;
//@property (nonatomic, strong) NSString *createTime;
//@property (nonatomic, strong) NSString *id;
//@property (nonatomic, strong) NSString *itemId;
//@property (nonatomic, strong) NSString *ts;
//@property (nonatomic, strong) NSString *type;
//@property (nonatomic, strong) NSString *word;
//@end
//
//
//@protocol EPItemModel
//@end
//@interface EPItemModel : JSONModel
//
//@property (nonatomic, strong) NSString *bisDelete;
//@property (nonatomic, strong) NSString *bisLock;
//@property (nonatomic, strong) NSString *bisRecommend;
//@property (nonatomic, strong) NSString *clickNum;
//@property (nonatomic, strong) NSString *clickWeight;
//@property (nonatomic, strong) NSString *createTime;
//@property (nonatomic, strong) NSString *gifPath;
//@property (nonatomic, strong) NSString *id;
//@property (nonatomic, strong) NSString *mediaType;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *picPath;
//@property (nonatomic, strong) NSString *recommendTime;
//@property (nonatomic, strong) NSString *ts;
//@end
//
//
//@interface EPTextModel : JSONModel
//
//@property (nonatomic,strong) NSArray<EPList2Model>*list;
//@property (nonatomic,strong) EPItemModel *item;
//
//@end
