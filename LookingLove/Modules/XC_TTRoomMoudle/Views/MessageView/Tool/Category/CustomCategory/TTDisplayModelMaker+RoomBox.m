//
//  TTDisplayModelMaker+RoomBox.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomBox.h"

@implementation TTDisplayModelMaker (RoomBox)

- (TTMessageDisplayModel *)makeOpenBoxContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
    
    if (attachment.second == Custom_Noti_Sub_Box_InRoom_AllMicSend) {
        //开箱子送全麦
        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
        info.targetUids = attachment.data[@"targetUids"];
        GiftInfo *giftInfo = [GetCore(GiftCore)findGiftInfoByGiftId:info.giftId];
        if (!giftInfo) {
            giftInfo = info.gift;
        }
        if (info.targetUids.count > 0) {
            string = [BaseAttrbutedStringHandler createOpenBoxAllMicroSendAttributedString:info.nick prizeValue:giftInfo.goldPrice prizeUrl:giftInfo.giftUrl prizeNum:info.giftNum];
        }
    }else {
        string = [BaseAttrbutedStringHandler createOpenBoxAttributedString:attachment.data[@"nick"] prizeName:attachment.data[@"prizeName"] prizeNum:attachment.data[@"prizeNum"] boxTypeStr:attachment.data[@"boxTypeStr"]];
        NSString *uidString = attachment.data[@"uid"];
        [string yy_setTextHighlightRange:[string.string rangeOfString:attachment.data[@"nick"]] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (model.textDidClick) {
                model.textDidClick(uidString.userIDValue);
            }
        } longPressAction:nil];
    }
    model.content = string;
    return model;
}

@end
