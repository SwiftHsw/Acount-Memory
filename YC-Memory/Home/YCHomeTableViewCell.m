//
//  YCHomeTableViewCell.m
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import "YCHomeTableViewCell.h"
#import <SWKit.h>
#import <SVProgressHUD.h>

@implementation YCHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ATViewRadius(_passButton, 10);
    ATViewRadius(_acountButton, 10);
      
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(YCAcountModel *)model{
    _model= model;
     
    _titleName.text =  [NSString stringWithFormat:@"title:%@",model.title];
    _tagName.text = [NSString stringWithFormat:@"tag:#%@",model.tagStr];
    _creatTime.text = [NSString stringWithFormat:@"Creation time :%@",[self  time_timestampToString:[model.creatTime  integerValue]/1000] ];
}
- (IBAction)copyPassAction:(id)sender {
    
    UIPasteboard * board = [UIPasteboard generalPasteboard];
    board.string = _model.password;
    [SVProgressHUD showSuccessWithStatus:@"Copy Success"];
    
}
- (IBAction)copyAcount:(id)sender {
    
    UIPasteboard * board = [UIPasteboard generalPasteboard];
    board.string = _model.account;
     [SVProgressHUD showSuccessWithStatus:@"Copy Success"];
}

- (NSString *)time_timestampToString:(NSInteger)timestamp{

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];

    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];

     [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString* string=[dateFormat stringFromDate:confromTimesp];

    return string;

}

@end
