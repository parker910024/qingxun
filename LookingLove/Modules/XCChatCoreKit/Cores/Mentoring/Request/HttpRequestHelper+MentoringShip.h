//
//  HttpRequestHelper+MentoringShip.h
//  XCChatCoreKit
//
//  Created by gzlx on 2019/1/21.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "GiftInfo.h"
#import "GiftAllMicroSendInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (MentoringShip)

/**
 是不是可以收徒

 @param uid 操作者的Uid
 @param success 成功
 @param failure 失败
 */
+ (void)userCanHarvestApprenticeWithUid:(UserID)uid
                                success:(void(^)(NSDictionary *dic))success
                                   fail:(void(^)(NSString * message, NSNumber * failCode))failure;


/**
 请求收徒

 @param uid 操作者的uid
 @param success 成功
 @param failure 失败
 */
+ (void)requstToHarvestApprcnticeWithUid:(UserID)uid
                                 success:(void(^)(NSDictionary *dic))success
                                    fail:(void(^)(NSString * message, NSNumber * failCode))failure;


/**
 请求师徒关系的b跑马灯

 @param page 当前的页数
 @param pageSize 一页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)getMasterAndApprenticeRelationShipListWithPage:(int)page pageSize:(int)pageSize
                                               success:(void(^)(NSArray *ships))success
                                                  fail:(void(^)(NSString * message, NSNumber * failCode))failure;


/**
 上报任务三

 @param userId 师傅的uid
 @param apprenticeUid 徒弟的Uid
 @param success 成功
 @param failure 失败
 */
+ (void)reportTheMentoringShipTaskThreeWithMasterUid:(UserID)userId apprenticeUid:(UserID)apprenticeUid
                                             success:(void(^)(NSDictionary *dic))success
                                                fail:(void(^)(NSString * message, NSNumber * failCode))failure;

/**
 建立师徒关系
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的Uid
 @param type 1 同意 2 失败
 @param success 成功
 @param failure 失败
 */
+ (void)bulidMentoringShipWithMasterUid:(UserID)masterUid
                          apprenticeUid:(UserID)apprenticeUid
                                   type:(int)type
                                success:(void(^)(NSDictionary *dic))success
                                   fail:(void(^)(NSString * message, NSNumber * failCode))failure;




/**
 师傅给徒弟打招呼
 
 @param uid 操作者的uid
 @param likedUid 关注的那个人的Uid
 @param success 成功
 @param failure 失败
 */
+ (void)mentoringShipFocusOrGreetToUser:(UserID)uid
                                likeUid:(UserID)likedUid
                                success:(void(^)(NSDictionary *dic))success
                                   fail:(void(^)(NSString * message, NSNumber * failCode))failure;

/**
 请求师徒关系的 我的师徒列表
 
 @param page 当前的页数
 @param pageSize 一页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)getMyMasterAndApprenticeList:(int)page
                            pageSize:(int)pageSize
                                               success:(void(^)(NSArray *ships))success
                                                  fail:(void(^)(NSString * message, NSNumber * failCode))failure;

/**
 请求师徒关系的 获取名师榜数据
 
 @param page 当前的页数
 @param pageSize 一页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)getMasterAndApprenticeRankingList:(int)page
                                 pageSize:(int)pageSize
                                     type:(int)type
                                  success:(void(^)(NSArray *ships))success
                                     fail:(void(^)(NSString * message, NSNumber * failCode))failure;

/**
 发送师徒关系邀请
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
+ (void)masterSendInviteRequestWithMasterUid:(UserID)masterUid
                               apprenticeUid:(UserID)apprenticeUid
                                     success:(void(^)(void))success
                                        fail:(void(^)(NSString * message, NSNumber * failCode))failure;

/**
 解除师徒关系
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 @param operUid 操作人uid
 */
+ (void)masterSendDeleteRequestWithMasterUid:(UserID)masterUid
                               apprenticeUid:(UserID)apprenticeUid
                                     operUid:(UserID)operUid
                                     success:(void(^)(void))success
                                        fail:(void(^)(NSString * message, NSNumber * failCode))failure;

/**
 师徒任务3 邀请进房判断师徒任务是否有效
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
+ (void)mentoringShipInviteEnableWithMasterUid:(UserID)masterUid
                                 apprenticeUid:(UserID)apprenticeUid
                                       success:(void(^)(void))success
                                          fail:(void(^)(NSString * message, NSNumber * failCode))failure;
/**
 师徒任务 送礼物
 */
+ (void)sendMentoringShipGift:(NSInteger)giftId
                    targetUid:(UserID)targetUid
                      giftNum:(NSInteger)giftNum
                 gameGiftType:(GameRoomGiftType)gameGiftType
                         type:(SendGiftType)type
                          msg:(NSString *)msg
                      success:(void (^)(GiftAllMicroSendInfo *info))success
                      failure:(void (^)(NSNumber *, NSString *))failure;

/**
 抢徒弟
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
+ (void)mentoringShipGrabApprenticeWithMasterUid:(UserID)masterUid
                                 apprenticeUid:(UserID)apprenticeUid
                                       success:(void(^)(void))success
                                          fail:(void(^)(NSString * message, NSNumber * failCode))failure;

@end

NS_ASSUME_NONNULL_END
