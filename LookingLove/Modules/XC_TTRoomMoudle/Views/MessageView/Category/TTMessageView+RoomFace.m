//
//  TTMessageView+RoomFace.m
//  TuTu
//
//  Created by KevinWang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomFace.h"
#import "TTMessageViewConst.h"

#import <YYText/YYText.h>

@implementation TTMessageView (RoomFace)

- (void)handleFaceCell:(TTMessageFaceCell *)cell model:(TTMessageDisplayModel *)model {
    
    NIMCustomObject *obj = (NIMCustomObject *)model.message.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        FaceSendInfo *faceattachement = [FaceSendInfo yy_modelWithJSON:attachment.data];
        NSMutableArray *arr = [faceattachement.data mutableCopy];//接受人数
        //add buble
        if (arr.count == 1) {
            FaceReceiveInfo *item = arr.firstObject;
            SingleNobleInfo *senderNobleInfo = [TTMessageHelper handleRoomExtToModel:model.message.remoteExt uid:[NSString stringWithFormat:@"%lld",item.uid]];
            
            if (senderNobleInfo.bubble && model.message.from.userIDValue == item.uid) {
                cell.messageBgView.hidden = YES;
                cell.chatBubleImageView.hidden = NO;
                [TTNobleSourceHandler handlerImageView:cell.chatBubleImageView nobleInfo:senderNobleInfo];;
            }else{
                cell.messageBgView.hidden = NO;
                cell.chatBubleImageView.hidden = YES;
            }
        }else{
            cell.messageBgView.hidden = NO;
            cell.chatBubleImageView.hidden = YES;
        }
    }
    @KWeakify(self);
    [model setTextDidClick:^(UserID uid) {
        if (uid > 0 && self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:needShowUserInfoCardWithUid:)]) {
            @KStrongify(self);
            [self.delegate messageTableView:self needShowUserInfoCardWithUid:uid];
        }
    }];

    cell.messageLabel.attributedText = model.content;
}


@end
