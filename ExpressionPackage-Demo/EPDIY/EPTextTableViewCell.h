//
//  EPTextTableViewCell.h
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/21.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EPListModel;
@interface EPTextTableViewCell : UITableViewCell
@property(nonatomic,strong)EPListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
