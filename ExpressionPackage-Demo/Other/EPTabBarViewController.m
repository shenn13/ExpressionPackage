//
//  EPTabBarViewController.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPTabBarViewController.h"
#import "EPNavigationViewController.h"

#import "UIImage+Extension.h"

@interface EPTabBarViewController ()

@end

@implementation EPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubViewsControllers];
    [self customTabbarItem];
    
//    [self.tabBar setBarTintColor:kMainScreenColor];
    
}

-(void)addSubViewsControllers{
    NSArray *classControllers = @[@"EPHomeViewController",@"EPSeriesViewController",@"EPRecommendViewController",@"EPMyCenterViewController"];
    NSMutableArray *conArr = [NSMutableArray array];
    
    for (int i = 0; i < classControllers.count; i ++) {
        Class cts = NSClassFromString(classControllers[i]);
        
        UIViewController *vc = [[cts alloc] init];
        EPNavigationViewController *naVC = [[EPNavigationViewController alloc] initWithRootViewController:vc];
        [conArr addObject:naVC];
    }
    self.viewControllers = conArr;
}

-(void)customTabbarItem{
    
    NSArray *titles = @[@"首页",@"系列分类",@"推荐模板",@"设置"];

    NSArray *normalImages = @[@"tabbar_home_default", @"tabbar_municipios_default", @"tabbar_tools_default", @"tabbar_mine_default"];
    NSArray *selectImages = @[@"tabbar_home_select", @"tabbar_municipios_select", @"tabbar_tools_select", @"tabbar_mine_select"];
    
    for (int i = 0; i < titles.count; i++) {
        
        UIViewController *vc = self.viewControllers[i];
        
        UIImage *normalImage = [UIImage imageWithOriginalImageName:normalImages[i]];
        UIImage *selectImage = [UIImage imageWithOriginalImageName:selectImages[i]];
        
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:normalImage selectedImage:selectImage];
        
        
        
    }
    
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
