//
//  XCGameVoiceBottleAttachment.m
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/6/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCGameVoiceBottleAttachment.h"

@implementation XCGameVoiceBottleAttachment


- (NSString *)cellContent:(NIMMessage *)message{
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    Attachment *customObject = (Attachment*)object.attachment;
    if(customObject.second == Custom_Noti_Sub_Voice_Bottle_Hello) {
        return @"XCGameVoiceGreetMessageContentView";
    }else if (customObject.second == Custom_Noti_Sub_Voice_Bottle_Heart) {
        return @"XCGmaeVoiceReceiveGreetContentView";
    }
    return @"XCGameVoiceMessageContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    Attachment*customObject = (Attachment*)object.attachment;
   if (customObject.second == Custom_Noti_Sub_Voice_Bottle_Hello){
       return CGSizeMake([UIScreen mainScreen].bounds.size.width, 70);
   }else if(customObject.second == Custom_Noti_Sub_Voice_Bottle_Recording || customObject.second == Custom_Noti_Sub_Voice_Bottle_Matching) {
       return CGSizeMake(245, 188);
   }else if (customObject.second == Custom_Noti_Sub_Voice_Bottle_Heart) {
       XCGameVoiceBottleAttachment * voiceAttach = [XCGameVoiceBottleAttachment yy_modelWithJSON:customObject.data];
       CGFloat width = [self getMessageWidthWith:voiceAttach.message];
       if (width <= 3) {
           width = 150;
       }
       return CGSizeMake(width, 21);
   }
    return CGSizeZero;
}

- (CGFloat)getMessageWidthWith:(NSString *)message {
   return  [message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 150, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width + 3;
}



@end
