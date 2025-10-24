//
//  RoomCategory.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/2/20.
//  Copyright © 2019 KevinWang. All rights reserved.
//  房间分类模型 目前用于兔兔首页 v4 接口

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomCategory : BaseObject
@property (nonatomic, copy) NSString *titleId;//房间标题
@property (nonatomic, copy) NSString *seqNo;//房间标题序号
@property (nonatomic, copy) NSString *titleName;//房间标题名
@end

NS_ASSUME_NONNULL_END
