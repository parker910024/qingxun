//
//  TTDisplayModelMaker+SuperAdmin.m
//  XC_TTRoomMoudle
//
//  Created by jiangfuyuan on 2019/8/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+SuperAdmin.h"
#import "XCRoomSuperAdminAttachment.h"

@implementation TTDisplayModelMaker (SuperAdmin)

- (TTMessageDisplayModel *)makeSuperAdminWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    XCRoomSuperAdminAttachment *attachment = (XCRoomSuperAdminAttachment *)obj.attachment;
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    if (attachment.first == Custom_Noti_Header_Room_SuperAdmin) {
        
        TTRoomSuperAdminModel *superModel = [TTRoomSuperAdminModel modelDictionary:attachment.data];
        NSString *micString;
        NSInteger micNumberInter = 0;
        if (superModel.micNumber > 0) {
            micNumberInter = superModel.micNumber.intValue + 1;
            if (micNumberInter == 0) {
                micString = @"房主位";
            } else {
                micString = [NSString stringWithFormat:@"%ld号麦位",micNumberInter];
            }
        }
        
        if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_unLimmit) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"系统检测涉嫌违规，予以解除进房限制警告" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        } else if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_unLock) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"系统检测涉嫌违规，予以解除房间上锁警告" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        } else if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_LockMic) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"系统检测涉嫌违规，" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:micString attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"被锁麦" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        } else if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_noVoiceMic) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"系统检测涉嫌违规，" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:micString attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"被闭麦" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        } else if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_DownMic) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"系统检测涉嫌违规，" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:superModel.targetNick attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"被请下麦" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        } else if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_Shield) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"系统检测涉嫌违规，" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:superModel.targetNick attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"被关进小黑屋" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        } else if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_TickRoom || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_TickManagerRoom) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"系统检测涉嫌违规，" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:superModel.targetNick attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
            
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"被请出房间" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        } else if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_CloseChat) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"系统检测涉嫌违规，予以关闭公屏消息警告" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        } else if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_CloseRoom) {
            [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"系统检测涉嫌违规，房间已关闭" attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        }
    }
    
    str.yy_lineSpacing = 6;
    
    model.content = str;
    
    model.contentHeight = [[TTMessageViewLayout shareLayout]getAttributedHeightWith:str];
    
    return model;
}

@end
