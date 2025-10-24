//
//  TTDisplayModelMaker+RoomKick.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomKick.h"

@implementation TTDisplayModelMaker (RoomKick)

- (TTMessageDisplayModel *)makeKickContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
    
    //create
    if (attachment.second == Custom_Noti_Sub_Queue_Kick) {//踢下麦
        RoomQueueCustomAttachment *queueAttachment = [RoomQueueCustomAttachment yy_modelWithJSON:attachment.data];
        
        NSMutableAttributedString * kickAttributedStr = [BaseAttrbutedStringHandler creatKick:BaseAttributedStringKickTypeBeDownMic handleNick:queueAttachment.handleNick targetNick:queueAttachment.targetNick];
        
        [kickAttributedStr yy_setTextHighlightRange:[[kickAttributedStr string] rangeOfString:queueAttachment.targetNick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (model.textDidClick) {
                model.textDidClick(queueAttachment.uid);
            }
        } longPressAction:nil];
        
        [kickAttributedStr yy_setTextHighlightRange:[[kickAttributedStr string] rangeOfString:queueAttachment.handleNick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (model.textDidClick) {
                model.textDidClick(queueAttachment.handleUid);
            }
        } longPressAction:nil];
        
        
        string = kickAttributedStr;
    }else if (attachment.first == Custom_Noti_Header_Kick){
        
        ChatRoomQueueNotifyModel *notifyInfo = [ChatRoomQueueNotifyModel yy_modelWithJSON:attachment.data];
        if (attachment.second == Custom_Noti_Sub_Kick_BeKicked){//踢出房间
            NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
            //踢的是机器人，所以需要把消息改成机器人主动退出房间
            if ([robotId integerValue] == notifyInfo.uid || [robotId integerValue] == notifyInfo.handleUid) {
                string = [BaseAttrbutedStringHandler creatRobotOutRoomStrBy:notifyInfo.targetNick];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Robot"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else {
                NSMutableAttributedString * kickAttributed = [BaseAttrbutedStringHandler creatKick:BaseAttributedStringKickTypeBeKick handleNick:notifyInfo.handleNick targetNick:notifyInfo.targetNick];
                @KWeakify(self);
                [kickAttributed yy_setTextHighlightRange:[[kickAttributed string] rangeOfString:notifyInfo.handleNick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    @KStrongify(self);
                    if (notifyInfo.targetUid) {
                        if (model.textDidClick) {
                            model.textDidClick(notifyInfo.targetUid);
                        }
                    }
                } longPressAction:nil];
                
                [kickAttributed yy_setTextHighlightRange:[[kickAttributed string] rangeOfString:notifyInfo.targetNick] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    @KStrongify(self);
                    if (model.textDidClick) {
                        model.textDidClick(notifyInfo.uid);
                    }
                }];
                string = kickAttributed;
            }
            
        }else if (attachment.second == Custom_Noti_Sub_Kick_BlackList){//拉黑
            NSMutableAttributedString * blackListAttributed = [BaseAttrbutedStringHandler creatKick:BaseAttributedStringKickTypeBeBack handleNick:notifyInfo.handleNick targetNick:notifyInfo.targetNick];
            @KWeakify(self);
            [blackListAttributed yy_setTextHighlightRange:[[blackListAttributed string] rangeOfString:notifyInfo.targetNick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @KStrongify(self);
                if (notifyInfo.uid) {
                    if (model.textDidClick) {
                        model.textDidClick(notifyInfo.uid);
                    }
                }
            } longPressAction:nil];
            
            [blackListAttributed yy_setTextHighlightRange:[[blackListAttributed string] rangeOfString:notifyInfo.handleNick] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @KStrongify(self);
                if (model.textDidClick) {
                    model.textDidClick(notifyInfo.handleUid);
                }
            }];
            string = blackListAttributed;
            
        }
    }else if (attachment.second == Custom_Noti_Sub_Queue_Invite){
        RoomInfo * infor = [GetCore(RoomCoreV2) getCurrentRoomInfo];
        if (infor.roomModeType == RoomModeType_Open_Micro_Mode) {
            XCInviteMicAttachment *queueAttachment = [XCInviteMicAttachment yy_modelWithJSON:attachment.data];
            NSMutableAttributedString * inviteAttribute = [BaseAttrbutedStringHandler createEmbrace:queueAttachment.targetNick];
            [inviteAttribute yy_setTextHighlightRange:[[inviteAttribute string] rangeOfString:queueAttachment.targetNick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                if (model.textDidClick) {
                    model.textDidClick(queueAttachment.uid.userIDValue);
                }
            } longPressAction:nil];
            string = inviteAttribute;
        }
    }
    model.content = string;
    return model;
}

@end
