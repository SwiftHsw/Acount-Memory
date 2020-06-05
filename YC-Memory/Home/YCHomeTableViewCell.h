//
//  YCHomeTableViewCell.h
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAcountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCHomeTableViewCell : UITableViewCell
@property (nonatomic,strong)YCAcountModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *tagName;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
 
@property (weak, nonatomic) IBOutlet UIButton *acountButton;
@property (weak, nonatomic) IBOutlet UIButton *passButton;

@end

NS_ASSUME_NONNULL_END
