//
//  LittleWorldCoreClient.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  小世界协议

#import <Foundation/Foundation.h>
#import "LittleWorldCategory.h"
#import "LittleWorldListModel.h"
#import "LittleWorldSquare.h"
#import "LittleWolrdMember.h"
#import "LittleWorldTeamModel.h"
#import "TTLittleWorldPartyModel.h"
#import "MessageBussiness.h"
#import "XCLittleWorldAttachment.h"
#import "LLDynamicModel.h"
#import "UserMoment.h"
#import "LittleWorldPartyRoom.h"
#import "LittleWorldDynamicPostWorld.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LittleWorldCoreClient <NSObject>
@optional

/**
 小世界首页（世界广场）
 */
- (void)responseWorldSquare:(LittleWorldSquare *)data code:(NSNumber *)errorCode msg:(NSString *)msg;

/**
 小世界首页全部分类列表，包含’我加入的‘和’推荐‘
 */
- (void)responseWorldFullCategoryList:(NSArray<LittleWorldCategory *> *)data code:(NSNumber *)errorCode msg:(NSString *)msg;

/**
 小世界分类列表
 */
- (void)responseWorldCategoryList:(NSArray<LittleWorldCategory *> *)data code:(NSNumber *)errorCode msg:(NSString *)msg;

/**
 小世界列表
 */
- (void)responseWorldList:(LittleWorldListModel *)data typeId:(NSString *)typeId code:(NSNumber *)errorCode msg:(NSString *)msg;

/**
 获取世界分享图片
 */
- (void)responseWorldSharePic:(NSString *)data code:(NSNumber *)errorCode msg:(NSString *)msg;

// start fuyuan
/**
 小世界客态页
 */
- (void)responseWorldletGuestPage:(LittleWorldListItem *)model;
- (void)responseWorldletGuestPageFail:(NSString *)message resCode:(NSNumber *)recCode;

/** 加入小世界成功 */
//- (void)memberEnterlittleWorldSuccessWithWorldId:(long long)worldId isFromRoom:(BOOL)isFromRoom;

//start @fengshuo
/**
 请求小世界成员列表
 */
- (void)requestLittleWorldMemberListSuccess:(LittleWorldMemberModel *)members isSearch:(BOOL)isSearch status:(int)stauts;
- (void)requestLittleWorldMemberListFail:(NSString *)message status:(int)stauts;

/**
随机话题
 */
- (void)requsetLittleWorldTeamRandomTopicSucess:(NSArray<LittleWorldTeamModel *>*)topics;
- (void)requsetLittleWorldTeamRandomTopicFail:(NSString *)message;

/**
 修改群聊的名称 话题
 */
- (void)updateLittleWorldTeamNameOrTopicSuccess;
- (void)updateLittleWorldTeamNameOrTopicFail:(NSString *)message;

/**
 获取群聊的名称和群聊的话题
 */
- (void)requsetLittleWorldTeamDetailSuccess:(LittleWorldTeamModel *)model;
- (void)requsetLittleWorldTeamDetailFail:(NSString *)message;

/**
 请求群聊中的派对列表
 */
- (void)requestLittleWorldTeamPartySuccess:(TTLittleWorldPartyListModel *)listModel status:(int)status;
- (void)requestLittleWorldTeamPartyFail:(NSString *)message status:(int)status;

/**
 创建群聊派对
 */
- (void)creatLittleWorldTeamPartySuccess:(NSString *)warn;
- (void)creatLittleWorldTeamPartyFail:(NSString *)message;

/** 移出小世界成员*/
- (void)removeLittleWorldMemberSuccess:(UserID)removerId;
- (void)removeLittleWorldMemberFail:(NSString *)message;

/** 收到系统通知更新小世界的话题*/
- (void)onReceiveTeamNotificationUpdateTopicOrNumbePersonWithAttach:(XCLittleWorldAttachment *)attach second:(Custom_Noti_Sub_Little_World)second;
//end @fengshuo

