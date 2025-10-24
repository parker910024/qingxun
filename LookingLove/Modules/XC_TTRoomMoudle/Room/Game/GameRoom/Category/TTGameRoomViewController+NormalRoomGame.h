//
//  TTGameRoomViewController+NormalRoomGame.h
//  TTPlay
//
//  Created by new on 2019/3/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (NormalRoomGame)<TTCPGameListViewDelegate,TTMessageViewDelegate,WBGameViewDelegate,RoomCoreClient>

// 开启游戏模式
- (void)normalRoomOperGameModel;

- (void)miniRoomAndCancelMyGameStatusWithMessage:(NIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
