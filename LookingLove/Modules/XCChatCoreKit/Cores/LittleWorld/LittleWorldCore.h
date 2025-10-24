//
//  LittleWorldCore.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  小世界

#import "BaseCore.h"
#import "LittleWorldListModel.h"
#import "LittleWorldCategory.h"
#import "LittleWorldCoreClient.h"
#import "AnchorOrderStatus.h"
#import "AnchorOrderConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class TTMessageDisplayModel;

@interface LittleWorldCore : BaseCore

/** 记录:房间公屏 邀请加入小世界 公屏消息模型 */
@property (nonatomic, strong) TTMessageDisplayModel *inviteJoinLittleWorldMessageModel;
/** 记录:房间公屏 邀请关注房主 公屏消息模型 */
@property (nonatomic, strong) TTMessageDisplayModel *inviteFollowRoomOwnerMessageModel;

/** 是不是小世界的输入框*/
@property (nonatomic,assign) BOOL isLittleWorldInput;

/** 房间的名字 进入小世界群聊 赋值 开启群聊派对的时候使用*/
@property (nonatomic,strong) NSString *roomTitle;

/** 群聊发言等级限制*/
@property (nonatomic,assign) NSInteger worldGroupChatLevelNo;

/**
 进房的时候 判断是不是从小世界里面进入的 没有别的用处 引用需谨慎
 */
@property (nonatomic,assign) UserID worldId;

/// 仅用于统计小世界用户活跃度时候使用
@property (nonatomic,assign) UserID reportWorldID;

/**
 标识当前是不是在派对房内，点击最小化，跳转小世界客态页
 */
@property (nonatomic, assign) BOOL littleWorldBackChat;

/**
  记录当前申请加入小世界的人的uid 和 申请的小世界id
 */
@property (nonatomic, strong) NSMutableDictionary *littleDict;

- (void)saveLittleDict;

- (NSString *)receiveDictWithKey:(NSString *)keyString;

- (void)removeDictWithKey:(NSString *)keyString;
/**
 小世界首页（世界广场）
 */
- (void)requestWorldSquare;

/**
 小世界首页全部分类列表，包含’我加入的‘和’推荐‘
 */
- (void)requestWorldFullCategoryList;

/**
 小世界分类列表（通过协议方法返回）
 */
- (void)requestWorldCategoryList;

/**
 小世界分类列表（通过block返回）
 
 @param isRefresh 是否刷新，如果不刷新，优先获取内存缓存，无缓存则请求获取
 @param completion 数据回调，若 data 为空，可尝试从 errorCode/msg 获取错误信息
 */
- (void)fetchWorldCategoryListWithRefresh:(BOOL)isRefresh
                               completion:(void(^)(NSArray<LittleWorldCategory *> *data, NSNumber *errorCode, NSString *msg))completion;

/**
 小世界列表
 
 @param page 查询页数，从 1 开始
 @param pageSize 每页数量
 @param searchKey 小世界查询关键字，用户耳伴号或小世界名称，支持模糊搜索
 @param worldTypeId 小世界类型，-1：我加入的，-2：推荐，其他
 */
- (void)requestWorldListWithPage:(NSInteger)page
                        pageSize:(NSInteger)pageSize
                       searchKey:(nullable NSString *)searchKey
                     worldTypeId:(nullable NSString *)worldTypeId;

/**
 获取世界分享图片
 */
- (void)requestWorldSharePicWithWorldId:(NSString *)worldId;

//@fuyuan
/**
 小世界详情页

 @param worldId 小世界 id
 @param uid 当前用户uid
 */
- (void)requestWorldLetDetailDataWithUid:(NSString *)worldId uid:(UserID)uid;

/**
 小世界详情页(block回调）
 
 @param worldId 小世界 id
 @param uid 用户uid
 @param completion 完成回调
 */
- (void)requestWorldDetailWithWorldId:(NSString *)worldId uid:(UserID)uid                              completion:(void(^)(LittleWorldListItem *data, NSNumber *errorCode, NSString *msg))completion;

/**
 加入小世界

 @param worldId 小世界 id
 @param uid 当前用户uid
 @param isFromRoom 是不是加入小世界
 */
- (RACSignal *)requestJoinWorldLetWithUid:(NSString *)worldId uid:(UserID)uid isFromRoom:(BOOL)isFromRoom;

/**
 退出小世界
 
 @param worldId 小世界 id
 @param uid 当前用户uid
 */
- (RACSignal *)requestExitWorldLetWithUid:(NSString *)worldId uid:(UserID)uid;

/**
 解散小世界
 
 @param worldId 小世界 id
 @param uid 创建者uid
 */
- (RACSignal *)requestDismissWorldLetWithUid:(NSString *)worldId uid:(UserID)uid;

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
- (RACSignal *)requestWorldLetEditDataWithWorld:(NSString *)worldId uid:(UserID)uid name:(NSString *)name icon:(NSString *)icon description:(NSString *)description notice:(NSString *)notice worldTypeId:(NSString *)worldTypeId agreeFlag:(BOOL)agreeFlag;

