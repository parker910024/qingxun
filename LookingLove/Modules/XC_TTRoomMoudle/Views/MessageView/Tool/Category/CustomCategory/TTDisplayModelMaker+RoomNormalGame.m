//
//  TTDisplayModelMaker+NormalGame.m
//  TTPlay
//
//  Created by new on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomNormalGame.h"
//model
#import "TTGameCPPrivateChatModel.h"
#import "UIView+XCToast.h"
#import "NSMutableDictionary+Safe.h"

//core
#import "TTCPGameStaticCore.h"
#import "TTGameStaticTypeCore.h"


@implementation TTDisplayModelMaker (RoomNormalGame)

- (TTMessageDisplayModel *)makeRoomNormalGameWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    
    TTGameCPPrivateChatModel *gameChatModel;
    if (message.localExt) {
        gameChatModel = [TTGameCPPrivateChatModel modelWithJSON:message.localExt];
    }else{
        gameChatModel = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
    }
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat) {
        if ([message.from isEqualToString:GetCore(AuthCore).getUid]) {
            
            TTGameCPPrivateChatModel *custonModel = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"你已发起" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"【%@】,",custonModel.gameInfo.gameName] attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"等待玩家加入(%d秒内有效)",GetCore(TTCPGameStaticCore).gameTime] attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            if (gameChatModel.status == TTGameStatusTypeTimeing) {
                NSMutableAttributedString *strPlay = [[NSMutableAttributedString alloc] initWithString:@"取消"];
                [strPlay addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:(kCTUnderlineStyleSingle|kCTUnderlinePatternSolid)] range:NSMakeRange(0, strPlay.length)];
                [strPlay addAttribute:(NSString *)kCTUnderlineColorAttributeName
                                value:(id)UIColorFromRGB(0xffffff).CGColor
                                range:NSMakeRange(0, strPlay.length)];
                [strPlay addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(0, strPlay.length)];
                [strPlay yy_setTextHighlightRange:NSMakeRange(0, strPlay.length) color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (model.textDidClick) {
                            model.textDidClick(message.from.userIDValue);
                        }
                    });
                } longPressAction:nil];
                
                [strPlay addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, strPlay.length)];
                
                [str appendAttributedString:strPlay];
            }else if (gameChatModel.status == TTGameStatusTypeInvalid) {
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"已取消" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            }else if (gameChatModel.status == TTGameStatusTypeAccept) {
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"已接受" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            }
            
        }else{
            
            TTGameCPPrivateChatModel *custonModel = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
            
            NSString *myNickString = custonModel.nick;
    
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:myNickString attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 发起" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"【%@】",custonModel.gameInfo.gameName] attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            if (gameChatModel.status == TTGameStatusTypeAccept) {
                if (GetCore(AuthCore).getUid.userIDValue == gameChatModel.acceptUid) {
                    [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"已接受" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
                }else{
                    NSMutableAttributedString * strPlay = [[NSMutableAttributedString alloc] initWithString:@"观战"];
                    [strPlay addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:(kCTUnderlineStyleSingle|kCTUnderlinePatternSolid)] range:NSMakeRange(0, strPlay.length)];
                    [strPlay addAttribute:(NSString *)kCTUnderlineColorAttributeName
                                    value:(id)UIColorFromRGB(0x7EFFDC).CGColor
                                    range:NSMakeRange(0, strPlay.length)];
                    [strPlay addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x7EFFDC) range:NSMakeRange(0, strPlay.length)];
                    [strPlay yy_setTextHighlightRange:NSMakeRange(0, strPlay.length) color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            NotifyCoreClient(TTCPGamePrivateChatClient, @selector(acceptGameFromNormalRoom:), acceptGameFromNormalRoom:msg);
                            if (model.textDidClick) {
                                model.textDidClick(message.from.userIDValue);
                            }
                        });
                    } longPressAction:nil];
                    
                    [strPlay addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, strPlay.length)];
                    
                    [str appendAttributedString:strPlay];
                }
            }else if (gameChatModel.status == TTGameStatusTypeTimeing){
                NSMutableAttributedString * strPlay = [[NSMutableAttributedString alloc] initWithString:@"接受"];
                [strPlay addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:(kCTUnderlineStyleSingle|kCTUnderlinePatternSolid)] range:NSMakeRange(0, strPlay.length)];
                [strPlay addAttribute:(NSString *)kCTUnderlineColorAttributeName
                                value:(id)UIColorFromRGB(0x7EFFDC).CGColor
                                range:NSMakeRange(0, strPlay.length)];
                [strPlay addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x7EFFDC) range:NSMakeRange(0, strPlay.length)];
                [strPlay yy_setTextHighlightRange:NSMakeRange(0, strPlay.length) color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!GetCore(TTGameStaticTypeCore).acceptGameFromNormalRoom){
//                            NotifyCoreClient(TTCPGamePrivateChatClient,
//                            @selector(acceptGameFromNormalRoom:), acceptGameFromNormalRoom:msg);
                            if (model.textDidClick) {
                                model.textDidClick(message.from.userIDValue);
                            }
                        }
                    });
                } longPressAction:nil];
                
                [strPlay addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, strPlay.length)];
                
                [str appendAttributedString:strPlay];
            }else if (gameChatModel.status == TTGameStatusTypeInvalid) {
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"已失效" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            }
        }
    }
    str.yy_lineSpacing = 6;
    model.content = str;
    model.contentHeight = [[TTMessageViewLayout shareLayout]getAttributedHeightWith:str];
    return model;
    
}

@end