/**
 小世界群聊列表(暂时未使用
 */
- (void)responseWorldGroupList:(NSArray *)data code:(NSNumber *)errorCode msg:(NSString *)msg;

/**
 加入小世界群聊
 @param errorCode 7907:人数达到3人之后才能生成群聊，还差x人，快去邀请好友加入吧,
                  7908:哎呀，群聊人满暂时加不进来啦~
 */
- (void)responseWorldGroupJoinSuccess:(BOOL)success code:(NSNumber *)errorCode msg:(NSString *)msg;

/**
 退出小世界群聊
 */
- (void)responseWorldGroupQuitSuccess:(BOOL)success code:(NSNumber *)errorCode msg:(NSString *)msg;

/**
 踢出小世界群聊
 */
- (void)responseWorldGroupKickSuccess:(BOOL)success code:(NSNumber *)errorCode msg:(NSString *)msg;

#pragma mark -
#pragma mark littleWorld 2.0
- (void)responseWorldPostDynamicSuccess:(BOOL)success code:(NSNumber *)errorCode msg:(NSString *)msg;

/**
 用户动态列表（我的主客态页）
 */
- (void)responseUserMomentList:(NSArray<UserMoment *> *)data uid:(NSString *)uid code:(NSNumber *)errorCode msg:(NSString *)msg;

/**删除动态成功*/
- (void)requestDynamicDeleteSuccess;
- (void)requestDynamicDeleteFailth:(NSString *)message;

/**请求动态列表成功*/
- (void)requestDynamicListSuccess:(NSArray <LLDynamicModel *>*)modelList nextDynamicId:(NSString *)nextDynamicId;
- (void)requestDynamicListFailth:(NSString *)message;

/**点赞成功*/
- (void)requestDynamicLikeSuccess;
- (void)requestDynamicLikeFailth:(NSString *)message dynamicId:(long)dynamicId;

/**请求动态详情成功*/
- (void)requestDynamicDetailsSuccess:(LLDynamicModel *)dynamicModel;
- (void)requestDynamicDetailsFailth:(NSNumber *)resCode errorMessage:(NSString *)errorMessage;

/**请求动态评论列表*/
- (void)requestCommentListSuccess:(NSArray <CTCommentReplyModel *>*)modelList timeStamp:(long)timeStamp;
- (void)requestCommentListFailth:(NSString *)message;

/**评论接口*/
- (void)requestAddCommentSuccess:(CTCommentReplyModel *)commentModel;
- (void)requestAddCommentFailth:(NSString *)message;

/**删除自己的评论或自己的回复*/
//- (void)requestDeleteCommentSuccessWithCommentId:(NSString *)commentId type:(NSInteger)type;
//- (void)requestDeleteCommentFailth:(NSString *)message type:(NSInteger)type;

/**评论回复接口*/
//- (void)requestReplyCommentSuccess:(CTReplyModel *)commentModel;
//- (void)requestReplyCommentFailth:(NSString *)message;

/// 嗨玩派对房间（语音派对列表）
- (void)responseWorldPartyRoomList:(NSArray<LittleWorldPartyRoom *> *)data code:(NSNumber *)errorCode msg:(NSString *)msg;

/**请求回复列表*/
- (void)requestCommentReplyListSuccess:(CTReplyInfoModel*)replyInfo;
- (void)requestCommentReplyListFailth:(NSString *)message;

#pragma mark -
#pragma mark 1.3.2
/**请求动态列表成功*/
- (void)requestDynamicSquareRecommendListSuccess:(NSArray <LLDynamicModel *>*)modelList;
- (void)requestDynamicSquareFollowListSuccess:(NSArray <LLDynamicModel *>*)modelList nextDynamicId:(NSString *)nextDynamicId;

/// 动态发布里的世界列表
- (void)responseWorldDynamicPostWorldList:(NSArray<LittleWorldDynamicPostWorld *> *)data type:(DynamicPostWorldRequestType)type code:(NSNumber *)errorCode msg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
