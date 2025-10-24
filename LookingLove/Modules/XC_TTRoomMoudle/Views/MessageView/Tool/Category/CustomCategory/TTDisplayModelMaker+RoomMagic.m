//
//  TTDisplayModelMaker+RoomMagic.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomMagic.h"

@implementation TTDisplayModelMaker (RoomMagic)


- (TTMessageDisplayModel *)makeRoomMagicContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    
    RoomMagicInfo *receiveInfo = [RoomMagicInfo modelDictionary:attachment.data];
    RoomMagicInfo *magicInfo = [GetCore(RoomMagicCore) findLocalMagicListsByMagicId:receiveInfo.giftMagicId];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    
    
    if (attachment.second == Custom_Noti_Sub_Magic_Send) {
        UserInfo *sendInfo = [GetCore(UserCore) getUserInfoInDB:receiveInfo.uid];
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
        NSMutableAttributedString *senderNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:receiveInfo.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:senderNickAttr];
        
        //send
        NSMutableAttributedString *sendAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 给 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:sendAttr];
        
        UserInfo *targetInfo = [GetCore(UserCore) getUserInfoInDB:receiveInfo.targetUid];
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
        NSMutableAttributedString *targetNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:receiveInfo.targetNick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:targetNickAttr];
        
        
        //action
        NSMutableAttributedString *actionAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 施魔法 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
        [str appendAttributedString:actionAttr];
        
        //magic
        CALayer *imageView = [[CALayer alloc]init];
        imageView.contentsScale = [UIScreen mainScreen].scale;
        imageView.bounds = CGRectMake(0, -10, 40, 37);
        [imageView qn_setImageImageWithUrl:magicInfo.magicIcon placeholderImage:nil type:ImageTypeRoomMagic];
        NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] alignment:YYTextVerticalAlignmentCenter];
        [str appendAttributedString:imageString];
        
        //是否触发暴击
        if (receiveInfo.playEffect) {
            NSMutableAttributedString *effectAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 并触发暴击 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
            [str appendAttributedString:effectAttr];
        }
        @KWeakify(self);
        [str yy_setTextHighlightRange:[[str string] rangeOfString:receiveInfo.nick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @KStrongify(self);
            if (model.textDidClick) {
                model.textDidClick(receiveInfo.uid);
            }
        } longPressAction:nil];
        
        [str yy_setTextHighlightRange:[[str string] rangeOfString:receiveInfo.targetNick] color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @KStrongify(self);
            if (model.textDidClick) {
                model.textDidClick(receiveInfo.targetUid);
            }
        } longPressAction:nil];
        
    }else if (attachment.second == Custom_Noti_Sub_AllMicro_MagicSend || attachment.second == Custom_Noti_Sub_Batch_MagicSend){
        
        receiveInfo.targetUids = attachment.data[@"targetUids"];
        
        if (attachment.second == Custom_Noti_Sub_Batch_MagicSend) {
            // 将targetUsers中的uid抽出填充targetUids, 后面很多计算需要用到
            NSMutableArray *uids = [NSMutableArray array];
            for (UserInfo *user in receiveInfo.targetUsers) {
                [uids addObject:@(user.uid)];
            }
            receiveInfo.targetUids = uids;
            receiveInfo.isBatch = YES;
        }
        
        if (receiveInfo.targetUids.count > 0) {
            if (receiveInfo.isBatch) {
                UserInfo *sendInfo = [GetCore(UserCore) getUserInfoInDB:receiveInfo.uid];
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
                NSMutableAttributedString *senderNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:receiveInfo.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
                @KWeakify(self);
                [senderNickAttr yy_setTextHighlightRange:NSMakeRange(0, senderNickAttr.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    @KStrongify(self);
                    if (model.textDidClick) {
                        model.textDidClick(receiveInfo.uid);
                    }
                }];
                [str appendAttributedString:senderNickAttr];
                
                //send
                NSMutableAttributedString *sendAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 给 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
                [str appendAttributedString:sendAttr];
                
                BOOL isFirst = YES; // 是否是第一个收礼人, 判断加"、"
                for (int i = 0; i < receiveInfo.targetUids.count; i++) {
                    NSString *user = [receiveInfo.targetUids safeObjectAtIndex:i];
                    UserInfo *targetInfo = [receiveInfo.targetUsers safeObjectAtIndex:i];
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
                            model.textDidClick(user.userIDValue);
                        }
                    }];
                }
                
                //action
                NSMutableAttributedString *actionAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 施魔法 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
                [str appendAttributedString:actionAttr];
                
                //magic
                CALayer *imageView = [[CALayer alloc]init];
                imageView.contentsScale = [UIScreen mainScreen].scale;
                imageView.bounds = CGRectMake(0, -10, 40, 40);
                [imageView qn_setImageImageWithUrl:magicInfo.magicIcon placeholderImage:nil type:ImageTypeRoomMagic];
                NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
                [str appendAttributedString:imageString];
                
                //是否触发暴击
                if (receiveInfo.playEffect) {
                    NSMutableAttributedString *effectAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 并触发暴击 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
                    [str appendAttributedString:effectAttr];
                }
                
            } else {
                UserInfo *sendInfo = [GetCore(UserCore) getUserInfoInDB:receiveInfo.uid];
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
                NSMutableAttributedString *senderNickAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:receiveInfo.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
                @KWeakify(self);
                [senderNickAttr yy_setTextHighlightRange:NSMakeRange(0, senderNickAttr.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    @KStrongify(self);
                    if (model.textDidClick) {
                        model.textDidClick(receiveInfo.uid);
                    }
                }];
                [str appendAttributedString:senderNickAttr];
                
                //send
                NSMutableAttributedString *sendAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 全麦施魔法 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]];
                [str appendAttributedString:sendAttr];
                
                
                //magic
                CALayer *imageView = [[CALayer alloc]init];
                imageView.contentsScale = [UIScreen mainScreen].scale;
                imageView.bounds = CGRectMake(0, -10, 40, 40);
                [imageView qn_setImageImageWithUrl:magicInfo.magicIcon placeholderImage:nil type:ImageTypeRoomMagic];
                NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
                [str appendAttributedString:imageString];
                
                //是否触发暴击
                if (receiveInfo.playEffect) {
                    NSMutableAttributedString *effectAttr = [BaseAttrbutedStringHandler creatStrAttrByStr:@" 并触发暴击 " attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
                    [str appendAttributedString:effectAttr];
                }
            }
        }
    }
    model.content = str;
    return model;
}

@end
