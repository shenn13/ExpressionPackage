//
//  EPRecommendViewController.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPRecommendViewController.h"
#import "EPRecommendModel.h"
#import "EPRecommendCollectionViewCell.h"
#import "EPDIYViewController.h"


@interface EPRecommendViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    UICollectionView *_collectView;
    NSMutableArray *_dataArr;
    NSInteger _numPage;
}

@end

@implementation EPRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem =  nil;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"推荐模板";
    _dataArr = [NSMutableArray array];
    
    _numPage = 0;
    
    [self getDataNetworkingWithPage:0 isLoadMore:NO];
}

-(void)getDataNetworkingWithPage:(NSInteger)page isLoadMore:(BOOL)isLoadMore{
    
    NSString *newStr = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/recommendList.html?pageNum=%ld&pageSize=48",(long)_numPage];
    
    [[AFNetworkingManager manager] getDataWithUrl:newStr parameters:nil successBlock:^(id data) {
//       NSLog(@"--------%@",data);
        NSArray *arr = data[@"data"];
        
        if (!isLoadMore) {
            
            [_dataArr removeAllObjects];
            
        } if (arr.count == 0) {
            
            [_collectView.mj_footer endRefreshingWithNoMoreData];
            [[EPProgressShow showHUDManager] showInfoWithStatus:@"没有更多数据啦..."];
        }else {
            
            
            for (NSDictionary *dict in arr) {
                
                EPRecommendModel *model = [[EPRecommendModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArr addObject:model];
            }
            if (!_collectView) {
                
                [self createCollectViewView];
            }
            [_collectView reloadData];
        }
        
        [_collectView.mj_footer endRefreshing];
        [_collectView.mj_header endRefreshing];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
        
        [_collectView.mj_footer endRefreshing];
        [_collectView.mj_header endRefreshing];
        
    }];
    
}

-(void)createCollectViewView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,10, kScreenWidth, kScreenHeight - 59 ) collectionViewLayout:layout];
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[EPRecommendCollectionViewCell class] forCellWithReuseIdentifier:@"EPRecommendCellID"];
    
    _collectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_collectView.mj_header beginRefreshing];
    _collectView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.view addSubview:_collectView];
}

#pragma 下拉刷新
- (void)refreshData{
    _numPage = 0;
    [self getDataNetworkingWithPage:0 isLoadMore:NO];
}
- (void)loadMoreData{
    _numPage ++;
    [self getDataNetworkingWithPage:_numPage isLoadMore:YES];
}


#pragma mark --UICollectionViewDelegate

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 60)/3, H(120));
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EPRecommendCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EPRecommendCellID" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EPRecommendModel *model = _dataArr[indexPath.row];
    EPDIYViewController *DIYVC = [[EPDIYViewController alloc] init];
    DIYVC.imageStrID = model.id;
    DIYVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:DIYVC animated:NO];
    
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
