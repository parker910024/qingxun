//
//  TTMessageView+RoomKick.m
//  TuTu
//
//  Created by KevinWang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomKick.h"

@implementation TTMessageView (RoomKick)

- (void)handleKickCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model{
    
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
