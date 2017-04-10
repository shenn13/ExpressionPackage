//
//  EPBaseViewController.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPBaseViewController.h"

@interface EPBaseViewController ()

@end

@implementation EPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:kMainScreenColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:246.0/255 alpha:1];
    
    
    [self customNavigationItem];
    
}

//自定制当前视图控制器的navigationItem
-(void)customNavigationItem{
    
    UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backimage"] style:UIBarButtonItemStylePlain target:self action:@selector(popDoBack)];
    self.navigationItem.leftBarButtonItem =  backbtn;
}

-(void)popDoBack{
    if (_isPresent) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
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
