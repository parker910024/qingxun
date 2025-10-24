//
//  TTDisplayModelMaker+Notification.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+Notification.h"
#import "AuthCore.h"
#import "ImMessageCore.h"

#import "TTStatisticsService.h"

@implementation TTDisplayModelMaker (Notification)

- (TTMessageDisplayModel *)makeNotificationContentWithMessage:(NIMMessage *)message withModel:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    NSString *nick = @"";
    
    NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
    
    
    if (content.eventType == NIMChatroomEventTypeEnter) {//enter
        
        
        
        NIMChatroomNotificationMember *member = content.targets[0];
        
        nick = member.nick.length > 0 ? member.nick : @"";
        nick = [nick cleanSpecialText];
        
        NSString * dic = ((NIMMessageChatroomExtension *)message.messageExt).roomExt;
        NSDictionary * userDic = [NSString dictionaryWithJsonString:dic];;
        UserInfo * userInfo= [UserInfo yy_modelWithJSON:[userDic valueForKey:message.from]];
        userInfo.uid = message.from.userIDValue;
        userInfo.nick = nick;
        NSString *carName = [TTMessageHelper handleRoomExtStrToCarModel:((NIMMessageChatroomExtension *)message.messageExt).roomExt uid:message.from];
        
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
        
        //offical
        if (userInfo.defUser == AccountType_Official) {
            NSMutableAttributedString * officalImageString = [BaseAttrbutedStringHandler makeOfficalImage:userInfo];
            [str appendAttributedString:officalImageString];
            [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
        }else{
            if (userInfo.newUser) {
                [str appendAttributedString:[BaseAttrbutedStringHandler makeNewUserImage:userInfo.newUserIcon]];
                [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
            }
        }
        
        NSMutableAttributedString *nickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
        
        [nickAttr yy_setTextHighlightRange:NSMakeRange(0, nickAttr.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (model.textDidClick) {
                model.textDidClick(message.from.userIDValue);
            }
        }];
        
        [str appendAttributedString:nickAttr];
        
        if(carName.length > 0) {
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 驾着 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:carName attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
        }
        
        [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 进入了房间" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
        
        BOOL onMic = [GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue];
        if (userInfo.uid != GetCore(AuthCore).getUid.userIDValue && onMic) {//麦上用户视角
            BOOL hadSendGreeting = [[message.localExt objectForKey:@(TTMessageViewEnterRoomSendGreetingFlag)] boolValue];
            if (!hadSendGreeting) {//未发送，增加发送按钮；已发送则不显示
                [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
                [str appendAttributedString:[self greetingAttributedStringWithUserInfo:userInfo model:model]];
            }
        }

        model.content = str;
        model.contentHeight = [[TTMessageViewLayout shareLayout]getAttributedHeightWith:str];
    }
    return model;
}

- (NSMutableAttributedString *)greetingAttributedStringWithUserInfo:(UserInfo *)userInfo model:(TTMessageDisplayModel *)model {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 47, 17);
    [button setImage:[UIImage imageNamed:@"room_enter_greeting"] forState:UIControlStateNormal];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [GetCore(RoomCoreV2) requestRoomEnterGreetingToUid:@(userInfo.uid).stringValue completion:^(RoomEnterGreeting * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
            
            if (data == nil) {
                return;
            }
            
            NSDictionary *dict = @{@"targetUid": @(userInfo.uid),
                                   @"targetNick": userInfo.nick?:@"",
                                   @"content": data.msg?:@"",
                                   @"isFans": @(data.isFans)};
            
            Attachment *attach = [[Attachment alloc] init];
            attach.first = Custom_Noti_Header_RoomPublicScreen;
            attach.second = Custom_Noti_Sub_RoomPublicScreen_greeting;
            attach.data = dict;
            
            NSString *sessionId = @(GetCore(ImRoomCoreV2).currentRoomInfo.roomId).stringValue;
            
            [GetCore(ImMessageCore) sendCustomMessageAttachement:attach
                                                       sessionId:sessionId
                                                            type:NIMSessionTypeChatroom];
            
            !model.textDidClick ?: model.textDidClick(TTMessageViewEnterRoomSendGreetingFlag);
            
            [TTStatisticsService trackEvent:@"room_welcome_him" eventDescribe:@"欢迎TA"];
        }];
    }];
    
    NSMutableAttributedString *str = [NSMutableAttributedString yy_attachmentStringWithContent:button contentMode:UIViewContentModeScaleAspectFit attachmentSize:button.frame.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return str;
}

@end

