//
//  HttpRequestHelper+Family.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "MessageBussiness.h"
#import "XCFamilyModel.h"
#import "XCFamilyMoneyModel.h"
#import "UserID.h"

@class XCFamily;
@interface HttpRequestHelper (Family)

/**
 请求家族信息（小接口非详情）

 @param familyId 家族id
 @param success 成功
 @param failure 失败
 */
+ (void)requestFamilyInfoByFamilyId:(NSString *)familyId
                            success:(void(^)(XCFamily *familyInfo))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 审批系统消息

 @param bussinessStatus 消息状态
 @param messageBussiness 消息实体
 @param method 方法
 @param success 成功
 @param failure 失败
 */
+ (void)updateFamilyBussinessStatusWith:(Message_Bussiness_Status)bussinessStatus
                       messageBussiness:(MessageBussiness *)messageBussiness
                                 method:(NSString *)method
                                 params:(NSMutableDictionary *)params
                               successs:(void(^)(MessageBussiness *bussiness))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 家族广场
 @param uid 用户的id
 @param success 成功
 @param failure 失败
 */
+ (void)getFamilyFinderMessageWith:(NSString *)uid
                          successs:(void(^)(NSMutableDictionary *bussiness))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 家族广场列表
 @param uid 用户的id
 @param success 成功
 @param failure 失败
 */
+ (void)getFamilySquareMessageWith:(NSString *)uid
                          successs:(void(^)(NSMutableDictionary *bussiness))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取所有的家族
 @param userID 用户的id
 @param page 当前的页数
 @param success 成功
 @param failure 失败
 */
+ (void)getTotalFamilys:(NSString *)userID
                page:(int)page
               successs:(void(^)(NSArray *squareList))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 家族客服
 @prarm userID用户的ID
 @param success 成功
 @param failure 失败
 */

+(void)guideAndServiceWith:(NSString *)userID
                  successs:(void(^)(NSDictionary *squareList))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 查询家族成员列表
 @param key 通过关键字的搜索

 */
+(void)searchFamilyMemberlistWithKey:(NSString *)key
                         successs:(void(^)(NSArray *memberList))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 家族广场 通过搜索得到的
 @param success 成功
 @param failure 失败
 @param key 关键词
 */
+ (void)searchFamilSquareListWithFamilykey:(NSString *)key
                                  successs:(void(^)(NSArray<XCFamily *> *squareList))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 家族信息
 @param temaId 家族的id
 @param success 成功
 @param failure 失败
 */
+ (void)getFamilyInforWith:(NSString *)temaId
                  successs:(void(^)(XCFamily *familyModel))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 修改家族信息
 @param inforDic 家族信息 familyName家族名称    inputfile 头像 verifyType 是否需要验证
 @param success 成功
 @param failure 失败
 */
+ (void)modifyFamilyInforWith:(NSDictionary *)inforDic
                     successs:(void(^)(NSDictionary *modelDic))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
退出家族
 @param success 成功
 @param failure 失败
 */
+ (void)quitFamilysuccesss:(void(^)(NSDictionary *successDic))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 加入家族
 @param content 加入家族的验证消息
 @param success 成功
 @param failure 失败
 */
+ (void)userenterFamilyWith:(NSString *)teamId
                    content:(NSString *)content
                   successs:(void(^)(NSDictionary *successDic))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 被踢出家族
 @param targetID 踢出家族的人的ID
 @param success 成功
 @param failure 失败
 */
+ (void)kichUserFromFamilyWithTargetID:(NSInteger )targetID
                              successs:(void(^)(NSDictionary *successDic))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 家族币
 @param userID 家族的人的ID
 @param success 成功
 @param failure 失败
 */
+ (void)familyMoneyManagermentWith:(NSString *)userID
                          successs:(void(^)(XCFamily *model))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 查询家族币
 @param userID 家族的人的ID
 @param page 当前的页数
 @param time 时间区间
 @param success 成功
 @param failure 失败
 */
