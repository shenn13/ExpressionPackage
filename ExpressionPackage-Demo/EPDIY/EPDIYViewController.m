//
//  EPDIYViewController.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPDIYViewController.h"
#import "LGSegment.h"
#import "EPTextTableViewCell.h"
#import "EPTextModel.h"
#import "EPListModel.h"
#import "IQLabelView.h"
#import "EPLoveManage.h"

#import "GGActionSheet.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#define scrollViewH 220
#define segmentH 40

#define childVCBackgroundColor [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1]

@interface EPDIYViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SegmentDelegate,IQLabelViewDelegate,GGActionSheetDelegate>{

    UIImageView *_headImageView; //表情图
    UITextField *_labelText;//表情字体
    UITableView *_textTableView;//热门字体tableView
    NSMutableArray *_textDataArr;//热门字体数组
    EPTextModel *_textModel;
    
    
    UIImageView *_colorImagePalette;//字体颜色调色板
    UIImageView *_backgroundColorPalette;//字体背景调色板
    NSMutableArray *_textTypeArr;//字体样式数据
    
    IQLabelView *_currentlyEditingLabel;//拖拽控件
}
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic,strong)NSMutableArray *buttonList;//
@property (nonatomic, weak) LGSegment *segment;
@property(nonatomic,weak)CALayer *LGLayer;
@property (nonatomic, assign) CGRect titleLabelFrame;

@property(nonatomic,strong) GGActionSheet *actionSheetTitle;

@end

@implementation EPDIYViewController

- (NSMutableArray *)buttonList{
    if (!_buttonList){
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

-(GGActionSheet *)actionSheetTitle{
    if (!_actionSheetTitle) {
        
        BOOL isExist = [[EPLoveManage shareManager] searchIsExistWithID:_textModel.id];
        
        NSArray *titleArr;
        if (isExist == 0) {
            titleArr = @[@"分享到QQ",@"分享到微信",@"保存本地",@"收藏"];
        }else{
            titleArr = @[@"分享到QQ",@"分享到微信",@"保存本地",@"取消收藏"];
        }
        _actionSheetTitle = [GGActionSheet ActionSheetWithTitleArray:titleArr andTitleColorArray:@[[UIColor blackColor]] delegate:self];
        _actionSheetTitle.cancelDefaultColor = [UIColor redColor];
        _actionSheetTitle.optionDefaultColor = [UIColor blackColor];
    }
    return _actionSheetTitle;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"制作表情";
    _textDataArr = [NSMutableArray array];
    _textTypeArr = [NSMutableArray array];
    [self customNavigationItem];
    [self setSegment];
    [self getTextDataNetworking];
}

-(void)getTextDataNetworking{
    
    NSString *newStr = [NSString stringWithFormat:@"%@%@",getDetailURL,_imageStrID];
    
    [[AFNetworkingManager manager] getDataWithUrl:newStr parameters:nil successBlock:^(id data) {
//          NSLog(@"------%@",data);
        
         _textModel = [[EPTextModel alloc] init];
         _textModel.gifPath = [NSString stringWithFormat:@"%@",data[@"data"][@"item"][@"gifPath"]];
         _textModel.name =[NSString stringWithFormat:@"%@",data[@"data"][@"item"][@"name"]];
         _textModel.id =[NSString stringWithFormat:@"%@",data[@"data"][@"item"][@"id"]];

        NSArray *listArr = data[@"data"][@"list"];
        if (listArr.count == 0) {
           [[EPProgressShow showHUDManager] showInfoWithStatus:@"没有更多数据啦..."];
            
        }else {
            for (NSDictionary *dict in listArr) {
                EPListModel *model = [[EPListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_textDataArr addObject:model];
            }
            if (!_textTableView) {
                
                [self addChildViewController];
                [self setContentScrollView];
                [self createDIYView];
            }
            [_textTableView reloadData];
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
}



-(void)createDIYView{
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - scrollViewH - 40)];
    _headImageView.userInteractionEnabled = YES;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_textModel.gifPath] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.view addSubview:_headImageView];
    
    [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside:)]];
    
     CGRect labelFrame = CGRectMake(20,_headImageView.height - 60,kScreenWidth - 40, 50);
    _labelText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 50)];
    _labelText.text = _textModel.name;
    _labelText.textAlignment = NSTextAlignmentCenter;
     [_labelText sizeToFit];
    
    IQLabelView *labelView = [[IQLabelView alloc] initWithFrame:labelFrame];
    labelView.delegate = self;
    labelView.showContentShadow = NO;
    labelView.textView = _labelText;
    _currentlyEditingLabel = labelView;
    [labelView sizeToFit];
    [_currentlyEditingLabel endEditing: YES];
    [_headImageView addSubview:labelView];
}

