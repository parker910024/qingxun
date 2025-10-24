//
//  TTGameRoomViewController+ChatMessage.h
//  TTPlay
//
//  Created by Jenkins on 2019/3/7.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (ChatMessage)
/**
 显示房间内消息
 */
- (void)showRoomChatMessage;

- (void)roomChatGotoUserWith:(UserID)uid controller:(UIViewController *)controller;

/** 找人私聊*/
- (void)roomChatGotoUserWith:(UserID)uid;

/** 点击空白的地方View消失*/
- (void)chatRoomHiddenWhenTouchView;
@end

NS_ASSUME_NONNULL_END
