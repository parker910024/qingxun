//
//  TTGameRoomViewController+RoomContribution.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+RoomContribution.h"
#import "TTBaseContributionViewController.h"
#import "TTGameRoomViewController+UserCard.h"

#import "XCMediator+TTPersonalMoudleBridge.h"

@implementation TTGameRoomViewController (RoomContribution)

//房间贡献榜
- (void)ttShowRoomGiftListView {
    
    if (![self.view.subviews containsObject:self.contributionContainerView]) {
        [self.view addSubview:self.contributionContainerView];
    }
    
    [self.view bringSubviewToFront:self.contributionContainerView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contributionContainerView.hidden = NO;
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTBaseContributionViewControllerShouldUpdateDataNoti object:nil];
}

#pragma mark - TTRoomContributionControllerDelegate
/**
 半小时榜选中用户
 
 @param userId 用户ID
 */
- (void)halfhourContributionDidSelectUser:(UserID)userId {
    
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:userId];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 房内榜选中用户
 
 @param userId 用户ID
 */
- (void)inRoomContributionDidSelectUser:(UserID)userId {
    UserInfo * info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
    if (info.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
        [self ttShowUserCard:userId isGaming:NO isSuperAdmin:YES];
    }else {
        [self ttShowUserCard:userId isGaming:NO];
    }
}

@end
