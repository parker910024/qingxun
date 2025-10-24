//
//  TTGameRoomViewController+OnlineList.m
//  TuTu
//
//  Created by KevinWang on 2018/12/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+OnlineList.h"
#import "TTGameRoomViewController+UserCard.h"

@implementation TTGameRoomViewController (OnlineList)

- (void)ttShowOnlineList{
    if (!self.isEnterRoomSuccess) {
        return;
    }
    
    TTRoomOnlineListController *vc = [[TTRoomOnlineListController alloc] initWithOnlineListType:TTRoomOnlineListTypeAll];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TTRoomOnlineListControllerDelegate
- (void)onOnlineList:(TTRoomOnlineListController *)roomOnlineListController didSelectWithUid:(UserID)uid{
    [self ttShowUserCard:uid isGaming:NO
              controller:roomOnlineListController type:ShowUserCardType_Online];
//    [self ttShowUserCard:uid isGaming:NO];
}


@end
