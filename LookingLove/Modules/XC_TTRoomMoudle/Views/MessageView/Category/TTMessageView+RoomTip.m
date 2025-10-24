//
//  TTMessageView+RoomTip.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomTip.h"
#import "TTMessageViewConst.h"

@implementation TTMessageView (RoomTip)

- (void)handleRoomTipCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model{
    @KWeakify(self);
    [model setTextDidClick:^(UserID uid) {
        @KStrongify(self);
        if ([self.delegate respondsToSelector:@selector(messageTableView:needShowUserInfoCardWithUid:)]) {
            [self.delegate messageTableView:self needShowUserInfoCardWithUid:uid];
        }
    }];
    
    newCell.messageLabel.attributedText = model.content;
    newCell.labelContentView.hidden = NO;
    newCell.chatBubleImageView.hidden = YES;
}

@end
