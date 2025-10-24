//
//  TTDisplayModelMaker+RoomUpdate.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomUpdate.h"

@implementation TTDisplayModelMaker (RoomUpdate)

- (TTMessageDisplayModel *)makeRoomUpdateRoomWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    
    [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"消息:" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
    //create
    if (attachment.second == Custom_Noti_Sub_Update_RoomInfo_AnimateEffect ) {//动画开关状态更新
        
        [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"管理员已关闭房间内礼物特效，点击底部" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
        NSMutableAttributedString *imageStr = [BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 22, 22) urlString:nil imageName:@"room_GameMore_logo"];
        [str appendAttributedString:imageStr];
        [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"图标即可开启" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getMSMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
        
        
    }else if (attachment.second == Custom_Noti_Sub_Update_RoomInfo_AgoraAudioQuity){//声网音质更新
        
        [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"管理员开启高音质模式" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
    }else if(attachment.second == Custom_Noti_Sub_Update_RoomInfo_MessageState){//公屏消息
        
        if (GetCore(ImRoomCoreV2).currentRoomInfo.isCloseScreen) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"管理员已关闭聊天公屏" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
        }else{
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"管理员已开启聊天公屏" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
        }
        
    }else if(attachment.second == Custom_Noti_Sub_Update_RoomInfo_Notice){//通用公屏提示文案
        
        NSString *tip = attachment.data[@"tips"];
        if ([tip isKindOfClass:[NSString class]] && tip.length) {
            str = [[NSMutableAttributedString alloc] initWithString:tip attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:TTMessageViewDefaultFontSize], NSForegroundColorAttributeName : [UIColor whiteColor]}];
        }
    }
    model.content = str;
    
    return model;
}

@end
