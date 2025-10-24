//
//  LittleWolrdMember.h
//  AFNetworking
//
//  Created by fengshuo on 2019/7/4.
//

#import "BaseObject.h"
#import "UserInfo.h"
#import "LittleWorldListModel.h"
#import "LevelInfo.h"
NS_ASSUME_NONNULL_BEGIN
@class LittleWolrdMember;
typedef enum {
    LittleWorldPromtFlag_close = 0,//屏蔽消息
    LittleWorldPromtFlag_open = 1//开启提醒
} LittleWorldPromtFlag;

typedef enum {
    LittleWorldMuteFlag_notMute = 0,//不禁言
    LittleWorldMuteFlag_mute = 1//禁言
} LittleWorldMuteFlag;

@interface LittleWorldMemberModel : BaseObject

/** 成员列表*/
@property (nonatomic,strong) NSArray<LittleWolrdMember *> *records;

/** 总人数*/
@property (nonatomic,strong) NSString *total;

@end


@interface LittleWolrdMember : BaseObject
/** 成员的id*/
@property (nonatomic,assign) UserID uid;
/** 头像*/
@property (nonatomic,strong) NSString *avatar;
/** 性别*/
@property (nonatomic,assign) UserGender gender;
/** 名称*/
@property (nonatomic,strong) NSString *nick;
/** 是不是提醒*/
@property (nonatomic,assign) LittleWorldPromtFlag promtFlag;
/** 是不是禁言*/
@property (nonatomic,assign) LittleWorldMuteFlag muteFlag;
/** 小世界里面人的身份*/
@property (nonatomic,assign) TTWorldLetType type;
/** 是不是在线*/
@property (nonatomic,assign) BOOL onlineFlag;
/** 是不是创始人*/
@property (nonatomic,assign) BOOL ownerFlag;
/** 当前派对的id 如有值就是在派对*/
@property (nonatomic,assign) UserID currentRoomUid;
/**
 *
 */
@property (nonatomic,strong) LevelInfo *userLevelVo;
@end

NS_ASSUME_NONNULL_END
