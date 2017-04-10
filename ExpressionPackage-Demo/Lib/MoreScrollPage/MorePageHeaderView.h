//
//  MorePageHeaderView.h
//  VideosPlayer
//
//  Created by shen on 16/12/21.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MorePageHeaderBtnDelegate <NSObject>

-(void)pageCurrentBtn:(NSInteger)current;

@end


@interface MorePageHeaderView : UIView <UIScrollViewDelegate>

@property(assign,nonatomic)id<MorePageHeaderBtnDelegate>delegate;

@property(nullable,nonatomic,strong)UIScrollView *scrollview;
@property(nullable, nonatomic,copy) NSArray<__kindof UIButton *> *buttons;

@property(nullable,nonatomic,strong)UIButton *currentBtn;

- (instancetype)initWithFrame:(CGRect)frame names:(NSArray<__kindof NSString *> * __nullable)names;

- (void)setCurrentheaderbtn:(NSInteger)index;

@end
