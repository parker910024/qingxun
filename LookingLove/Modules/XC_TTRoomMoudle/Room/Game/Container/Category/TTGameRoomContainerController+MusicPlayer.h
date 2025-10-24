//
//  TTGameRoomContainerController+MusicPlayer.h
//  TuTu
//
//  Created by KevinWang on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomContainerController.h"
#import "TTMusicEntrance.h"
#import "TTMusicPlayerView.h"
//vc
#import "TTMusicListController.h"

@interface TTGameRoomContainerController (MusicPlayer)
<
    TTMusicEntranceDelegate,
    TTMusicPlayerViewDelegate,
    TTMusicListControllerDelegate
>
@end
