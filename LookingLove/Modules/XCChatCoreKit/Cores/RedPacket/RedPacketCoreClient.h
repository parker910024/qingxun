//
//  RedPacketClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedPacketDetailInfo.h"

@protocol RedPacketCoreClient <NSObject>
@optional
- (void)queryRedPacketDetailSuccess:(RedPacketDetailInfo *)info;
- (void)queryRedPacketDetailFailth:(NSString *)message;
- (void)getRedPacketSuccess:(RedPacketDetailInfo *)info;
- (void)getRedpacketFailth:(NSString *)message;
- (void)sendRedPacketSuccess;
- (void)sendRedPacketFailth:(NSString *)message;


@end