-(void)setSegment{
    [self buttonList];
    LGSegment *segment = [[LGSegment alloc]initWithFrame:CGRectMake(0,kScreenHeight - scrollViewH - 40, kScreenWidth, segmentH)];
    segment.delegate = self;
    self.segment = segment;
    [self.view addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
    
}

-(void)setContentScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kScreenHeight - scrollViewH, kScreenWidth, scrollViewH + 64)];
    scrollView.bounces = NO;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    for (int i=0; i<self.childViewControllers.count; i++) {
        UIViewController *childVC = self.childViewControllers[i];
        childVC.view.frame = CGRectMake(i * kScreenWidth, - 64, kScreenWidth, scrollViewH + 64);
        childVC.view.backgroundColor = childVCBackgroundColor;
        childVC.automaticallyAdjustsScrollViewInsets = NO;
        [scrollView addSubview:childVC.view];
        
    }
    scrollView.contentSize = CGSizeMake(3 * kScreenWidth, 0);
    self.contentScrollView = scrollView;
}
//加载3个ViewController
-(void)addChildViewController{
/*************
  设置热门配文控件
************* */
    UIViewController * textVC = [[UIViewController alloc]init];
    [self addChildViewController:textVC];
    
    _textTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth,scrollViewH) style:UITableViewStylePlain];
    _textTableView.delegate = self;
    _textTableView.dataSource = self;
    _textTableView.backgroundColor = [UIColor clearColor];
    [textVC.view addSubview:_textTableView];
    
/*************
   设置字体控件
************* */
    UIViewController * colorVC = [[UIViewController alloc]init];
    
    [self addChildViewController:colorVC];
    
    UIButton *defaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(W(20),154, W(80), H(30))];
    [defaultBtn setTitle:@"默认颜色" forState:UIControlStateNormal];
    defaultBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [defaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    defaultBtn.layer.cornerRadius = defaultBtn.height / 2;
    defaultBtn.layer.masksToBounds = YES;
    defaultBtn.layer.borderWidth = 1;
    defaultBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    [defaultBtn addTarget:self action:@selector(defaultColor) forControlEvents:UIControlEventTouchUpInside];
    [colorVC.view addSubview:defaultBtn];
    
    _colorImagePalette = [[UIImageView alloc] initWithFrame:CGRectMake(defaultBtn.x + defaultBtn.width + W(20), 80, 180, 180)];
    _colorImagePalette.image = [UIImage imageNamed:@"Image_Palette"];
    _colorImagePalette.userInteractionEnabled = YES;
    [colorVC.view addSubview:_colorImagePalette];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorImagePaletteClick:)];
    [_colorImagePalette addGestureRecognizer:singleTap];

