//
//  APNSCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/4.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfo.h"
#import "XCRedPckageModel.h"

@protocol APNSCoreClient <NSObject>

@optional
/**开启一个房间*/
- (void)onRequestToOpenRoomWithUid:(UserID)uid;
- (void)onRequestToCallWithOrderInfo:(OrderInfo *)orderInfo;
- (void)onRequestToPushChatList;

/**绑定cp*/
- (void)onRequestToPushWithBindCP:(BOOL)isStranger;
/**解绑cp*/
- (void)onRequestToPushWithUnBindCP:(NSString *)message;
/**提醒cp签到*/
- (void)onRequestToPushwWithRemindCPSign;
/**请求成为cp*/
- (void)onRequestToPushCPRequest;
/**签到奖励*/
- (void)onRequestToPushSignReward:(XCRedPckageModel *)signInInfo;
/**在线时长 随机红包*/
- (void)onRequestToPushOnlineFinish:(XCRedPckageModel *)onlineFinish;
/**文字模式改变*/
- (void)onRequestToPushChangeTextModel;


/* CP房 游戏匹配到somebody */
- (void)onMatchingPeopleAndData:(NSDictionary *)dict;
/* CP房 游戏匹配到somebody 但是数据格式返回错误*/
- (void)onMatchingPeopleFailed;

// 找玩友匹配
- (void)onFindFriendMatchingWithData:(NSDictionary *)dict;

// 异性匹配推送
- (void)onOppositeSexMatchingWithData:(NSDictionary *)dict;

/**评论推送*/
- (void)onRequestToPushComment;

/**比心推送*/
- (void)onRequestToPushHeart;

/**早晚安推送*/
- (void)onRequestToPushMorningEveningData:(NSDictionary *)data;

/**早晚安 动态 推送*/
- (void)onRequestToPushMorningEveningDynamicsData:(NSDictionary *)data;

/**推荐奖励、二级推荐奖励 推送*/
- (void)onRequestToPushShareRewardWithRedPckageModel:(XCRedPckageModel *)redPckageModel;


/**距离推送*/
- (void)onRequestToPushDistance;

/// 收到消息页面类型的通知（需跳转到消息页）
- (void)onReceiveMessageTypeNotification:(NSDictionary *)info;

/// 收到网页页面类型的通知（需跳转到web页）
- (void)onReceiveWebTypeNotificationWithURL:(NSString *)url;

/// 动态未读消息更新通知
- (void)onReceiveDynamicMessageUpdateNotification:(NSDictionary *)info;
@end
