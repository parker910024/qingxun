//
//  XCCommunityShareAttachment.m
//  AFNetworking
//
//  Created by zoey on 2019/3/4.
//

#import "XCCommunityShareAttachment.h"
#import "P2PInteractiveAttachment.h"

@implementation XCCommunityShareAttachment



- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCCommunityShareMessageContentView";
}




- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    Attachment *att = (Attachment *)object.attachment;
    P2PInteractiveAttachment *customObject = [P2PInteractiveAttachment yy_modelWithJSON:att.data];
    
    customObject.msg = @"XCUserUpgradeAttachmentw我的这个是风向的 撒打算阿萨擦萨法法XCUserUpgradeAttachmentw我的这个是风向的 撒打算阿萨擦萨法法XCUserUpgradeAttachmentw我的这个是风向的 撒打算阿萨擦萨法法";
    
    CGFloat maxwidth = [UIScreen mainScreen].bounds.size.width-55-15;
    //    CGFloat messageWidth =  [UIScreen mainScreen].bounds.size.width - 86 - 109;
    CGFloat messageWidth =  maxwidth - 76 - 18;
    
    CGSize size = [customObject.msg boundingRectWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    return CGSizeMake(maxwidth,size.height);
    
}

@end
