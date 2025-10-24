//
//  TTDisplayModelMaker+TextMessage.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+TextMessage.h"

#import "SingleNobleInfo.h"


@implementation TTDisplayModelMaker (TextMessage)

- (TTMessageDisplayModel *)makeTextContentWithMessage:(NIMMessage *)message withModel:(nonnull TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    SingleNobleInfo *nobleInfo = [TTMessageHelper handleRoomExtToModel:message.remoteExt uid:message.from];
    LevelInfo *levelInfo = [TTMessageHelper handleRoomExtToLevelModel:message.remoteExt uid:message.from];
    NSString *userId = [GetCore(AuthCore) getUid];
    NSString *nick = @"";
    if ([message.from isEqualToString:userId]) {
        nick = @"我";
    } else {
        nick = ((NIMMessageChatroomExtension *)message.messageExt).roomNickname;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.nick = nick;
    userInfo.uid = message.from.userIDValue;
    userInfo.nobleUsers = nobleInfo;
    userInfo.userLevelVo = levelInfo;
    userInfo.defUser = levelInfo.defUser;
    userInfo.newUser = [TTMessageHelper handelNewUserToLevelModel:message.remoteExt uid:message.from];
    userInfo.nameplate = [TTMessageHelper handleOfficialAnchorCertification:message.remoteExt uid:message.from];
    
    NSMutableAttributedString *nickAndBadge = [BaseAttrbutedStringHandler creatOffical_nobleBadge_userLevel_nickAttributedByUserInfo:userInfo];    
    [str appendAttributedString:nickAndBadge];
    
    NSMutableAttributedString *symbol = [[NSMutableAttributedString alloc]initWithString:@":"];
    [str appendAttributedString:symbol];
    
    NSMutableAttributedString *msgStr;
    if (message.text) {
        msgStr = [[NSMutableAttributedString alloc]initWithString:message.text];
        [str appendAttributedString:msgStr];
    }
    [str addAttribute:NSForegroundColorAttributeName
                value:[XCTheme getTTMessageViewNickColor]
                range:NSMakeRange(0,nickAndBadge.length + symbol.length)];
    [str addAttribute:NSForegroundColorAttributeName
                value:[XCTheme getTTMessageViewTextColor]
                range:NSMakeRange(nickAndBadge.length + symbol.length,msgStr.length)];
    
    [str addAttribute:NSFontAttributeName
                value:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]
                range:NSMakeRange(0,str.length)];
    
    [str yy_setTextHighlightRange:NSMakeRange(0, str.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (model.textDidClick) {
            model.textDidClick(userInfo.uid);
        }
    }];
    
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    
    model.contentHeight = [[TTMessageViewLayout shareLayout]getAttributedHeightWith:str];
    model.content = str;
    
    return model;
}

@end
