//
//  VoiceBottleModel.h
//  XCChatCoreKit
//
//  Created by Macx on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

typedef enum : NSUInteger {
    TTVoiceStatusAudit = 0,     // 待审核
    TTVoiceStatusPass = 1,      // 审核通过
    TTVoiceStatusNoSubmit = 2,  // 无提交审核
} TTVoiceStatus; // 声音的状态

NS_ASSUME_NONNULL_BEGIN

@interface VoiceBottleModel : NSObject
/** id */
@property (nonatomic, assign) NSInteger id;
/** 声音所属用户uid */
@property (nonatomic, assign) NSInteger uid;
/** 是否默认声音 */
@property (nonatomic, assign) BOOL defFlag;
/** 喜欢次数 */
@property (nonatomic, assign) NSInteger likeCount;
/** 听过次数 */
@property (nonatomic, assign) NSInteger playCount;
/** 性别（1.男，2.女) */
@property (nonatomic, assign) UserGender gender;
/** 声音地址 */
@property (nonatomic, strong) NSString *voiceUrl;
/** 声音时长 */
@property (nonatomic, assign) NSInteger voiceLength;
/** Pia剧本Id */
@property (nonatomic, assign) NSInteger piaId;
/** 用户昵称 */
@property (nonatomic, strong) NSString *nick;
/** 用户生日 */
@property (nonatomic, assign) long birth;
/** 用户头像 */
@property (nonatomic, strong) NSString *avatar;
/** 定位 */
@property (nonatomic, strong) NSString *location;
/** 0,待审核 1 审核通过 2.无提交审核 */
@property (nonatomic, assign) TTVoiceStatus status;
@end

NS_ASSUME_NONNULL_END
