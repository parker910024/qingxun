//
//  MessageBussiness.m
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "MessageBussiness.h"
#import <YYText/YYText.h>
#import "UIColor+UIColor_Hex.h"
#import "FamilyCore.h"
#import "AttributedStringDataModel.h"

@implementation MessageBussiness

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"params" : MessageParams.class,
             };
}

- (NSString *)cellContent:(NIMMessage *)message{
    return @"MessageCommonView";
}


- (void)setStatus:(Message_Bussiness_Status)status {
    if (status == 5) {
        _status = Message_Bussiness_Status_Agree;
    }else if (status == 6) {
        _status = Message_Bussiness_Status_Agree;
    }else if (status == 7) {
        _status = Message_Bussiness_Status_Refused;
    }else {
        _status = status;
    }
}


- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    MessageBussiness *customObject = (MessageBussiness*)object.attachment;
    CGFloat controlPanelHeight = 0;
    if (customObject.status> 0 || customObject.second == Custom_Noti_Sub_Header_Message_Handle_Bussiness || customObject.second == Custom_Noti_Sub_OfficialAnchorCertification_Bussiness) {
        controlPanelHeight = 40;
    }
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 130, CGFLOAT_MAX) text:[self creatMessageContentAttributeWithMessageBusiness:customObject messageId:message.messageId]];
    CGFloat contenHeight = layout.textBoundingSize.height;
    CGFloat headerHeight = 25;
    CGFloat totalHeight = controlPanelHeight + contenHeight + headerHeight;

    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 120, totalHeight + 15);
}

- (NSMutableAttributedString *)creatMessageContentAttributeWithMessageBusiness:(MessageBussiness *)messageBussiness messageId:(NSString *)messageId{
    if ((AttributedStringDataModel *)[GetCore(FamilyCore)queryAttrByMessageId:messageId]) {
        AttributedStringDataModel *data = (AttributedStringDataModel *)[GetCore(FamilyCore)queryAttrByMessageId:messageId];
        return data.attributedString;
    }else {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
        MessageLayout *layout = messageBussiness.layout;
        for (LayoutParams *params in layout.contents) {
            NSMutableAttributedString *subAttr = [[NSMutableAttributedString alloc]initWithString:params.content];
            if (params.fontSize.length > 0) {
                [subAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[params.fontSize floatValue]] range:NSMakeRange(0, subAttr.length)];
            }
            
            if (params.fontColor.length > 0) {
                [subAttr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:params.fontColor] range:NSMakeRange(0, subAttr.length)];
            }
            
            [attr appendAttributedString:subAttr];
        }
        attr.yy_lineSpacing = 5;
        [GetCore(FamilyCore)saveAttributedString:attr WithMessageId:messageId isComplete:NO];
        return attr;

    }

}



@end
