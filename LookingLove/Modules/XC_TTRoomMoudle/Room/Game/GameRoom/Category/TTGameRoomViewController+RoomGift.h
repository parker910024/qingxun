//
//  TTGameRoomViewController+RoomGift.h
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"
#import "TTOpenNobleTipCardView.h"
#import "TTSendGiftView.h"

@interface TTGameRoomViewController (RoomGift)<TTSendGiftViewDelegate,TTOpenNobleTipCardViewDelegate>

//展示礼物面板
- (void)ttShowSendGiftViewType:(SelectGiftType)type targetUid:(UserID)targetUid;

@end
