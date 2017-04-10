//
//  MoreScrollPageView.m
//  VideosPlayer
//
//  Created by shen on 16/12/21.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "MoreScrollPageView.h"

@implementation MoreScrollPageView

//初始化
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray<UIViewController *> *)viewControllers names:(NSArray<__kindof NSString *> * _Nullable)names
{
    if (self=[super initWithFrame:frame]) {
        
        self.currentPage=0;
        
        self.userInteractionEnabled=YES;
        
        self.viewControllers = viewControllers;
        
        self.headerView = [[MorePageHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40) names:names];
        
        self.headerView.delegate = self;
        [self addSubview:self.headerView];
        
        
        self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height - 50)];
        self.scrollview.delegate = self;
        self.scrollview.pagingEnabled = YES;
        [self addSubview:self.scrollview];
        
        
        self.scrollview.showsHorizontalScrollIndicator = NO;
        self.scrollview.contentSize = CGSizeMake(self.bounds.size.width * self.viewControllers.count, 0);
        
        if (viewControllers.count>0) {
            
            [self addSubviewWithPage:0];
        }
    }
    
    return self;
    
}
//添加view
-(void)addSubviewWithPage:(NSInteger)page{
    
    if (self.viewControllers.count > page) {
        
        UIView *currentView = self.viewControllers[page].view;
        
        if (currentView.superview == nil) {
            
            CGFloat width = self.scrollview.bounds.size.width;
            
            CGFloat height = self.scrollview.bounds.size.height;
            
            currentView.frame = CGRectMake(width * page, 0, width, height);
            
            [self.scrollview addSubview:currentView];
            
        }
        
    }
}
#pragma mark---uiscrollView delegate
/**结束拖拽*/
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"DidEndDragging");
}
/**正在滑动*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"DidScroll");
}
/**滑动结束*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPage = (NSInteger)scrollView.contentOffset.x/(NSInteger)self.scrollview.bounds.size.width;
    
    [self addSubviewWithPage:self.currentPage];
    
//    NSLog(@"DidEndDecelerating:");
    
    if (self.delegate) {
        
        [self.delegate LKQDidEndDeceleratingCurrentPage:self.currentPage];
    }
    [self.headerView setCurrentheaderbtn:self.currentPage];
}




#pragma mark--page header dalegate
-(void)pageCurrentBtn:(NSInteger)current
{
    self.currentPage=current;
    
    self.scrollview.contentOffset=CGPointMake(self.bounds.size.width*current, 0);
    
    [self addSubviewWithPage:self.currentPage];
    
//    self.scrollview.contentOffset=CGPointMake(self.bounds.size.width*current, 0);
//    
//    [self addSubviewWithPage:self.currentPage];
    
    if (self.delegate) {
        
        [self.delegate LKQDidEndDeceleratingCurrentPage:self.currentPage];
    }
    
}

@end
