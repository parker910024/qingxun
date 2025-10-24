//
//  ResourceList.h
//  XCChatCoreKit
//
//  Created by Lee on 2019/11/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResourceList : BaseObject
//资源url，图片、语音、视频等资源url
@property (nonatomic, strong) NSString *resUrl;
//语音与视频时长，其他类型可不传
@property (nonatomic, strong) NSString *resDuration;
//视频封面，其他类型可不传
@property (nonatomic, strong) NSString *cover;
//图片格式，其他类型可不传
@property (nonatomic, strong) NSString *format;
//    图片宽度，其他类型可不传
@property (nonatomic, assign) CGFloat width;
//    图片宽度，其他类型可不传
@property (nonatomic, assign) CGFloat height;
@end

NS_ASSUME_NONNULL_END
