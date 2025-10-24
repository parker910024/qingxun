//
//  TTMessageView+RoomNoble.m
//  TuTu
//
//  Created by KevinWang on 2018/11/26.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomNoble.h"
#import "NobleBroadcastInfo.h"

@implementation TTMessageView (RoomNoble)

- (void)handleNobleCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model{
    
    
    NIMCustomObject *obj = (NIMCustomObject *)model.message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    @KWeakify(self);
    [model setTextDidClick:^(UserID uid) {
        @KStrongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:needShowUserInfoCardWithUid:)]) {
            [self.delegate messageTableView:self needShowUserInfoCardWithUid:uid];
        }
    }];
    
    newCell.messageLabel.attributedText = model.content;
    newCell.labelContentView.hidden = NO;
    newCell.chatBubleImageView.hidden = YES;
}

@end
