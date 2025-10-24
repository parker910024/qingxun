//
//  AuctionCore.m
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "AuctionCore.h"
#import "AuthCore.h"
#import "AuctionCoreClient.h"
#import "HttpRequestHelper+Auction.h"
#import "ImRoomCoreClient.h"
#import "ImMessageCoreClient.h"
#import "Attachment.h"
#import "ImRoomCoreV2.h"
#import "ImRoomCoreClientV2.h"

#import "NSObject+YYModel.h"

@interface AuctionCore()<ImRoomCoreClient,ImRoomCoreClientV2,ImMessageCoreClient>

@end

@implementation AuctionCore
- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(ImRoomCoreClient, self);
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(ImRoomCoreClientV2, self);
    }
    return self;
}

- (void)dealloc{
    
    RemoveCoreClient(ImRoomCoreClient, self);
    RemoveCoreClient(ImMessageCoreClient, self);
}

- (void)startAuction:(UserID)uid auctUid:(UserID)auctUid auctMoney:(NSInteger)auctMoney servDura:(NSInteger)servDura minRaiseMoney:(NSInteger)minRaiseMoney auctDesc:(NSString *)auctDesc
{
    if (uid <= 0) {
        return;
    }
    
    [HttpRequestHelper startAuction:uid auctUid:auctUid auctMoney:auctMoney servDura:servDura minRaiseMoney:minRaiseMoney auctDesc:auctDesc success:^(AuctionInfo *auctionInfo) {
        NotifyCoreClient(AuctionCoreClient, @selector(onStartAuctionSuccess:), onStartAuctionSuccess:auctionInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuctionCoreClient, @selector(onStartAuctionFailth:message:), onStartAuctionFailth:resCode message:message);
    }];
}

- (void) upAuction:(UserID)uid auctId:(NSString *)auctId roomUid:(UserID)roomUid type:(NSInteger)type money:(NSInteger)money
{
    if (uid <= 0) {
        return;
    }
    
    [HttpRequestHelper upAuction:uid auctId:auctId roomUid:roomUid type:type money:money success:^(AuctionInfo *auctionInfo) {
        NotifyCoreClient(AuctionCoreClient, @selector(onUpAuctionSuccess:), onUpAuctionSuccess:auctionInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuctionCoreClient, @selector(onUpAuctionFailth:message:), onUpAuctionFailth:resCode message:message);
    }];
}

- (void)finishAuction:(UserID)uid auctId:(NSString *)auctId
{
    if (uid <= 0) {
        return;
    }
    
    [HttpRequestHelper finishAuction:uid auctId:auctId success:^(AuctionInfo *auctionInfo) {
        NotifyCoreClient(AuctionCoreClient, @selector(onFinishAuctionSuccess:), onFinishAuctionSuccess:auctionInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuctionCoreClient, @selector(onFinishAuctionFailth:message:), onFinishAuctionFailth:resCode message:message);
    }];
}

- (void)requestCurrentAuction:(UserID)uid
{
    if (uid <= 0) {
        return;
    }
    
    [HttpRequestHelper getAuction:uid success:^(AuctionInfo *auctionInfo) {
        self.currentAuction = auctionInfo;
        NotifyCoreClient(AuctionCoreClient, @selector(onCurrentAuctionInfoUpdate:), onCurrentAuctionInfoUpdate:auctionInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
    }];
}

//获取周榜
- (void) fetchAuctionWeeklyList:(NSString *)roomUid {
    [HttpRequestHelper fetchAuctionWeeklyListWith:roomUid success:^(NSArray *weeklyList) {
        NotifyCoreClient(AuctionCoreClient, @selector(onFetchAuctionListWeeklySuccess:), onFetchAuctionListWeeklySuccess:weeklyList);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuctionCoreClient, @selector(onFetchAuctionListWeeklyFailth:), onFetchAuctionListWeeklyFailth:message);
    }];
}


//获取总榜
- (void)fetchAuctionTotallyList:(NSString *)roomUid {
   [HttpRequestHelper fetchAuctionTotalListWith:roomUid success:^(NSArray *totallyList) {
       NotifyCoreClient(AuctionCoreClient, @selector(onFetchAuctionListTotallySuccess:), onFetchAuctionListTotallySuccess:totallyList);
   } failure:^(NSNumber *resCode, NSString *message) {
       NotifyCoreClient(AuctionCoreClient, @selector(onFetchAuctionListTotallyFailth:), onFetchAuctionListTotallyFailth:message);
   }];
}

#pragma mark - ImRoomCoreClient
- (void)onConnectionStateChanged:(NIMChatroomConnectionState)state
{
    if (state == NIMChatroomConnectionStateEnterOK) {
//        [self requestCurrentAuction:GetCore(ImRoomCoreV2).currentRoomInfo.uid];
    }
}

- (void)onMeExitChatRoomSuccessV2
{
    self.currentAuction = nil;
}

- (void)onUserBeKicked:(NSString *)roomid reason:(NIMChatroomKickReason)reason
{
    self.currentAuction = nil;
}

#pragma mark - ImMessageCoreClient
- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg
{
    if (GetCore(ImRoomCoreV2).currentRoomInfo.roomId != [msg.session.sessionId integerValue]) {
        return;
    }
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        if (attachment.first == Custom_Noti_Header_Auction) {
            if (attachment.data != nil) {
                self.currentAuction = [AuctionInfo yy_modelWithDictionary:attachment.data];
                if (attachment.second == Custom_Noti_Sub_Auction_Start) {
                    NotifyCoreClient(AuctionCoreClient, @selector(onAuctionStart:), onAuctionStart:self.currentAuction);
                } else if (attachment.second == Custom_Noti_Sub_Auction_Finish) {
                    self.currentAuction = nil;
                    NotifyCoreClient(AuctionCoreClient, @selector(onAuctionWillFinished:), onAuctionWillFinished:[AuctionInfo yy_modelWithDictionary:attachment.data]);
                } else if (attachment.second == Custom_Noti_Sub_Auction_Update) {
                    NotifyCoreClient(AuctionCoreClient, @selector(onCurrentAuctionInfoUpdate:), onCurrentAuctionInfoUpdate:self.currentAuction);
                }
            }
        }
    }
}

@end
