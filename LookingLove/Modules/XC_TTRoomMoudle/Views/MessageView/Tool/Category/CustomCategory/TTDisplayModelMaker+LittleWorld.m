//
//  TTDisplayModelMaker+LittleWorld.m
//  XC_TTRoomMoudle
//
//  Created by apple on 2019/7/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+LittleWorld.h"
#import "XCLittleWorldRoomAttachment.h"
#import "UIView+NTES.h"
#import "TTWorldletRoomModel.h"

@implementation TTDisplayModelMaker (LittleWorld)

- (TTMessageDisplayModel *)makeLittleWorldWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    XCLittleWorldRoomAttachment *attachment = (XCLittleWorldRoomAttachment *)obj.attachment;
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    if (attachment.first == Custom_Noti_Header_Game_LittleWorld) {
        TTWorldletRoomModel *customModel = [TTWorldletRoomModel yy_modelWithJSON:attachment.data];
        if (attachment.second == Custom_Noti_Sub_Little_World_Room_Lead_Notify) {
             [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"欢迎进入  " attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:attachment.worldName attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"  加入小世界与小伙伴一起狂欢吧！" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            if (!customModel.inWorld) {
                NSMutableAttributedString *joinStr = [self makeButtonWithAttStr:@"room_joinLittleWorld"];
                
                [joinStr yy_setTextHighlightRange:NSMakeRange(0, joinStr.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    if (model.textDidClick) {
                        model.textDidClick(0);
                    }
                }];
                [str appendAttributedString:joinStr];
            } else { // 已加入小世界
                NSMutableAttributedString *joinStr = [self makeButtonWithAttStr:@"room_joinLittleWorld_finish"];
                [str appendAttributedString:joinStr];
            }
        } else if (attachment.second == Custom_Noti_Sub_Little_World_Room_Join_Notify) {
            if (GetCore(RoomCoreV2).getCurrentRoomInfo.worldId == customModel.worldId) {
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"欢迎  " attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
                
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:customModel.nick attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
                
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"  加入  " attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
                
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:customModel.worldName attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            }
        } else if (attachment.second == Custom_Noti_Sub_Little_World_Room_Praise_Notify) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"欢迎  " attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:attachment.title attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"  关注房主不迷路哦 " attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            if (!attachment.isFollowRoomOwner) {
                NSMutableAttributedString *joinStr = [self makeButtonWithAttStr:@"room_worldAttend"];
                
                [joinStr yy_setTextHighlightRange:NSMakeRange(0, joinStr.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    if (model.textDidClick) {
                        model.textDidClick(1);
                    }
                }];
                [str appendAttributedString:joinStr];
            } else { // 已关注
                NSMutableAttributedString *joinStr = [self makeButtonWithAttStr:@"room_worldAttend_finish"];
                [str appendAttributedString:joinStr];
            }
        }
    }
   
    str.yy_lineSpacing = 6;
    
    model.content = str;
    
    model.contentHeight = [[TTMessageViewLayout shareLayout]getAttributedHeightWith:str];
    
    return model;
}

- (NSMutableAttributedString *)makeButtonWithAttStr:(NSString *)string {
    
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, 37, 15);
    layer.cornerRadius = 15 / 2;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contents = (__bridge id)[UIImage imageNamed:string].CGImage;

    NSMutableAttributedString * str = [NSMutableAttributedString yy_attachmentStringWithContent:layer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(37, 15) alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
    
    return str;
}

@end
