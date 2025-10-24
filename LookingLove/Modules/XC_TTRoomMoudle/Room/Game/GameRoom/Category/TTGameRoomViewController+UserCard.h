//
//  TTGameRoomViewController+UserCard.h
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"
#import "TTUserCardContainerView.h"

@interface TTGameRoomViewController (UserCard)

/*
 * uid：用户uid
 * canSendGift:是否能送礼物
 * isSuperAdmin:是不是超管
 */
- (void)ttShowUserCard:(UserID)uid isGaming:(BOOL)isGaming isSuperAdmin:(BOOL)isSuperAdmin;

/*
 * uid：用户uid
 * canSendGift:是否能送礼物
 */
- (void)ttShowUserCard:(UserID)uid isGaming:(BOOL)isGaming;

/**从榜单或者在线列表展示用户卡片*/
- (void)ttShowUserCard:(UserID)uid isGaming:(BOOL)isGaming controller:(UIViewController *)controller type:(ShowUserCardType)type;

@end
