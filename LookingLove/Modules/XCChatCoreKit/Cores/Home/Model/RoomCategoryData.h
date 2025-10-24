//
//  RoomCategoryData.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/2/20.
//  Copyright © 2019 KevinWang. All rights reserved.
//  房间分类数据

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@class BannerInfo, TTHomeV4DetailData;

@interface RoomCategoryData : BaseObject
@property (nonatomic, strong) NSArray<BannerInfo *> *banner;
@property (nonatomic, strong) NSArray<TTHomeV4DetailData *> *rooms;

/**
 客户点标识字段，服务器不返回，用于存储当前请求的 ID，注意自己设置值
 */
@property (nonatomic, copy) NSString *titleId;

@end

NS_ASSUME_NONNULL_END
