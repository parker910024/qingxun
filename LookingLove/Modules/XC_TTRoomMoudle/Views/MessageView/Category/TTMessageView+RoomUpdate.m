//
//  TTMessageView+RoomUpdate.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomUpdate.h"
#import "TTMessageViewConst.h"

@implementation TTMessageView (RoomUpdate)

- (void)handleUpdateRoomInfo:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model{

    newCell.messageLabel.attributedText = model.content;
    newCell.labelContentView.hidden = NO;
    newCell.chatBubleImageView.hidden = YES;
}

@end
