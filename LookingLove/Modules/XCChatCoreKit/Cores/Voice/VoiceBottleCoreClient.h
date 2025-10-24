//
//  VoiceBottleCoreClient.h
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoiceBottlePiaModel.h"
#import "VoiceBottleModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol VoiceBottleCoreClient <NSObject>
@optional
/** 获取剧本*/
- (void)getVoicePiaWhenRecordSuccess:(NSArray<VoiceBottlePiaModel *> *)array;
- (void)getVoicePiaWhenRecordFail:(NSString *)message;

/** 获取声音匹配列表 */
- (void)requestVoiceMatchingListSuccess:(NSArray<VoiceBottleModel *> *)array;
- (void)requestVoiceMatchingListFail:(NSString *)message errorCode:(NSNumber *)errorCode;

/** 声音喜欢or不喜欢请求 */
- (void)sendVoiceLikeRequestSuccess;
- (void)sendVoiceLikeRequestFail:(NSString *)message errorCode:(NSNumber *)errorCode;

/** 请求我的声音列表 */
- (void)requestMyVoiceListSuccess:(NSArray<VoiceBottleModel *> *)array;
- (void)requestMyVoiceListFail:(NSString *)message errorCode:(NSNumber *)errorCode;

/** 查询旧版本个人介绍声音 */
- (void)requestOldVoiceIntroduceSuccess:(NSDictionary *)dict;
- (void)requestOldVoiceIntroduceFail:(NSString *)message errorCode:(NSNumber *)errorCode;

/** 声音录制完成 回调声音model*/
- (void)recordVoiceCompleteWithVoiceBottleModel:(VoiceBottleModel *)voiceModel;
- (void)uploadVoiceBottleFail:(NSString *)message;

/** 在IMUI上添加一个回话*/
- (void)addMeesageToChatUIWith:(NSArray *)messages;


/** 同步旧版本个人介绍声音到声音瓶子 */
- (void)sendOldVoiceIntroduceSyncVoiceBottleSuccess;
- (void)sendOldVoiceIntroduceSyncVoiceBottleFail:(NSString *)message errorCode:(NSNumber *)errorCode;

@end

NS_ASSUME_NONNULL_END
