//
//  MentoringShip.h
//  XCChatCoreKit
//
//  Created by gzlx on 2019/1/21.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "BaseCore.h"
#import "HttpRequestHelper+MentoringShip.h"
#import "GiftInfo.h"
#import "UserInfo.h"
#import "MentoringGiftModel.h"
#import "MentoringGrabModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TTMasterCountDownStatusDefult, // 默认状态(没有倒计时)
    TTMasterCountDownStatusIng, // 倒计时中ing
    TTMasterCountDownStatusEnd, // 倒计时结束
} TTMasterCountDownStatus;  // 师徒任务3房间倒计时状态

@interface MentoringShipCore : BaseCore

@property (strong, nonatomic) dispatch_source_t timer;
/** 当前倒计时的时间 */
@property (nonatomic, assign) NSInteger currentTime;
/** 师傅邀请进房的时候使用*/
@property (nonatomic, assign) UserID inviteApprenticeUid;
/** 师徒任务三 当前房间正在记录的师傅的uid */
@property (nonatomic, assign) UserID masterUid;
/** 师徒任务三 当前房间正在记录的师傅的uid */
@property (nonatomic, assign) UserID apprenticeUid;
/** 师徒任务3房间倒计时状态 */
@property (nonatomic, assign) TTMasterCountDownStatus countDownStatus;
/** 正在被抢徒弟的数组, core 内部管理 */
@property (nonatomic, strong, readonly) NSMutableArray<MentoringGrabModel *> *grabApprenticesModels;
/** 是否隐藏 抢徒弟 顶部提示 NO: 展示 YES:不展示 */
@property (nonatomic, assign) BOOL isHideGrabApprenticeHint;
/**
 是不是可以收徒
 */
- (void)canHarvestApprenticeWithUid:(UserID)uid;


/**
 请求收徒
 */
- (void)applyToHarvestApprcnticeWithUid:(UserID)uid;


/**
 请求师徒关系的b跑马灯
 
 @param page 当前的页数
 @param pageSize 一页的个数
 */
- (void)getMasterAndApprenticeRelationShipListWithPage:(int)page pageSize:(int)pageSize;


/**
 上报任务三
 @param userId 师傅的uid
 @param apprenticeUid 徒弟的Uid
 */
- (void)reportTheMentoringShipTaskThreeWithMasterUid:(UserID)userId apprenticeUid:(UserID)apprenticeUid;

/**
 建立师徒关系
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的Uid
 @param type 1 同意 2 拒绝
 */
- (void)bulidMentoringShipWithMasterUid:(UserID)masterUid
                          apprenticeUid:(UserID)apprenticeUid
                                   type:(int)type;

/**
师傅给徒弟打招呼
 
 @param uid 操作者的uid
 @param likedUid 关注的那个人的Uid
 */
- (void)mentoringShipFocusOrGreetToUser:(UserID)uid
                                likeUid:(UserID)likedUid;

/**
 请求师徒关系的 我的师徒列表
 
 @param page 当前的页数
 @param pageSize 一页的个数
 */
- (void)getMyMasterAndApprenticeList:(int)page pageSize:(int)pageSize state:(int)state;


/**
 请求师徒关系的 获取名师榜数据

 @param page 当前的页数
 @param pageSize 一页的个数
 @param state 下拉or上啦
 @param type 查询类型（1：本周名师榜，2：上周名师榜
 */
- (void)getMasterAndApprenticeRankingList:(int)page pageSize:(int)pageSize state:(int)state type:(int)type;


/**
 发送师徒关系邀请

 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
- (void)masterSendInviteRequestWithMasterUid:(UserID)masterUid
                               apprenticeUid:(UserID)apprenticeUid;

/**
 解除师徒关系

 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 @param operUid 操作人uid
 */
- (void)masterSendDeleteRequestWithMasterUid:(UserID)masterUid
                               apprenticeUid:(UserID)apprenticeUid
                                     operUid:(UserID)operUid;

/**
 师徒关系送礼物（师傅给徒弟送）
 
 @param giftID 礼物的id
 @param gameGiftType 礼物的类型
 @param giftNum 礼物的数量
 @param targetUid 目标
 */
- (void)mentoringShipSendChatGift:(NSInteger)giftID
                     gameGiftType:(GameRoomGiftType)gameGiftType
                          giftNum:(NSInteger)giftNum
                        targetUid:(UserID)targetUid
                        giftModel:(MentoringGiftModel *)giftModel;

/**
 师徒任务3 邀请进房判断师徒任务是否有效

 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
- (void)mentoringShipInviteEnableWithMasterUid:(UserID)masterUid apprenticeUid:(UserID)apprenticeUid isMaster:(BOOL)isMaster;

/**
 抢徒弟
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
- (void)mentoringShipGrabApprenticeWithMasterUid:(UserID)masterUid apprenticeUid:(UserID)apprenticeUid;

/**
 师徒任务三 的开启定时器的方法
 
 @param time 倒计时时间
 */
- (void)openCountdownWithTime:(long)time;
// 销毁倒计时
- (void)stopCountDown;

/**
 更新消息主控制器 头部选中的菜单 0:选中消息 1:选中联系人
 
 @param index 0:选中消息 1:选中联系人
 */
- (void)updateMessageMainViewControllerSelectIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
