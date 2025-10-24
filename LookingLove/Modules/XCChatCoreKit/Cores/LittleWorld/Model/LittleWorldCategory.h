//
//  LittleWorldCategory.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  小世界分类列表

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LittleWorldCategory : BaseObject

@property (nonatomic, copy) NSString *typeId;// convert from id
@property (nonatomic, copy) NSString *typeName;//分类名称
@property (nonatomic, strong) NSString *pict; // 分类图片
@property (nonatomic, strong) NSString *tagPic; // 列表展示的小标签

@end

NS_ASSUME_NONNULL_END
