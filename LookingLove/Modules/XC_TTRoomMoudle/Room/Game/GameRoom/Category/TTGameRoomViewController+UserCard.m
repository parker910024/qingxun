//
//  TTGameRoomViewController+UserCard.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+UserCard.h"
#import "TTUserCardContainerView.h"
#import "TTGameRoomUserCardFunctionItemsConfig.h"

//category
#import "TTGameRoomViewController+ChatMessage.h"

#import "TTPopup.h"

@implementation TTGameRoomViewController (UserCard)

/*
 * uid：用户uid
 * canSendGift:是否能送礼物
 */
- (void)ttShowUserCard:(UserID)uid isGaming:(BOOL)isGaming isSuperAdmin:(BOOL)isSuperAdmin {
    @KWeakify(self);
    [XCHUDTool showGIFLoading];
    [[TTGameRoomUserCardFunctionItemsConfig getFunctionItemsInGameRoomWithUid:uid isSuperAdmin:isSuperAdmin] subscribeNext:^(id x) {
        
        NSMutableArray * bottomOpeArray = x;
        
        [[TTGameRoomUserCardFunctionItemsConfig getCenterFunctionItemsInGameRoomWithUid:uid isGaming:isGaming isSuperAdmin:isSuperAdmin] subscribeNext:^(id x) {
            @KStrongify(self);
            [XCHUDTool hideHUD];
            NSMutableArray * functionArray = x;
            CGFloat height = [TTUserCardContainerView getTTUserCardContainerViewHeightWithFunctionArray:functionArray bottomOpeArray:bottomOpeArray];
            TTUserCardContainerView *view = [[TTUserCardContainerView alloc]initWithFrame:CGRectMake(0, 0, 314, height) uid:uid];
            [view setTTUserCardContainerViewHeightWithFunctionArray:functionArray bottomOpeArray:bottomOpeArray];
            view.itemBlock = ^(UserID uid) {
                [self roomChatGotoUserWith:uid];
            };
            
            [TTPopup popupView:view style:TTPopupStyleAlert];
            [XCHUDTool hideHUD];
        }];
    }];
}

/*
 * uid：用户uid
 * canSendGift:是否能送礼物
 */
- (void)ttShowUserCard:(UserID)uid isGaming:(BOOL)isGaming{
    [self ttShowUserCard:uid isGaming:isGaming isSuperAdmin:NO];
}

- (void)ttShowUserCard:(UserID)uid isGaming:(BOOL)isGaming controller:(UIViewController *)controller type:(ShowUserCardType)type{
    UserInfo * infor = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
    BOOL isSuperAdmin = NO;
    if (infor.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
        isSuperAdmin = YES;
    }
    @KWeakify(self);
    [XCHUDTool showGIFLoading];
    [[TTGameRoomUserCardFunctionItemsConfig getFunctionItemsInGameRoomWithUid:uid isSuperAdmin:isSuperAdmin] subscribeNext:^(id x) {
        NSMutableArray * bottomOpeArray = x;
        [[TTGameRoomUserCardFunctionItemsConfig getCenterFunctionItemsInGameRoomWithUid:uid isGaming:isGaming isSuperAdmin:isSuperAdmin] subscribeNext:^(id x) {
            
            @KStrongify(self);
            [XCHUDTool hideHUD];
            NSMutableArray * functionArray = x;
            
            CGFloat height = [TTUserCardContainerView getTTUserCardContainerViewHeightWithFunctionArray:functionArray bottomOpeArray:bottomOpeArray];
            
            TTUserCardContainerView *view = [[TTUserCardContainerView alloc]initWithFrame:CGRectMake(0, 0, 314, height) uid:uid type:type];
            [view setTTUserCardContainerViewHeightWithFunctionArray:functionArray bottomOpeArray:bottomOpeArray];
            view.itemBlock = ^(UserID uid) {
                [self roomChatGotoUserWith:uid controller:controller];
            };
            
            [TTPopup popupView:view style:TTPopupStyleAlert];
        }];
    }];
}

@end
