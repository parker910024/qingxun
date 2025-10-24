//
//  TTDisplayModelMaker+RoomGift.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomGift.h"

@implementation TTDisplayModelMaker (RoomGift)

- (TTMessageDisplayModel *)makeGiftConentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    
    if (attachment.second == Custom_Noti_Sub_Gift_LuckySend){
        
        [self luckyGiftAttributedStr:str attachment:attachment];
        
    }else {
        
        [self normalGiftAttributedStr:str attachment:attachment];
    }
//    GiftReceiveInfo *info = [GiftReceiveInfo modelDictionary:attachment.data];
//    [str yy_setTextHighlightRange:[[str string] rangeOfString:info.nick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        if (model.textDidClick) {
//            model.textDidClick(info.uid);
//        }
//    } longPressAction:nil];
//
//    [str yy_setTextHighlightRange:[[str string] rangeOfString:info.targetNick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        if (model.textDidClick) {
//            model.textDidClick(info.targetUid);
//        }
//    } longPressAction:nil];
    model.content = str;
    
    return model;
}

#pragma mark - private method
//处理普通礼物消息
- (void)normalGiftAttributedStr:(NSMutableAttributedString *)str attachment:(Attachment *)attachment {
    GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelDictionary:attachment.data];
    GiftInfo *giftInfo = [GetCore(GiftCore) findGiftInfoByGiftId:info.giftId];
    if (!giftInfo) {
        giftInfo = info.gift;
    }
    
    if (info.giftInfo.consumeType == GiftConsumeTypeBox) {
        [self boxGiftAttributedStringWithAttachment:attachment str:str];
        return;
    }
    
    UserInfo * senderInfo = [GetCore(UserCore) getUserInfoInDB:info.uid];
    if (senderInfo) {
        //offical
        if (senderInfo.defUser == AccountType_Official) {
            NSMutableAttributedString * officalImageString = [BaseAttrbutedStringHandler makeOfficalImage:senderInfo];
            [str appendAttributedString:officalImageString];
            [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
        }else{
            if (senderInfo.newUser) {
                [str appendAttributedString:[BaseAttrbutedStringHandler makeNewUserImage:senderInfo.newUserIcon]];
                [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
            }
        }
    }
    
    
    NSMutableAttributedString *senderNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:info.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:senderNickAttr];
    
    //send
    NSMutableAttributedString *sendAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 打赏 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:sendAttr];
    
    
    UserInfo * targetInfo = [GetCore(UserCore) getUserInfoInDB:info.targetUid];
    if (targetInfo) {
        //offical
        if (targetInfo.defUser == AccountType_Official) {
            NSMutableAttributedString * officalImageString = [BaseAttrbutedStringHandler makeOfficalImage:targetInfo];
            [str appendAttributedString:officalImageString];
            [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
        }else{
            if (targetInfo.newUser) {
                [str appendAttributedString:[BaseAttrbutedStringHandler makeNewUserImage:targetInfo.newUserIcon]];
                [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
            }
        }
    }
    //target
    NSMutableAttributedString *targetNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:info.targetNick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:targetNickAttr];
    
    //gift
    //img
    CALayer *imageView = [[CALayer alloc]init];
    imageView.contentsScale = [UIScreen mainScreen].scale;
    imageView.bounds = CGRectMake(0, -10, 40, 40);
    [imageView qn_setImageImageWithUrl:giftInfo.giftUrl placeholderImage:nil type:(ImageType)ImageTypeRoomGift];
    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
    [str appendAttributedString:imageString];
    
    //x N
    NSMutableAttributedString *giftNumAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@" X%ld",info.giftNum] attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor]  size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:giftNumAttr];
}

// MARK: - 盲盒gift
- (void)boxGiftAttributedStringWithAttachment:(Attachment *)attachment str:(NSMutableAttributedString *)str {
    
    GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelDictionary:attachment.data];
    UserInfo *senderInfo = [GetCore(UserCore) getUserInfoInDB:info.uid];
    GiftInfo *giftInfo = [GetCore(GiftCore) findGiftInfoByGiftId:info.giftId];
    UserInfo *targetInfo = [info.targetUsers firstObject];
    
    NSInteger receiveGiftId = targetInfo ? targetInfo.receiveGiftId : info.receiveGiftId;
    NSString *targetNick = targetInfo ? targetInfo.nick : info.targetNick;
    UserID targetUid = targetInfo ? targetInfo.uid : info.targetUid;
    
    GiftInfo *receiveGift = [GetCore(GiftCore) findPrizeGiftByGiftId:receiveGiftId];

    if (!giftInfo) {
        id giftData = attachment.data[@"giftInfo"] ? attachment.data[@"giftInfo"] : attachment.data[@"gift"];
        giftInfo = [GiftInfo modelDictionary:giftData];
    }

    //nick
    NSAttributedString *nickAttr = [self nickAttributedStringWithNick:info.nick userInfo:senderInfo];
    if (nickAttr) {
        [str appendAttributedString:nickAttr];
    }

    //send
    NSString *sendStr = @" 送出了 ";
    NSMutableAttributedString *sendAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:sendStr attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:sendAttr];

    // 盲盒 gift
    NSAttributedString *giftString = [self giftAttributedStringWithGiftImage:giftInfo.giftUrl];
    [str appendAttributedString:giftString];
    // 给
    NSString *giveStr = @" 给 ";
    NSMutableAttributedString *giveAtt = [BaseAttrbutedStringHandler creatStrAttrByStr:giveStr attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:giveAtt];

    //target user
    if (targetNick) {
        NSMutableAttributedString *nickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:targetNick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:nickAttr];
    }

    // 开出了
    NSString *openStr = [NSString stringWithFormat:@"，开出了%@ ", receiveGift.giftName];
    NSMutableAttributedString *openAtt = [BaseAttrbutedStringHandler creatStrAttrByStr:openStr attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:openAtt];

    // 盲盒礼物 receiveGift
    NSAttributedString *boxString = [self giftAttributedStringWithGiftImage:receiveGift.giftUrl];
    [str appendAttributedString:boxString];

    // 价值xxx金币
    NSString *pieceStr = [NSString stringWithFormat:@"价值%@金币", @(receiveGift.goldPrice).stringValue];
    NSMutableAttributedString *pieceAtt = [BaseAttrbutedStringHandler creatStrAttrByStr:pieceStr attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:pieceAtt];
}

