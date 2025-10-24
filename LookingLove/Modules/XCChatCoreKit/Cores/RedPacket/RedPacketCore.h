//
//  RedPacketCore.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import <NIMSDK/NIMSDK.h>
#import "RedPacketDetailInfo.h"

@interface RedPacketCore : BaseCore

- (void)queryRedPacketDetailByRedId:(NSInteger)redPacketId teamId:(NSInteger)teamId;
- (void)getRedByRedPacketId:(NSInteger)redPacketId
                     teamId:(NSInteger)teamId
                    message:(NIMMessage *)message
                    success:(void (^)(RedPacketDetailInfo *info))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;
- (void)sendARedPacketMoney:(NSString *)money
                      count:(NSString *)count
                     teamId:(NSInteger)teamId
                    message:(NSString *)message;
@end
