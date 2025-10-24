//
//  XCMentoringShipAttachment.h
//  XCChatCoreKit
//
//  Created by gzlx on 2019/1/21.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface XCMentoringShipAttachment : Attachment<NIMCustomAttachment, XCCustomAttachmentInfo>
/** 任务标号*/
@property (nonatomic, assign) int step;
/** 提示*/
@property (nonatomic, strong) NSString * tips;
/** 标题*/
@property (nonatomic, strong) NSString * title;
/** 内容*/
@property (nonatomic, strong) NSArray<NSString *> * content;
/** 消息*/
@property (nonatomic, strong) NSString * message;
/**师傅的UID*/
@property (nonatomic, assign) UserID masterUid;
/** 徒弟的uid*/
@property (nonatomic, assign) UserID apprenticeUid;
/** 会话 的id*/
@property (nonatomic, assign) UserID sessionId;
/** 扩展字段 如礼物信息*/
@property (nonatomic, strong) id extendData;

//这下面的属性是 本地保存的

/** 师傅是不是已经关注了徒弟*/
@property (nonatomic, assign) BOOL masterFocus;
/** 师傅是不是赠送了话 给徒弟*/
@property (nonatomic, assign) BOOL masterSendGift;
/** 师傅是不是邀请进房*/
@property (nonatomic, assign) BOOL masterInviteRoom;
/**师傅是不是发了邀请函*/
@property (nonatomic, assign) BOOL masterInvite;

/** 徒弟关注师傅*/
@property (nonatomic, assign) BOOL apprenticeFocus;
/** 徒弟送花给师傅*/
@property (nonatomic, assign) BOOL apprenticeSendGift;

/** 徒弟答谢师傅*/
@property (nonatomic, assign) BOOL apprenticeThank;

/** 徒弟拒绝师傅的邀请*/
@property (nonatomic, assign) BOOL apprenticeReject;
/** 徒弟同意师傅的邀请*/
@property (nonatomic, assign) BOOL apprenticeAgree;
/** 徒弟拒绝的时候任务失败了*/
@property (nonatomic, assign) BOOL apprenticeRejectFail;
/** 徒弟同意任务的时候 失败了*/
@property (nonatomic, assign) BOOL apprenticeAgreeFail;
@end

NS_ASSUME_NONNULL_END
