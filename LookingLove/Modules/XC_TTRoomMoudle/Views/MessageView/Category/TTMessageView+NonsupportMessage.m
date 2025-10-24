//
//  TTMessageView+NonsupportMessage.m
//  TTPlay
//
//  Created by Macx on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageView+NonsupportMessage.h"

@implementation TTMessageView (NonsupportMessage)
- (void)handleNonsupportMessageCell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model {
    cell.messageLabel.attributedText = model.content;
    cell.labelContentView.hidden = NO;
    cell.chatBubleImageView.hidden = YES;
}
@end
