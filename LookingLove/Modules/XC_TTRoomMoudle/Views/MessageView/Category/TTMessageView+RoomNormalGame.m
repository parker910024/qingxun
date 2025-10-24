//
//  TTMessageView+RoomNormalGame.m
//  TTPlay
//
//  Created by new on 2019/3/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageView+RoomNormalGame.h"

//maker
#import "TTDisplayModelMaker+RoomNormalGame.h"

#import "XCHUDTool.h"

@implementation TTMessageView (RoomNormalGame)

- (void)handleNormalGameModelCell:(TTMessageTextCell *)newCell  model:(TTMessageDisplayModel *)model{
    
    __block __weak TTMessageDisplayModel *blockModel = model;
    
    __block __weak TTMessageTextCell *blockCell = newCell;
    
    @KWeakify(self);
    [model setTextDidClick:^(UserID uid) {
        @KStrongify(self);
        
        //超管接受房间游戏拦截
        UserInfo *info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
        if (info.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
            [XCHUDTool showSuccessWithMessage:@"好好上班，不要玩游戏"];
            return;
        }
        
        if (uid == GetCore(AuthCore).getUid.userIDValue) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:updateRoomNormalGameMessage:)]) {
                [self.delegate messageTableView:self updateRoomNormalGameMessage:blockModel];
            }
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableView:updateRoomNormalGameForAcceptMessage:)]) {
                [self.delegate messageTableView:self updateRoomNormalGameForAcceptMessage:blockModel];
            }
        }
        
        [[TTDisplayModelMaker shareMaker] makeRoomNormalGameWithMessage:blockModel.message model:blockModel];

        blockCell.messageLabel.attributedText = blockModel.content;
    }];
    
    newCell.messageLabel.attributedText = model.content;
    newCell.labelContentView.hidden = NO;
    newCell.chatBubleImageView.hidden = YES;
}



@end
