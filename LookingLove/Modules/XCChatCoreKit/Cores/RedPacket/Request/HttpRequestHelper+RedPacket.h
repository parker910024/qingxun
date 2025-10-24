//
//  HttpRequestHelper+RedPacket.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "RedPacketDetailInfo.h"

@interface HttpRequestHelper (RedPacket)

/**
 请求[XCKeyWordTool sharedInstance].xcRedColor详情
 
 @param teamId 群ID
 @param success 成功
 @param failure 失败
 */
+ (void)requestRedPacketDetailByTeamId:(NSInteger)teamId
                           redPacketId:(NSInteger)redPacketId
                        Success:(void (^) (RedPacketDetailInfo *))success
                        failure:(void (^) (NSNumber *, NSString *))failure;


/**
 抢[XCKeyWordTool sharedInstance].xcRedColor

 @param redPacketId [XCKeyWordTool sharedInstance].xcRedColorid
 @param teamId 群聊id
 @param success 成功
 @param failure 失败
 */
+ (void)getRedByRedId:(NSInteger)redPacketId
               teamId:(NSInteger)teamId
              Success:(void (^) (RedPacketDetailInfo *))success
              failure:(void (^) (NSNumber *, NSString *))failure;

/**
 发送[XCKeyWordTool sharedInstance].xcRedColor

 @param money 价格
 @param count 数量
 @param message 消息
 @param teamId 团队ID
 @param success 成功
 @param failure 失败
 */
+ (void)sendRedPacketByMoney:(NSString *)money
                       count:(NSString *)count
                      teamId:(NSInteger)teamId
                     message:(NSString *)message
                     success:(void (^)(RedPacketDetailInfo *info))success
                     failure:(void (^)(NSNumber *, NSString *))failure;

@end
