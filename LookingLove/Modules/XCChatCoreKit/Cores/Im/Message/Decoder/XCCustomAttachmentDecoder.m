//
//  XCCustomAttachmentDecoder.m
//  BberryCore
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "XCCustomAttachmentDecoder.h"

//model
#import "UserInfo.h"
#import "GiftReceiveInfo.h"
//tool
#import "NSString+JsonToDic.h"
#import "NSObject+YYModel.h"
//core
#import "VersionCore.h"
#import "UserCore.h"
#import "GiftCore.h"
#import "AuthCore.h"
//attachment
#import "Attachment.h"
#import "XCOpenLiveAttachment.h"
#import "XCRedPacketInfoAttachment.h"
#import "XCNewsInfoAttachment.h"
#import "XCGiftAttachment.h"
#import "XCInviteMicAttachment.h"
#import "TurntableAttachment.h"
#import "NobleNotifyAttachment.h"
#import "P2PInteractiveAttachment.h"
#import "PublicChatAtMemberAttachment.h"
#import "XCATAttachment.h"
#import "XCCommunityNotiAttachment.h"
#import "XCTopicNotiAttachment.h"
#import "XCWebH5Attachment.h"
#import "XCGameVoiceBottleAttachment.h"
#import "XCLittleWorldAutoQuitAttachment.h"
#import "TTRoomLoveModelAttachment.h"

#import "XCApplicationSharement.h"
#import "RedPacketDetailInfo.h"
#import "MessageBussiness.h"
#import "VersionCore.h"
#import "UserCore.h"
#import "AuthCore.h"

#import "XCUserUpgradeAttachment.h"
#import "XCCoupleMessageAttachment.h"
#import "XCGuildAttachment.h"
#import "XCMentoringShipAttachment.h"

#import "XCCPGamePrivateAttachment.h"
#import "XCCPGamePrivateSysNotiAttachment.h"
#import "XCChatterboxAttachment.h"
#import "XCChatterboxPointAttachment.h"

#import "XCCheckinNoticeAttachment.h"
#import "XCCheckinDrawCoinAttachment.h"
#import "XCRoomGiftValueSyncAttachment.h"
#import "XCLittleWorldAttachment.h"

#import "XCRoomSuperAdminAttachment.h"
#import "XCDynamicAuditAttachment.h"

#import "XCDynamicPostSuccessAttachment.h"
#import "FeedbackAttachment.h"
#import "XCRedRecieveAttachment.h"
#import "XCRedDrawAttachment.h"
#import "XCRedAuthorityAttachment.h"

