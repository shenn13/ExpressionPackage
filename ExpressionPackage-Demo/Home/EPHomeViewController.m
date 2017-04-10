//
//  EPHomeViewController.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPHomeViewController.h"
#import "MoreScrollPageView.h"

#import "EPTodayViewController.h"
#import "EPHotViewController.h"
#import "EPNewViewController.h"
#import "PYSearchViewController.h"
#import "PESearchViewController.h"

@interface EPHomeViewController ()

@end

@implementation EPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"首页";
    self.navigationItem.leftBarButtonItem =  nil;
    
    [self createMoreView];
    [self cusNavigationItem];
    
    
}

-(void)cusNavigationItem{
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setImage:[UIImage imageNamed:@"searchimage"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(jumpToSearchView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)jumpToSearchView{
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入要搜索的表情包名字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        PESearchViewController *searchVC = [[PESearchViewController alloc] init];
        searchVC.searchWord = searchText;
        [searchViewController.navigationController pushViewController:searchVC animated:NO];
    }];
    
    searchViewController.hotSearchStyle = PYHotSearchStyleRankTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    nav.navigationBar.barTintColor = kMainScreenColor;
    [self presentViewController:nav  animated:NO completion:nil];
}


-(void)createMoreView{
    
    EPTodayViewController *todayVC=[[EPTodayViewController alloc]init];
    todayVC.urlStr = shareItemNewListURL;
    todayVC.isHide = YES;
    EPHotViewController *hotVC=[[EPHotViewController alloc]init];
    hotVC.urlStr = hotListURL;
    hotVC.isHide = NO;
    EPNewViewController *newVC=[[EPNewViewController alloc]init];
    newVC.urlStr = newListURL;
    newVC.isHide = NO;
    
   
    MoreScrollPageView *scrollPageview=[[MoreScrollPageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) controllers:@[todayVC,hotVC,newVC] names:@[@"今日推荐",@"热门更新",@"最新表情"] ];
    
    [self.view addSubview:scrollPageview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
