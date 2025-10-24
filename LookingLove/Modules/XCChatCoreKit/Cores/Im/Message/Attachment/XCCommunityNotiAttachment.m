//
//  XCCommunityNotiAttachment.m
//  AFNetworking
//
//  Created by zoey on 2019/3/4.
//

#import "XCCommunityNotiAttachment.h"

#import "P2PInteractiveAttachment.h"

@implementation XCCommunityNotiAttachment


- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCCommunityNotiMessageView";
}




- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    Attachment *att = (Attachment *)object.attachment;
    XCCommunityNotiAttachment *customObject = [XCCommunityNotiAttachment yy_modelWithJSON:att.data];
    
    CGFloat maxwidth = [UIScreen mainScreen].bounds.size.width-55-15;
//    CGFloat messageWidth =  [UIScreen mainScreen].bounds.size.width - 86 - 109;
        CGFloat messageWidth =  maxwidth - 76 - 18;
    
    CGSize size = [customObject.msg boundingRectWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if(size.height > 80) {
        return CGSizeMake(maxwidth,size.height+19+9);
    }else {
        return CGSizeMake(maxwidth,80);
    }
    
    
}


@end
