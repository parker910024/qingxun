//
//  TTSessionCellLayoutConfig.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSessionCellLayoutConfig.h"

#import "TTSessionContentConfig.h"

#import "XCOpenLiveAttachment.h"
#import "XCRedPacketInfoAttachment.h"
#import "XCNewsInfoAttachment.h"
#import "XCGiftAttachment.h"
#import "XCInviteMicAttachment.h"
#import "TurntableAttachment.h"
#import "NobleNotifyAttachment.h"
#import "P2PInteractiveAttachment.h"
#import "XCApplicationSharement.h"
#import "XCUserUpgradeAttachment.h"
#import "XCGameVoiceBottleAttachment.h"

#import "ImPublicChatroomCore.h"
#import "XCMacros.h"

@interface TTSessionCellLayoutConfig ()
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) TTSessionContentConfig *sessionContentConfig;
@end

@implementation TTSessionCellLayoutConfig

- (instancetype)init {
    if (self = [super init]) {
        _types =  @[
                    @"XCOpenLiveAttachment",
                    @"XCRedPacketInfoAttachment",
                    @"XCNewsInfoAttachment",
                    @"XCGiftAttachment",
                    @"XCInviteMicAttachment",
                    @"TurntableAttachment",
                    @"NobleNotifyAttachment",
                    @"P2PInteractiveAttachment",
                    @"XCUserUpgradeAttachment",
                    @"XCApplicationSharement",
                    @"MessageBussiness",
                    @"RedPacketDetailInfo",
                    @"XCUserUpgradeAttachment",
                    @"XCMentoringShipAttachment",
                    @"XCCPGamePrivateAttachment",
                    @"XCCPGamePrivateSysNotiAttachment",
                    @"XCChatterboxAttachment",
                    @"XCChatterboxPointAttachment",
                    @"XCGameVoiceBottleAttachment",
                    @"XCLittleWorldAttachment",
                    @"XCLittleWorldAutoQuitAttachment",
                    @"XCDynamicAuditAttachment",
                    @"XCDynamicPostSuccessAttachment"
                    ];
        _sessionContentConfig = [[TTSessionContentConfig alloc] init];
    }
    return self;
}

#pragma mark - NIMCellLayoutConfig
- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)width {
    
    NIMMessage *message = model.message;
    
    //检查是不是当前支持的自定义消息类型
    if ([self isSupportedCustomMessage:message]) {
        return [_sessionContentConfig contentSize:width message:message];
    }

    //如果没有特殊需求，就走默认处理流程
    return [super contentSize:model cellWidth:width];
}

- (NSString *)cellContent:(NIMMessageModel *)model {
    
    NIMMessage *message = model.message;
    
    //检查是不是当前支持的自定义消息类型
    if ([self isSupportedCustomMessage:message]) {
        return [_sessionContentConfig cellContent:message];
    }
    //如果没有特殊需求，就走默认处理流程
    return [super cellContent:model];
}

/**
 *  左对齐的气泡，cell内容距离气泡的内间距，
 */
- (UIEdgeInsets)contentViewInsets:(NIMMessageModel *)model {

    if ([self isSupportedCustomContentViewInsetsWithMessage:model.message]) {
        return [_sessionContentConfig contentViewInsets:model.message];
    }
    
    //图片类型不留边距
    if (model.message.messageType == NIMMessageTypeImage) {
        return UIEdgeInsetsZero;
    }
    
    //如果没有特殊需求，就走默认处理流程
    return [super contentViewInsets:model];
}

- (UIEdgeInsets)cellInsets:(NIMMessageModel *)model {
    
    NIMMessage *message = model.message;

    //检查是不是聊天室消息
    if (message.session.sessionType == NIMSessionTypeChatroom) {
        return UIEdgeInsetsZero;
    }
    
    //如果没有特殊需求，就走默认处理流程
    return [super cellInsets:model];
}

- (BOOL)shouldShowAvatar:(NIMMessageModel *)model {
    if (model.message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
        Attachment *att = (Attachment *)object.attachment;
        if (att.second == Custom_Noti_Sub_Header_Group_RedPacket_Tips) {
            return NO;
        }else if (att.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification){
            return NO;
        }
        
        if (att.first == Custom_Noti_Header_Mentoring_RelationShip) {
            if (att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Master || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Master || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Master || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Apprentice ||att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master_Tips || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Tips || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite ||
                att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Apprentice|| att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Fail_Tips ||
                att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Result){
                return NO;
            }
        }
        
        if (att.first == Custom_Noti_Header_Game_VoiceBottle) {
            if (att.second == Custom_Noti_Sub_Voice_Bottle_Hello) {
                return NO;
            }
        }
        
        if (att.first == Custom_Noti_Header_PrivateChat_Chatterbox) {
            if (att.second == Custom_Noti_Sub_PrivateChat_Chatterbox_Init) {
                return NO;
            }
        }
    }
    return [super shouldShowAvatar:model];
}

