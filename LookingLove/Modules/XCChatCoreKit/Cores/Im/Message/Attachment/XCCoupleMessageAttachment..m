//
//  XCCustomAttachmentInfo.h
//  AFNetworking
//
//  Created by apple on 2018/12/6.
//

#import "XCCoupleMessageAttachment.h"

@implementation XCCoupleMessageAttachment

- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCCoupleMessageView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    
    return CGSizeMake(220, 103);
}

@end
