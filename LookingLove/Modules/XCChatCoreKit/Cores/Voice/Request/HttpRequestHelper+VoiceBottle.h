//
//  HttpRequestHelper+VoiceBottle.h
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "VoiceBottlePiaModel.h"
#import "VoiceBottleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (VoiceBottle)

/**
 录制声音的时候 请求剧本内容

 @param uid 当前用的的ID
 @param pageSize 一次请求多少
 @param type 剧本的类型（现在没哟）
 @param success 成功
 @param failure 失败
 */
+ (void)voliceBottleGetPiaWith:(UserID)uid
                      pageSize:(int)pageSize
                          type:(VoicePiaType)type
                       success:(void(^)(NSArray *array))success
                       failure:(void (^)(NSNumber *, NSString *))failure;

/** 获取声音匹配列表 */
+ (void)requestVoiceMatchingListWithGender:(NSInteger)gender
                                  pageSize:(NSInteger)pageSize
                                   success:(void(^)(NSArray *array))success
                                   failure:(void (^)(NSNumber *, NSString *))failure;
/** 声音喜欢or不喜欢请求 */
+ (void)sendVoiceLikeRequestWithVoiceId:(NSInteger)voiceId
                                 isLike:(BOOL)isLike
                                success:(void(^)(void))success
                                failure:(void (^)(NSNumber *, NSString *))failure;

/** 增加声音播放次数 */
+ (void)addVoicePlayCountRequestWithVoiceId:(UserID)voiceId
                                   voiceUid:(UserID)voiceUid
                                    success:(void(^)(void))success
                                    failure:(void (^)(NSNumber *, NSString *))failure;

/**
 请求我的声音列表
 */
+ (void)requestMyVoiceListWithSuccess:(void(^)(NSArray *array))success
                              failure:(void (^)(NSNumber *, NSString *))failure;

/** 查询旧版本个人介绍声音 */
+ (void)requestOldVoiceIntroduceWithSuccess:(void(^)(NSDictionary *dict))success
                                    failure:(void (^)(NSNumber *, NSString *))failure;

/** 同步旧版本个人介绍声音到声音瓶子 */
+ (void)sendOldVoiceIntroduceSyncVoiceBottle:(NSInteger)voiceId
                                     success:(void(^)(void))success
                                     failure:(void (^)(NSNumber *, NSString *))failure;


/**
上传声音到服务器

 @param uid 用户的id
 @param voiceUrl 声音的链接
 @param voiceLength 声音的长度
 @param piaId 剧本的id
 @param type 剧本的类型
 @param voiceId 声音的id
 */
+ (void)updateVoiceToServiceWith:(UserID)uid
                        voiceUrl:(NSString *)voiceUrl
                     voiceLength:(int)voiceLength
                           piaId:(UserID)piaId
                            type:(VoicePiaType)type
                         voiceId:(UserID)voiceId
                         success:(void(^)(VoiceBottleModel * model))success
                         failure:(void (^)(NSNumber *, NSString *))failure;

@end

NS_ASSUME_NONNULL_END