- (BOOL)shouldShowNickName:(NIMMessageModel *)model {
    if (model.message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
        Attachment *att = (Attachment *)object.attachment;
        if (att.second == Custom_Noti_Sub_Header_Group_RedPacket_Tips) {
            return NO;
        }
        if (att.first == Custom_Noti_Header_Mentoring_RelationShip) {
            if (att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Master || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Master || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Master || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Apprentice || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master_Tips || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Tips || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite||
                att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Apprentice || att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Fail_Tips ||
                att.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Result){
                return NO;
            }
        }
        //声音瓶子
        if (att.first == Custom_Noti_Header_Game_VoiceBottle) {
            if (att.second == Custom_Noti_Sub_Voice_Bottle_Hello) {
                return NO;
            }
        }
        
        if (att.first == Custom_Noti_Header_PrivateChat_Chatterbox) {
            if (att.second == Custom_Noti_Sub_PrivateChat_Chatterbox_Init) {
                return NO;
            }
        }
    }
    
    if ([model.message.session.sessionId integerValue] == GetCore(ImPublicChatroomCore).publicChatroomId) {
        return YES;
    }
    return [super shouldShowNickName:model];
}




//- (BOOL)disableRetryButton:(NIMMessageModel *)model {
//    if (model.message.messageType == NIMMessageTypeCustom) {
//        NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
//        Attachment *att = (Attachment *)object.attachment;
//        if (att.second == Custom_Noti_Sub_Header_Group_RedPacket_Tips) {
//            return YES;
//        }else {
//            return NO;
//        }
//    }
//    return [super shouldShowNickName:model];
//}

#pragma mark - Private Method
- (BOOL)isSupportedCustomMessage:(NIMMessage *)message {
    
    if (message.messageType != NIMMessageTypeCustom) {
        return NO;
    }
    
    NIMCustomObject *object = message.messageObject;
    Attachment *att = (Attachment *)object.attachment;
    if (att.first == Custom_Noti_Header_Gift) {
        if (att.second == Custom_Noti_Sub_Gift_Send) {
            return YES;
        }
    }
    
    if (att.first == Custom_Noti_Header_RedPacket) {
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_News) {
        if (att.second == Custom_Noti_Sub_News) {
            return YES;
        }
    }
    
    if (att.first == Custom_Noti_Header_CustomMsg) {
        if (att.second == Custom_Noti_Sub_Online_alert) {
            return YES;
        }
    }
    if (att.first == Custom_Noti_Header_Queue) {
        if (att.second == Custom_Noti_Sub_Queue_Invite) {
            return YES;
        }
    }
    if (att.first == Custom_Noti_Header_Turntable) {
        if (att.second == Custom_Noti_Sub_Turntable) {
            return YES;
        }
    }
    
    if (att.first == Custom_Noti_Header_User_UpGrade) {
        if (att.second == Custom_Noti_Sub_User_UpGrade_ExperLevelSeq || att.second == Custom_Noti_Sub_User_UpGrade_CharmLevelSeq) {
            return YES;
        }
    }
    
    if (att.first == Custom_Noti_Header_Secretary_Universal) {
        if (att.second == CustomNotification_Secretary_Universal_Interactive) {
            return YES;
        }
    }
    
    if (att.first == Custom_Noti_Header_Group_RedPacket) {
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_PublicChatroom) {
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_Mentoring_RelationShip) {
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_HALL) {
        // 公会模厅系统消息
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_Checkin) {
        // 签到系统消息
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_PrivateChat_Chatterbox) {
        //话匣子
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_Game_VoiceBottle) {
        //声音瓶子
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_Game_LittleWorld) {
        //小世界
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_Room_LittleWorldQuit) {
        // 自动离开小世界群聊
        return YES;
    }
    
    if (att.first == Custom_Noti_Header_Dynamic) {
        if (att.second == Custom_Noti_Sub_Dynamic_Approved ||
            att.second == Custom_Noti_Sub_Dynamic_Ban_Delete ||
            att.second == Custom_Noti_Sub_Dynamic_ShareDynamic) {
            //动态审核通过/动态删除
            return YES;
        }
    }
    
    if (att.first == Custom_Noti_Header_Feedback) {
        if (att.second == Custom_Noti_Sub_Feedback_Msg) {
            //举报反馈
            return YES;
        }
    }
    
    return [object isKindOfClass:[NIMCustomObject class]] &&
    [_types indexOfObject:NSStringFromClass([object.attachment class])] != NSNotFound;
}

- (BOOL)isSupportedChatroomMessage:(NIMMessage *)message {
    return message.session.sessionType == NIMSessionTypeChatroom &&
    (message.messageType == NIMMessageTypeText || message.messageType == NIMMessageTypeRobot || [self isSupportedCustomMessage:message]);
}

- (BOOL)isChatroomTextMessage:(NIMMessage *)message {
    return message.session.sessionType == NIMSessionTypeChatroom &&
    message.messageType == NIMMessageTypeText;
}

/// 是否可是设置气泡内间距，默认是{11, 15, 9, 9}
/// 如果需要自定义内间距，在CustomAttachment实现contentViewInsets:即可
- (BOOL)isSupportedCustomContentViewInsetsWithMessage:(NIMMessage *)message {
    if (![self isSupportedCustomMessage:message]) {
        return NO;
    }
    
    NIMCustomObject *object = message.messageObject;
    id<XCCustomAttachmentInfo> info = (id<XCCustomAttachmentInfo>)object.attachment;
    if ([info conformsToProtocol:@protocol(XCCustomAttachmentInfo)]) {//自定义视图
        if ([info respondsToSelector:@selector(contentViewInsets:)]) {//实现自定义内间距
            return YES;
        }
    }
    
    return NO;
}

@end

