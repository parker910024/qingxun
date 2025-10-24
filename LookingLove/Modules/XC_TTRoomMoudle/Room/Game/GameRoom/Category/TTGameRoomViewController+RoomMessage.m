//
//  TTGameRoomViewController+RoomMessage.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+RoomMessage.h"
#import "TTGameRoomViewController+UserCard.h"
#import "TTGameRoomViewController+Introduce.h"

#import "TTMessageViewConst.h"

#import "TTDisplayModelMaker+Notification.h"

@implementation TTGameRoomViewController (RoomMessage)

#pragma mark - MessageTableViewDelegate

- (void)messageTableView:(TTMessageView *)messageTableView needShowUserInfoCardWithUid:(UserID)uid{
      UserInfo *  myInfor = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
    if (myInfor.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
      [self ttShowUserCard:uid isGaming:YES isSuperAdmin:YES];
    }else {
        [self ttShowUserCard:uid isGaming:YES];
    }
    
}

- (void)messageTableView:(TTMessageView *)messageTableView enterRoomHadSendGreetingWithModel:(TTMessageDisplayModel *)messageModel {
    
    //设置为已发送欢迎语
    NSMutableDictionary *localExt = messageModel.message.localExt.mutableCopy;
    if (localExt == nil) {
        localExt = [NSMutableDictionary dictionary];
    }
    [localExt setObject:@(YES) forKey:@(TTMessageViewEnterRoomSendGreetingFlag)];
    messageModel.message.localExt = localExt.copy;
    
    [[TTDisplayModelMaker shareMaker] makeNotificationContentWithMessage:messageModel.message withModel:messageModel];

    [self.messageView.tableView reloadData];
}

#pragma mark - TTMessageHeaderViewDelegate
- (void)ttMessageHeaderView:(TTMessageHeaderView *)headerView didClickTipView:(UILabel *)tipLabel; {
    [self showIntroduceAlertView];
}

@end

