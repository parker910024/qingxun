//
//  TTBaseRoomViewController.h
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

//core
#import "RoomInfo.h"
#import "UserInfo.h"
#import "RoomCoreV2.h"
#import "ImRoomCoreClient.h"

//SVGA动画播放
#import "SVGA.h"
#import "SVGAParserManager.h"

@interface TTBaseRoomViewController : BaseUIViewController

@property (nonatomic, strong) UIImageView *roomBg;
@property (nonatomic, strong) SVGAImageView *svgDisplayView;
@property (nonatomic, strong) SVGAImageView *nobleOpenEffectView;
@property (nonatomic, strong) SVGAImageView *svgaCarEffectView;
@property (nonatomic, strong) SVGAParserManager *parserManager;
@property (nonatomic, strong) UILabel *nobleOpenTextLabel;
@property (nonatomic, strong) UIButton *nobleOpenCloseBtn;

- (void)ttBeKicked:(NIMChatroomKickReason)reson;
- (void)showRoomExitWithUid:(UserID)uid;

- (void)updateNobleOpenEffectQueue:(SVGAPlayer *)player;
- (void)updateCarEffectQueue:(SVGAPlayer *)player;
- (void)updateRoomBg:(RoomInfo *)info andUserInfo:(UserInfo *)userInfo;



@end
