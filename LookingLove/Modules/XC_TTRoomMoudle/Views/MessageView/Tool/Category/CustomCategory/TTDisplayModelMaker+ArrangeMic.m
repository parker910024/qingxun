//
//  TTDisplayModelMaker+ArrangeMic.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+ArrangeMic.h"

#import "XCArrangeMicAttachment.h"

#import "BaseAttrbutedStringHandler+TTRoomModule.h"

@implementation TTDisplayModelMaker (ArrangeMic)

- (TTMessageDisplayModel *)makeArrangeMicContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    
    if (!model) {
        model = [[TTMessageDisplayModel alloc]init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    NSMutableAttributedString *content = [BaseAttrbutedStringHandler crateRoomArrangeMicWith:attachment];
    model.content = content;
    return model;
}

@end
