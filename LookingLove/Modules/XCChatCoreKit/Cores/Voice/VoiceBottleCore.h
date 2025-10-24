//
//  VoiceBottleCore.h
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoiceBottleCore : BaseCore

/** 录音的时候 获取剧本的内容*/
- (void)getVoiceBottlePiaWhenRecord;

/**
 获取声音匹配列表

 @param gender 0.不限 1.男 2.女
 @param pageSize 一页大小
 */
- (void)requestVoiceMatchingListWithGender:(NSInteger)gender pageSize:(NSInteger)pageSize;

/**
 声音喜欢or不喜欢请求

 @param voiceId 声音的id
 @param isLike 是否喜欢 yes:喜欢
 */
- (void)sendVoiceLikeRequestWithVoiceId:(NSInteger)voiceId isLike:(BOOL)isLike;

/**
 增加声音播放次数

 @param voiceId 声音id（不传时为voiceUid对应的默认声音）
 @param voiceUid 声音所属用户Uid
 */
- (void)addVoicePlayCountRequestWithVoiceId:(UserID)voiceId voiceUid:(UserID)voiceUid;

/**
 请求我的声音列表
 */
- (void)requestMyVoiceList;

/**
 查询旧版本个人介绍声音
 */
- (void)requestOldVoiceIntroduce;

/**
 同步旧版本个人介绍声音到声音瓶子
 */
- (void)sendOldVoiceIntroduceSyncVoiceBottle:(NSInteger)voiceId;

/**
 上传声音

 @param voiceUrl 声音的地址
 @param voiceLength 声音的长度
 @param piaId 剧本的id
 @param voiceId 声音的id
 */
- (void)uploadVoiceWith:(NSString *)voiceUrl
            voiceLength:(int)voiceLength
                  piaId:(UserID)piaId
                voiceId:(UserID)voiceId;

@end

NS_ASSUME_NONNULL_END
