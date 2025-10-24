//
//  TTLittleWorldPartyModel.h
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/7/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "UserInfo.h"
@class TTLittleWorldPartyModel;
NS_ASSUME_NONNULL_BEGIN

@interface TTLittleWorldPartyListModel : BaseObject

/** 是不是存在房间信息*/
@property (nonatomic,assign) BOOL hasCurrentUserRoom;

/** 派对列表*/
@property (nonatomic,strong) NSArray<TTLittleWorldPartyModel *> *worldRoomVoList;

@end



@interface TTLittleWorldPartyModel : BaseObject
/** 世界的id*/
@property (nonatomic,assign) UserID worldId;
/** 房间的id*/
@property (nonatomic,assign) UserID roomId;
/** 房主的uid*/
@property (nonatomic,assign) UserID roomUid;
/** 小世界名称*/
@property (nonatomic,strong) NSString *worldName;
/** 房间名称*/
@property (nonatomic,strong) NSString *title;
/** 头像*/
@property (nonatomic,strong) NSString *avatar;
/** 标签*/
@property (nonatomic,strong) NSString *roomTag;
/** 标签的图片地址*/
@property (nonatomic,strong) NSString *tagPict;
/** 标签的id*/
@property (nonatomic,assign) int tagId;
/** 在线人数*/
@property (nonatomic,assign) int onlineNum;
/** 性别*/
@property (nonatomic,assign) UserGender gender;

/** 是不是创始人*/
@property (nonatomic,assign) BOOL ownerFlag;
@end

NS_ASSUME_NONNULL_END
