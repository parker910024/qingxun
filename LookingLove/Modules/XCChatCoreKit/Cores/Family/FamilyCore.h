//
//  FamilyCore.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "MessageBussiness.h"
#import "AttributedStringDataModel.h"

//家族专用
typedef NS_ENUM(NSInteger, XCShare_Type){
    XCShare_Type_Invite = 1,
    XCShare_Type_Share = 2
};

typedef NS_ENUM(NSInteger, FamilyFinderSkipType)
{
    FamilyFinderSkipWeb =1,//网页
    FamilyFinderSkipRoom =2,//房间
    FamilyFinderSkipGame =3,//游戏
    FamilyFinderSkipHeadWear =4, //头饰
};

typedef NS_ENUM(NSInteger, FamilyMemberListType)
{
    FamilyMemberListFamilyRemove = 1, //移除 家族内
    FamilyMemberListCreateGroup = 2, //创建群的时候选择成员
    FamilyMemberListMoneyTransfer =3, //家族币转让
    FamilyMemberGroupListAtMe = 4, //群里面的@
    FamilyMemberListGroupBanned = 5, //群禁言
    FamilyMemberListGroupManager = 6, //设置群管理
    FamilyMemberListGroupRemove = 7, //移出群
    FamilyMemberListCheck = 8, //查看家族成员列表 什么都不做
    FamilyGroupMemberListCheck = 9, //查看群成员列表 什么都不做
    FamilyMemberAddGroup = 10,//往群里面加 家族成员
};


@class XCFamily;
@interface FamilyCore : BaseCore
@property (nonatomic, strong) NSDictionary * serviceDic;//客服电话和id
@property (nonatomic, strong) NSString * teamId;//家族的id
//@property (nonatomic, strong) XCFamily * familyInfor;//不管是不是自己的家族 都保存起来
- (XCFamily *)getFamilyModel;//得到我自己的家族信息
- (void)reloadFamilyInfor:(XCFamily *)familyInfor;//更新家族信息



/**
 请求家族信息（小接口）

 @param familyId 家族id
 */
- (void)requestFamilyInfoByFamilyId:(NSString *)familyId
                            success:(void (^)(XCFamily *))success;
- (void)requestFamilyInfoByFamilyId:(NSString *)familyId
                            success:(void (^)(XCFamily *))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

//族长id
- (NSString *)getLaderID;

/**
 查询系统通知的富文本缓存

 @param messageId 消息id
 @return 富文本实体
 */
- (AttributedStringDataModel *)queryAttrByMessageId:(NSString *)messageId;

/**
 存储系统通知的富文本（非审批富文本）

 @param attributedString 富文本
 @param messageId 消息id
 @param isComplete 是否是完全生成的、因为性能优化 富文本分两个阶段生成，如果没生成则继续生成并且缓存
 */
- (void)saveAttributedString:(NSMutableAttributedString *)attributedString
               WithMessageId:(NSString *)messageId
                  isComplete:(BOOL)isComplete;



/**
 审批

 @param bussiness 审批实体，用作本地更新
 @param message 消息实体
 @param targetStatus 需要修改的状态
 @param method 方法
 @param params 参数实体
 */
- (void)updateApprovalStatus:(MessageBussiness *)bussiness
                     message:(NIMMessage *)message
                targetStatus:(Message_Bussiness_Status)targetStatus
                      method:(NSString *)method
                      params:(NSMutableDictionary *)params;
/**
 得到客服电话和客服耳伴id
 */
- (void)requestService;
/**
 发现页
 @param userID  用户id
 */
- (void)familyFinderMessage:(NSString *)userID;

/**
  家族广场
 @param userID  用户id
 */
- (void)familySquareListWithID:(NSString *)userID;

/**
 所有的家族
 @param userId  用户id
 @param status 结束尾部刷新还是 头部刷新
 @param page 当前的页数
 */
- (void)getTotalFamilysWith:(NSString *)userId
                  andStatus:(int)status
                    andPage:(int)page;

/**
 搜索家族广场
 @param key  关键字
 */
