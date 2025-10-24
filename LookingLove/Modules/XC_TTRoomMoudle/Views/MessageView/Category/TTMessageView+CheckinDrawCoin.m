//
//  TTMessageView+CheckinDrawCoin.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageView+CheckinDrawCoin.h"

@implementation TTMessageView (CheckinDrawCoin)

- (void)messageCell:(TTMessageTextCell *)cell handleDrawCoinWithModel:(TTMessageDisplayModel *)model {

    if (![cell isKindOfClass:TTMessageTextCell.class]) {
        return;
    }
    
    cell.labelContentView.hidden = NO;
    cell.chatBubleImageView.hidden = YES;
    
    NSAttributedString *cacheAttributedString = [self.attributedStringContent objectForKey:model.message.messageId];
    if (cacheAttributedString) {
        cell.messageLabel.attributedText = cacheAttributedString;
        return;
    }

    if (model.content) {
        cell.messageLabel.attributedText = model.content;
        return;
    }
}

@end
