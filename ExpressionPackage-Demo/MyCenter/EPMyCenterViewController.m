//
//  EPMyCenterViewController.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPMyCenterViewController.h"
#import "EPAboutViewController.h"
#import "EPLoveViewController.h"


@interface EPMyCenterViewController (){
    UILabel *_canchSizeLabel;
}

@end

@implementation EPMyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem =  nil;
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createMyView];
}


-(void)createMyView{
    
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 150)];
    header.backgroundColor = kMainScreenColor;
    [self.view addSubview:header];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, (header.height - 120)/2, 100, 100)];
    imageView.layer.cornerRadius = imageView.width/2;
    imageView.layer.masksToBounds = YES;
    
    imageView.image = [UIImage imageNamed:@"logoimage"];
    [header addSubview:imageView];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(imageView.frame)+ 5 , kScreenWidth,20)];
    label.text = [NSString stringWithFormat:@"版本号:%@(%@)",app_Version,app_build];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [header addSubview:label];
    
    NSArray *picImageArr = @[@"edit",@"loveimage",@"mycenter",@"pingfen"];
    NSArray *nameArr = @[@"清除缓存",@"我的收藏",@"关于APP",@"为我评分"];
    for (int i = 0; i < picImageArr.count; i ++) {
        
        UIView *myBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame) + 57 * i, kScreenWidth, 55)];
        myBgView.tag = i;
        myBgView.userInteractionEnabled = YES;
        myBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:myBgView];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [myBgView addGestureRecognizer:singleTap];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, 2)];
        line.backgroundColor = kLineColor;
        [myBgView addSubview:line];
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 25, 25)];
        iconImage.image = [UIImage imageNamed:picImageArr[i]];
        [myBgView addSubview:iconImage];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 15, 125, 25)];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = nameArr[i];
        [myBgView addSubview:nameLabel];
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 15, 25, 25)];
        arrowImage.image = [UIImage imageNamed:@"about"];
        [myBgView addSubview:arrowImage];
        if (i == 0) {
            arrowImage.image =[UIImage imageNamed:@""];
            
            _canchSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 15, 100, 25)];
            _canchSizeLabel.textAlignment = NSTextAlignmentCenter;
            _canchSizeLabel.font = [UIFont systemFontOfSize:10];
            _canchSizeLabel.text = [NSString stringWithFormat:@"总共有%.2fM缓存",[self getCanchSize]];
            [myBgView addSubview:_canchSizeLabel];
        }
    }
}
-(void)viewClick:(UITapGestureRecognizer*)gesture{
    
    UIView *v = (UIView*)gesture.view;
    switch (v.tag) {
        case 0:
            [self wipeCache];
            break;
        case 1:
            
            [self pushLoveViewController];
            
            break;
        case 2:
            [self pushAboutViewController];
            break;
        case 3:
            [self releaseInfo];
            break;
        default:
            break;
    }
}

-(void)wipeCache{
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"总共有%.2fM缓存",[self getCanchSize]] preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //清除磁盘
        [[SDImageCache sharedImageCache] clearDisk];
        //清除内存
        [[SDImageCache sharedImageCache] clearMemory];
        
        _canchSizeLabel.text = [NSString stringWithFormat:@"总共有%.2fM缓存",[self getCanchSize]];
        
        [[EPProgressShow showHUDManager] showSuccessWithStatus:@"缓存清空完成"];
        
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //取消
    }]];
    [self presentViewController:sheet animated:YES completion:nil];
    
    
}

-(void)pushLoveViewController{
    EPLoveViewController *loveVC = [[EPLoveViewController alloc] init];
    loveVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loveVC animated:NO];
}
-(void)pushAboutViewController{
    
    EPAboutViewController *aboutVC = [[EPAboutViewController alloc] init];
    aboutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutVC animated:NO];
}

- (void)releaseInfo{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPCommentURL]];
}

-(CGFloat )getCanchSize{
    
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    return imageCacheSize*1.0/(1024*1024);
    
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
