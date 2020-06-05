//
//  YCAcountModel.h
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCAcountModel : NSObject
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * tagStr;//所属标签
@property(nonatomic,copy)NSString * account;
@property(nonatomic,copy)NSString * password;
@property(nonatomic,copy)NSString * category;//所属分类
@property(nonatomic,copy)NSString * remark;
@property(nonatomic,copy)NSString * creatTime;
@end


@interface YCCategoryModel : NSObject
@property(nonatomic,copy)NSString * category; 
@end

NS_ASSUME_NONNULL_END
