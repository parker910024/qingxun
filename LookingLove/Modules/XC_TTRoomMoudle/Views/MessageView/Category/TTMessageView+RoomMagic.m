//
//  TTMessageView+RoomMagic.m
//  TuTu
//
//  Created by KevinWang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomMagic.h"
#import "TTMessageViewConst.h"

#import "RoomMagicCore.h"
#import "RoomMagicCoreClient.h"

@implementation TTMessageView (RoomMagic)

- (void)handleRoomMagicCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model{
    
    @KWeakify(self);
    [model setTextDidClick:^(UserID uid) {
        @KStrongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:needShowUserInfoCardWithUid:)]) {
            [self.delegate messageTableView:self needShowUserInfoCardWithUid:uid];
        }
    }];
    
    newCell.messageLabel.attributedText = model.content;
    
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
