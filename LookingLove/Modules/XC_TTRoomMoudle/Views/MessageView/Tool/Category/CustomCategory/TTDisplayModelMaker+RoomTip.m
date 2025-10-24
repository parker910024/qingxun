//
//  TTDisplayModelMaker+RoomTip.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomTip.h"

@implementation TTDisplayModelMaker (RoomTip)

- (TTMessageDisplayModel *)makeRoomTipsContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    
    NSDictionary *data = attachment.data[@"data"];
    NSString *nick = [NSString stringWithFormat:@"%@",data[@"nick"]];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    NSDictionary * tipDic = (NSDictionary *)attachment.data;
    if (tipDic && tipDic.allKeys.count >0) {
        UserInfo * userInfo= [GetCore(UserCore) getUserInfoInDB:((NSString *)attachment.data[@"uid"]).userIDValue];
        //offical
        if (userInfo.defUser == AccountType_Official) {
            NSMutableAttributedString * officalImageString = [BaseAttrbutedStringHandler makeOfficalImage:userInfo];
            [str appendAttributedString:officalImageString];
            [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
        }else{
            if (userInfo.newUser) {
                [str appendAttributedString:[BaseAttrbutedStringHandler makeNewUserImage:userInfo.newUserIcon]];
                [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
            }
        }
    }
    
    NSMutableAttributedString *nickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:nickAttr];
    
    NSString *tipString = @"";
    if (attachment.second == Custom_Noti_Header_Room_Tip_ShareRoom) {
        
        //分享房间
        tipString = @"分享了房间";
    }else if (attachment.second == Custom_Noti_Header_Room_Tip_Attentent_Owner) {
        
        //关注了房主
        tipString = @"关注了房主";
    }
    NSMutableAttributedString *shareAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:tipString attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:shareAttr];
    [str yy_setTextHighlightRange:NSMakeRange(0, str.length) color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (model.textDidClick) {
            model.textDidClick(message.from.userIDValue);
        }
    } longPressAction:nil];
    
    model.content = str;
    
    return model;
}

@end
