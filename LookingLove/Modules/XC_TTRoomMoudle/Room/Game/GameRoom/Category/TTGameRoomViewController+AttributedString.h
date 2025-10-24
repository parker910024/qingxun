//
//  TTGameRoomViewController+AttributedString.h
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"

@interface TTGameRoomViewController (AttributedString)

//创建房间title
- (NSMutableAttributedString *)creatRoomTitle:(NSString *)roomTitle;

//靓/id/在线人数
- (NSMutableAttributedString *)creatRoomBeauty_ID:(UserInfo *)userInfo onLineCount:(int)count;

// lock/effect/高音质
- (NSMutableAttributedString *)creatRoomLock_GiftEffect_HighAudio:(RoomInfo *)roomInfo;
@end
