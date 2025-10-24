//
//  HttpRequestHelper+RedPacket.m
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+RedPacket.h"
#import "NSObject+YYModel.h"
#import "AuthCore.h"
#import "FamilyCore.h"

@implementation HttpRequestHelper (RedPacket)

+ (void)requestRedPacketDetailByTeamId:(NSInteger)teamId redPacketId:(NSInteger)redPacketId Success:(void (^)(RedPacketDetailInfo *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"family/red_packet/record";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(teamId) forKey:@"tid"];
    [params setObject:@(redPacketId) forKey:@"redPacketId"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        RedPacketDetailInfo *info = [RedPacketDetailInfo yy_modelWithDictionary:data[@"redPacket"]];
        info.moneyName = [GetCore(FamilyCore) getFamilyModel].moneyName;
        info.records = [NSArray yy_modelArrayWithClass:[RedPacketRecordInfo class] json:data[@"records"]];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)getRedByRedId:(NSInteger)redPacketId teamId:(NSInteger)teamId Success:(void (^)(RedPacketDetailInfo *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/red_packet/claim";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(teamId) forKey:@"tid"];
    [params setObject:@(redPacketId) forKey:@"redPacketId"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        RedPacketDetailInfo *info = [RedPacketDetailInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)sendRedPacketByMoney:(NSString *)money
                       count:(NSString *)count
                      teamId:(NSInteger)teamId
                     message:(NSString *)message
                     success:(void (^)(RedPacketDetailInfo *info))success
                     failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/red_packet/dispatch";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(teamId) forKey:@"tid"];
    [params setObject:money forKey:@"amount"];
    [params setObject:count forKey:@"count"];
    if (message.length > 0) {
        [params setObject:message forKey:@"message"];
    }else {
        [params setObject:@"恭喜发财，大吉大利！" forKey:@"message"];
    }
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        RedPacketDetailInfo *info = [RedPacketDetailInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];

}

@end
