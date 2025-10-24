//
//  TTDisplayModelMaker+EnterGreeting.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/3/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTDisplayModelMaker+EnterGreeting.h"

#import "PraiseCore.h"

#import "TTStatisticsService.h"

@implementation TTDisplayModelMaker (EnterGreeting)

- (TTMessageDisplayModel *)makeEnterGreetingWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];

    if (attachment.first == Custom_Noti_Header_RoomPublicScreen) {
        if (attachment.second == Custom_Noti_Sub_RoomPublicScreen_greeting) {
            
            SingleNobleInfo *nobleInfo = [TTMessageHelper handleRoomExtToModel:message.remoteExt uid:message.from];
            LevelInfo *levelInfo = [TTMessageHelper handleRoomExtToLevelModel:message.remoteExt uid:message.from];
            NSString *senderNick = ((NIMMessageChatroomExtension *)message.messageExt).roomNickname;
            
            //欢迎者视角
            if ([message.from isEqualToString:GetCore(AuthCore).getUid]) {
                senderNick = @"我";
            }
                 
            UserInfo *userInfo = [[UserInfo alloc] init];
            userInfo.nick = senderNick;
            userInfo.uid = message.from.userIDValue;
            userInfo.nobleUsers = nobleInfo;
            userInfo.userLevelVo = levelInfo;
            userInfo.defUser = levelInfo.defUser;
            userInfo.newUser = [TTMessageHelper handelNewUserToLevelModel:message.remoteExt uid:message.from];
            userInfo.nameplate = [TTMessageHelper handleOfficialAnchorCertification:message.remoteExt uid:message.from];
            
            NSMutableAttributedString *nickAndBadge = [BaseAttrbutedStringHandler creatOffical_nobleBadge_userLevel_nickAttributedByUserInfo:userInfo];
            [str appendAttributedString:nickAndBadge];
            
            NSMutableAttributedString *symbol = [[NSMutableAttributedString alloc]initWithString:@":"];
            [str appendAttributedString:symbol];
            
            [str addAttribute:NSForegroundColorAttributeName
                        value:[XCTheme getTTMessageViewNickColor]
                        range:NSMakeRange(0, nickAndBadge.length + symbol.length)];
            [str addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]
                        range:NSMakeRange(0, str.length)];
            
            [str yy_setTextHighlightRange:NSMakeRange(0, str.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                if (model.textDidClick) {
                    model.textDidClick(userInfo.uid);
                }
            }];
            
            NSString *nick = attachment.data[@"targetNick"];
            NSString *content = attachment.data[@"content"];
            BOOL isFans = [attachment.data[@"isFans"] boolValue];
            NSString *placeholder = @"${nick}";
            NSRange placeholderRange = [content rangeOfString:placeholder];
            NSString *msg = [content stringByReplacingCharactersInRange:placeholderRange withString:nick];
            NSRange nickRange = [msg rangeOfString:nick];
            
            NSMutableAttributedString *msgStr = [BaseAttrbutedStringHandler creatStrAttrByStr:msg attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            [msgStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFD98C) range:nickRange];
            [str appendAttributedString:msgStr];

            if (!isFans) {
                [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
                NSMutableAttributedString *fansStr = [self focusAttributedStringWithUserId:userInfo.uid];
                [str appendAttributedString:fansStr];
            }
        }
    }
        
    str.yy_lineSpacing = 6;

    model.content = str;
    model.contentHeight = [[TTMessageViewLayout shareLayout] getAttributedHeightWith:str];
    
    return model;
}

- (NSMutableAttributedString *)focusAttributedStringWithUserId:(UserID)toUid {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 47, 17);
    [button setImage:[UIImage imageNamed:@"room_enter_focus"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"room_enter_focus_done"] forState:UIControlStateSelected];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [GetCore(PraiseCore) praise:GetCore(AuthCore).getUid.userIDValue bePraisedUid:toUid];
        button.selected = YES;
        button.userInteractionEnabled = NO;
        
        [TTStatisticsService trackEvent:@"room_follow_him" eventDescribe:@"关注TA"];
    }];
    
    NSMutableAttributedString *str = [NSMutableAttributedString yy_attachmentStringWithContent:button contentMode:UIViewContentModeScaleAspectFit attachmentSize:button.frame.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return str;
}

@end
