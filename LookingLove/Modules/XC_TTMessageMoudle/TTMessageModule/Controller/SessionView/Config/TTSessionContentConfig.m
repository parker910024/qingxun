//
//  TTSessionContentConfig.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSessionContentConfig.h"

#import "XCCustomAttachmentInfo.h"
#import "RedPacketDetailInfo.h"

#import "Attachment.h"
#import "XCOpenLiveAttachment.h"
#import "XCRedPacketInfoAttachment.h"
#import "XCNewsInfoAttachment.h"
#import "XCGiftAttachment.h"
#import "XCInviteMicAttachment.h"
#import "XCApplicationSharement.h"
#import "XCMentoringShipAttachment.h"
#import "XCGameVoiceBottleAttachment.h"
#import "XCGuildAttachment.h"
#import "XCLittleWorldAttachment.h"
#import <YYModel/YYModel.h>

#import "XCChatterboxAttachment.h"
#import "XCChatterboxPointAttachment.h"

#import "XCCPGamePrivateAttachment.h"
#import "XCCPGamePrivateSysNotiAttachment.h"

#import "XCCheckinNoticeAttachment.h"
#import "XCCheckinDrawCoinAttachment.h"

#import "XCDynamicAuditAttachment.h"
#import "XCLittleWorldAttachment.h"
#import "XCDynamicPostSuccessAttachment.h"

