//
//  YCAddRecordCell.h
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^InputBlock)(NSString * str);
@interface YCAddRecordCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLab;
@property(nonatomic,strong)UITextField * inputTF;
@property(nonatomic,copy)InputBlock inputBlock;
@end

NS_ASSUME_NONNULL_END
