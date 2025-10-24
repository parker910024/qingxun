//
//  RoomRedListItem.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/5/13.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  红包列表

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomRedListItem : BaseObject
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, assign) NSInteger amount;//总金币
@property (nonatomic, assign) NSInteger openSecond;//开抢秒数
@property (nonatomic, assign) NSInteger overSecond;//距离抢红包结束秒数，红包过期秒数
@property (nonatomic, assign) NSInteger num;//总个数
@property (nonatomic, assign) BOOL openStatus;//是否在开抢中
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, assign) NSInteger uid;//发红包用户
@property (nonatomic, copy) NSString *packetId;//红包id
@property (nonatomic, assign) NSInteger roomUid;//房主
@property (nonatomic, assign) BOOL alreadyReceive;//是否已经领到
@property (nonatomic, assign) BOOL alreadyOpen;//是否抢过这个红包
@property (nonatomic, copy) NSString *notifyText;//喊话文案
@property (nonatomic, assign) NSInteger requirement;//红包条件，0-无，1-关注房主，2-关注发红包用户
@property (nonatomic, assign) BOOL canShare;//是否可以被分享
@property (nonatomic, copy) NSString *nick;//发红包用户昵称
@end

NS_ASSUME_NONNULL_END
