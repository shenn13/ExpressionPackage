//
//  MorePageHeaderView.m
//  VideosPlayer
//
//  Created by shen on 16/12/21.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "MorePageHeaderView.h"

@implementation MorePageHeaderView

-(instancetype)initWithFrame:(CGRect)frame names:(NSArray<__kindof NSString *> *)names
{
    if (self=[super initWithFrame:frame]) {
        /**开启交互*/
        self.userInteractionEnabled=YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.scrollview=[[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:self.scrollview];
        self.scrollview.showsHorizontalScrollIndicator=NO;
        NSMutableArray *btns=[[NSMutableArray alloc]init];
        CGFloat lastX=0;
        
        for (NSInteger i=0; i<names.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:names[i] forState:UIControlStateNormal];
            
            button.frame=CGRectMake(lastX, 5, self.bounds.size.width/names.count, 30);
            
            lastX += self.bounds.size.width/names.count;
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [btns addObject:button];
            
            if (i == 0) {
                button.selected = YES;
                [button setTitleColor:kMainScreenColor forState:UIControlStateNormal];
                button.layer.cornerRadius = 15.0;
                button.layer.borderColor = [kMainScreenColor CGColor];
                button.layer.borderWidth = 1.0f;
                self.currentBtn = button;
            }
        }
        self.buttons = btns;
        UIButton *lastBtn = [self.buttons lastObject];
        
        self.scrollview.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame), 0);
        
        
        
    }
    return self;
}


-(void)headerBtnClick:(UIButton *)headerBtn{
    
    NSInteger currentPage=[self.buttons indexOfObjectIdenticalTo:headerBtn];
    
    [self setCurrentheaderbtn:currentPage];
    
    if (self.delegate) {
        [self.delegate pageCurrentBtn:currentPage];
    }
    
}

-(void)setCurrentheaderbtn:(NSInteger)index{
    
    [self.currentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.currentBtn.layer.cornerRadius = 15.0;
    self.currentBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    self.currentBtn.layer.borderWidth = 1.0f;
    
    self.currentBtn.selected = NO;
    
    self.currentBtn = self.buttons[index];
    [self.currentBtn setTitleColor:kMainScreenColor forState:UIControlStateNormal];
    self.currentBtn.layer.cornerRadius = 15.0;//2.0是圆角的弧度，根据需求自己更改
    self.currentBtn.layer.borderColor = [kMainScreenColor CGColor];//设置边框颜色
    self.currentBtn.layer.borderWidth = 1.0f;//设置边框颜色
    self.currentBtn.selected = YES;
}

@end
