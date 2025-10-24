//
//  TTMessageView+LittleWorld.m
//  XC_TTRoomMoudle
//
//  Created by apple on 2019/7/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageView+LittleWorld.h"

@implementation TTMessageView (LittleWorld)

- (void)handleLittleWorld:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model {
    
    model.textDidClick = ^(UserID uid) {
        if (uid == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:littleWorldWithModel:)]) {
                [self.delegate messageTableView:self littleWorldWithModel:model];
            }
        } else if (uid == 1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:littleWorldPraiseWithModel:)]) {
                [self.delegate messageTableView:self littleWorldPraiseWithModel:model];
            }
        }
    };
    
    cell.messageLabel.attributedText = model.content;
    cell.labelContentView.hidden = NO;
    cell.chatBubleImageView.hidden = YES;
}

@end
