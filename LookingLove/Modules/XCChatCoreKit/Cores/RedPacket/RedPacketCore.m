//
//  RedPacketCore.m
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "RedPacketCore.h"
#import "HttpRequestHelper+RedPacket.h"
#import "RedPacketCoreClient.h"
#import "ImMessageCore.h"
#import "NSObject+YYModel.h"
#import "AuthCore.h"
#import "NSString+JsonToDic.h"
#import "UserCore.h"
#import "FamilyCore.h"
#import "XCKeyWordTool.h"

@implementation RedPacketCore

- (void)queryRedPacketDetailByRedId:(NSInteger)redPacketId teamId:(NSInteger)teamId {
    [HttpRequestHelper requestRedPacketDetailByTeamId:teamId redPacketId:redPacketId Success:^(RedPacketDetailInfo *info) {
        NotifyCoreClient(RedPacketCoreClient, @selector(queryRedPacketDetailSuccess:), queryRedPacketDetailSuccess:info);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RedPacketCoreClient, @selector(queryRedPacketDetailFailth:), queryRedPacketDetailFailth:message);
    }];
}

- (void)getRedByRedPacketId:(NSInteger)redPacketId
                     teamId:(NSInteger)teamId
                    message:(NIMMessage *)message
                    success:(void (^)(RedPacketDetailInfo *info))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    [HttpRequestHelper getRedByRedId:redPacketId teamId:teamId Success:^(RedPacketDetailInfo *info) {
        RedPacketDetailInfo *redInfo = [RedPacketDetailInfo yy_modelWithJSON:message.localExt];
        redInfo.status = info.status;
        redInfo.amount = info.amount;
        redInfo.receiveUid = [GetCore(AuthCore)getUid].userIDValue;
        redInfo.receiveNick = [GetCore(UserCore)getUserInfoInDB:redInfo.receiveUid].nick;
        message.localExt = [redInfo model2dictionary];
        success(redInfo);
        NotifyCoreClient(RedPacketCoreClient, @selector(getRedPacketSuccess:), getRedPacketSuccess:info);
        [GetCore(ImMessageCore)updateMessage:message session:message.session];
        //发送抢到[XCKeyWordTool sharedInstance].xcRedColor的tips
//        [GetCore(ImMessageCore)sendTipsMessage:@{@"nick":[GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue].nick.length > 0 ? [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue].nick : @"" , @"uid":[GetCore(AuthCore)getUid]} sessionId:message.session.sessionId type:message.session.sessionType];
        if (redInfo.status == RedPacketStatus_DidOpen) {
            Attachment *attachment = [[Attachment alloc]init];
            attachment.first = Custom_Noti_Header_Group_RedPacket;
            attachment.second = Custom_Noti_Sub_Header_Group_RedPacket_Tips;
            attachment.data = [redInfo model2dictionary];
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:message.session.sessionId type:message.session.sessionType needApns:NO apnsContent:nil];
            [GetCore(FamilyCore) fetchFamilyMoneyManaegerWith:[GetCore(AuthCore) getUid]];
        }
    } failure:^(NSNumber *resCode, NSString *msg) {
        [self handlegetRedPacketErrorWithRedCode:[resCode integerValue] message:message];
        NotifyCoreClient(RedPacketCoreClient, @selector(getRedpacketFailth:), getRedpacketFailth:msg);
    }];
}

- (void)sendARedPacketMoney:(NSString *)money
                      count:(NSString *)count
                     teamId:(NSInteger)teamId
                    message:(NSString *)message {
    [HttpRequestHelper sendRedPacketByMoney:money count:count teamId:teamId message:message success:^(RedPacketDetailInfo *info) {
        if (info) {
            Attachment *attachment = [[Attachment alloc]init];
            attachment.first = Custom_Noti_Header_Group_RedPacket;
            attachment.second = Custom_Noti_Sub_Header_Group_RedPacket_Send;
            RedPacketDetailInfo *red = [[RedPacketDetailInfo alloc]init];
            red.message = message;
            red.senderUid = [GetCore(AuthCore)getUid].userIDValue;
            red.id = info.id;
            red.avatar = [GetCore(UserCore) getUserInfoInDB:red.senderUid].avatar;
            red.nick = [GetCore(UserCore) getUserInfoInDB:red.senderUid].nick;
            red.tid = info.tid;
            red.status = RedPacketStatus_NotOpen;
            attachment.data = [red model2dictionary];
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:[NSString stringWithFormat:@"%ld",(long)info.tid] type:(NIMSessionType)NIMSessionTypeTeam needApns:YES apnsContent:[NSString stringWithFormat:@"你收到了一个%@",[XCKeyWordTool sharedInstance].xcRedColor]];
            [GetCore(FamilyCore) fetchFamilyMoneyManaegerWith:[GetCore(AuthCore) getUid]];
            NotifyCoreClient(RedPacketCoreClient, @selector(sendRedPacketSuccess), sendRedPacketSuccess);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RedPacketCoreClient, @selector(sendRedPacketFailth:), sendRedPacketFailth:message);
    }];
}

#pragma mark - Private
//7016,"[XCKeyWordTool sharedInstance].xcRedColor不存在"
//
//7018,"该[XCKeyWordTool sharedInstance].xcRedColor已经领取过"
//
//7019,"[XCKeyWordTool sharedInstance].xcRedColor已领完"
//
//7022,"[XCKeyWordTool sharedInstance].xcRedColor已经过期"
//
//7005,"消息已过期"
//
//7003,"你被该家族拒绝"
//
//7002,"你已经加入了该家族"
- (void)handlegetRedPacketErrorWithRedCode:(NSInteger)resCode message:(NIMMessage *)message {
    if (message.localExt) {
        RedPacketDetailInfo *redInfo = [RedPacketDetailInfo yy_modelWithJSON:message.localExt];
        switch (resCode) {
            case 7019: //[XCKeyWordTool sharedInstance].xcRedColor已领完
            {
                redInfo.status = RedPacketStatus_OutBouns;
            }
                break;
            case 7018: //该[XCKeyWordTool sharedInstance].xcRedColor已经领取过
            {
                redInfo.status = RedPacketStatus_DidOpen;
                
            }
                break;
            case 7022: //[XCKeyWordTool sharedInstance].xcRedColor已经过期
            {
                redInfo.status = RedPacketStatus_OutDate;
            }
                break;
            default:
                break;
        }
        message.localExt = [redInfo model2dictionary];
        [GetCore(ImMessageCore)updateMessage:message session:message.session];
    }
    
}

@end
