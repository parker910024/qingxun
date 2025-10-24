//
//  XCCPGamePrivateSysNotiAttachment.m
//  XCChatCoreKit
//
//  Created by new on 2019/2/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "XCCPGamePrivateSysNotiAttachment.h"
#import "NSObject+YYModel.h"

@implementation XCCPGamePrivateSysNotiAttachment


- (NSString *)cellContent:(NIMMessage *)message {
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    XCCPGamePrivateSysNotiAttachment *attach = (XCCPGamePrivateSysNotiAttachment*)object.attachment;

    if (attach.second == Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_AnchorOrderTips) {
        return @"XCAnchorOrderTipsContentMessageView";
    } else {
        return @"XCCPGamePrivateSysNotiView";
    }
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    XCCPGamePrivateSysNotiAttachment *attach = (XCCPGamePrivateSysNotiAttachment*)object.attachment;

    if (attach.second == Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_AnchorOrderTips) {
        
        NSString *msg = [attach.data objectForKey:@"msg"];
        
        CGFloat viewWidth = width - 26;
        CGFloat labelWidth = viewWidth - 20*2 - 15*2;
        CGFloat labelHeight = [msg boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
        CGFloat viewHeight = labelHeight + 15*2 - 20;
        
        return CGSizeMake(viewWidth, viewHeight);
        
    } else {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 6);
    }
}


@end
