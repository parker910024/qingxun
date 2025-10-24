//
//  HttpRequestHelper+LittleWorld.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  小世界

#import "HttpRequestHelper.h"
#import "LittleWorldListModel.h"
#import "LittleWolrdMember.h"
#import "TTLittleWorldPartyModel.h"
#import "LittleWorldTeamModel.h"
#import "TTWorldletRoomModel.h"
#import "LTUnreadModel.h"
#import "LittleWorldCore.h"

@class LLDynamicModel;
@class CTTabTopicModel;
@class VKDynamicRedPackageModel;
@class CTCommentReplyModel;
@class CTReplyModel;
@class CTReplyInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (LittleWorld)

/**
 小世界首页（世界广场）
 */
+ (void)requestWorldSquareWithCompletion:(HttpRequestHelperCompletion)completion;

/**
 小世界首页全部分类列表，包含’我加入的‘和’推荐‘
 */
+ (void)requestWorldFullCategoryListOnCompletion:(HttpRequestHelperCompletion)completion;

/**
 小世界分类列表
 */
+ (void)requestWorldCategoryListOnCompletion:(HttpRequestHelperCompletion)completion;

/**
 小世界列表
 
 @param page 查询页数，从 1 开始
 @param pageSize 每页数量
 @param searchKey 小世界查询关键字，用户耳伴号或小世界名称，支持模糊搜索
 @param worldTypeId 小世界类型，-1：我加入的，-2：推荐，其他
 */
+ (void)requestWorldListWithPage:(NSInteger)page
                        pageSize:(NSInteger)pageSize
                       searchKey:(nullable NSString *)searchKey
                     worldTypeId:(NSString *)worldTypeId
                      completion:(HttpRequestHelperCompletion)completion;

/**
 获取世界分享图片
 */
+ (void)requestWorldSharePicWithWorldId:(NSString *)worldId
                             completion:(HttpRequestHelperCompletion)completion;

// start fuyuan
/**
 小世界详情页
 
 @param worldId 小世界 id
 */
