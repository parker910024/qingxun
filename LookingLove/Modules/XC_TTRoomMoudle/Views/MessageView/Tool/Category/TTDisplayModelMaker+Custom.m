//
//  TTDisplayModelMaker+Custom.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+Custom.h"

#import "TTDisplayModelMaker+Face.h"
#import "TTDisplayModelMaker+Noble.h"
#import "TTDisplayModelMaker+ArrangeMic.h"
#import "TTDisplayModelMaker+RoomAllMicro.h"
#import "TTDisplayModelMaker+RoomBox.h"
#import "TTDisplayModelMaker+RoomCP.h"
#import "TTDisplayModelMaker+RoomDragon.h"
#import "TTDisplayModelMaker+RoomFace.h"
#import "TTDisplayModelMaker+RoomGift.h"
#import "TTDisplayModelMaker+RoomKick.h"
#import "TTDisplayModelMaker+RoomMagic.h"
#import "TTMessageView+RoomNoble.h"
#import "TTDisplayModelMaker+RoomTip.h"
#import "TTDisplayModelMaker+RoomUpdate.h"
#import "TTDisplayModelMaker+NonsupportMessage.h"

#import "TTMessageStrategy.h"

@implementation TTDisplayModelMaker (Custom)

- (TTMessageDisplayModel *)makeCustomContentWithMessage:(NIMMessage *)message withModel:(TTMessageDisplayModel *)model {
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    if (attachment.first == Custom_Noti_Header_Face) {
        if (attachment.second == Custom_Noti_Sub_Face_Send) {
            model.content = [self creatFaceAttributedWithMsg:message withModel:model];
        } else {
            [self makeRoomNonsupportMessageContentWithMessage:message model:model];
        }
    }else if (attachment.first == Custom_Noti_Header_NobleNotify) { //noble
        if (attachment.second == Custom_Noti_Sub_NobleNotify_Renew_Success || attachment.second == Custom_Noti_Sub_NobleNotify_Open_Success) {
            model.content = [self creatNobleAttributedWithMsg:message withModel:model];
        } else {
            [self makeRoomNonsupportMessageContentWithMessage:message model:model];
        }
    }else {
        NSInvocation *strategy = [[TTMessageStrategy defaultStrategy]strategyByMessageHeader:attachment.first target:self model:model message:message];
        [strategy invoke];
    }
    model.contentHeight = [[TTMessageViewLayout shareLayout]getAttributedHeightWith:model.content];
    return model;
}




@end
