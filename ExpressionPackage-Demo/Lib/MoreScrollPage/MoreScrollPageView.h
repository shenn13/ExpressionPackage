//
//  MoreScrollPageView.h
//  VideosPlayer
//
//  Created by shen on 16/12/21.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MorePageHeaderView.h"


@protocol LKQScrollPageViewDelegate <NSObject>

-(void)LKQDidEndDeceleratingCurrentPage:(NSInteger)currentPage;

@end

@interface MoreScrollPageView : UIView<UIScrollViewDelegate,MorePageHeaderBtnDelegate>
//header
@property(nonatomic,strong) MorePageHeaderView *headerView;

//下面的视图
@property(nullable,nonatomic,strong)UIScrollView *scrollview;
//当前第几个view
@property(nonatomic,assign)NSInteger currentPage;

@property(nullable,nonatomic,weak)id<LKQScrollPageViewDelegate> delegate;

/**加载的view的控制器viewcontroller*/
@property(nullable, nonatomic,copy) NSArray<__kindof UIViewController *> *viewControllers;

- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray<__kindof UIViewController *> * __nullable)viewControllers names:(NSArray<__kindof NSString *> * __nullable)names;

@end
