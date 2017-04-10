//
//  EPLoveCollectionViewCell.h
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/23.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EPTextModel;

@interface EPLoveCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)EPTextModel *model;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleName;
@property (strong, nonatomic) UILabel *gifImageLogo;

@end
