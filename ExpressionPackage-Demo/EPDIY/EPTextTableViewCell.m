//
//  EPTextTableViewCell.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/21.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPTextTableViewCell.h"
#import "EPListModel.h"

@interface EPTextTableViewCell(){
    
    UILabel *_textLable;
    
}
@end

@implementation EPTextTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"textCellID";
    EPTextTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[EPTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    [cell addSubviews];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)addSubviews{

    _textLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 30)];
    _textLable.font = [UIFont systemFontOfSize:12];
    _textLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_textLable];
}

-(void)setModel:(EPListModel *)model{
    _model = model;
    _textLable.text = model.word;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
