//
//  TTDisplayModelMaker+RoomDragon.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+RoomDragon.h"

@implementation TTDisplayModelMaker (RoomDragon)

- (TTMessageDisplayModel *)makeDragonContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];\
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    FaceSendInfo *faceattachement = [FaceSendInfo yy_modelWithJSON:attachment.data];
    FaceReceiveInfo *receive = (FaceReceiveInfo *)faceattachement.data.firstObject;
    NSString *nick = receive.nick;
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    
    if (attachment.second == Custom_Noti_Sub_Dragon_Finish ) {//本局龙珠结束
        
        [str appendAttributedString:
         [BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"%@:",nick] attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewNickColor] size:TTMessageViewDefaultFontSize]]];
        
        NSMutableString *dragonStr = [NSMutableString stringWithString:@" 爱心值"];
        for (NSNumber *indexStr in receive.resultIndexes) {
            [dragonStr appendString:[NSString stringWithFormat:@"%ld",indexStr.intValue-GetCore(FaceCore).dragonConfigInfo.resultStartPos+1]];
            [dragonStr appendString:@","];
        }
        dragonStr = [[dragonStr substringToIndex:(dragonStr.length-1)] mutableCopy];
        
        [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:dragonStr attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
        @KWeakify(self);
        [str yy_setTextHighlightRange:[[str string] rangeOfString:nick] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @KStrongify(self);
            if (model.textDidClick) {
                model.textDidClick(receive.uid);
            }
        }];
    }else if (attachment.second == Custom_Noti_Sub_Dragon_Cancel){//取消龙珠游戏
        
        NSMutableAttributedString * nickAttribute = [BaseAttrbutedStringHandler creatStrAttrByStr:nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewNickColor] size:TTMessageViewDefaultFontSize]];
        @KWeakify(self);
        [nickAttribute yy_setTextHighlightRange:NSMakeRange(0, nickAttribute.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @KStrongify(self);
            if (model.textDidClick) {
                model.textDidClick(receive.uid);
            }
        }];
        
        [str appendAttributedString:nickAttribute];
        
        [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 放弃本次匹配" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
        
    }else if(attachment.second == Custom_Noti_Sub_Dragon_Continue){//展示前面的
        
        [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewNickColor] size:TTMessageViewDefaultFontSize]]];
        
        [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" 之前在本房间由于不明原因退出匹配，此次匹配展示为上局数据" attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
    }
    model.content = str;
    
    
    
    return model;
}

@end
