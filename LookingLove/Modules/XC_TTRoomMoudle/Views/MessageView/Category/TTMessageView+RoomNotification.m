//
//  TTMessageView+RoomNotification.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomNotification.h"
#import "TTMessageViewConst.h"

#import <YYText/YYText.h>
#import "LevelInfo.h"

@implementation TTMessageView (RoomNotification)

- (void)handleNotificationCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model notificationBlock:(void (^)(NIMMessage * message))notificationBlock {
    newCell.messageLabel.attributedText = model.content;
    __block TTMessageDisplayModel *weakModel = model;
    [model setTextDidClick:^(UserID uid) {
        
        //点击进房欢迎
        if (uid == TTMessageViewEnterRoomSendGreetingFlag) {
            if ([self.delegate respondsToSelector:@selector(messageTableView:enterRoomHadSendGreetingWithModel:)]) {
                [self.delegate messageTableView:self enterRoomHadSendGreetingWithModel:weakModel];
            }
            return;
        }
        
        if (notificationBlock) {
            notificationBlock(weakModel.message);
        }
    }];
    
    newCell.labelContentView.hidden = NO;
    newCell.chatBubleImageView.hidden = YES;
    newCell.chatBubleImageView.image = nil;
}


@end