@implementation XCCustomAttachmentDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content {
    id<NIMCustomAttachment> attachment = nil;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]){
            
            int first = [dict[@"first"] intValue];
            int second = [dict[@"second"] intValue];
            
            NSDictionary *data = dict[@"data"];
            if ([data isKindOfClass:[NSString class]]) {
                data = [NSString dictionaryWithJsonString:(NSString *)data];
            }
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                
                if (first == Custom_Noti_Header_CustomMsg) {//云信自定义消息
                    
                    if (second == Custom_Noti_Sub_Online_alert) {//主播上线
                        
                        UserInfo *user = [[UserInfo alloc]init];
                        if (dict[@"userVo"] && [dict[@"userVo"] isKindOfClass:[NSDictionary class]]) {
                            user = [UserInfo modelWithJSON:dict];
                        }
                        NSString *uid = [NSString stringWithFormat:@"%@",data[@"uid"]];
                        XCOpenLiveAttachment *attachment = [[XCOpenLiveAttachment alloc]init];
                        if (user.nick.length > 0) {
                            attachment.avatar = user.avatar;
                            attachment.nick = user.nick;
                            attachment.uid = user.uid;
                            
                        }else {
                            attachment.uid = uid.userIDValue;
                            attachment.first = (short)first;
                            attachment.second = (short)second;
                            attachment.data = data;
                        }
                        return attachment;
                    }
                }else if (first == Custom_Noti_Header_Gift) {//礼物
                    if (second == Custom_Noti_Sub_Gift_Send || second == Custom_Noti_Sub_Gift_LuckySend) {
                        XCGiftAttachment *attachment = [[XCGiftAttachment alloc]init];
                        GiftInfo * info = [GetCore(GiftCore)findGiftInfoByGiftId:[data[@"giftId"]integerValue]];
                        if (!info) {
                            info = data[@"gift"] ? [GiftInfo yy_modelWithJSON:data[@"gift"]] : [GiftInfo yy_modelWithJSON:data[@"giftInfo"]];
                        }
                        attachment.giftName = [NSString stringWithFormat:@"%@",info.giftName];
                        attachment.giftPic = [NSString stringWithFormat:@"%@",info.giftUrl];
                        attachment.giftNum = [NSString stringWithFormat:@"%@",data[@"giftNum"]];
                        
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        attachment.data = data;
                        return attachment;
                    }
                }else if (first == Custom_Noti_Header_RedPacket){
                    
                    if (GetCore(VersionCore).loadingData) {
                        UserInfo *user = [[UserInfo alloc]init];
                        user = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
                        XCOpenLiveAttachment *attachment = [[XCOpenLiveAttachment alloc]init];
                        attachment.avatar = user.avatar;
                        attachment.nick = user.nick;
                        attachment.uid = user.uid;
                        return attachment;
                        
                    }else {
                        
                        XCRedPacketInfoAttachment *attachment = [[XCRedPacketInfoAttachment alloc]init];
                        attachment.title = [NSString stringWithFormat:@"%@",data[@"packetName"]];
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        attachment.data = data;
                        return attachment;
                    }
                }else if (first == Custom_Noti_Header_News) {
                    
                    if (second == Custom_Noti_Sub_News) {
                        
                        XCNewsInfoAttachment *attachment = [XCNewsInfoAttachment yy_modelWithJSON:data];
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        attachment.data = data;
                        
                        return attachment;
                    }
                    
                }else if (first == Custom_Noti_Header_Queue) {//队列
                    
                    if (second == Custom_Noti_Sub_Queue_Invite || second == Custom_Noti_Sub_Queue_Kick) {
                        
                        XCInviteMicAttachment *attachment = [XCInviteMicAttachment yy_modelWithJSON:data];
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        attachment.data = data;
                        return attachment;
                    }
                }else if (first == Custom_Noti_Header_Turntable) {//转盘
                    
                    if (second == Custom_Noti_Sub_Turntable) {
                        
                        TurntableAttachment *attachment = [TurntableAttachment yy_modelWithJSON:data];
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        return attachment;
                    }
                }else if (first == Custom_Noti_Header_NobleNotify) {//贵族通知
                    NobleNotifyAttachment *attachment = [[NobleNotifyAttachment alloc]init];
                    if (second != Custom_Noti_Sub_NobleNotify_Welocome) {
                        if (data[@"msg"]) {
                            attachment.uid = [data[@"uid"] integerValue];
                            attachment.msg = data[@"msg"];
                            attachment.first = (short)first;
                            attachment.second = (short)second;
                        }else {
                            attachment.first = (short)first;
                            attachment.second = (short)second;
                            attachment.data = data;
                        }
                    }else {
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        attachment.data = data;
                    }
                    return attachment;
                }else if (first == Custom_Noti_Header_CarNotify) {//座驾
                    
                    NobleNotifyAttachment *attachment = [[NobleNotifyAttachment alloc]init];
                    if (second == Custom_Noti_Sub_Car_OutDate) {
                        if (data[@"msg"]) {
                            attachment.uid = [data[@"uid"] integerValue];
                            attachment.msg = data[@"msg"];
                            attachment.first = (short)first;
                            attachment.second = (short)second;
                        }else {
                            
                            attachment.first = (short)first;
                            attachment.second = (short)second;
                            attachment.data = data;
                        }
                    }else {
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        attachment.data = data;
                    }
                    return attachment;
                }else if (first == Custom_Noti_Header_Secretary_Universal) {//小秘书通用消息
                    
                    if (second == CustomNotification_Secretary_Universal_Interactive) {
                        P2PInteractiveAttachment *p2pAttachment = [P2PInteractiveAttachment yy_modelWithJSON:data];
                        p2pAttachment.first = (short)first;
                        p2pAttachment.second = (short)second;
                        return p2pAttachment;
                    }
                    
                }else if (first ==Custom_Noti_Header_User_UpGrade){//用户升级提醒
                    if (second == Custom_Noti_Sub_User_UpGrade_ExperLevelSeq || second == Custom_Noti_Sub_User_UpGrade_CharmLevelSeq) {
                        XCUserUpgradeAttachment *attachment = [XCUserUpgradeAttachment yy_modelWithJSON:data];
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        attachment.data = data;
                        return attachment;
                    }
                }else if (first == Custom_Noti_Header_NobleNotify) {
                    if (second != Custom_Noti_Sub_NobleNotify_Welocome) {
                        if (data[@"msg"]) {
                            attachment = [[NobleNotifyAttachment alloc]init];
                            ((NobleNotifyAttachment *)attachment).uid = [data[@"uid"] integerValue];
                            ((NobleNotifyAttachment *)attachment).msg = data[@"msg"];
                            ((NobleNotifyAttachment *)attachment).first = (short)first;
                            ((NobleNotifyAttachment *)attachment).second = (short)second;
                        }else {
                            attachment = [[Attachment alloc]init];
                            ((Attachment *)attachment).first = (short)first;
                            ((Attachment *)attachment).second = (short)second;
                            ((Attachment *)attachment).data = data;
                        }
                    }else {
                        attachment = [[Attachment alloc]init];
                        ((Attachment *)attachment).first = (short)first;
                        ((Attachment *)attachment).second = (short)second;
                        ((Attachment *)attachment).data = data;
                    }
                }else if (first == Custom_Noti_Header_CarNotify) {
                    if (second == Custom_Noti_Sub_Car_OutDate) {
                        if (data[@"msg"]) {
                            attachment = [[NobleNotifyAttachment alloc]init];
                            ((NobleNotifyAttachment *)attachment).uid = [data[@"uid"] integerValue];
                            ((NobleNotifyAttachment *)attachment).msg = data[@"msg"];
                            ((NobleNotifyAttachment *)attachment).first = (short)first;
                            ((NobleNotifyAttachment *)attachment).second = (short)second;
                        }else {
                            attachment = [[Attachment alloc]init];
                            ((Attachment *)attachment).first = (short)first;
                            ((Attachment *)attachment).second = (short)second;
                            ((Attachment *)attachment).data = data;
                        }
                    }else {
                        attachment = [[Attachment alloc]init];
                        ((Attachment *)attachment).first = (short)first;
                        ((Attachment *)attachment).second = (short)second;
                        ((Attachment *)attachment).data = data;
                    }
                }else if (first == Custom_Noti_Header_Message_Handle) {
                    MessageBussiness *bussiness = [MessageBussiness yy_modelWithJSON:data];
                    bussiness.layout = [MessageLayout yy_modelWithJSON:data[@"layout"]];
                    bussiness.first = (short)first;
                    bussiness.second = (short)second;
                    bussiness.data = data;
                    attachment = bussiness;
                }else if (first == Custom_Noti_Header_OfficialAnchorCertification) {//复制上一个if
                    MessageBussiness *bussiness = [MessageBussiness yy_modelWithJSON:data];
                    bussiness.layout = [MessageLayout yy_modelWithJSON:data[@"layout"]];
                    bussiness.first = (short)first;
                    bussiness.second = (short)second;
                    bussiness.data = data;
                    attachment = bussiness;
                }else if (first == Custom_Noti_Header_InApp_Share){
                    XCApplicationSharement * memtn = [XCApplicationSharement yy_modelWithJSON:data];
                    memtn.first = (short)first;
                    memtn.second = (short)second;
                    memtn.data = data;
                    attachment = memtn;
                    
                }else if (first == Custom_Noti_Header_Game_LittleWorld){
                    XCLittleWorldAttachment *attach = [XCLittleWorldAttachment yy_modelWithJSON:data];
                    attach.first = (int)first;
                    attach.second = (int)second;
                    attach.data = data;
                    return attach;
                }else if (first == Custom_Noti_Header_Group_RedPacket) {
                    
                    RedPacketDetailInfo * info = [RedPacketDetailInfo yy_modelWithJSON:data];
                    info.first = (short)first;
                    info.second = (short)second;
                    info.data = data;
                    attachment = info;
                    
                }else if (first == Custom_Noti_Header_PublicChatroom) {
                    if (second == Custom_Noti_Sub_PublicChatroom_Send_At) {
                        PublicChatAtMemberAttachment *at = [PublicChatAtMemberAttachment modelWithJSON:data];
                        at.first = (short)first;
                        at.second = (short)second;
                        at.data = data;
                        attachment = at;
                    }else if (second == Custom_Noti_Sub_PublicChatroom_Send_Private_At) {
                        XCATAttachment *attach = [XCATAttachment yy_modelWithJSON:data];
                        P2PInteractiveAttachment *at = [[P2PInteractiveAttachment alloc] init];
                        at.first = (short)first;
                        at.second = (short)second;
                        at.msg = attach.content;
                        at.data = data;
                        attachment = at;
                    }else if (second == Custom_Noti_Sub_PublicChatroom_Send_Gift) {
                        XCGiftAttachment *attachment = [[XCGiftAttachment alloc]init];
                        GiftInfo * info = [GetCore(GiftCore)findGiftInfoByGiftId:[data[@"giftId"]integerValue]];
                        if (!info) {
                            info = data[@"gift"] ? [GiftInfo yy_modelWithJSON:data[@"gift"]] : [GiftInfo yy_modelWithJSON:data[@"giftInfo"]];
                        }
                        attachment.giftName = [NSString stringWithFormat:@"%@",info.giftName];
                        attachment.giftPic = [NSString stringWithFormat:@"%@",info.giftUrl];
                        attachment.giftNum = [NSString stringWithFormat:@"%@",data[@"giftNum"]];
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        attachment.data = data;
                        return attachment;
                    }
                }else if (first == Custom_Noti_Header_CoupleMsg) {
                    if (second == Custom_Noti_Header_CoupleMessage) {
                        XCCoupleMessageAttachment *attachment = [[XCCoupleMessageAttachment alloc]init];
                        attachment.from = data[@"frome"];
                        attachment.title = data[@"title"];
                        attachment.first = (short)first;
                        attachment.second = (short)second;
                        attachment.data = data;
                        return attachment;
                    }
                } else if (first == Custom_Noti_Header_HALL) {
                    
                    XCGuildAttachment *attach = [XCGuildAttachment yy_modelWithJSON:data];
                    attach.layout = [MessageLayout yy_modelWithJSON:data[@"layout"]];
                    attach.first = (short)first;
                    attach.second = (short)second;
                    attach.data = data;
                    return attach;
                    
                }else if (first == Custom_Noti_Header_Mentoring_RelationShip) {
                    XCMentoringShipAttachment  *attach = [XCMentoringShipAttachment yy_modelWithJSON:data];
                    attach.first = (short)first;
                    attach.second = (short)second;
                    attach.data = data;
                    return attach;
                    
                }else if (first ==  Custom_Noti_Header_Game_VoiceBottle) {
                    XCGameVoiceBottleAttachment  *attach = [XCGameVoiceBottleAttachment yy_modelWithJSON:data];
                    attach.first = (short)first;
                    attach.second = (short)second;
                    attach.data = data;
                    return attach;
                    
                }else if (first == Custom_Noti_Header_CPGAME_PrivateChat){
                    XCCPGamePrivateAttachment * memtn = [XCCPGamePrivateAttachment yy_modelWithJSON:data];
                    memtn.first = (short)first;
                    memtn.second = (short)second;
                    memtn.data = data;
                    attachment = memtn;
                }else if (first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification){
                    XCCPGamePrivateSysNotiAttachment * memtn = [XCCPGamePrivateSysNotiAttachment yy_modelWithJSON:data];
                    memtn.first = (short)first;
                    memtn.second = (short)second;
                    memtn.data = data;
                    attachment = memtn;
                } else if (first == Custom_Noti_Header_PrivateChat_Chatterbox) {
                    if (second == Custom_Noti_Sub_PrivateChat_Chatterbox_launchGame || second == Custom_Noti_Sub_PrivateChat_Chatterbox_Init) {
                        XCChatterboxAttachment * memtn = [XCChatterboxAttachment yy_modelWithJSON:data];
                        memtn.first = (short)first;
                        memtn.second = (short)second;
                        memtn.data = data;
                        attachment = memtn;
                    } else if (second == Custom_Noti_Sub_PrivateChat_Chatterbox_throwPoint) {
                        XCChatterboxPointAttachment * memtn = [XCChatterboxPointAttachment yy_modelWithJSON:data];
                        memtn.first = (short)first;
                        memtn.second = (short)second;
                        memtn.data = data;
                        attachment = memtn;
                    }
                } else if (first == Custom_Noti_Header_SystemNoti){
                    /*
                     Custom_Noti_Header_SystemNoti_Communit = 381,//社区  推送
                     Custom_Noti_Header_SystemNoti_Topic = 382,// 话题
                     Custom_Noti_Header_SystemNoti_H5 = 383,// H5
                     */
                    if (second == Custom_Noti_Header_SystemNoti_Communit) {
                        XCCommunityNotiAttachment * memtn = [XCCommunityNotiAttachment yy_modelWithJSON:data];
                        memtn.first = (short)first;
                        memtn.second = (short)second;
                        memtn.data = data;
                        attachment = memtn;
                    }
                    // 话题下一期做
                    /*
                     else if (second == Custom_Noti_Header_SystemNoti_Topic) {
                     XCTopicNotiAttachment * memtn = [XCTopicNotiAttachment yy_modelWithJSON:data];
                     memtn.first = (short)first;
                     memtn.second = (short)second;
                     memtn.data = data;
                     attachment = memtn;
                     
                     }*/
                    else if (second == Custom_Noti_Header_SystemNoti_H5) {
                        XCWebH5Attachment * memtn = [XCWebH5Attachment yy_modelWithJSON:data];
                        memtn.first = (short)first;
                        memtn.second = (short)second;
                        memtn.data = data;
                        attachment = memtn;
                    }
                    
                    
                } else if (first == Custom_Noti_Header_Checkin) {
                    if (second == Custom_Noti_Sub_Checkin_Notice) {//签到提醒通知
                        XCCheckinNoticeAttachment *attach = [XCCheckinNoticeAttachment yy_modelWithJSON:data];
                        attach.content = data[@"content"];
                        attach.title = data[@"title"];
                        attach.first = (int)first;
                        attach.second = (int)second;
                        attach.data = data;
                        return attach;
                        
                    } else {//签到瓜分金币通知
                        XCCheckinDrawCoinAttachment *attach = [XCCheckinDrawCoinAttachment yy_modelWithJSON:data];
                        attach.nick = data[@"nick"];
                        attach.goldNum = data[@"goldNum"];
                        attach.first = (int)first;
                        attach.second = (int)second;
                        attach.data = data;
                        return attach;
                    }
                    
                } else if (first == Custom_Noti_Header_GiftValue) {
                    
                    if (second == Custom_Noti_Sub_GiftValue_sync) {//房间礼物值同步
                        XCRoomGiftValueSyncAttachment *attach = [XCRoomGiftValueSyncAttachment yy_modelWithJSON:data];
                        attach.first = (int)first;
                        attach.second = (int)second;
                        attach.data = data;
                        return attach;
                    }
                    
                } else if (first == Custom_Noti_Header_Room_SuperAdmin) {
                    XCRoomSuperAdminAttachment *superAdminAttachment = [XCRoomSuperAdminAttachment yy_modelWithJSON:data];
                    superAdminAttachment.first = (int)first;
                    superAdminAttachment.second = (int)second;
                    superAdminAttachment.data = data;
                    return superAdminAttachment;
                    
                } else if (first == Custom_Noti_Header_Room_LittleWorldQuit) {
                    XCLittleWorldAutoQuitAttachment *autoQuitAttachment = [XCLittleWorldAutoQuitAttachment yy_modelWithJSON:data];
                    autoQuitAttachment.first = (int)first;
                    autoQuitAttachment.second = (int)second;
                    autoQuitAttachment.data = data;
                    return autoQuitAttachment;
                    
                } else if (first == Custom_Noti_Header_Dynamic) {
                    if (second == Custom_Noti_Sub_Dynamic_Approved ||
                        second == Custom_Noti_Sub_Dynamic_Ban_Delete) {
                        
                        XCDynamicAuditAttachment *attach = [XCDynamicAuditAttachment yy_modelWithJSON:data];
                        attach.layout = [MessageLayout yy_modelWithJSON:data[@"layout"]];
                        attach.first = first;
                        attach.second = second;
                        attach.data = data;
                        return attach;
                        
                    } else if (second == Custom_Noti_Sub_Dynamic_Unread_Update) {
                        Attachment *attach = [[Attachment alloc] init];
                        attach.first = first;
                        attach.second = second;
                        attach.data = data;
                        return attach;
                    } else if (second == Custom_Noti_Sub_Dynamic_ShareDynamic) {
                        // 发布成功
                        XCDynamicPostSuccessAttachment *attach = [[XCDynamicPostSuccessAttachment alloc] init];
                        attach.first = first;
                        attach.second = second;
                        attach.data = data;
                        return attach;
                    }
                    
                } else if (first == Custom_Noti_Header_Red) {
                    if (second == Custom_Noti_Sub_Red_Room_Current ||
                        second == Custom_Noti_Sub_Red_Room_Other) {
                        
                        XCRedRecieveAttachment *attach = [XCRedRecieveAttachment modelWithJSON:data];
                        attach.first = first;
                        attach.second = second;
                        return attach;
                        
                    } else if (second == Custom_Noti_Sub_Red_Room_Draw) {
                        
                        XCRedDrawAttachment *attach = [XCRedDrawAttachment modelWithJSON:data];
                        attach.first = first;
                        attach.second = second;
                        return attach;
                        
                    } else if (second == Custom_Noti_Sub_Red_Authority_All ||
                               second == Custom_Noti_Sub_Red_Authority_Specific) {
                                           
                        XCRedAuthorityAttachment *attach = [XCRedAuthorityAttachment modelWithJSON:data];
                        attach.first = first;
                        attach.second = second;
                        return attach;
                    }
                } else if (first == Custom_Noti_Header_Feedback) {
                    if (second == Custom_Noti_Sub_Feedback_Msg) {
                        FeedbackAttachment *attach = [FeedbackAttachment yy_modelWithJSON:data];
                        attach.first = first;
                        attach.second = second;
                        return attach;
                    }
                    
                } else if (first == Custom_Noti_Header_RoomLoveModelFirst) {
                    if (second == Custom_Noti_Sub_Room_LoveModel_Sec_Anmintions ||
                        second == Custom_Noti_Sub_Room_LoveModel_Sec_SuccessMsg ||
                        second == Custom_Noti_Sub_Room_LoveModel_Sec_SrceenMsg ||
                        second == Custom_Noti_Sub_Room_LoveModel_Sec_DownMicToast ||
                        second == Custom_Noti_Sub_Room_LoveModel_Sec_PublicLoveEffect) {
                        TTRoomLoveModelAttachment *attach = [TTRoomLoveModelAttachment modelDictionary:data];
                        attach.first = (int)first;
                        attach.second = (int)second;
                        attach.data = data;
                        return attach;
                    }
                } else {
                    
                    Attachment *attachment = [[Attachment alloc]init];
                    attachment.first = (short)first;
                    attachment.second = (short)second;
                    attachment.data = data;
                    return attachment;
                }
                
            }//data is dic
            
            
        }//dic
        
    }//has data
    return attachment;
}


@end
