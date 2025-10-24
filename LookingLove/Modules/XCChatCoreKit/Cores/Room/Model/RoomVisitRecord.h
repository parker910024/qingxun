//
//  RoomVisitRecord.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/3/3.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  进房记录

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomVisitRecord : BaseObject
@property (nonatomic, copy) NSString *roomUid;//房间uid
@property (nonatomic, copy) NSString *roomId;//房间id
@property (nonatomic, copy) NSString *title;//房间名称
@property (nonatomic, copy) NSString *avatar;//房间头像
@property (nonatomic, assign) BOOL valid;//开房状态
@end

NS_ASSUME_NONNULL_END
