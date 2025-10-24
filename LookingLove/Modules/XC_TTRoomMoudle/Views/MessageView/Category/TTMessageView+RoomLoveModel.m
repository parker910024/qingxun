//
//  TTMessageView+RoomLoveModel.m
//  CeEr
//
//  Created by jiangfuyuan on 2020/12/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMessageView+RoomLoveModel.h"

@implementation TTMessageView (RoomLoveModel)

- (void)handleRoomLoveScreenCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model {
    
    newCell.messageLabel.attributedText = model.content;
    newCell.labelContentView.hidden = NO;
    newCell.chatBubleImageView.hidden = YES;
}

@end
