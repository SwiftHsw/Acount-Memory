

 
//
//  YCAddRecordCell.m
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import "YCAddRecordCell.h"
#import <SWKit/SWKit.h>
#import <SDAutoLayout.h>

@interface YCAddRecordCell()


@end
@implementation YCAddRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *bgView = [UIImageView new];
        [self.contentView addSubview:bgView];
        bgView.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .rightSpaceToView(self.contentView, 15)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView);
        ATViewRadius(bgView, 10);
        [bgView setImage:kImageName(@"矩形 9")];
        
        [self createCusUI];
    }
    return self;
}
-(void)createCusUI{
    
    self.titleLab = [ SWKit labelWithText:@"" fontSize:14 textColor:[UIColor whiteColor] textAlignment:0 frame:CGRectZero];
    self.titleLab.font = kBoldFontWithSize(15);
    [self.contentView addSubview:self.titleLab];
    
    _titleLab.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .centerYEqualToView(self.contentView)
    .heightIs(16);
    [_titleLab setSingleLineAutoResizeWithMaxWidth:300];
   
    
    self.inputTF = [UITextField new];
    _inputTF.textAlignment = NSTextAlignmentRight;
    _inputTF.font = kBoldFontWithSize(15);
    _inputTF.placeholder = @"Please enter";
    [_inputTF addTarget:self action:@selector(textFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
    _inputTF.textColor = UIColor.whiteColor;
    
    [self.contentView addSubview:self.inputTF];
    _inputTF.sd_layout
    .leftSpaceToView(_titleLab, 10)
    .rightSpaceToView(self.contentView, 30)
    .centerYEqualToView(_titleLab)
    .heightIs(40);
}
- (void)textFieldDidChangeValue:(UITextField*)textField{
    if (self.inputBlock) {
        self.inputBlock(textField.text);
    }
}
@end