/**
 小世界消息免打扰
 
 @param chatId 群聊ID
 @param uid uid
 @param ope true=开启、false=关闭
 */
- (RACSignal *)requestWorldLetChatMuteWithChatId:(UserID)chatId uid:(UserID)uid ope:(BOOL)ope;

/**
 关闭普通房的派对模式
 
 @param roomUid 房主uid
 */
- (void)requestWorldLetCloseGroupChatWithRoomUid:(UserID)roomUid;

/**
 查询当前用户是否在世界内
 
 @param worldId 世界ID
 @param uid uid
 */
- (RACSignal *)requestUserInWorldletWithWorldId:(UserID)worldId uid:(UserID)uid;


//@fegnshuo
/**
请求小世界成员列表

 @param worldId 世界的id
 @param searchKey 搜索的关键字
 @param isSearch 是不是通过搜索
 @param status 是头部刷新还是尾部 刷新
 */
- (void)requestLittleWorldMemberListWithWorldId:(UserID)worldId searchKey:(NSString * __nullable)searchKey isSearch:(BOOL)isSearch page:(int)page status:(int)status;

/**
 请求小世界随机话题
 */
- (void)requestLittleWorldTeamRandomTopic;


/**
 更新

 @param name 群聊的名字
 @param topic 群聊的话题
 @param chatId 群聊的id
 */
- (void)updteLittleWorldTeamNameOrTopicWithTeamName:(nullable NSString *)name topic:(nullable NSString *)topic chatId:(UserID)chatId;


/**
 请求小世界群聊的详情

 @param tId 群聊的id
 */
- (void)requsetLittleWorldTeamDetailWithTid:(UserID)tId;


/**
 创建群聊派对
 
 @param worldId 世界的id
 @param tid 云信群聊的id
 */
- (void)createLittleWorldTeamPartyWithWorldId:(UserID)worldId tid:(NSString *)tid ownerFlag:(BOOL)ownerFlag;


/**
 获取小世界派对列表

 @param worldId 世界的id
 @param page 当前的页数
 @param pageSize 每页的个数
 */
- (void)requestLittleWorldTeamPartyListWithWorldId:(UserID)worldId page:(int)page pageSize:(int)pageSize status:(int)status;

/**
 移除小世界成员
 
 @param worldId 世界的id
 @param removerId 移出的人的id
 */
- (void)removeLittleWorldMemberWithWorldId:(UserID)worldId removerUid:(UserID)removerId;
//end fengshuo

/// 小世界成员活跃上报
/// @auth fulong
/// @param worldId 小世界id
/// @param uid 用户uid
/// @param activeType 在小世界群聊中活跃类型 活跃类型，1-消息，2-送礼物，3-创建语音派对，4-加入语音派对
- (void)reportWorldMemberoActiveType:(int)activeType reportUid:(UserID)uid worldId:(UserID)worldId;
//end fulong

/**
 小世界列表
 
 @param worldId 世界id
  @param page 查询页数，从 1 开始
  @param pageSize 每页数量
  @param searchKey 小世界查询关键字，用户耳伴号或小世界名称，支持模糊搜索
  */
- (void)requestWorldGroupListWithWorldId:(NSString *)worldId
                                    page:(NSInteger)page
                                pageSize:(NSInteger)pageSize
                               searchKey:(nullable NSString *)searchKey;

/**
 加入小世界群聊
 
 @param worldId 小世界id
 */
- (void)requestWorldGroupJoinWithWorldId:(NSString *)worldId;

/**
退出小世界群聊，两个id二选一

@param chatId 小世界群聊id
@param sessionId 云信id
*/
- (void)requestWorldGroupQuitWithChatId:(NSString *)chatId sessionId:(NSString *)sessionId;

/**
 踢出小世界群聊

 @param toUid 被踢用户id
 */
- (void)requestWorldGroupKickWithUid:(NSString *)toUid;

/// 发布动态（已弃用，使用发布动态广场接口 requestWorldPostSquareDynamicWithWorldID）
/// @param worldId 小世界id
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
- (void)requestWorldPostDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList;

/// 发布动态（已弃用，使用发布动态广场接口 requestWorldPostSquareDynamicWithWorldID）
/// @param worldId 小世界id
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param workOrder 认证主播的派单
- (void)requestWorldPostDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList workOrder:(AnchorOrderInfo *_Nullable)workOrder;

/// 发布动态(广场）
/// @param worldId 小世界id（可为空）
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
- (void)requestWorldPostSquareDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList;

/// 发布动态(广场）
/// @param worldId 小世界id（可为空）
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param workOrder 认证主播的派单
- (void)requestWorldPostSquareDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList workOrder:(AnchorOrderInfo *_Nullable)workOrder;

/**
 用户动态列表（我的主客态页）
 @param uid 查看对象的uid
 @param types 类型 0：纯文本，1:语音，2图片，3视频(为空标识所有,多种用逗号隔开)
 */