//处理福袋信息
- (void)luckyGiftAttributedStr:(NSMutableAttributedString *)str attachment:(Attachment *)attachment{
    if (attachment.first == Custom_Noti_Header_Gift && attachment.second == Custom_Noti_Sub_Gift_LuckySend) {
        NSAttributedString * attributed =  [self dealLuckyGiftWithAttachment:attachment];
        [str appendAttributedString:attributed];
    }
    //    }
}

//个人福袋
- (NSAttributedString *)dealLuckyGiftWithAttachment:(Attachment *)attachment{
    
    GiftReceiveInfo *info = [GiftReceiveInfo modelDictionary:attachment.data];
    GiftInfo *giftInfo = [GetCore(GiftCore) findGiftInfoByGiftId:info.giftId];
    
    if (!giftInfo) {
        giftInfo = info.gift;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    //nick
    NSMutableAttributedString *senderNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:info.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:senderNickAttr];
    
    //action
    NSMutableAttributedString *sendAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 赠送 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
    NSMutableAttributedString *countAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 一个福袋 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    NSMutableAttributedString *giveAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 给 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:sendAttr];
    [str appendAttributedString:countAttr];
    [str appendAttributedString:giveAttr];
    
    //target
    NSMutableAttributedString *targetNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:info.targetNick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:targetNickAttr];
    
    //lucky
    NSMutableAttributedString *luckyAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@"爆出了价值 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:luckyAttr];
    
    //price
    NSMutableAttributedString *giftValueAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@" %ld萌币 ",(NSInteger)info.gift.goldPrice] attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    NSMutableAttributedString *giftTextAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@"的礼物 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:giftValueAttr];
    [str appendAttributedString:giftTextAttr];
    
    //gift
    CALayer *imageView = [[CALayer alloc]init];
    imageView.bounds = CGRectMake(0, -10, 40, 37);

    [imageView qn_setImageImageWithUrl:giftInfo.gifUrl placeholderImage:nil type:ImageTypeRoomGift];

    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] alignment:YYTextVerticalAlignmentCenter];
    [str appendAttributedString:imageString];
    return [str copy];
}

/// 用户名称富文本，官新+用户名
- (NSAttributedString *)nickAttributedStringWithNick:(NSString *)nick userInfo:(UserInfo *)userInfo {
    if (nick == nil) {
        return nil;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];

    //官新
    NSAttributedString *statusString = [self statusAttributedStringWithUserInfo:userInfo];
    if (statusString) {
        [str appendAttributedString:statusString];
    }
    
    //nick
    NSMutableAttributedString *nickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
    [str appendAttributedString:nickAttr];
    
    return [str copy];
}

- (NSAttributedString *)giftAttributedStringWithGiftImage:(NSString *)giftImage {

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];

    //gift image
    CALayer *imageView = [[CALayer alloc]init];
    imageView.contentsScale = [UIScreen mainScreen].scale;
    imageView.bounds = CGRectMake(0, -10, 40, 40);
    [imageView qn_setImageImageWithUrl:giftImage placeholderImage:nil type:(ImageType)ImageTypeRoomGift];
    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
    [str appendAttributedString:imageString];
    
    return [str copy];
}

/// 身份状态富文本：官、新等
- (NSAttributedString *)statusAttributedStringWithUserInfo:(UserInfo *)userInfo {
    if (userInfo == nil) {
        return nil;
    }
    
    //offical
    if (userInfo.defUser == AccountType_Official) {
        NSMutableAttributedString *officialString = [[BaseAttrbutedStringHandler makeOfficalImage:userInfo] mutableCopy];
        [officialString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
        return [officialString copy];
        
    } else if (userInfo.newUser) {
        NSMutableAttributedString *newerString = [[BaseAttrbutedStringHandler makeCharmImage:userInfo.newUserIcon size:CGSizeMake(16, 16)] mutableCopy];
        [newerString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
        return [newerString copy];
    }
    
    return nil;
}
@end
