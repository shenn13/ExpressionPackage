//
//  EPRecommendCollectionViewCell.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPRecommendCollectionViewCell.h"
#import "EPRecommendModel.h"
@implementation EPRecommendCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [kLineColor CGColor];
        self.layer.borderWidth = 1.0f;
        
        [self addSubviews];
        
    }else{
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    return self;
}

-(void)addSubviews{
    
    _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    _imageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imageView];

    _gifImageLogo  = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.width - 25, 0, 25, 15)];
    _gifImageLogo.font = [UIFont systemFontOfSize:14];
    _gifImageLogo.backgroundColor = [UIColor greenColor];
    _gifImageLogo.textColor = [UIColor yellowColor];
    _gifImageLogo.textAlignment = NSTextAlignmentCenter;
    
    
    _titleName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.height - 30, self.contentView.width, 20)];
    _titleName.font = [UIFont systemFontOfSize:12];
    _titleName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleName];
    
}

-(void)setModel:(EPRecommendModel *)model{
    
    _model = model;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.gifPath] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if ([[model.gifPath lowercaseString] hasSuffix:@".gif"]) {
        
        _gifImageLogo.text = @"GIF";
        [_imageView addSubview:_gifImageLogo];
        
    }else{
        [_gifImageLogo removeFromSuperview];
    }
    
    _titleName.text = model.name;
    
}
@end
