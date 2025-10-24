//
//  TTMessageView+RoomGift.m
//  TuTu
//
//  Created by KevinWang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomGift.h"
#import "TTMessageViewConst.h"

#import "VersionCore.h"

@implementation TTMessageView (RoomGift)

- (void)handleGiftCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model{

    newCell.messageLabel.attributedText = model.content;
    @KWeakify(self);
    [model setTextDidClick:^(UserID uid) {
        @KStrongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:needShowUserInfoCardWithUid:)]) {
            [self.delegate messageTableView:self needShowUserInfoCardWithUid:uid];
        }
    }];
    
    SingleNobleInfo *nobleInfo = [TTMessageHelper handleRoomExtToModel:model.message.remoteExt uid:model.message.from];
    if (nobleInfo.bubble) {
        newCell.labelContentView.hidden = YES;
        newCell.chatBubleImageView.hidden = NO;

        [TTNobleSourceHandler handlerImageView:newCell.chatBubleImageView nobleInfo:nobleInfo];
    }else{
        newCell.labelContentView.hidden = NO;
        newCell.chatBubleImageView.hidden = YES;
    }
}

@end
