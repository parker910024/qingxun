//
//  LittleWorldPartyRoom.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  语音派对房

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LittleWorldPartyRoom : BaseObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *roomDesc;
@property (nonatomic, assign) NSInteger realOnlineNum;//真实在线人数
@property (nonatomic, copy) NSString *tagPict;
@property (nonatomic, assign) NSInteger onlineNum;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) float totalFlow;//半小时流水
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, copy) NSString *roomTag;
@property (nonatomic, copy) NSString *worldId;
@property (nonatomic, copy) NSString *roomUid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL ownerFlag;
@end

NS_ASSUME_NONNULL_END
