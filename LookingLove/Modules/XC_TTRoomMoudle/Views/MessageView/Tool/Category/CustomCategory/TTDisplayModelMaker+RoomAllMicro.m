//
//  TTDisplayModelMaker+RoomAllMicro.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomAllMicro.h"

#import "TTMessageViewConst.h"

#import "VersionCore.h"

@implementation TTDisplayModelMaker (RoomAllMicro)

- (TTMessageDisplayModel *)makeRoomAllMicContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
    
    if (attachment.second == Custom_Noti_Sub_AllMicroSend || attachment.second == Custom_Noti_Sub_AllBatchSend) {
        [self allMicroNormalGiftAttributedStr:string attachment:attachment model:model];
    }else if (attachment.second == Custom_Noti_Sub_AllMicroLuckySend) {
        [self allMicroLuckyGiftAttributedStr:string attachment:attachment];
    }
    model.content = string;
    return model;
}

#pragma mark - private method

//处理普通礼物消息

- (void)allMicroNormalGiftAttributedStr:(NSMutableAttributedString *)str attachment:(Attachment *)attachment model:(TTMessageDisplayModel *)model {
    GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelDictionary:attachment.data];
    
    if (info.gift.consumeType == GiftConsumeTypeBox) {
        [self boxGiftAttributedStringWithAttachment:attachment str:str];
        return;
    }
    
    if (attachment.second == Custom_Noti_Sub_AllBatchSend) {
        // 将targetUsers中的uid抽出填充targetUids, 后面很多计算需要用到
        NSMutableArray *uids = [NSMutableArray array];
        for (UserInfo *user in info.targetUsers) {
            [uids addObject:@(user.uid)];
        }
        info.targetUids = uids;
        info.isBatch = YES;
    }
    
    GiftInfo *giftInfo = [GetCore(GiftCore)findGiftInfoByGiftId:info.giftId];
    if (!giftInfo) {
        giftInfo = attachment.data[@"giftInfo"]?[GiftInfo modelDictionary:attachment.data[@"giftInfo"]]:[GiftInfo modelDictionary:attachment.data[@"gift"]];
    }
    
    if (info.isBatch) {
        UserInfo *sendInfo = [GetCore(UserCore) getUserInfoInDB:info.uid];
        if (sendInfo) {
            //offical
            if (sendInfo.defUser == AccountType_Official) {
                NSMutableAttributedString * officalImageString = [BaseAttrbutedStringHandler makeOfficalImage:sendInfo];
                [str appendAttributedString:officalImageString];
                [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
            }else{
                if (sendInfo.newUser) {
                    [str appendAttributedString:[BaseAttrbutedStringHandler makeNewUserImage:sendInfo.newUserIcon]];
                    [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
                }
            }
        }
        
        NSInteger loc = str.length;
        //nick
        NSMutableAttributedString *nickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:info.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:nickAttr];
        NSInteger len = nickAttr.length;
        @KWeakify(self);
        [str yy_setTextHighlightRange:NSMakeRange(loc, len) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @KStrongify(self);
            if (model.textDidClick) {
                model.textDidClick(info.uid);
            }
        }];
        
        //send
        NSMutableAttributedString *sendAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 打赏 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:sendAttr];
        
        BOOL isFirst = YES; // 是否是第一个收礼人, 判断加"、"
        for (int i = 0; i < info.targetUids.count; i++) {
            NSString *user = [info.targetUids safeObjectAtIndex:i];
            UserInfo *targetInfo = [info.targetUsers safeObjectAtIndex:i];
            if (!targetInfo) {
                targetInfo = [GetCore(UserCore) getUserInfoInDB:[user userIDValue]];
            }
            
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
            
            if (isFirst) {
                isFirst = NO;
            } else {
                NSMutableAttributedString *sAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@"、" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
                [str appendAttributedString:sAttr];
            }
            
            //target
            NSInteger loc = str.length;
            //nick
            NSMutableAttributedString *targetNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:targetInfo.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
            [str appendAttributedString:targetNickAttr];
            NSInteger len = targetNickAttr.length;
            @KWeakify(self);
            [str yy_setTextHighlightRange:NSMakeRange(loc, len) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @KStrongify(self);
                if (model.textDidClick) {
                    model.textDidClick(info.uid);
                }
            }];
        }
        
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
    } else {
        UserInfo *sendInfo = [GetCore(UserCore) getUserInfoInDB:info.uid];
        if (sendInfo) {
            //offical
            if (sendInfo.defUser == AccountType_Official) {
                NSMutableAttributedString * officalImageString = [BaseAttrbutedStringHandler makeOfficalImage:sendInfo];
                [str appendAttributedString:officalImageString];
                [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
            }else{
                if (sendInfo.newUser) {
                    [str appendAttributedString:[BaseAttrbutedStringHandler makeNewUserImage:sendInfo.newUserIcon]];
                    [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
                }
            }
        }
        //nick
        NSMutableAttributedString *nickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:info.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:nickAttr];
        
        //send
        NSMutableAttributedString *sendAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 全麦打赏 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:sendAttr];
        
        //img
        CALayer *imageView = [[CALayer alloc]init];
        imageView.contentsScale = [UIScreen mainScreen].scale;
        imageView.bounds = CGRectMake(0, -10, 40, 40);
        [imageView qn_setImageImageWithUrl:giftInfo.giftUrl placeholderImage:nil type:(ImageType)ImageTypeRoomGift];
        NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] alignment:YYTextVerticalAlignmentCenter];
        [str appendAttributedString:imageString];
        
        //x N
        NSMutableAttributedString *giftNumAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@" X%ld",info.giftNum] attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor]  size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:giftNumAttr];
        
        @KWeakify(self);
        [str yy_setTextHighlightRange:[[str string] rangeOfString:info.nick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @KStrongify(self);
            if (model.textDidClick) {
                model.textDidClick(info.uid);
            }
        } longPressAction:nil];
    }
}

