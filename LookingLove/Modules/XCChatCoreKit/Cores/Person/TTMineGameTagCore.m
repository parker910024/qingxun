//
//  TTMineGameTagCore.m
//  XCChatCoreKit
//
//  Created by new on 2019/3/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMineGameTagCore.h"
#import "HttpRequestHelper+GameTag.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "RoomQueueCoreV2.h"

#import "RoomQueueCoreClient.h"
#import "ImRoomCoreClient.h"
#import "NSDictionary+JSON.h"
#import "NSString+JsonToDic.h"
#import <NIMSDK/NIMSDK.h>

@interface TTMineGameTagCore () <ImRoomCoreClient>

@end

@implementation TTMineGameTagCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(ImRoomCoreClient, self);
    }
    return self;
}

- (RACSignal *)personPageGameTagDeleteOrUserWithLiveId:(NSInteger )liveId WithStatus:(NSInteger )status{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper personPageGameTagDeleteOrUserWithLiveId:liveId WithStatus:status success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (void)userUpdateHeadWear {
    [[GetCore(UserCore) getUserInfoByRac:[GetCore(AuthCore) getUid].userIDValue refresh:YES]subscribeNext:^(id x) {
        if (x) {
            UserInfo *userInfo = (UserInfo *)x;
            NIMChatroomMemberInfoUpdateRequest *request = [[NIMChatroomMemberInfoUpdateRequest alloc]init];
            if (userInfo.userHeadwear) {
                UserHeadWear *headWear = userInfo.userHeadwear;
                NSDictionary *extSource = [headWear model2dictionary];
                NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithObject:extSource forKey:[GetCore(AuthCore) getUid]];
                request.updateInfo = [NSDictionary dictionaryWithObject:[ext toJSONWithPrettyPrint:YES] forKey:@(NIMChatroomMemberInfoUpdateTagExt)];
                request.notifyExt = [ext yy_modelToJSONString];

            }else {
                NSDictionary *empty = [NSDictionary dictionary];
                request.updateInfo = [NSDictionary dictionaryWithObject:[empty yy_modelToJSONString] forKey:@(NIMChatroomMemberInfoUpdateTagExt)];
                request.notifyExt = @"";
            }
            [GetCore(ImRoomCoreV2) updateMyRoomMemberInfoWithrequest:request];
        }
    }];
}

- (void)onUpdateRoomMemberInfoSuccess:(NIMChatroomMemberInfoUpdateRequest *)request {
    
    NIMChatroomMembersByIdsRequest *request2 = [[NIMChatroomMembersByIdsRequest alloc]init];
    request2.roomId = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
    NSString *userId = [GetCore(AuthCore) getUid];
    request2.userIds = @[userId];
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request2 completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        if (error == nil) {
            if (members.count > 0) {
                
                NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:[GetCore(AuthCore) getUid].userIDValue];
                ChatRoomMicSequence *micSequence = GetCore(ImRoomCoreV2).micQueue[position];
                micSequence.chatRoomMember = members.firstObject;
            }
        }else {
            
        }
    }];
    
}
@end
