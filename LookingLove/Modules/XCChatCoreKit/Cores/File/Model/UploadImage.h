//
//  UploadImage.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/7/10.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  接口上传图片返回对象模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadImage : BaseObject
@property (nonatomic, copy) NSString *filename;//现图片名
@property (nonatomic, copy) NSString *url;//全路径

@property (nonatomic, copy) NSString *format;// 图片类型 gif, png, jpeg
@property (nonatomic, assign) CGFloat width;// 宽
@property (nonatomic, assign) CGFloat height;// 高

@end

NS_ASSUME_NONNULL_END
