//
//  TTDisplayModelMaker.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker.h"

//category
#import "TTDisplayModelMaker+TextMessage.h"
#import "TTDisplayModelMaker+Notification.h"
#import "TTDisplayModelMaker+Custom.h"

//tool
#import <YYText/YYText.h>
#import "TTCPGamePrivateChatCore.h"


@implementation TTDisplayModelMaker

+ (instancetype)shareMaker {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (TTMessageDisplayModel *)makeMessageDisplayModelWithMessage:(NIMMessage *)message {
    TTMessageDisplayModel *model = [[TTMessageDisplayModel alloc]init];
    model.message = message;
    [GetCore(TTCPGamePrivateChatCore) storageMessageForNormalRoomGameStatus:model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (message.messageType) {
            case NIMMessageTypeText:
            {
                [self makeTextContentWithMessage:message withModel:model];
            }
                break;
            case NIMMessageTypeNotification:
            {
                [self makeNotificationContentWithMessage:message withModel:model];
            }
                break;
            case NIMMessageTypeCustom:
            {
                [self makeCustomContentWithMessage:message withModel:model];
            }
                break;
            default:
                break;
        }
    });
    
    return model;
}


@end
