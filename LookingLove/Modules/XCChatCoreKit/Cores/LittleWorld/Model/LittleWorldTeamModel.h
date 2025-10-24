//
//  LittleWorldTeamModel.h
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/7/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LittleWorldTeamModel : BaseObject

/** 群聊话题*/
@property (nonatomic,strong) NSString *topic;
/** 群聊名称*/
@property (nonatomic,strong) NSString *name;
/** 群聊id*/
@property (nonatomic,assign) UserID chatId;
/** 群主uid*/
@property (nonatomic,assign) UserID uid;
/** 世界id*/
@property (nonatomic,assign) UserID worldId;
/** 云信群聊tid*/
@property (nonatomic,assign) UserID tid;
/** 派对的数量*/
@property (nonatomic,assign) int  count;
/** 派对列表*/
@property (nonatomic,strong) NSArray<NSString *> *roomUids;
@end

NS_ASSUME_NONNULL_END
