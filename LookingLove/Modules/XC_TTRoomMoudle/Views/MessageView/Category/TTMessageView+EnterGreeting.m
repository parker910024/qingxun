//
//  TTMessageView+EnterGreeting.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/3/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMessageView+EnterGreeting.h"

@implementation TTMessageView (EnterGreeting)
- (void)handleEnterGreetingCell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model {
    
    @KWeakify(self);
    [model setTextDidClick:^(UserID uid) {
        @KStrongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:needShowUserInfoCardWithUid:)]) {
            [self.delegate messageTableView:self needShowUserInfoCardWithUid:uid];
        }
    }];
    
    cell.messageLabel.attributedText = model.content;
    cell.labelContentView.hidden = NO;
    cell.chatBubleImageView.hidden = NO;
}
@end
