//
//  XCSessionConfig.m
//  XChat
//
//  Created by 卫明何 on 2017/10/12.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "TTSessionConfig.h"
//#import <NIMSessionConfig.h>
#import "NIMSessionConfig.h"
#import "NSString+NTES.h"
#import "VersionCore.h"
#import "XCFamily.h"
#import "FamilyCore.h"
#import "XCMacros.h"

#import "HostUrlManager.h"

@implementation TTSessionConfig

- (NSArray<NIMMediaItem *> *)mediaItems {
    
    NIMMediaItem *sendPic = [NIMMediaItem item:@"onTapMediaItemPicture:"
                                   normalImage:[UIImage imageNamed:@"chat_icon_photo"]
                                 selectedImage:[UIImage imageNamed:@"chat_icon_photo"]
                                         title:@"图片"];
    NIMMediaItem *sendGift = [NIMMediaItem item:@"onTapSendGift:"
                                    normalImage:[UIImage imageNamed:@"chat_icon_gift"]
                                  selectedImage:[UIImage imageNamed:@"chat_icon_gift"]
                                          title:@"礼物"];
    NIMMediaItem *chatterboxGame = [NIMMediaItem item:@"onTapChatterbox:"
                                    normalImage:[UIImage imageNamed:@"chat_icon_say"]
                                  selectedImage:[UIImage imageNamed:@"chat_icon_say"]
                                          title:@"话匣子"];
    NIMMediaItem *presentDressUp = [NIMMediaItem item:@"onTapDressUp:"
                                          normalImage:[UIImage imageNamed:@"chat_icon_primp"]
                                        selectedImage:[UIImage imageNamed:@"chat_icon_primp"]
                                                title:@"装扮"];
    NIMMediaItem *game = [NIMMediaItem item:@"onTapGame:"
                                normalImage:[UIImage imageNamed:@"message_item_game"]
                              selectedImage:[UIImage imageNamed:@"message_item_game"]
                                      title:@"家族游戏"];
    
    NSArray *items = @[];
    
    if (self.isGuildGroupType) {
        items = @[sendPic];
    }  else {
        EnvironmentType env = [HostUrlManager.shareInstance currentEnvironment];
        BOOL devMode = env == TestType || env == DevType;
        NSString *secretaryUid = keyWithType(KeyType_SecretaryUid, devMode);
        NSString *systemUid = keyWithType(KeyType_SystemNotifyUid, devMode);
        if ([self.session.sessionId isEqualToString:secretaryUid] || [self.session.sessionId isEqualToString:systemUid]) {
            
            return @[sendPic,chatterboxGame];
        }
        BOOL isMe = _session.sessionType == NIMSessionTypeP2P &&
        [_session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
        
        if (!isMe) {
            items = @[sendPic, sendGift, chatterboxGame, presentDressUp];
        }
        
        if (_session.sessionType == NIMSessionTypeTeam) {
            XCFamily *family = (XCFamily *)[GetCore(FamilyCore) getFamilyModel];
            if (!family.openGame && family.openMoney) { //关闭游戏或者关闭家族币 或者两个都关闭都要隐藏游戏
                items = @[sendPic, /*redGroup*/];
            } else if (!family.openMoney) {
                items = @[sendPic];
            } else {
                items = @[sendPic/*, redGroup*/, game];
            }
        }
    }
    
    return items;
}

- (BOOL)shouldHandleReceipt {
    return YES;
}


- (BOOL)shouldHandleReceiptForMessage:(NIMMessage *)message {
    //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
    NIMMessageType type = message.messageType;
//    if (type == NIMMessageTypeCustom) {
//        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
//        id attachment = object.attachment;
        
//    }
    
    return type == NIMMessageTypeText ||
    type == NIMMessageTypeAudio ||
    type == NIMMessageTypeImage ||
    type == NIMMessageTypeVideo ||
    type == NIMMessageTypeFile ||
    type == NIMMessageTypeLocation ||
    type == NIMMessageTypeCustom;
}

@end
