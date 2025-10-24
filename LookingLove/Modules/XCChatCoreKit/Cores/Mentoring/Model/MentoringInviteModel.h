//
//  MentoringInviteModel.h
//  XCChatCoreKit
//
//  Created by gzlx on 2019/2/18.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface MentoringInviteModel : BaseObject
/** 师傅的头像*/
@property (nonatomic, copy) NSString * avatar;
/** 师傅的昵称*/
@property (nonatomic, copy) NSString * nick;
/**师傅房间的Uid*/
@property (nonatomic, assign) UserID roomUid;
/** 徒弟的uid*/
@property (nonatomic, assign) UserID apprenticeUid;
/** 消息是不是过期 按钮能不能按*/
@property (nonatomic, assign) BOOL expired;
/** 师傅的Uid*/
@property (nonatomic, assign) UserID masterUid;
@end

NS_ASSUME_NONNULL_END
