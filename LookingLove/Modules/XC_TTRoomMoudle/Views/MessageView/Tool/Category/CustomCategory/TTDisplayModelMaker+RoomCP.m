
//
//  TTDisplayModelMaker+RoomCP.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomCP.h"

#import "TTMessageViewConst.h"

#import "TTCPGameCustomModel.h"
#import "CPGameListModel.h"
#import "TTGameStaticTypeCore.h"

#import "UIColor+UIColor_Hex.h"

@implementation TTDisplayModelMaker (RoomCP)

- (TTMessageDisplayModel *)makeCPGameContentWith:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    TTCPGameCustomModel *gameModel = [TTCPGameCustomModel modelWithJSON:attachment.data];
    
    NSArray *gameListArray = GetCore(TTGameStaticTypeCore).privateMessageArray;
    
    NSString *gameName;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    
    if (gameListArray.count > 0) {
        for (int i = 0; i < gameListArray.count; i++) {
            NSDictionary *dict = gameListArray[i];
            if (gameModel.gameInfo) {
                if ([dict[@"gameId"] isEqualToString:gameModel.gameInfo.gameId]) {
                    gameName = dict[@"gameName"];
                    break;
                }
            }else if (gameModel.gameResultInfo){
                if ([dict[@"gameId"] isEqualToString:gameModel.gameResultInfo.gameId]) {
                    gameName = dict[@"gameName"];
                    break;
                }
            }
        }
    }
    
    if (!gameName) {
        gameName = GetCore(RoomCoreV2).getCurrentRoomInfo.roomGame[@"gameName"];
    }
    
    if (attachment.second == Custom_Noti_Sub_CPGAME_Open ) {//开启游戏模式
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"消息:" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"房主开启快玩模式，赶紧加入吧" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
    }else if (attachment.second == Custom_Noti_Sub_CPGAME_Select){
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:gameModel.nick attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 发起" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"【%@】",gameName] attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"赶紧来玩！" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
    }else if (attachment.second == Custom_Noti_Sub_CPGAME_Start){
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:gameModel.nick attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 加入" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"【%@】",gameName] attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        
        //            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"游戏" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        
    }else if (attachment.second == Custom_Noti_Sub_CPGAME_Cancel_Prepare){
        
        //            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:model.nick attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        //
        //            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 退出" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        //
        //            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"【%@】",gameName] attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        
        //            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"游戏" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        
    }else if (attachment.second == Custom_Noti_Sub_CPGAME_End){
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"消息:" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        
        if ([gameModel.gameResultInfo.resultType isEqualToString:@"not_draw"]) {
            // 不是平局
            NSString *myNickString = [[gameModel.gameResultInfo.winners safeObjectAtIndex:0] objectForKey:@"name"];
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"【%@】",gameName] attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"恭喜 " attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:myNickString attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 战胜 " attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
            
            NSString *youNickString = [[gameModel.gameResultInfo.failers safeObjectAtIndex:0] objectForKey:@"name"];
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:youNickString attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        }else{
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"【%@】",gameName] attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
            
            NSString *myNickString = [[gameModel.gameResultInfo.users safeObjectAtIndex:0] objectForKey:@"name"];
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:myNickString attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"对战" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
            
            NSString *youNickString = [[gameModel.gameResultInfo.users safeObjectAtIndex:1] objectForKey:@"name"];
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:youNickString attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
            
            [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"为平局" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        }
        
    }else if (attachment.second == Custom_Noti_Sub_CPGAME_Close){
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"消息:" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"房主关闭快玩模式" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
    }else if (attachment.second == Custom_Noti_Sub_CPGAME_Ai_Enter){
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:gameModel.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
        
        [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 进入了房间" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTipColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
    }else if (attachment.second == Custom_Noti_Sub_CPGAME_RoomGame) {
        CPGameListModel *gameModel = [CPGameListModel modelWithJSON:attachment.data];
        if (gameModel.checkSelf  && gameModel.uid == GetCore(AuthCore).getUid.userIDValue) { // 游戏已经开始
                NSDictionary *dict = [NSString dictionaryWithJsonString:gameModel.selfMsg];
                NSArray *contentArray = [dict objectForKey:@"contents"];
                for (int i = 0; i < contentArray.count; i++) {
                    NSDictionary *contentDict = [contentArray safeObjectAtIndex:i];
                    [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[contentDict objectForKey:@"content"] attributed:@{NSForegroundColorAttributeName:[contentDict[@"fontColor"] length] > 0 ? [UIColor colorWithHexString:contentDict[@"fontColor"]] : [XCTheme getTTMessageViewTipColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
                }
        } else {  // 发起游戏的消息
            NSDictionary *dict = [NSString dictionaryWithJsonString:gameModel.otherMsg];
            NSArray *contentArray = [dict objectForKey:@"contents"];
            for (int i = 0; i < contentArray.count; i++) {
                NSDictionary *contentDict = [contentArray safeObjectAtIndex:i];
                [string appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[contentDict objectForKey:@"content"] attributed:@{NSForegroundColorAttributeName:[contentDict[@"fontColor"] length] > 0 ? [UIColor colorWithHexString:contentDict[@"fontColor"]] : [XCTheme getTTMessageViewTipColor],NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
            }
        }
        [string yy_setTextHighlightRange:NSMakeRange(0, string.length) color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (model.textDidClick) {
                model.textDidClick(0);
            }
        } longPressAction:nil];
    }
    
    model.content = string;
    
    return model;
}

@end
