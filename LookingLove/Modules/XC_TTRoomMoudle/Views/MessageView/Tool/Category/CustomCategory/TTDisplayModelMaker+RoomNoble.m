//
//  TTDisplayModelMaker+RoomNoble.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomNoble.h"

@implementation TTDisplayModelMaker (RoomNoble)

- (TTMessageDisplayModel *)makeNobleContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    NobleBroadcastInfo *nobleInfo = [NobleBroadcastInfo modelWithJSON:attachment.data];
    NSString *typeStr = nil;
    if (nobleInfo.type == NobleBroadcastType_Open) {
        typeStr = @"开通";
    }else if(nobleInfo.type == NobleBroadcastType_Renew) {
        typeStr = @"续费";
    }
    NSMutableAttributedString *nobleAttributed = [BaseAttrbutedStringHandler creatSysNobleNotify:nobleInfo.nick andSingleNobleInfo:nobleInfo.nobleInfo typeStr:typeStr];
    [nobleAttributed yy_setTextHighlightRange:[[nobleAttributed string] rangeOfString:nobleInfo.nick] color:nil backgroundColor:nil userInfo:nil tapAction:nil longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (model) {
            model.textDidClick(nobleInfo.uid);
        }
    }];
    model.content = nobleAttributed;
    return model;
}

@end
