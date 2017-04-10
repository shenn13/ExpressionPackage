//
//  EPLoveViewController.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/23.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPLoveViewController.h"
#import "EPLoveManage.h"
#import "EPDIYViewController.h"
#import "EPLoveCollectionViewCell.h"

#import "EPTextModel.h"
@interface EPLoveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    UICollectionView *_collectView;
    NSMutableArray *_dataArr;
    NSInteger _numPage;
}
@end

@implementation EPLoveViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [_collectView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    _dataArr = [NSMutableArray array];
    
    [self createCollectViewView];
}

-(void)createCollectViewView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,10, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[EPLoveCollectionViewCell class] forCellWithReuseIdentifier:@"EPLoveCellID"];
    [self.view addSubview:_collectView];
    
    [_dataArr addObjectsFromArray:[[EPLoveManage shareManager] searchAllData]];
    [_collectView reloadData];
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
    
    EPLoveCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EPLoveCellID" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EPTextModel *model = _dataArr[indexPath.row];
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
