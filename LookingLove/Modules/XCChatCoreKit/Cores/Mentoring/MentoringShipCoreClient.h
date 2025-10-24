//
//  MentoringShipCoreClient.h
//  XCChatCoreKit
//
//  Created by gzlx on 2019/1/21.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestHelper+MentoringShip.h"
#import "MentoringGrabModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MentoringShipCoreClient <NSObject>
@optional;
/** 查询是不是能请求收徒*/
- (void)checkUserCanHarvestApprenticeingSuceess:(NSDictionary *)dic;
- (void)checkUserCanHarvestApprenticeingFail:(NSString *)message;

/** 请求收徒*/
- (void)requestHarvestApprenticeingSuccess:(NSDictionary *)dic;
- (void)requestHarvestApprenticeingFail:(NSString *)message;

/** 关注并打招呼*/
- (void)mentoringShipFocusOrGreetToUserSuccess:(NSDictionary *)dic;
- (void)mentoringShipFocusOrGreetToUserFail:(NSString *)message;

/**师徒建立成功 跑马灯*/
- (void)getMasterAndApprenticeRelationShipListSuccess:(NSArray *)relationShips;
- (void)getMasterAndApprenticeRelationShipListFail:(NSString *)message;

/** 上报任务三*/
- (void)reportTheMentoringShipTaskThreeWithMasteSuccess:(NSDictionary *)dic;
- (void)reportTheMentoringShipTaskThreeWithMasteFail:(NSString *)message;

/**建立师徒关系成功*/
- (void)bulidMentoringShipWithMasterSuccess:(NSDictionary *)dic type:(int)type;
- (void)bulidMentoringShipWithMasterFail:(NSString *)message code:(NSNumber *)code type:(int)type;

/** 我的师徒list接口 */
- (void)getMyMasterAndApprenticeListSuccess:(NSArray *)list page:(int)page state:(int)state;
- (void)getMyMasterAndApprenticeListFail:(NSString *)message page:(int)page state:(int)state;

/** 请求师徒关系的 获取名师榜数据 */
- (void)getMasterAndApprenticeRankingListSuccess:(NSArray *)list page:(int)page state:(int)state type:(int)type;
- (void)getMasterAndApprenticeRankingListFail:(NSString *)message page:(int)page state:(int)state type:(int)type;

/** 发送师徒关系邀请 */
- (void)masterSendInviteRequestSuccess;
- (void)masterSendInviteRequestFail:(NSString *)message;

/** 解除师徒关系 */
- (void)masterSendDeleteRequestSuccess;
- (void)masterSendDeleteRequestFail:(NSString *)message;

/** 在IMUI上添加一个回话*/
- (void)addMeesageToChatUIWith:(NSArray *)messages;

/** 邀请进房判断师徒任务 有效 */
- (void)mentoringShipInviteEnableSuccessisMaster:(BOOL)isMaster;
/** 邀请进房判断师徒任务 无效 */
- (void)mentoringShipInviteEnableFail:(NSString *)message isMaster:(BOOL)isMaster;
/** 收徒成功*/
- (void)setupMentoringShipSucess;

/** 师徒任务3, 倒计时回调 */
- (void)mentoringShipCutdownOpen:(NSInteger)time;
/** 师徒任务3, 倒计时结束, 消息页监听并上报任务 */
- (void)mentoringShipCutdownFinishWithMasterUid:(long long)masterUid apprenticeUid:(long long)apprenticeUid;

/** 抢徒弟成功的回调 */
- (void)mentoringShipGrabApprenticeSuccess:(UserID)apprenticeUid;
/** 抢徒弟失败的回调 */
- (void)mentoringShipGrabApprenticeFail:(NSString *)message errorCode:(NSNumber *)errorCode;
/** 接收到了 抢徒弟的消息通知 */
- (void)onRecvCustomP2PGrabApprenticeNoti:(NSArray<MentoringGrabModel *> *)grabModels;
/** 更新了可抢徒弟的数据 */
- (void)updateGrabApprenticeData:(NSArray<MentoringGrabModel *> *)grabModels;
/** 可抢徒弟, 倒计时回调 */
- (void)grabApprenticeCutdownAction;

/**
 更新消息主控制器 头部选中的菜单 0:选中消息 1:选中联系人

 @param index 0:选中消息 1:选中联系人
 */
- (void)updateMessageMainViewControllerSelectIndex:(NSInteger)index;

/** 当在做师徒任务的时候 发送礼物成功*/
- (void)onUpdatePackGiftWithGiftIdWhenMentoringShip;
@end

NS_ASSUME_NONNULL_END
