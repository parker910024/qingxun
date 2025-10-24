//
//  TTDisplayModelMaker+CheckinDrawCoin.m
//  TTPlay
//
//  Created by lvjunhang on 2019/4/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+CheckinDrawCoin.h"
#import "XCCheckinDrawCoinAttachment.h"

@implementation TTDisplayModelMaker (CheckinDrawCoin)

- (TTMessageDisplayModel *)makeCheckinDrawCoinContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    
    if (!model) {
        model = [[TTMessageDisplayModel alloc] init];
        model.message = message;
    }
    
    if ([model.message.messageObject isKindOfClass:NIMCustomObject.class]) {
        
        NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;

        if ([object.attachment isKindOfClass:XCCheckinDrawCoinAttachment.class]) {
            
            XCCheckinDrawCoinAttachment *attachment = (XCCheckinDrawCoinAttachment *)object.attachment;
            
            NSString *coin = [NSString stringWithFormat:@"%@金币", attachment.goldNum];
            NSString *content = [NSString stringWithFormat:@"【签到瓜分百万】哇塞，恭喜%@签到获得%@！", attachment.nick, coin];
            NSRange nickRange = [content rangeOfString:attachment.nick];
            NSRange coinRange = [content rangeOfString:coin];
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
            [attr addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMessageViewTipColor] range:NSMakeRange(0, content.length)];
            [attr addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMessageViewCPNickColor] range:nickRange];
            [attr addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMessageViewCPNickColor] range:coinRange];
            
            model.content = attr.copy;
        }
    }
    
    return model;
}

@end