+ (void)srachFamilyMoneyTradRecordWith:(NSInteger)userID
                               andPage:(int)page
                               andTime:(NSString *)time
                              successs:(void(^)(NSMutableArray<XCFamilyMoneyModel *> *recordList))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 家族币的分配（交易)
 @param userID 当前分配人的ID
 @param targetID 分配给谁ID
 @param amount 分配的金额
 @param success 成功
 @param failure 失败
 */

+ (void)familyMoneyTradExchangeWith:(NSInteger)userID andTargetID:(NSInteger)targetID andAmount:(NSString *)amount
                           successs:(void(^)(NSDictionary *successDic))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 成员贡献家族币给族长
 @param amount 金额
 @param success 成功
 @param failure 失败
 */
+ (void)memberContributFamilyMoneyTo:(NSString *)amount
                             uccesss:(void(^)(NSDictionary *successDic))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 邀请别人加入家族
 @param userID 当前分配人的ID
 @param targetID 分配给谁ID
 @param success 成功
 @param failure 失败
 */
+ (void)inviteUserToFamilyWith:(NSString *)userID andTargetID:(NSString *)targetID
                      successs:(void(^)(NSDictionary *successDic))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 接受别人的邀请
 @param userID 当前分配人的ID
 @param inviteID 分配给谁ID
 @param success 成功
 @param failure 失败
 */
+ (void)acceptInviteEnterFamilyWith:(NSString *)userID andInviteID:(NSString *)inviteID
                           successs:(void(^)(NSDictionary *successDic))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 查询游戏家族列表
 @param familyId 家族id
 @param success 成功
 @param failure 失败
 */
+ (void)requestFamilyGameListByFamilyId:(NSInteger)familyId success:(void(^)(NSArray<XCFamilyModel *>*))success failure:(void(^)(NSNumber *redCode , NSString *message))failure;

/**
 得到家族成员
 @param userId 用户id
 @param page 当前的页数
 @param success 成功
 @param failure 失败
 */
+ (void)fetchFamilyMembersList:(NSString*)userId page:(NSInteger)page success:(void(^)(XCFamily *family))success failure:(void(^)(NSNumber *redCode , NSString *message))failure;


/**
 查询当前群聊还没有加入的家族成员列表
 @param tid 群聊的id
 @param page 当前的页数
 @param key 查询的关键字 如果key 存在的话 page 不起作用
 @param success 成功
 @param failure 失败
 */
+ (void)fetchFamilyMemberNotJoinGroupWith:(NSInteger)tid andPage:(NSInteger)page andKey:(NSString *)key success:(void(^)(XCFamily * familyInfor))success failure:(void(^)(NSNumber *redCode , NSString *message))failure;

/**
 群聊本周的交易记录
 @param groupId 群聊的id
 @param erbanNo 查看的那个人耳伴号
 @param page 页数
 @param success 成功
 @param failure 失败
 */
+ (void)fetchGroupWeekRecordWith:(NSInteger)groupId erbanNo:(NSInteger)erbanNo page:(int)page success:(void(^)(XCFamily *family))success failure:(void(^)(NSNumber * redCode, NSString * message))failure;
/**
 家族的家族币流水
 */
+ (void)getFamilyMoneyRecord:(NSString *)userID
                        time:(NSString *)time
                        page:(int)page
                    successs:(void(^)(NSMutableArray<XCFamilyMoneyModel *> *recordList))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 家族魅力排行榜
 @param type 是上周还是这周的
 @param page 页数
 */
+ (void)getFamilyRecormmendList:(int)type
                           page:(int)page
                       pageSize:(int)pageSize
                       successs:(void(^)(XCFamily *charmFamilyInfor))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;


#pragma mark - 萌声的需求
+ (void)getMSDicoverBannderInfor:(UserID)uid
                        successs:(void(^)(XCFamily *charmFamilyInfor))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end
