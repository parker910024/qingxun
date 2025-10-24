//
//  TTMessageView+RoomBox.m
//  TuTu
//
//  Created by KevinWang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomBox.h"
#import "VersionCore.h"

@implementation TTMessageView (RoomBox)


- (void)handleOpenBox:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model{
    
    newCell.messageLabel.attributedText = model.content;
    newCell.labelContentView.hidden = NO;
    newCell.chatBubleImageView.hidden = YES;
    
    model.textDidClick = ^(UserID uid) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:needShowUserInfoCardWithUid:)]) {
            [self.delegate messageTableView:self needShowUserInfoCardWithUid:uid];
        }
    };
}

@end
