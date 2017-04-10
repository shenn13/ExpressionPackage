//
//  EPSeriesViewController.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPSeriesViewController.h"
#import "EPSeriesTableViewCell.h"
#import "EPSeriesModel.h"
#import "JSONModel.h"
#import "EPDetailsSeriesViewController.h"

@interface EPSeriesViewController ()<UITableViewDelegate,UITableViewDataSource,EPSeriesTableViewCellDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}

@end

@implementation EPSeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem =  nil;
    self.title = @"系列分类";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [NSMutableArray array];

    [self getSeriesDataNetworking];
}

-(void)getSeriesDataNetworking{
    [[AFNetworkingManager manager] getDataWithUrl:allListURL parameters:nil successBlock:^(id data) {
//        NSLog(@"--------%@",data);
        NSArray *arr = data[@"data"];
       if (arr.count == 0) {
            [[EPProgressShow showHUDManager] showInfoWithStatus:@"没有更多数据啦..."];
        }else {
            for (NSDictionary *dict in arr) {
                EPSeriesModel *model = [[EPSeriesModel alloc] init];
                model = [[EPSeriesModel alloc] initWithDictionary:dict error:nil];
                [_dataArr addObject:model];
            }
            if (!_tableView) {
                [self createTableView];
            }
            [_tableView reloadData];
        }
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
       
    }];
    
}


-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight  - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EPSeriesTableViewCell *cell = [EPSeriesTableViewCell cellWithTableView:tableView];
    cell.model = _dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    
    NSArray *arr = [_dataArr[indexPath.row] tagList];
    CGFloat H;
    if (arr.count%4 == 0) {
        H = H(110) * (arr.count/4);
    }else{
        H =H(110) * (arr.count/4 + 1);
    }
    return H + H(50);

}
#pragma mark - EPSeriesTableViewCellDelegate

-(void)tapedViewInCell:(UITableViewCell *)cell withIndex:(NSInteger)index{

    EPDetailsSeriesViewController *detailsVideoViewVC = [[EPDetailsSeriesViewController alloc] init];
    detailsVideoViewVC.idStr = [NSString stringWithFormat:@"%ld",(long)index];
    detailsVideoViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVideoViewVC animated:NO];
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
