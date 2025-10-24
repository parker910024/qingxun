//
//  TTGameRoomContainerController+GameRoom.m
//  TuTu
//
//  Created by KevinWang on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomContainerController+GameRoom.h"

@implementation TTGameRoomContainerController (GameRoom)

#pragma mark - TTGameRoomViewControllerDelagte

- (void)showRoomExit:(UserID)uid {
    [self showRoomExitWithUid:uid];
}


//更新背景图
- (void)updateBackPicWith:(RoomInfo *)info userInfo:(UserInfo *)userInfo {
    self.roomOwner = userInfo;
    if (info.backPic.length > 0) {
        self.effectView.hidden = YES;
    }else {
        self.effectView.hidden = NO;
    }
    [self updateRoomBg:info andUserInfo:userInfo];
}


@end