- (void)searchFamilyListWithKey:(NSString *)key;

/**
 通过家族id 查看家族信息
 @param teamId  家族Id
 */
- (void)checktFamilyInforWith:(NSString *)teamId;

/**
 退出家族
 */
- (void)quitFamily;


/**
 加入家族
 @param content 加入家族的验证消息
 @param teamId 所家族家族的id
 */
- (void)enterFamilyWith:(NSString *)content
                 teamId:(NSString *)teamId;

/**
 修改家族信息
 @param familyDic 家族的信息
 */
- (void)modifyFamilyInfor:(NSDictionary *)familyDic;

/**
 获取家族成员列表
 @param userId 用户id
 @param page 当前的页数
 @param status 刷新的头部还是尾部
 */
- (void)fetchFamilyMemberList:(NSString * )userId
                         page:(NSInteger)page
                       status:(NSInteger)status;

/**
 移出家族
 @param targetId 目标用uid
 */
- (void)removeFamilyMember:(NSInteger)targetId;

/**
 获取家族游戏列表
 @param familyId 家族的id
 */
- (void)requestGameListByFamilyId:(NSInteger)familyId;

/**
获取家族币 头部
 @param userID 用户的id
 */
- (void)fetchFamilyMoneyManaegerWith:(NSString *)userID;

/**
 获取家族币列表
 @param userId 用户的id
 @param page 当前的页数
 @param time 时间
 @param isSearch 是不是搜索
 @param status 刷新的头部还是尾部
 */
- (void)fetchFamilyMoneyRecordListWith:(NSInteger)userId
                               andPage:(int)page
                              withTime:(NSString *)time
                                status:(int)status
                               isSearch:(BOOL)isSearch;


/**
 交易家族币(族长分配)
 @param targetId 目标用户的id
 @parma amoutn 交易的金额
 */
- (void)transferFamilyMoenyTo:(NSInteger)targetId
                    andAmount:(NSString*)amount;

/**
 贡献家族币（成员给族长）
 */
- (void)memberContributeFamilyMoney:(NSString *)amount;

/**
 搜索得到家族成员的列表(在搜索页面使用)
 @param key 关键字
 */
- (void)searchFamilyMemberListWithKey:(NSString *)key;


/**
邀请别人加入家族
 @param targetId 邀请那个人的id
*/
- (void)inviteUserEnterFamilyWithTargetId:(NSString *)targetId;


/**
 接受族长的邀请加入家族
 @param inviterId 邀请人的id
 */
-(void)acceptPatriarchInviteWith:(NSString *)inviterId;

/**
 查询不在群里面的家族成员列表
 @param chatId 群聊的id
 @param page 当前的页数
 @param key 搜索的关键字
 @param status 刷新的时候 头部还是尾部
 */
- (void)fetchFamilyMemberNotInGroupWith:(NSInteger)chatId
                                andPage:(NSInteger)page
                                 andKey:(NSString *)key
                              andStatus:(int)status
                               isSearch:(BOOL)isSearch;


/**
 查询群聊本周交易记录
 */
- (void)getGroupWeekFamilyMoneyRecord:(NSInteger)groupId erbanNo:(NSInteger)erbanNo page:(int)page status:(int)status isSearch:(BOOL)isSearch;

/**
 家族的 家族币记录
 */
- (void)getFamilyMoneyRecordList:(NSString *)userId time:(NSString *)time page:(int)page status:(int)status;

/**
 家族列表的（新的）魅力家族
 @param type 1 上周 2 本周
 @param page 页数
 @param pageSize 一页多少
 @param status 刷新
 */
- (void)getCharmFamilyList:(int)type page:(int)page pageSize:(int)pageSize status:(int)status;

#pragma mark - 萌声的
- (void)getMSDiscoverInforWith:(UserID)userID;
/** 得到用户的家族信息*/
- (void)getMSDiscoverFamilyInfor;

#pragma mark - 兔兔的
//获取发现页的banner
- (void)getTTDiscoverBannerInfor:(NSString *)userId;
@end
