//
//  EPTodayViewController.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPTodayViewController.h"
#import "EPTodayCollectionViewCell.h"
#import "EPTodayModel.h"
#import "EPDIYViewController.h"
#import "EPNavigationViewController.h"
#import "AppDelegate.h"


@interface EPTodayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    UICollectionView *_collectView;
    NSMutableArray *_dataArr;
    NSInteger _numPage;
}

@end

@implementation EPTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArr = [NSMutableArray array];
    
    _numPage = 0;
    
    [self getDataNetworkingWithPage:0 isLoadMore:NO];
    
}

-(void)getDataNetworkingWithPage:(NSInteger)page isLoadMore:(BOOL)isLoadMore{
    
    NSString *newStr = [NSString stringWithFormat:@"%@%ld&pageSize=48",_urlStr,(long)_numPage];
    
    
    [[AFNetworkingManager manager] getDataWithUrl:newStr parameters:nil successBlock:^(id data) {
//        NSLog(@"--------%@",data);
        
        NSArray *arr = data[@"data"];

        if (!isLoadMore) {
            
            [_dataArr removeAllObjects];
            
        } if (arr.count == 0) {
            [_collectView.mj_footer endRefreshingWithNoMoreData];
             [[EPProgressShow showHUDManager] showInfoWithStatus:@"没有更多数据啦..."];
            
        }else {
            for (NSDictionary *dict in arr) {
                
                EPTodayModel *model = [[EPTodayModel alloc] init];
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
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,- 54, kScreenWidth, kScreenHeight - 49 - 40 ) collectionViewLayout:layout];
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[EPTodayCollectionViewCell class] forCellWithReuseIdentifier:@"EPTodayCellID"];
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
    
    EPTodayCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EPTodayCellID" forIndexPath:indexPath];
    
    EPTodayModel *model = _dataArr[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.picPath] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    if ([[model.gifPath lowercaseString] hasSuffix:@".gif"]) {
        
        cell.gifImageLogo.text = @"GIF";
        
        [cell.imageView addSubview:cell.gifImageLogo];
        
    }else{
        [cell.gifImageLogo removeFromSuperview];
    }
    
    if (_isHide == YES) {
        
        cell.titleName.text = @"";
        
    }else{
        
        cell.titleName.text = model.name;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EPTodayModel *model = _dataArr[indexPath.row];
    
    EPDIYViewController *DIYVC = [[EPDIYViewController alloc] init];
    DIYVC.isPresent = YES;
    if (_isHide == YES) {
       DIYVC.imageStrID = model.itemId;
    }else{
        DIYVC.imageStrID = model.id;
    }
    EPNavigationViewController * nav = [[EPNavigationViewController alloc]   initWithRootViewController:DIYVC];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:nav animated:NO completion:nil];
    
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
