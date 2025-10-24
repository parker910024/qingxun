//
//  TTBlindDateCoreClient.h
//  WanBan
//
//  Created by jiangfuyuan on 2020/10/25.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTBlindDateCoreClient <NSObject>

- (void)updateLoveRoomProcedureFailure:(NSString *)msg;

- (void)updateLoveRoomPublicLoveWithPosition:(NSString *)position choosePosition:(NSString *)chooseUid chooseMic:(NSString *)chooseMic;
 
- (void)countDownTimer:(NSInteger)time;
@end

NS_ASSUME_NONNULL_END
