//
//  AdCore.m
//  BberryCore
//
//  Created by 卫明何 on 2017/12/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "AdCore.h"
#import "AdCoreClient.h"
#import "AdCache.h"
#import "ImMessageCoreClient.h"
#import "ImMessageCore.h"
#import "XCUserUpgradeAttachment.h"

@interface AdCore()
<
    ImMessageCoreClient
>


@end

@implementation AdCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(ImMessageCoreClient, self);
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)setSplash:(AdInfo *)splash {
    _splash = splash;
    if (splash.pict.length > 0) {
        [[AdCache shareCache]saveAdInfo:splash];
    }
}

#pragma mark - ImMessageCoreClient
- (void)onRecvP2PCustomMsg:(NIMMessage *)msg {
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        if (attachment.first == Custom_Noti_Header_Turntable) {
            if (attachment.second == Custom_Noti_Sub_Turntable) {
                NotifyCoreClient(AdCoreClient, @selector(onReceiveTurntableMessage), onReceiveTurntableMessage);
            }
        }else if (attachment.first == Custom_Noti_Header_User_UpGrade){
            UserUpGradeInfo *info = [[UserUpGradeInfo alloc] init];
            XCUserUpgradeAttachment *attachment = ( XCUserUpgradeAttachment*)obj.attachment;
            info.levelName = attachment.levelName;
            if (attachment.second == Custom_Noti_Sub_User_UpGrade_ExperLevelSeq) {
                NotifyCoreClient(AdCoreClient, @selector(onReceiveUserUpGradeMessage:type:), onReceiveUserUpGradeMessage:info type:UserUpgradeViewTypeExperLevel);
            }else if (attachment.second == Custom_Noti_Sub_User_UpGrade_CharmLevelSeq){
                NotifyCoreClient(AdCoreClient, @selector(onReceiveUserUpGradeMessage:type:), onReceiveUserUpGradeMessage:info type:UserUpgradeViewTypeCharmLevel);
            }
        }
    }
}


@end
