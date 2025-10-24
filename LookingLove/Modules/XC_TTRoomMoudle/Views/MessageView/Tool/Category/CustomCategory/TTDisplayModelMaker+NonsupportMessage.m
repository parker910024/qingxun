//
//  TTDisplayModelMaker+NonsupportMessage.m
//  TTPlay
//
//  Created by Macx on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+NonsupportMessage.h"

@implementation TTDisplayModelMaker (NonsupportMessage)
- (TTMessageDisplayModel *)makeRoomNonsupportMessageContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    model.content = [BaseAttrbutedStringHandler creatStrAttrByStr:@"该版本不支持本消息, 请升级至最新版本" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
    NIMCustomObject *obj = (NIMCustomObject *)model.message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    attachment.first = Custom_Noti_Header_Nonsupport_Message;
    return model;
}
@end