/*************
 设置字体样式控件
************* */
    UIViewController * textTypeVC = [[UIViewController alloc]init];
    [self addChildViewController:textTypeVC];
    
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *name in familyNames){
        NSArray *fontNames  = [UIFont fontNamesForFamilyName:name];
        for(NSString *fontname  in  fontNames){
            [_textTypeArr addObject:fontname];
        }
    }
    UIScrollView * textTypeScrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, scrollViewH)];
    textTypeScrollView.scrollEnabled = YES;
    textTypeScrollView.contentSize = CGSizeMake(0,660);
    [textTypeVC.view addSubview:textTypeScrollView];
    
    self.titleLabelFrame = CGRectZero;
    CGSize size = CGSizeMake((kScreenWidth - 60)/2 ,30);
    for (int i = 0; i < _textTypeArr.count; i ++ ) {
        CGFloat x = self.titleLabelFrame.origin.x;
        CGFloat y = self.titleLabelFrame.origin.y;
        if (i != 0) {
            x += (kScreenWidth - 60)/2;
        }else {
            y += 10;
        }
        CGFloat minX = x;
        CGFloat maxX = x + size.width;
        if (maxX > CGRectGetWidth(self.view.frame)) {
            x -= minX;
            y = y + size.height + 10;
        }
        CGRect rect = CGRectMake(x + 20, y, size.width, size.height);
        self.titleLabelFrame = rect;

        UIButton * titleBtn= [[UIButton alloc] initWithFrame:rect];
        [titleBtn setTitle:@"我是示范字体" forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont fontWithName:_textTypeArr[i] size:16];
        titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleBtn.layer.cornerRadius = titleBtn.height / 2;
        titleBtn.layer.masksToBounds = YES;
        titleBtn.layer.borderWidth = 1;
        titleBtn.tag = 1000 + i;
        titleBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        [titleBtn addTarget:self action:@selector(textTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [textTypeScrollView addSubview:titleBtn];
    }
    CGFloat H;
    if (_textTypeArr.count%2==0) {
        H = (size.height +10) * (_textTypeArr.count/2);
    }else{
        H = (size.height +10) * (_textTypeArr.count/2 + 1);
    }
    textTypeScrollView.contentSize = CGSizeMake(0,H + 10);
    
    
/*************
 设置字体背景控件
************* */
    UIViewController *backgroundColorVC = [[UIViewController alloc]init];
    [self addChildViewController:backgroundColorVC];
    
    UIButton *defaultBg = [[UIButton alloc] initWithFrame:CGRectMake(W(20),154, W(80), H(30))];
    [defaultBg setTitle:@"默认颜色" forState:UIControlStateNormal];
    defaultBg.titleLabel.font = [UIFont systemFontOfSize:16];
    [defaultBg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    defaultBg.layer.cornerRadius = defaultBg.height / 2;
    defaultBg.layer.masksToBounds = YES;
    defaultBg.layer.borderWidth = 1;
    defaultBg.layer.borderColor = [[UIColor blackColor] CGColor];
    [defaultBg addTarget:self action:@selector(defaultBackgroundColor) forControlEvents:UIControlEventTouchUpInside];
    [backgroundColorVC.view addSubview:defaultBg];
    
    _backgroundColorPalette = [[UIImageView alloc] initWithFrame:CGRectMake(defaultBtn.x + defaultBtn.width + W(20), 80, 180, 180)];
    _backgroundColorPalette.image = [UIImage imageNamed:@"Image_Palette"];
    _backgroundColorPalette.userInteractionEnabled = YES;
    [backgroundColorVC.view addSubview:_backgroundColorPalette];
    
    UITapGestureRecognizer *backgroundColorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundColorPaletteClick:)];
    [_backgroundColorPalette addGestureRecognizer:backgroundColorTap];
    
}
/******************
 设置字体的颜色点击方法
************* ********/
-(void)colorImagePaletteClick:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:_colorImagePalette];
    [_colorImagePalette at_getColorFromCircleWithPoint:point completion:^(UIColor * _Nonnull color) {
        _labelText.textColor = color;
    }];
}
-(void)defaultColor{
    _labelText.textColor = [UIColor blackColor];
}
/*******************
 设置字体背景的颜色点击方法
 ******************** */

-(void)backgroundColorPaletteClick:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:_backgroundColorPalette];
    [_backgroundColorPalette at_getColorFromCircleWithPoint:point completion:^(UIColor * _Nonnull color) {
        _labelText.backgroundColor = color;
    }];
}
-(void)defaultBackgroundColor{
    _labelText.backgroundColor = [UIColor clearColor];
}
/*******************
 设置字体样式的点击方法
 ******************** */
-(void)textTypeClicked:(UIButton *)sender{
    NSUInteger index = sender.tag - 1000;
    _labelText.font = [UIFont fontWithName:_textTypeArr[index] size:20];
}

#pragma mark - Gesture
- (void)touchOutside:(UITapGestureRecognizer *)touchGesture{
    [_currentlyEditingLabel hideEditingHandles];
}

#pragma mark - IQLabelDelegate
- (void)labelViewDidClose:(IQLabelView *)label{
}
- (void)labelViewDidBeginEditing:(IQLabelView *)label{
}
- (void)labelViewDidShowEditingHandles:(IQLabelView *)label{
    _currentlyEditingLabel = label;
}
- (void)labelViewDidHideEditingHandles:(IQLabelView *)label{
    _currentlyEditingLabel = nil;
}
- (void)labelViewDidStartEditing:(IQLabelView *)label{
    _currentlyEditingLabel = label;
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _textDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EPTextTableViewCell *cell = [EPTextTableViewCell cellWithTableView:tableView];
    cell.model = _textDataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EPListModel *model = _textDataArr[indexPath.row];
    _labelText.text = model.word;
    [_currentlyEditingLabel refresh];
    
}
#pragma mark - UIScrollViewDelegate
//实现LGSegment代理方法
-(void)scrollToPage:(int)Page {
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = self.view.frame.size.width * Page;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = offset;
    }];
}
// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    [self.segment moveToOffsetX:offsetX];
}

