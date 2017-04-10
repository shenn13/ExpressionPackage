//
//  EPSeriesTableViewCell.h
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EPSeriesModel;

@protocol EPSeriesTableViewCellDelegate <NSObject>

- (void)tapedViewInCell:(UITableViewCell*)cell withIndex:(NSInteger)index;

@end

@interface EPSeriesTableViewCell : UITableViewCell

@property(assign,nonatomic)id<EPSeriesTableViewCellDelegate>delegate;

@property (nonatomic,strong)EPSeriesModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
