//
//  LittleWorldDynamicPostWorld.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/1/8.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  动态发布里的世界列表

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

///动态发布世界列表的请求类型
typedef NS_ENUM(NSInteger, DynamicPostWorldRequestType) {
    DynamicPostWorldRequestTypeAll = 0,//全部
    DynamicPostWorldRequestTypeMine = 1,//我加入的
    DynamicPostWorldRequestTypeRecommend = 2//推荐
};

@interface LittleWorldDynamicPostWorld : BaseObject
@property (nonatomic, copy) NSString *worldId;//id
@property (nonatomic, copy) NSString *worldName;//名称
@property (nonatomic, assign) BOOL inWorld;//是否加入了小世界
@property (nonatomic, copy) NSString *icon;//头像
@property (nonatomic, copy) NSString *desc;//描述
@end

NS_ASSUME_NONNULL_END