/*******************
 保存编辑后的表情点击方法
 ******************** */
-(void)sendExpressionPackageBtn{
    
    [self.actionSheetTitle showGGActionSheet];
}

#pragma mark - GGActionSheet代理方法
-(void)GGActionSheetClickWithIndex:(int)index{
    
    if (index == 0) {
        [self showActionShareTypeQQ];
    }else if (index == 1){
        [self showActionShareWechat];
    }else if (index == 2){
        UIImage *image = [self snapshot:_headImageView];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }else if (index == 3){

        BOOL isExist = [[EPLoveManage shareManager] searchIsExistWithID:_textModel.id];

        if (isExist == 0) {
            
           [[EPLoveManage shareManager] insertDataWithModel:_textModel];
           _actionSheetTitle = [GGActionSheet ActionSheetWithTitleArray:@[@"分享到QQ",@"分享到微信",@"保存本地",@"取消收藏"] andTitleColorArray:@[[UIColor blackColor]] delegate:self];
        }else{
            [[EPLoveManage shareManager] deleteDataWithID:_textModel.id];
            _actionSheetTitle = [GGActionSheet ActionSheetWithTitleArray:@[@"分享到QQ",@"分享到微信",@"保存本地",@"收藏"] andTitleColorArray:@[[UIColor blackColor]] delegate:self];
        }
    }
}
- (UIImage *)snapshot:(UIView *)view{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if(error != NULL){
        [[EPProgressShow showHUDManager] showErrorWithStatus:@"保存图片失败！"];
    }else{
         [[EPProgressShow showHUDManager] showErrorWithStatus:@"保存图片成功！"];
    }
   
}

//自定制当前视图控制器的navigationItem
-(void)customNavigationItem{
    
    UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backimage"] style:UIBarButtonItemStylePlain target:self action:@selector(popDoBack)];
    self.navigationItem.leftBarButtonItem =  backbtn;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(sendExpressionPackageBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}



- (void)showActionShareTypeQQ{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[self snapshot:_headImageView]];
    if (imageArray){
        [shareParams SSDKSetupShareParamsByText:_textModel.name
                                         images:imageArray
                                            url:nil
                                          title:@"来呀，互相伤害啊！！"
                                           type:SSDKContentTypeImage];
    }
    [ShareSDK share:SSDKPlatformTypeQQ 
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state){
             case SSDKResponseStateSuccess:{
                 [[EPProgressShow showHUDManager] showSuccessWithStatus:@"分享QQ成功"];
                 break;
             }
             case SSDKResponseStateFail:{
            
                 [[EPProgressShow showHUDManager] showErrorWithStatus:@"分享QQ失败"];
                 break;
             }
             case SSDKResponseStateCancel:{
                 [[EPProgressShow showHUDManager] showInfoWithStatus:@"分享QQ已取消"];
                 break;
             }
             default:
                 break;
         }
         
     }];
}


- (void)showActionShareWechat{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[self snapshot:_headImageView]];
    if (imageArray){
        [shareParams SSDKSetupShareParamsByText:_textModel.name
                                         images:imageArray
                                            url:nil
                                          title:@"来呀，互相伤害啊！！"
                                           type:SSDKContentTypeImage];
    }
    [ShareSDK share:SSDKPlatformTypeWechat
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state){
             case SSDKResponseStateSuccess:{
                [[EPProgressShow showHUDManager] showSuccessWithStatus:@"分享QQ成功"];
                 break;
             }
             case SSDKResponseStateFail:{
                [[EPProgressShow showHUDManager] showErrorWithStatus:@"分享微信失败"];
                 break;
             }
             case SSDKResponseStateCancel:{
                 [[EPProgressShow showHUDManager] showInfoWithStatus:@"分享微信已取消"];
                 break;
             }
             default:
                 break;
         }
     }];
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