// MARK: - 盲盒gift
- (void)boxGiftAttributedStringWithAttachment:(Attachment *)attachment str:(NSMutableAttributedString *)str {
    GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelDictionary:attachment.data];
    UserInfo *senderInfo = [GetCore(UserCore) getUserInfoInDB:info.uid];
    GiftInfo *giftInfo = [GetCore(GiftCore) findGiftInfoByGiftId:info.giftId];
    UserInfo *targetInfo = [info.targetUsers firstObject];
    GiftInfo *receiveGift = [GetCore(GiftCore) findPrizeGiftByGiftId:info.receiveGiftId];

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

    //target user(s)
    NSAttributedString *targetAttr = [self nickAttributedStringWithNick:targetInfo.nick userInfo:targetInfo];
    if (targetAttr) {
        [str appendAttributedString:targetAttr];
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
- (void)allMicroLuckyGiftAttributedStr:(NSMutableAttributedString *)str attachment:(Attachment *)attachment{
    if(attachment.first == Custom_Noti_Header_ALLMicroSend && attachment.second == Custom_Noti_Sub_AllMicroLuckySend) {
        
        //送房间全麦 福袋
        NSArray *infoArray = [GiftAllMicroSendInfo modelsWithArray:attachment.data[luckyAllMicroKey]];
        
        NSAttributedString * attributed =  [self dealAllMicroLuckySendWithData:infoArray];
        [str appendAttributedString:attributed];
        
    }
    //    }
}

//全麦 福袋
- (NSAttributedString *)dealAllMicroLuckySendWithData:(NSArray<GiftAllMicroSendInfo *> *)infos {
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
    if (infos.count<=0) {
        return attribute;
    }
    
    GiftAllMicroSendInfo *info = infos.firstObject;
    //nick
    NSMutableAttributedString *senderNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:info.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    [attribute appendAttributedString:senderNickAttr];
    
    
    //action
    NSMutableAttributedString *sendAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 全麦赠送 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTRedColor] size:TTMessageViewDefaultFontSize]];
    NSMutableAttributedString *countAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 一个福袋 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
    NSMutableAttributedString *giveAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 爆出了 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
    [attribute appendAttributedString:sendAttr];
    [attribute appendAttributedString:countAttr];
    [attribute appendAttributedString:giveAttr];
    
    
    //target
    for (GiftAllMicroSendInfo *info in infos) {
        GiftInfo *giftInfo = info.gift;
        if (!giftInfo) {
            giftInfo = info.giftInfo;
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        //value
        NSAttributedString *valueTitle = [BaseAttrbutedStringHandler creatStrAttrByStr:@"价值" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
        
        NSMutableAttributedString *valueAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@" %ld萌币 ",(NSInteger)giftInfo.goldPrice] attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
        
        NSAttributedString *giftTitle = [BaseAttrbutedStringHandler creatStrAttrByStr:@"的礼物" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
        
        [str appendAttributedString:valueTitle];
        [str appendAttributedString:valueAttr];
        [str appendAttributedString:giftTitle];
        
        //gift
        CALayer *imageView = [[CALayer alloc]init];
        imageView.contentsScale = [UIScreen mainScreen].scale;
        imageView.bounds = CGRectMake(0, -10, 40, 37);
        [imageView qn_setImageImageWithUrl:giftInfo.giftUrl placeholderImage:nil type:(ImageType)ImageTypeRoomGift];
        NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] alignment:YYTextVerticalAlignmentCenter];
        [str appendAttributedString:imageString];
        
        //give
        NSAttributedString *give = [BaseAttrbutedStringHandler creatStrAttrByStr:@"给" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:give];
        
        //target
        NSMutableAttributedString *targetNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:info.targetNick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:targetNickAttr];
        
        //space
        NSAttributedString *fraction = [BaseAttrbutedStringHandler creatStrAttrByStr:@";  " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:fraction];
        
        [attribute appendAttributedString:str];
    }
    return attribute;
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
