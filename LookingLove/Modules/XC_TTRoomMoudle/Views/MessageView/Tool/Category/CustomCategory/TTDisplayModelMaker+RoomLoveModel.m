//
//  TTDisplayModelMaker+RoomLoveModel.m
//  CeEr
//
//  Created by jiangfuyuan on 2020/12/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTDisplayModelMaker+RoomLoveModel.h"
#import "TTRoomLoveModelAttachment.h"

@implementation TTDisplayModelMaker (RoomLoveModel)

- (TTMessageDisplayModel *)makeRoomLoveScreenMsgTipsWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    
    Attachment *attachment = (Attachment *)obj.attachment;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    TTRoomLoveModelAttachment *roomLoveAttachment = [TTRoomLoveModelAttachment modelDictionary:attachment.data];
    
    if (attachment.first == Custom_Noti_Header_RoomLoveModelFirst) {
        if (attachment.second == Custom_Noti_Sub_Room_LoveModel_Sec_SrceenMsg) { // 开始公屏消息
    
            // 开始公屏文案  # 进入心动选择阶段，选择时间5分钟，喜欢就去撩TA牌子吧！
            if (roomLoveAttachment.msg) {
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:roomLoveAttachment.msg attributed:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : UIColor.whiteColor}]];
            }
            
        } else if (attachment.second == Custom_Noti_Sub_Room_LoveModel_Sec_SuccessMsg) {    // 配对成功消息
            
            if (roomLoveAttachment.users) {
                
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"本次牵手成功的嘉宾有：" attributed:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : UIColor.whiteColor}]];
                
                [roomLoveAttachment.users enumerateObjectsUsingBlock:^(RoomLoveUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *nickStr;
                    if (roomLoveAttachment.users.count > 1) {
                        if (idx != (roomLoveAttachment.users.count - 1)) {
                            nickStr = [NSString stringWithFormat:@"%@与%@，", obj.nick, obj.choseNick];
                        } else {
                            nickStr = [NSString stringWithFormat:@"%@与%@", obj.nick, obj.choseNick];
                        }
                    } else {
                        nickStr = [NSString stringWithFormat:@"%@与%@", obj.nick, obj.choseNick];
                    }
                    [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:nickStr attributed:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : UIColorFromRGB(0xFFE89D)}]];
                }];
                
                [str appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"，祝你们从网络走到现实，从牵手走到白头~" attributed:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : UIColor.whiteColor}]];
            }
        }
    }
    model.content = str;
    return model;
}


@end
