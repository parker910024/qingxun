//
//  LittleWorldWoreToastClient.h
//  AFNetworking
//
//  Created by apple on 2019/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LittleWorldWoreToastClient <NSObject>
@optional

/** 加入小世界成功 */
- (void)memberEnterlittleWorldSuccessWithWorldId:(long long)worldId isFromRoom:(BOOL)isFromRoom;

/** 小秘书消息回调  加入小世界成功 */
- (void)smallSecretaryJoinWorldletSuccessWithWorldId:(long long)worldId isFromRoom:(BOOL)isFromRoom;
@end

NS_ASSUME_NONNULL_END
