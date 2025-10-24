//
//  XCLittleWorldAttachment.h
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/7/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCLittleWorldAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>

/** 小世界的id*/
@property (nonatomic,assign) UserID worldId;

/** 当前派对的总人数*/
@property (nonatomic,assign) int count;

/** 派对列表*/
@property (nonatomic,strong) NSArray<NSString *> *roomUids;

/** 房间话题*/
@property (nonatomic,strong) NSString *topic;

/** 房间的Uid*/
@property (nonatomic,assign) UserID roomUid;

/** 房间的id*/
@property (nonatomic,assign) UserID roomId;
/** 是不是创始人*/
@property (nonatomic,assign) BOOL ownerFlag;

@end

NS_ASSUME_NONNULL_END