@implementation TTSessionContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    
    Attachment *att = (Attachment *)object.attachment;
    NSAssert([att isKindOfClass:[Attachment class]], @"attachment unexpected");
    
    if (att.first == Custom_Noti_Header_CustomMsg) {
        if (att.second == Custom_Noti_Sub_Online_alert) {
            XCOpenLiveAttachment *attachment = [XCOpenLiveAttachment yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        }
        
    } else if (att.first == Custom_Noti_Header_Gift) {
        if (att.second == Custom_Noti_Sub_Gift_Send) {
            XCGiftAttachment *attachment = [XCGiftAttachment yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        }
        
    } else if (att.first == Custom_Noti_Header_RedPacket) {
        XCRedPacketInfoAttachment *attachment = [XCRedPacketInfoAttachment yy_modelWithJSON:att.data];
        return [attachment contentSize:message cellWidth:cellWidth];
        
    } else if (att.first == Custom_Noti_Header_Group_RedPacket) {
        if (att.second == Custom_Noti_Sub_Header_Group_RedPacket_Send) {
            RedPacketDetailInfo *attachment = [RedPacketDetailInfo yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        } else if (att.second == Custom_Noti_Sub_Header_Group_RedPacket_Tips) {
            RedPacketDetailInfo *attachment = [RedPacketDetailInfo yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        }
        
    } else if (att.first == Custom_Noti_Header_News) {
        if (att.second == Custom_Noti_Sub_News) {
            XCNewsInfoAttachment *attachment = [XCNewsInfoAttachment yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        }
        
    } else if (att.first == Custom_Noti_Header_Queue) {
        if (att.second == Custom_Noti_Sub_Queue_Invite) {
            XCInviteMicAttachment *attachment = [XCInviteMicAttachment yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        }
        
    } else if(att.first == Custom_Noti_Header_InApp_Share) {
        XCApplicationSharement * attachment = [XCApplicationSharement yy_modelWithJSON:att.data];
        return [attachment contentSize:message cellWidth:cellWidth];
    } else if (att.first == Custom_Noti_Header_PublicChatroom) {
        if (att.second == Custom_Noti_Sub_PublicChatroom_Send_Private_At) {
            P2PInteractiveAttachment *attachment = [P2PInteractiveAttachment yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        }else if (att.second == Custom_Noti_Sub_PublicChatroom_Send_Gift) {
            XCGiftAttachment *attachment = [XCGiftAttachment yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        }else if (att.second == Custom_Noti_Sub_PublicChatroom_Send_At) {
            PublicChatAtMemberAttachment *at = [PublicChatAtMemberAttachment modelWithJSON:att.data];
            return [at contentSize:message cellWidth:cellWidth];
        }
    }else if (att.first == Custom_Noti_Header_Mentoring_RelationShip){
        XCMentoringShipAttachment * mentoringshipAtt = [XCMentoringShipAttachment modelWithJSON:att.data];
        return [mentoringshipAtt contentSize:message cellWidth:cellWidth];
    } else if (att.first == Custom_Noti_Header_HALL) {
        XCGuildAttachment *attachment = [XCGuildAttachment yy_modelWithJSON:att.data];
        return [attachment contentSize:message cellWidth:cellWidth];
    } else if (att.first == Custom_Noti_Header_Checkin) {
        if (att.second == Custom_Noti_Sub_Checkin_Notice) {
            XCCheckinNoticeAttachment *attachment = [XCCheckinNoticeAttachment yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        } else {
            XCCheckinDrawCoinAttachment *attachment = [XCCheckinDrawCoinAttachment yy_modelWithJSON:att.data];
            return [attachment contentSize:message cellWidth:cellWidth];
        }
    }else if (att.first == Custom_Noti_Header_PrivateChat_Chatterbox){
        if (att.second == Custom_Noti_Sub_PrivateChat_Chatterbox_launchGame || att.second == Custom_Noti_Sub_PrivateChat_Chatterbox_Init) {
            XCChatterboxAttachment * memtn = [XCChatterboxAttachment yy_modelWithJSON:att.data];
            [memtn contentSize:message cellWidth:cellWidth];
        } else if (att.second == Custom_Noti_Sub_PrivateChat_Chatterbox_throwPoint) {
            XCChatterboxPointAttachment * memtn = [XCChatterboxPointAttachment yy_modelWithJSON:att.data];
            [memtn contentSize:message cellWidth:cellWidth];
        }
    }else if (att.first == Custom_Noti_Header_Game_VoiceBottle) {
        XCGameVoiceBottleAttachment *attachment = [XCGameVoiceBottleAttachment yy_modelWithJSON:att.data];
        return [attachment contentSize:message cellWidth:cellWidth];
    }else if (att.first == Custom_Noti_Header_Game_LittleWorld) {
        XCLittleWorldAttachment * attach = [XCLittleWorldAttachment yy_modelWithJSON:att.data];
        return [attach contentSize:message cellWidth:cellWidth];
    } else if (att.first == Custom_Noti_Header_Game_LittleWorld) {
        if (att.second == Custom_Noti_Sub_Dynamic_Approved ||
            att.second == Custom_Noti_Sub_Dynamic_Ban_Delete) {
            
            XCDynamicAuditAttachment *attach = [XCDynamicAuditAttachment yy_modelWithJSON:att.data];
            return [attach contentSize:message cellWidth:cellWidth];
        }
    } else if (att.first == Custom_Noti_Header_Dynamic) {
        if (att.second == Custom_Noti_Sub_Dynamic_ShareDynamic) {
            
            XCDynamicPostSuccessAttachment *attach = [XCDynamicPostSuccessAttachment yy_modelWithJSON:att.data];
            return [attach contentSize:message cellWidth:cellWidth];
        }
    }
    
    id<XCCustomAttachmentInfo> info = (id<XCCustomAttachmentInfo>)object.attachment;
    NSAssert([info conformsToProtocol:@protocol(XCCustomAttachmentInfo)], @"invalid protocol type");
    
    return [info contentSize:message cellWidth:cellWidth];
}

- (NSString *)cellContent:(NIMMessage *)message {
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    
    Attachment *att = (Attachment *)object.attachment;
    NSAssert([att isKindOfClass:[Attachment class]], @"attachment unexpected");
    
    if (att.first == Custom_Noti_Header_CustomMsg) {
        if (att.second == Custom_Noti_Sub_Online_alert) {
            XCOpenLiveAttachment *attachment = [XCOpenLiveAttachment yy_modelWithJSON:att.data];;
            return [attachment cellContent:message];
        }
        
    } else if (att.first == Custom_Noti_Header_Gift) {
        if (att.second == Custom_Noti_Sub_Gift_Send) {
            XCGiftAttachment *attachment = [XCGiftAttachment yy_modelWithJSON:att.data];
            return [attachment cellContent:message];
        }
        
    } else if (att.first == Custom_Noti_Header_RedPacket) {
        XCRedPacketInfoAttachment *attachment = [XCRedPacketInfoAttachment yy_modelWithJSON:att.data];
        return [attachment cellContent:message];
        
    } else if (att.first == Custom_Noti_Header_Group_RedPacket) {
        RedPacketDetailInfo *attachment = [RedPacketDetailInfo yy_modelWithJSON:att.data];
        return [attachment cellContent:message];
        
    } else if (att.first == Custom_Noti_Header_News) {
        if (att.second == Custom_Noti_Sub_News) {
            XCNewsInfoAttachment *attachment = [XCNewsInfoAttachment yy_modelWithJSON:att.data];
            return [attachment cellContent:message];
        }
        
    } else if (att.first == Custom_Noti_Header_Queue) {
        if (att.second == Custom_Noti_Sub_Queue_Invite) {
            XCInviteMicAttachment *attachment = [XCInviteMicAttachment yy_modelWithJSON:att.data];
            return [attachment cellContent:message];
        }
        
    } else if (att.first == Custom_Noti_Header_InApp_Share) {
        XCApplicationSharement *attachment = [XCApplicationSharement yy_modelWithJSON:att.data];
        return [attachment cellContent:message];
    } else if (att.first == Custom_Noti_Header_PublicChatroom) {
        if (att.second == Custom_Noti_Sub_PublicChatroom_Send_Private_At) {
            P2PInteractiveAttachment *attachment = [P2PInteractiveAttachment yy_modelWithJSON:att.data];
            return [attachment cellContent:message];
        }
    }else if (att.first == Custom_Noti_Header_Mentoring_RelationShip){
        XCMentoringShipAttachment * mentoringshipAtt = [XCMentoringShipAttachment modelWithJSON:att.data];
        return [mentoringshipAtt cellContent:message];
    } else if (att.first == Custom_Noti_Header_HALL) {
        XCGuildAttachment *attachment = [XCGuildAttachment yy_modelWithJSON:att.data];
        return [attachment cellContent:message];
    } else if (att.first == Custom_Noti_Header_Checkin) {
        if (att.second == Custom_Noti_Sub_Checkin_Notice) {
            XCCheckinNoticeAttachment *attachment = [XCCheckinNoticeAttachment yy_modelWithJSON:att.data];
            return [attachment cellContent:message];
        } else {
            XCCheckinDrawCoinAttachment *attachment = [XCCheckinDrawCoinAttachment yy_modelWithJSON:att.data];
            return [attachment cellContent:message];
        }
    }else if (att.first == Custom_Noti_Header_PrivateChat_Chatterbox){
        if (att.second == Custom_Noti_Sub_PrivateChat_Chatterbox_launchGame || att.second == Custom_Noti_Sub_PrivateChat_Chatterbox_Init) {
            XCChatterboxAttachment * memtn = [XCChatterboxAttachment yy_modelWithJSON:att.data];
            [memtn cellContent:message];
        } else if (att.second == Custom_Noti_Sub_PrivateChat_Chatterbox_throwPoint) {
            XCChatterboxPointAttachment * memtn = [XCChatterboxPointAttachment yy_modelWithJSON:att.data];
            [memtn cellContent:message];
        }
    }else if (att.first == Custom_Noti_Header_Game_VoiceBottle) {
        XCGameVoiceBottleAttachment *attachment = [XCGameVoiceBottleAttachment yy_modelWithJSON:att.data];
        return [attachment cellContent:message];
    }else if (att.first == Custom_Noti_Header_Game_LittleWorld) {
        XCLittleWorldAttachment * attach = [XCLittleWorldAttachment yy_modelWithJSON:att.data];
        return [attach cellContent:message];
    } else if (att.first == Custom_Noti_Header_Dynamic) {
        if (att.second == Custom_Noti_Sub_Dynamic_Approved ||
            att.second == Custom_Noti_Sub_Dynamic_Ban_Delete) {
            
            XCDynamicAuditAttachment *attach = [XCDynamicAuditAttachment yy_modelWithJSON:att.data];
            return [attach cellContent:message];
        } else if (att.second == Custom_Noti_Sub_Dynamic_ShareDynamic) {
            
            XCDynamicPostSuccessAttachment *attach = [XCDynamicPostSuccessAttachment yy_modelWithJSON:att.data];
            return [attach cellContent:message];
        }
    }
    
    id<XCCustomAttachmentInfo> info = (id<XCCustomAttachmentInfo>)object.attachment;
    NSAssert([info conformsToProtocol:@protocol(XCCustomAttachmentInfo)], @"invalid protocol type");
    
    return [info cellContent:message];
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    id<XCCustomAttachmentInfo> info = (id<XCCustomAttachmentInfo>)object.attachment;
    return [info contentViewInsets:message];
}
@end
