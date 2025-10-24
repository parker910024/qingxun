//
//  TTMessageView+RoomCP.m
//  TuTu
//
//  Created by new on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomCP.h"
#import "TTMessageViewConst.h"

#import "TTCPGameCustomModel.h"
#import "CPGameListModel.h"

@implementation TTMessageView (RoomCP)

- (void)handleCPGameCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model{

    newCell.messageLabel.attributedText = model.content;
    newCell.labelContentView.hidden = NO;
    newCell.chatBubleImageView.hidden = YES;
    __block TTMessageDisplayModel *weakModel = model;
    @KWeakify(self);
    [model setTextDidClick:^(UserID uid) {
        @KStrongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:enterRoomGameWithModel:)]) {
            [self.delegate messageTableView:self enterRoomGameWithModel:weakModel];
        }
    }];
    
}


@end
