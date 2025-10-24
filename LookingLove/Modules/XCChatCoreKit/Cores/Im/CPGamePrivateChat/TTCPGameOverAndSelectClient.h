//
//  TTCPGameOverAndSelectClient.h
//  XCChatCoreKit
//
//  Created by new on 2019/2/27.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTCPGameOverAndSelectClient <NSObject>

/*
 
 收到再来一局的通知
 
 */
- (void)receiveAgainGameAction;


/*
 
 收到换个游戏的通知
 
 */
- (void)receiveChangeGameAction;


/*
 
 发送同意再来一局的通知
 
 */
- (void)sendAgreePlayGameAgainAction;


/*
 
 收到对方离开的通知
 
 */
- (void)receiveAnotherOneLiveGameAction;


// 进入游戏页面了，通知销毁定时器
- (void)enterGamePageDestructionTimer;


// 手机时间不对时。游戏倒计时  误差在半小时之内
- (void)gameTimeWasWrongAndRrefresh:(NIMMessage *)message;


/*
 
 收到对方发表情的通知
 
 */
- (void)receiveAnotherOneSendFaceAcitonWithFaceString:(NSString *)faceString;

@end

NS_ASSUME_NONNULL_END
