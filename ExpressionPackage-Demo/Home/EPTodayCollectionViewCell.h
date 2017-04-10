//
//  EPTodayCollectionViewCell.h
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EPTodayModel;

@interface EPTodayCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)EPTodayModel *model;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleName;

@property (strong, nonatomic) UILabel *gifImageLogo;

@end