- (void)requestUserMomentListForUid:(NSString *)uid types:(NSString *)types page:(NSInteger)page pageSize:(NSInteger)pageSize;

/**
 删除动态

 @param dynamicId 动态id
 @param worldId uid
 */
- (void)requestDynamicDeleteWitDynamicId:(long)dynamicId worldId:(NSString *)worldId;

/// 获取动态列表
/// @param worldID 小世界id
/// @param pageNum 分页码数
/// @param dynamicId 动态id，只有在上拉加载更多的时候传入。此参数由服务器提供
- (void)requestDynamicListWithWorldID:(NSString *)worldID pageNum:(NSInteger)pageNum dynamicId:(NSInteger)dynamicId;

/**
 点赞/取消点赞
 
 @param dynamicId 动态id
 @param worldId 小世界id
 @param isLike true 点赞 false 取消 状态,0-取消赞,1-赞
 @param dynamicUid 动态发布者的uid
 */
- (void)requestDynamicLikeWitDynamicId:(NSInteger)dynamicId
                               worldId:(NSString *)worldId
                               isLike:(BOOL)isLike
                               dynamicUid:(NSString *)dynamicUid;

/**
 点赞/取消点赞（block)
 
 @param dynamicId 动态id
 @param worldId 小世界id
 @param isLike true 点赞 false 取消 状态,0-取消赞,1-赞
 @param dynamicUid 动态发布者的uid
 */
- (void)requestDynamicLikeWitDynamicId:(NSInteger)dynamicId
                               worldId:(NSString *)worldId
                                isLike:(BOOL)isLike
                            dynamicUid:(NSString *)dynamicUid
                            completion:(void(^)(BOOL success, NSString *errorMsg))completion;
/**
 请求动态详情

 @param dynamicId 动态id
 @param worldID 小世界id
 */
- (void)requestDynamicDetailsWitDynamicId:(NSString *)dynamicId worldID:(NSString *)worldID;

/**
 请求评论列表

 @param worldID 所在小世界id
 @param dynamicId 动态id
 @param pageNum 页数
 @param timestamp 上一个评论list里的最后时间戳
 */
- (void)requestCommentListWithWorldID:(NSString *)worldID
                            dynamicId:(NSString *)dynamicId
                              pageNum:(NSInteger)pageNum
                            timestamp:(long)timestamp;

/**
 评论接口
 @param dynamicId 动态id
 @param content 评论内容
 */
- (void)requestAddCommentWithDynamicId:(NSInteger)dynamicId content:(NSString *)content;

/**
 回复评论接口
 @param dynamicId 动态id
 @param content 评论内容
 @param commentId 评论id

 */
- (RACSignal *)requestReplyCommentWithDynamicId:(NSInteger)dynamicId
                                 content:(NSString *)content
                               commentId:(NSInteger )commentId;

/**
 查询嗨玩派对房间（语音派对）
 */
- (void)requestWorldPartyRoomListWithWorldId:(NSString *)worldId;

/// 删除评论 or 评论回复
/// @param commnetID 评论/回复id (commentId或replyId)
/// @param deleteType 删除类型 0 = 评论， 1 = 回复
- (RACSignal *)requestDynamicDeleteCommentWithCommentID:(NSString *)commnetID deleteType:(NSInteger)deleteType;

/// 获取评论回复列表
/// @param dynamicID 当前动态的动态id
/// @param commentID 动态的当前评论id
/// @param timestamp 上一条回复的时间戳
- (void)requestDynamicCommentReplyListWithDynamicID:(NSInteger)dynamicID commentID:(NSString *)commentID timestamp:(NSString *)timestamp;

/// 分享动态
/// @param worldId 所在的小世界id
/// @param dynamicID 动态id
/// @param uid 被分享人的 uid
- (void)requestWorldShareDynamicWithWorldId:(NSString *)worldId dynamicID:(NSInteger)dynamicID uid:(NSString *)uid;

#pragma mark -
#pragma mark 1.3.2

/// 动态广场推荐的动态
- (void)requestDynamicSquareRecommendDynamicsWithPage:(NSInteger)page;
/// 动态广场关注的动态
- (void)requestDynamicSquareFollowerDynamicsWithDynamicId:(NSString *)dynamicId;

/// 动态发布里的世界列表
/// @param type 请求世界类型
/// @param page 分页，默认1
- (void)requestWorldDynamicPostWorldListWithType:(DynamicPostWorldRequestType)type page:(NSInteger)page;


/// 获取主播订单状态（获取用户最新的动态派单）
/// @param targetUid 对方uid
- (void)requestAnchorOrderStatusWithUid:(NSString *)targetUid
                           completion:(void(^)(AnchorOrderStatus *data, NSNumber *errorCode, NSString *msg))completion;

/// 获取动态派单的配置
- (void)requestAnchorOrderConfigWithCompletion:(void(^)(AnchorOrderConfig *data, NSNumber *errorCode, NSString *msg))completion;
@end

NS_ASSUME_NONNULL_END
