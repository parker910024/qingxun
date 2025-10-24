//
//  TTPublicChatroomMessageProvider.h
//  TuTu
//
//  Created by 卫明 on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicChatroomMessageProvider : NSObject

@property (nonatomic,assign) NSTimeInterval firstTimeInterval;

/**
 首页公聊大厅的消息
 */
@property (strong, nonatomic) NSMutableArray *modelMessages;


+ (instancetype)shareProvider;

- (void)fetchHistoryMessageByChatroomId:(NSString *)chatroomId
                                  count:(NSInteger)count
                              startTime:(NSTimeInterval)startTime;

@end

NS_ASSUME_NONNULL_END
