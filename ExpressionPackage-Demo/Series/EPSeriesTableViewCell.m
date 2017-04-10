//
//  EPSeriesTableViewCell.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/20.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPSeriesTableViewCell.h"
#import "EPSeriesModel.h"



#define kMargin 10
#define kLabelW 100
#define kLabelH 30


@interface EPSeriesTableViewCell(){
    
    UIImageView *_imageLogo;
    UIImageView *_imageView;
    UILabel *_textLb;
    
}

@property (nonatomic, assign) CGRect imageViewFrame;

@end


@implementation EPSeriesTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"cellID";
    EPSeriesTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[EPSeriesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    [cell addSubviews];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)addSubviews{
    
    _imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth, 5)];
    _imageLogo.backgroundColor = kLineColor;
    [self.contentView addSubview:_imageLogo];
    
    _textLb = [[UILabel alloc] initWithFrame:CGRectMake(15, kMargin,kScreenWidth - 60, kLabelH)];
    _textLb.font = [UIFont systemFontOfSize:14];
    _textLb.textColor = kMainScreenColor;
    _textLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_textLb];
    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin,kMargin,kScreenWidth - kMargin * 2,0.4 *kScreenHeight)];
    _imageView.userInteractionEnabled = YES;
    _imageView.image = [UIImage imageNamed: @"sub-back.png"];
    [self.contentView addSubview:_imageView];
}


-(void)setModel:(EPSeriesModel *)model{
    _model = model;
    
    _textLb.text = model.dtTypeModel.name;
    NSArray *arr = model.tagList;
    
    self.imageViewFrame = CGRectZero;
    CGSize size = CGSizeMake((_imageView.width - 55)/4 ,H(100));
    for (int i = 0; i < arr.count - 1; i ++ ) {
        CGFloat x = self.imageViewFrame.origin.x;
        CGFloat y = self.imageViewFrame.origin.y;
        
        if (i != 0) {
            x += (_imageView.width - 55)/4;
        }else {
            y += H(10);
        }
        CGFloat minX = x;
        CGFloat maxX = x + size.width;
        if (maxX > CGRectGetWidth(_imageView.frame)) {
            x -= minX;
            y = y + size.height + H(10);
        }
        CGRect rect = CGRectMake(x + 15, y, size.width, size.height);
        self.imageViewFrame = rect;
        
        UIView *expressionImageBg = [[UIView alloc] initWithFrame:rect];
        expressionImageBg.backgroundColor = [UIColor whiteColor];
        expressionImageBg.userInteractionEnabled = YES;
        expressionImageBg.layer.cornerRadius = 10;
        expressionImageBg.layer.masksToBounds = YES;
        expressionImageBg.layer.borderColor = [kLineColor CGColor];
        expressionImageBg.layer.borderWidth = 1.0f;
        
        expressionImageBg.tag = [[arr[i] id] integerValue];
        [_imageView addSubview:expressionImageBg];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expressionImageClicked:)];
        [expressionImageBg addGestureRecognizer:singleTap];
      
        UIImageView *expressionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, rect.size.width - 10, rect.size.height - H(30))];
        
        [expressionImageView sd_setImageWithURL:[NSURL URLWithString:[arr[i] picPath]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [expressionImageBg addSubview:expressionImageView];
        
        UILabel *expressionImageName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(expressionImageView.frame), rect.size.width, H(20))];
        expressionImageName.font = [UIFont systemFontOfSize:14];
        expressionImageName.text = [arr[i] name];
        expressionImageName.textAlignment = NSTextAlignmentCenter;
        [expressionImageBg addSubview:expressionImageName];
    }
    
    CGFloat H;
    if (arr.count%4 == 0) {
        H = ( size.height + 10) * (arr.count/4);
    }else{
        H = ( size.height + 10) * (arr.count/4 + 1);
    }
    _imageView.frame = CGRectMake(0, CGRectGetMaxY(_textLb.frame), kScreenWidth, H + 20);
    
}

-(void)expressionImageClicked:(UITapGestureRecognizer*)gesture{
    
    if ([_delegate respondsToSelector:@selector(tapedViewInCell:withIndex:)]){
        UIView *v = (UIView*)gesture.view;
        [_delegate tapedViewInCell:self withIndex:v.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
