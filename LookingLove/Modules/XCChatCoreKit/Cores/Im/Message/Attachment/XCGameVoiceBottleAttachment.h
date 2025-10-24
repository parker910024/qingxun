//
//  XCGameVoiceBottleAttachment.h
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/6/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"
#import "P2PInteractiveAttachment.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum {
    VoiceNotifyStatus_Prepare = 0, //准备审核
    VoiceNotifyStatus_Synchronizat = 1,//同步
    VoiceNotifyStatus_Pass = 2,//审核通过
    VoiceNotifyStatus_Delete = 3,//删除
    VoiceNotifyStatus_Fail = 4//审核不通过
}VoiceNotifyStatus;

@interface XCGameVoiceBottleAttachment : Attachment <NIMCustomAttachment,XCCustomAttachmentInfo>

/** 审核的状态*/
@property (nonatomic,assign) VoiceNotifyStatus status;;
/** 失败的原因*/
@property (nonatomic,strong) NSString *reason;
/** 跳转的类型*/
@property (nonatomic,assign) P2PInteractive_SkipType    routerType;
/** 转跳当前界面需要传的参*/
@property (nonatomic,strong) NSString                   *routerValue;

/** 打招呼的那个问候语*/
@property (nonatomic,strong) NSString *message;
/** 是不是已经收到打招呼*/
@property (nonatomic,assign) BOOL isReceiveGreet;
/** 是不是已经打过了招呼*/
@property (nonatomic,assign) BOOL isGreet;

/** 打招呼要给谁发*/
@property (nonatomic,assign) UserID voiceUid;
@end

NS_ASSUME_NONNULL_END
