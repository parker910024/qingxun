//
//  TTMessageView+TextMessage.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+TextMessage.h"
#import "TTMessageViewConst.h"

#import <YYText/YYText.h>

@implementation TTMessageView (TextMessage)

- (void)handleTextCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model textMessageBlock:(void (^)(UserID uid))textMessageBlock {
    
    SingleNobleInfo *nobleInfo = [TTMessageHelper handleRoomExtToModel:model.message.remoteExt uid:model.message.from];
    
    newCell.messageLabel.attributedText = model.content;
    
    [model setTextDidClick:^(UserID uid) {
        if (textMessageBlock) {
            textMessageBlock(uid);
        }
    }];
    
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