+ (void)requestWorldLetDetailDataWithUid:(NSString *)worldId uid:(UserID)uid success:(void(^)(LittleWorldListItem *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 加入小世界
 
 @param worldId 小世界 id
 @param uid 当前用户uid
 @param isFromRoom 是不是从房间
 */
+ (void)requestJoinWorldLetWithUid:(NSString *)worldId uid:(UserID)uid isFromRoom:(BOOL)isFromRoom success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 退出小世界
 
 @param worldId 小世界 id
 @param uid 当前用户uid
 */
+ (void)requestExitWorldLetWithUid:(NSString *)worldId uid:(UserID)uid success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 解散小世界
 
 @param worldId 小世界 id
 @param uid 创建者uid
 */
+ (void)requestDismissWorldLetWithUid:(NSString *)worldId uid:(UserID)uid success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 编辑小世界
 
 @param worldId 小世界ID
 @param uid 创建者ID
 @param name 小世界名称
 @param icon 小世界图片
 @param description 小世界描述
 @param notice 小世界公告
 @param worldTypeId 小世界类型ID
 @param agreeFlag 加入小世界是否有限制
 */
+ (void)requestWorldLetEditDataWithWorld:(NSString *)worldId uid:(UserID)uid name:(NSString *)name icon:(NSString *)icon description:(NSString *)description notice:(NSString *)notice worldTypeId:(NSString *)worldTypeId agreeFlag:(BOOL)agreeFlag success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 小世界消息免打扰
 
 @param chatId 群聊ID
 @param uid uid
 @param ope true=开启、false=关闭
 */
+ (void)requestWorldLetChatMuteWithChatId:(UserID)chatId uid:(UserID)uid ope:(BOOL)ope success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 关闭普通房的派对模式
 
 @param roomUid 房主uid
 */
+ (void)requestWorldLetCloseGroupChatWithRoomUid:(UserID)roomUid success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 查询当前用户是否在世界内
 
 @param worldId 世界ID
 @param uid uid
 */
+ (void)requestUserInWorldletWithWorldId:(UserID)worldId uid:(UserID)uid success:(void(^)(TTWorldletRoomModel *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


//start @fengshuo
/**
 请求小世界成员列表
 
 @param worldId 小世界的id
 @param searchKey 搜索的关键词
 @param success 成功
 @param failure 失败
 */
+ (void)requsetLittleWorldMemberListWithWorldId:(UserID)worldId
                               searchKey:(NSString *)searchKey
                                    page:(int)page
                                 success:(void(^)(LittleWorldMemberModel * model))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 群聊里面的随机话题
 
 @param pageSize 一页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)requestLittleWorldTeamTopicListWithPageSize:(int)pageSize
                                    success:(void(^)(NSArray <LittleWorldTeamModel *> *lists))success
                                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 更新群聊的名字 或者是话题
 
 @param chatId 群聊的id
 @param name 群聊的名字
 @param topic 群聊的话题
 @param uid 操作人的UId
 @param success 成功
 @param failure 失败
 */
+ (void)updateLittleWorldTeamTopicWithChatId:(UserID)chatId
                                  name:(NSString *)name
                                 topic:(NSString *)topic
                                   uid:(UserID)uid
                               success:(void(^)(BOOL success))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取群聊的信息
 
 @param chatId 群聊的id
 @param uid 操作人的uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestLittleWorldTeamDetailWithChatId:(UserID)chatId
                                     uid:(UserID)uid
                                 success:(void(^)(LittleWorldTeamModel *teamModel))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
请求群聊中的派对列表

 @param worldId 世界的id
 @param page 当前的页数
 @param pageSize 每页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)requsetLittleWorldTeamPartyListWithWorldId:(UserID)worldId
                                       page:(int)page
                                   pageSize:(int)pageSize
                                    success:(void(^)(TTLittleWorldPartyListModel *listModel))success
                                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 创建群聊派对
 
 @param worldId 世界的id
 @param roomUid 房间的Uid
 @param success 成功
 @param failure 失败
 */
+ (void)creatLittleWorldTeamPartyWithWorldId:(UserID)worldId
                                     roomUid:(UserID)roomUid
                                     success:(void(^)(NSString * warn))success
                                     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
小世界移出成员

@param worldId 小世界的id
@param managerUid 操作者的uid
@param removerUid 移出的那个人的uid
@param success 成功
@param failure 失败
*/
+ (void)littleWorldRemoveMemberWithWorld:(UserID)worldId
                              managerUid:(UserID)managerUid
                               removerId:(UserID)removerUid
                                 success:(void(^)(BOOL isSuccess))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;

//end @fengshuo

/// 小世界成员活跃上报
/// @auth fulong
/// @param worldId 小世界id
/// @param uid 用户uid
/// @param activeType 在小世界群聊中活跃类型 活跃类型，1-消息，2-送礼物，3-创建语音派对，4-加入语音派对
/// @param completionHandler 完成回调
+ (void)reportWorldMemberoActiveType:(int)activeType
                           reportUid:(UserID)uid
                             worldId:(UserID)worldId
                   completionHandler:(HttpRequestHelperCompletion)completionHandler;

#pragma mark -
#pragma mark LittleWorld 2.0
/**
 请求我的动态列表（我发布的动态）

 @param uid 用户uid
 @param pageNum 页数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestMyDynamicListWithUid:(NSString *)uid
                                pageNum:(NSInteger)pageNum
                                Success:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 请求动态列表

 @param start start
 @param pageNum 页数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicListWithStart:(NSString *)start
                            pageNum:(NSInteger)pageNum
                            Success:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 获取动态列表
/// @param worldId 所在的小世界id
/// @param dynamicId 动态id 服务器提供，只有在上拉加在更多的时候需要传入
/// @param success 成功回调
/// @param failure 失败回调
+ (void)requestDynamicListWithWorldID:(NSString *)worldId dynamicId:(NSInteger)dynamicId Success:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList, NSString *nextDynamicId))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 发布动态

 @param model 动态模型
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicAddWitDynamicModel:(LLDynamicModel *)model Success:(void (^)(LLDynamicModel *dynamicModel))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 发布动态
/// @param worldId 小世界id
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param completionHandler 请求回调
+ (void)requestPostDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList completionHandler:(HttpRequestHelperCompletion)completionHandler;

/// 发布动态
/// @param worldId 小世界id
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param workOrder 认证主播的派单
/// @param completionHandler 请求回调
+ (void)requestPostDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList workOrder:(AnchorOrderInfo  * _Nullable)workOrder completionHandler:(HttpRequestHelperCompletion)completionHandler;

/// 发布动态（广场）
/// @param worldId 小世界id（可为空）
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param completionHandler 请求回调
+ (void)requestPostSquareDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList completionHandler:(HttpRequestHelperCompletion)completionHandler;

/// 发布动态（广场）
/// @param worldId 小世界id（可为空）
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param workOrder 认证主播的派单
/// @param completionHandler 请求回调
+ (void)requestPostSquareDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList workOrder:(AnchorOrderInfo * _Nullable)workOrder completionHandler:(HttpRequestHelperCompletion)completionHandler;

/**
 删除动态

 @param dynamicId 动态id
 @param worldId uid
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicDeleteWitDynamicId:(long)dynamicId worldId:(NSString *)worldId Success:(void (^)(void))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 点赞/取消点赞

 @param dynamicId 动态id
 @param worldId 用户uid
 @param isLike true 点赞 false 取消
 @param dynamicUid 动态发布者的uid
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicLikeWitWitDynamicId:(NSInteger)dynamicId
                                  worldId:(NSString *)worldId
                                   isLike:(BOOL)isLike
                               dynamicUid:(NSString *)dynamicUid
                                 Success:(void (^)(void))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取动态详情

 @param dynamicId 动态id
 @param uid uid
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicDetailsWitDynamicId:(long)dynamicId
                                uid:(NSString *)uid
                                Success:(void (^)(LLDynamicModel *dynamicModel))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取tab信息

 @param uid uid
 @param success 成功回调 homeTabModelList 首页tab   topicTabModelList 话题tab
 @param failure 失败回调
 */
+ (void)requestTabListWitUid:(NSString *)uid
                                  Success:(void (^)(NSArray <CTTabTopicModel *> *homeTabModelList , NSArray <CTTabTopicModel *> *topicTabModelList))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 首页话题列表

 @param uid uid
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestHomeTopicsWitUid:(NSString *)uid
                     Success:(void (^)(NSArray <CTTabTopicModel *> *tabModelList))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取推荐话题（用在发布动态）

 @param uid uid
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestTopicsRecommendWitUid:(NSString *)uid
                        Success:(void (^)(NSArray <CTTabTopicModel *> *tabModelList))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取全部的话题  (全部话题展示)

 @param uid uid
 @param pageNum 页数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestTopicListWitUid:(NSString *)uid
                             pageNum:(NSInteger)pageNum
                             Success:(void (^)(NSArray <CTTabTopicModel *> *tabModelList))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/*******************************红包相关********************************/



/**
 点击勾搭他发送消息

 @param uid uid 谁点击填谁
 @param dynamicId 动态id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicSeduceWitUid:(NSString *)uid
                            dynamicId:(long)dynamicId
                              Success:(void (^)(void))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 判断是否领取过红包
 
 @param uid 发帖人的uid
 @param dynamicId 动态id
 @param receiveUid 领红包人的uid
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestRedpacketIsReceiveWitUid:(NSString *)uid
                                 dynamicId:(long)dynamicId
                                 receiveUid:(NSString *)receiveUid
                                 Success:(void (^)(void))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 验证动态红包是否领取完了
 
 @param uid 发帖人的uid
 @param dynamicId 动态id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestRedpacketEffectiveWitUid:(NSString *)uid
                                    dynamicId:(long)dynamicId
                                    Success:(void (^)(BOOL isEffective))success
                                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 查询动态房间

 @param uid 发帖人的uid
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestFindDynamicRoomWitUid:(NSString *)uid
                                Success:(void (^)(long long roomId))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 把动态重置为过期

 @param uid 发帖人uid
 @param dynamicId 动态id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicExpireWitUid:(NSString *)uid
                            dynamicId:(long)dynamicId
                            Success:(void (^)(void))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取未读列表
 
 @param type 类型 0, 评论 1，点赞
 @param success 成功
 @param failure 失败
 */
+ (void) requestUnReadListTpye:(int)type
                       success:(void (^)(NSArray *userInfos))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 清除消息
 
 @param type 类型 0, 评论 1，点赞
 @param success 成功
 @param failure 失败
 */
+ (void) requestUnReadClearListTpye:(int)type
                            success:(void (^)(void))success
                            failure:(void (^)(NSString *message))failure;

/**
 获取未读消息总数
 */
+ (void) requestUnReadCountSuccess:(void (^)(LTUnreadModel *model))success
                           failure:(void (^)(NSString *message))failure;


/**
 查询评论历史消息
 
 @param type 类型 0, 评论 1，点赞
 @param page 页数
 @param success 成功
 @param failure 失败
 */
+ (void) requestHistoryListTpye:(int)type
                           page:(NSInteger)page
                        minDate:(NSInteger)minDate
                        success:(void (^)(NSArray *lists))success
                        failure:(void (^)(NSString *message))failure;



/**
 获取广场动态

 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicGetSquareSuccess:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList))success
                        failure:(void (^)(NSString *message))failure;


/**
 根据自己id和他人id查询两人是否拉黑状态

 @param myUid 自己的uid
 @param toUid 他人的uid
 @param success 成功回调  0表示都没拉黑 1表示我拉黑对方，2对方拉黑我，3互相拉黑
 @param failure 失败回调
 */
+ (void)requestGetBlackListStatusWithMyUid:(long)myUid toUid:(long)toUid Success:(void (^)(NSInteger likeStatus))success failure:(void (^)(NSString *message))failure;

/**
 小世界列表
 
 @param worldId 世界id
  @param page 查询页数，从 1 开始
  @param pageSize 每页数量
  @param searchKey 小世界查询关键字，用户耳伴号或小世界名称，支持模糊搜索
  */
+ (void)requestWorldGroupListWithWorldId:(NSString *)worldId
                                    page:(NSInteger)page
                                pageSize:(NSInteger)pageSize
                               searchKey:(nullable NSString *)searchKey
                              completion:(HttpRequestHelperCompletion)completion;

/**
 加入小世界群聊
 
 @param worldId 小世界id
 */
+ (void)requestWorldGroupJoinWithWorldId:(NSString *)worldId
                              completion:(HttpRequestHelperCompletion)completion;

/**
 退出小世界群聊，两个id二选一
 
 @param chatId 小世界群聊id
 @param sessionId 云信id
 */
+ (void)requestWorldGroupQuitWithChatId:(NSString *)chatId
                              sessionId:(NSString *)sessionId
                             completion:(HttpRequestHelperCompletion)completion;

/**
 踢出小世界群聊

 @param toUid 被踢用户id
 */
+ (void)requestWorldGroupKickWithUid:(NSString *)toUid
                          completion:(HttpRequestHelperCompletion)completion;

/**
 用户动态列表（我的主客态页）
 @param uid 查看对象的uid
 @param types 类型 0：纯文本，1:语音，2图片，3视频(为空标识所有,多种用逗号隔开)
 */
+ (void)requestUserMomentListForUid:(NSString *)uid types:(NSString *)types page:(NSInteger)page pageSize:(NSInteger)pageSize completion:(HttpRequestHelperCompletion)completion;

/**
 获取动态详情

 @param dynamicId 动态id
 @param worldID 小世界id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicDetailsWitDynamicId:(NSString *)dynamicId
                                      worldID:(NSString *)worldID
                                  Success:(void (^)(LLDynamicModel *dynamicModel))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 请求评论列表

 @param worldID 所在小世界id
 @param dynamicId 动态id
 @param pageNum 页数
 @param timestamp 上一个评论list里的最后时间戳
 */
+ (void)requestCommentListWithWorldID:(NSString *)worldID
                            dynamicId:(NSString *)dynamicId
                              pageNum:(NSInteger)pageNum
                            timestamp:(long)timestamp
                              Success:(void (^)(NSArray <CTCommentReplyModel *> *commentList, long timeStamp))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 评论动态接口
 @param dynamicId 动态id
 @param content 评论文本
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestAddCommentWithDynamicId:(NSInteger)dynamicId
                          content:(NSString *)content
                          Success:(void (^)(CTCommentReplyModel * commentModel))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 回复评论

 @param dynamicId 动态id
 @param content 回复类容
 @param commentId 被回复的评论id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestReplyCommentWitDynamicId:(NSInteger)dynamicId
                                content:(NSString *)content
                              commentId:(NSInteger )commentId
                                Success:(void (^)(CTReplyModel * replyModel))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 查询嗨玩派对房间（语音派对）
 */
+ (void)requestWorldPartyRoomListWithWorldId:(NSString *)worldId completion:(HttpRequestHelperCompletion)completion;

/// 删除评论 or 评论回复
/// @param commnetID 评论id
/// @param success 成功回调
/// @param failure 失败回调
+ (void)requestDynamicDeleteCommentWithCommentID:(NSString *)commnetID
                                         Success:(void (^)(CTReplyModel * replyModel))success
                                         failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 获取评论回复列表
/// @param dynamicID 当前动态的动态id
/// @param commentID 动态的当前评论id
/// @param timestamp 上一条回复的时间戳
+ (void)requestDynamicCommentReplyListWithDynamicID:(NSInteger)dynamicID commentID:(NSString *)commentID timestamp:(NSString *)timestamp Success:(void (^)(CTReplyInfoModel *replyInfoModel))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 分享动态
/// @param worldId 所在的小世界id
/// @param dynamicID 动态id
/// @param uid 被分享人的 uid
+ (void)requestWorldShareDynamicWithWorldId:(NSString *)worldId dynamicID:(NSInteger)dynamicID uid:(NSString *)uid Success:(void (^)(CTReplyInfoModel *replyInfoModel))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

#pragma mark -
#pragma mark 1.3.2

/// 动态广场推荐的动态
+ (void)requestDynamicSquareRecommendDynamicsWithPage:(NSInteger)page Success:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/// 动态广场关注的动态
+ (void)requestDynamicSquareFollowerDynamicsWithDynamicId:(NSString *)dynamicId Success:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList, NSString *nextDynamicId))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/// 动态广场动态详情
+ (void)requestDynamicSquareDynamicsDetailWithSuccess:(void (^)(LLDynamicModel *dynamicModel))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 动态发布里的世界列表
/// @param type 请求世界类型
/// @param page 分页，默认1
+ (void)requestWorldDynamicPostWorldListWithType:(DynamicPostWorldRequestType)type page:(NSInteger)page completion:(HttpRequestHelperCompletion)completion;

/// 获取主播订单状态（获取用户最新的动态派单）
/// @param targetUid 对方uid
+ (void)requestAnchorOrderStatusWithUid:(NSString *)targetUid
                             completion:(HttpRequestHelperCompletion)completion;

/// 获取动态派单的配置
+ (void)requestAnchorOrderConfigWithCompletion:(HttpRequestHelperCompletion)completion;
@end

NS_ASSUME_NONNULL_END
