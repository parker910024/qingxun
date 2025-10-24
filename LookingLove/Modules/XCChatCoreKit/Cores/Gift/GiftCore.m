//
//  GiftCore.m
//  BberryCore
//
//  Created by chenran on 2017/7/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "GiftCore.h"
#import "HttpRequestHelper+Gift.h"
#import "GiftCoreClient.h"

#import "VersionCore.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "RoomCoreV2.h"
#import "RoomCoreClient.h"
#import "ImRoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "PublicChatroomCore.h"
#import "ImPublicChatroomCore.h"

#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"

#import "TTPopup.h"
#import "XCHUDTool.h"
#import "XCTheme.h"
#import "XCHtmlUrl.h"
#import "TTWKWebViewViewController.h"
#import "XCCurrentVCStackManager.h"
#import "TTSendGiftLimitView.h"

#import "Attachment.h"
#import "UserInfo.h"
#import "GiftInfoStorage.h"
#import "GiftReceiveInfo.h"
#import "GiftAllMicroSendInfo.h"
#import "GiftChannelNotifyInfo.h"
#import "ActivityBoxAllMicroGiftInfo.h"

#import "NSObject+YYModel.h"
#import "NSString+JsonToDic.h"


#import <SDWebImageDownloader.h>
#import <SDImageCache.h>
#import <SDWebImageManager.h>

#import "NSArray+Safe.h"
#import "TTMp4PlayerTool.h"

#import "HttpErrorClient.h"

NSString *const luckyAllMicroKey = @"luckyGiftList";
NSString *const kPagerKer = @"pager";

@interface GiftCore()<ImMessageCoreClient,RoomCoreClient>
@property (nonatomic, strong) NSMutableArray<GiftInfo *> *giftInfos;
/// 盲盒奖励礼物列表
@property (nonatomic, strong) NSArray<GiftInfo *> *prizeGifts;
/** key:房间id value:房间对应的礼物列表 */
@property (nonatomic, strong) NSCache<NSNumber *, NSArray *> *roomGiftCache;

@property (nonatomic, strong) dispatch_source_t timer; //计时器
@property (strong, nonatomic) NSTimer *retryTimer;
@property (nonatomic,assign) NSInteger retryCount;
@end
@implementation GiftCore

- (instancetype)init{
    
    self = [super init];
    if (self) {
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(RoomCoreClient, self);
        _giftInfos = [GiftInfoStorage getGiftInfos];
        [self requestGiftList];
        [[self getPrizeGiftList] subscribeNext:^(id  _Nullable x) {
            
        } error:^(NSError * _Nullable error) {
            
        }];
    }
    return self;
}

- (void)dealloc{
    
    RemoveCoreClientAll(self);
}


- (NSMutableArray *)getGameRoomGift {
    return [self getGameRoomGiftType:GameRoomGiftType_Normal];
}

- (NSMutableArray *)getGameRoomGiftType:(GameRoomGiftType)type {

    return [self getGameRoomGiftType:type giftList:self.giftInfos];
}

/**
 根据type获取房间普通礼物(萝卜+普通+房间专属) 或者 贵族礼物
 
 @param type （普通礼物&贵族礼物）
 @param roomUid 房间uid 传0则 普通礼物(萝卜+普通) 或者 贵族礼物
 @return 礼物数组
 */
- (NSMutableArray *)getGameRoomGiftType:(GameRoomGiftType)type roomUid:(NSInteger)roomUid {
    
    if (roomUid == 0) {
        return [self getGameRoomGiftType:type];
    }
    
    NSArray *giftLists = [self.roomGiftCache objectForKey:@(roomUid)];
    if (giftLists.count == 0) {
        [self requestGiftListWithRoomUid:roomUid];
        return nil;
    }
    
    return [self getGameRoomGiftType:type giftList:giftLists.copy];
}

- (NSMutableArray *)getGameRoomGiftType:(GameRoomGiftType)type giftList:(NSMutableArray *)giftList {
    NSMutableArray *arr = [NSMutableArray array];
    UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
    
    [giftList enumerateObjectsUsingBlock:^(GiftInfo * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.giftType == GiftType_Game) {
            
            if (type == GameRoomGiftType_Normal &&
                !item.isNobleGift) {
                // 普通非贵族礼物
                [arr addObject:item];
                
            } else if (type == GameRoomGiftType_Noble &&
                       item.isNobleGift){
                
                // 贵族礼物
                if (myInfo.nobleUsers.level <= 0) {
                    if (item.nobleId<=1) {
                        [arr addObject:item];
                    }
                } else {
                    if (myInfo.nobleUsers.level>=item.nobleId) {
                        [arr addObject:item];
                    }
                }
            }
        }
    }];
    return arr;
}

- (void)getPackGift {
    
    [HttpRequestHelper getPackGiftSuccess:^(NSArray<GiftInfo *> *info) {
        [info enumerateObjectsUsingBlock:^(GiftInfo * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if (item.mp4Url.length > 0) {
                [TTMp4PlayerTool defaultPlayerTool].info = item;
            }
        }];
        NotifyCoreClient(GiftCoreClient, @selector(onBackPackGiftSuccess:), onBackPackGiftSuccess:info);
    } failure:^(NSNumber *resCode, NSString *message) {
        NSString *error = [NSString stringWithFormat:@"code=%@ %@", resCode, message];
        NotifyCoreClient(GiftCoreClient, @selector(onBackPackGiftFailed:), onBackPackGiftFailed:error);
    }];
    
}

- (RACSignal *)getPrizeGiftList {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HttpRequestHelper requestPrizeGiftListAndCompletionHandler:^(id data, NSNumber *code, NSString *msg) {
            NSArray<GiftInfo *> *list = [GiftInfo modelsWithArray:data[@"gift"]];
            [list enumerateObjectsUsingBlock:^(GiftInfo * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
                if (item.mp4Url.length > 0) {
                    [TTMp4PlayerTool defaultPlayerTool].info = item;
                }
            }];
            self.prizeGifts = list;
            NotifyCoreClient(GiftCoreClient, @selector(onRequestPrizeGiftList:code:msg:), onRequestPrizeGiftList:list code:code.integerValue msg:msg);
            if (data) {
                [subscriber sendNext:@(YES)];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

/**
 请求普通礼物列表
 */
- (void)requestGiftList{
    
    if (self.retryTimer != nil) {
        [self.retryTimer invalidate];
        self.retryTimer = nil;
    }
    @weakify(self)
    [HttpRequestHelper requestGiftList:^(NSArray *list) {
        @strongify(self)
        self.giftInfos = [list mutableCopy];
        [GiftInfoStorage saveGiftInfos:[list yy_modelToJSONString]];
        NotifyCoreClient(GiftCoreClient, @selector(onGiftIsRefresh), onGiftIsRefresh);
    } failure:^(NSNumber *resCode, NSString *message) {

        @strongify(self)
        if (self.retryCount < 3) {
            self.retryCount ++;
            self.retryTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(requestGiftList) userInfo:nil repeats:NO];
        }

    }];
}

/**
 请求房间礼物列表 (普通礼物 + 房间专属礼物)
 */
- (void)requestGiftListWithRoomUid:(NSInteger)roomUid {
    
    if (roomUid == 0) {
        return;
    }
    
//    NSArray *giftList = [self.roomGiftCache objectForKey:@(roomUid)];
//    if (giftList.count) {
//        NotifyCoreClient(GiftCoreClient, @selector(onGiftIsRefresh), onGiftIsRefresh);
//        return;
//    }
    
    @weakify(self)
    [HttpRequestHelper requestGiftListWithRoomUid:roomUid success:^(NSArray *list) {
        @strongify(self)
        [self.roomGiftCache setObject:list forKey:@(roomUid)];
        NotifyCoreClient(GiftCoreClient, @selector(onGiftIsRefresh), onGiftIsRefresh);
        [list enumerateObjectsUsingBlock:^(GiftInfo * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if (item.mp4Url.length > 0) {
                [TTMp4PlayerTool defaultPlayerTool].info = item;
            }
        }];
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GiftCoreClient, @selector(onRequestGiftListFailth:roomUid:), onRequestGiftListFailth:message roomUid:roomUid);
    }];
}

/**
 开箱子 爆全麦
 
 @param recordId 中奖记录id
 @param targetUids 接收人ids
 @param roomUid 房主id
 @param code 验证码
 */
- (void)sendBoxAllMicGiftRecordId:(NSInteger)recordId
                       targetUids:(NSString *)targetUids
                          roomUid:(NSInteger)roomUid
                             code:(NSString *)code {
    [HttpRequestHelper sendBoxAllMicroGiftRecordId:recordId targetUids:targetUids roomUid:roomUid code:code success:^(GiftAllMicroSendInfo *info) {
        if (targetUids.length) {
            Attachment *attachement = [[Attachment alloc]init];
            attachement.first = Custom_Noti_Header_Box;
            attachement.second = Custom_Noti_Sub_Box_InRoom_AllMicSend;
            attachement.data = [info model2dictionary];
            NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        }
    } failure:^(NSNumber *error, NSString *msg) {
        
    }];
}

/**
 发送 私聊 福袋 礼物
 
 @param giftInfo 福袋礼物
 @param info 被赠送人
 @param targetUid 被赠送人uid
 */
- (void)sendChatLuckyGift:(GiftInfo *)giftInfo info:(UserInfo *)info targetUid:(UserID)targetUid {
    
    @weakify(self);
    [HttpRequestHelper sendLuckyGift:giftInfo.giftId targetUid:targetUid type:SendGiftType_Person success:^(GiftAllMicroSendInfo *info) {
        @strongify(self);
        if (info.nick.length > 0) {
            Attachment *attachement = [[Attachment alloc]init];
            attachement.first = Custom_Noti_Header_Gift;
            attachement.second = Custom_Noti_Sub_Gift_LuckySend;
            attachement.data = [info model2dictionary];
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%lld",targetUid] type:NIMSessionTypeP2P needApns:YES apnsContent:[NSString stringWithFormat:@"%@给你送了%d个礼物",info.nick,1]];
        }
        info.giftId = giftInfo.giftId;
        info.gift = giftInfo;
        info.giftInfo = giftInfo;
        [self minusGold:info];
    } failure:^(NSNumber *errorCode, NSString *msg) {
        
    }];
}

/**
 发送 房间 福袋 礼物 一对一
 
 @param giftInfo 福袋礼物
 @param targetUid 被赠送人uid
 */
- (void) sendRoomLuckyGift:(GiftInfo *)giftInfo targetUid:(UserID)targetUid {
    
    @weakify(self);
    [HttpRequestHelper sendLuckyGift:giftInfo.giftId targetUid:targetUid type:SendGiftType_RoomToPerson success:^(GiftAllMicroSendInfo *info) {
        @strongify(self);
        Attachment *attachement = [[Attachment alloc]init];
        attachement.first = Custom_Noti_Header_Gift;
        attachement.second = Custom_Noti_Sub_Gift_LuckySend;
        attachement.data = [info model2dictionary];
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        info.giftId = giftInfo.giftId;
        info.gift = giftInfo;
        info.giftInfo = giftInfo;
        [self minusGold:info];
    } failure:^(NSNumber *errorCode, NSString *msg) {
        
    }];
}


/**
 发送 房间全麦 福袋礼物
 
 @param uids 麦上用户
 @param uidsArray 麦上用户uid数组
 @param giftInfo 福袋礼物
 @param roomUid 房主id
 */
- (void)sendAllMicroLuckyGiftByUids:(NSString *)uids
                          uidsArray:(NSArray *)uidsArray
                             giftInfo:(GiftInfo *)giftInfo
                            roomUid:(NSInteger)roomUid {
    @weakify(self);
    [HttpRequestHelper sendAllMicroLuckyGiftByUids:uids giftId:giftInfo.giftId roomUid:roomUid success:^(NSArray<GiftReceiveInfo *> *infoArray) {
        
        NSMutableArray *giftInfoArray = [infoArray mutableCopy];
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        
        if (giftInfoArray.count <= 5) {
            
            Attachment *attachement = [[Attachment alloc]init];
            attachement.first = Custom_Noti_Header_ALLMicroSend;
            attachement.second = Custom_Noti_Sub_AllMicroLuckySend;
            //这里需要注意一下 云信消息不能超过  4kb
            attachement.data = @{luckyAllMicroKey:[giftInfoArray yy_modelToJSONString]};
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
            
        } else {
            
            NSArray *firstInfo = [giftInfoArray subarrayWithRange:NSMakeRange(0, 5)];
            Attachment *firstAttachement = [[Attachment alloc]init];
            firstAttachement.first = Custom_Noti_Header_Segment_AllMicSend;
            firstAttachement.second = Custom_Noti_Sub_Segment_AllMicSend_LuckBag;
            firstAttachement.data = @{luckyAllMicroKey:[firstInfo yy_modelToJSONString],
                                      kPagerKer:@"（1/2）"};
            [GetCore(ImMessageCore)sendCustomMessageAttachement:firstAttachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
            
            NSArray *secondInfo = [giftInfoArray subarrayWithRange:NSMakeRange(5, giftInfoArray.count - 5)];
            Attachment *secondAttachement = [[Attachment alloc]init];
            secondAttachement.first = Custom_Noti_Header_Segment_AllMicSend;
            secondAttachement.second = Custom_Noti_Sub_Segment_AllMicSend_LuckBag;
            secondAttachement.data = @{luckyAllMicroKey:[secondInfo yy_modelToJSONString],
                                       kPagerKer:@"（2/2）"};
            [GetCore(ImMessageCore)sendCustomMessageAttachement:secondAttachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
            
        }
        
        GiftAllMicroSendInfo *info = [[GiftAllMicroSendInfo alloc] init];
        info.giftId = giftInfo.giftId;
        info.gift = giftInfo;
        info.giftInfo = giftInfo;
        info.giftNum = 1;
        info.targetUids = uidsArray;
        [self minusGold:info];
        
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if ([resCode integerValue] == 8000) {
            [self requestGiftList];
            NotifyCoreClient(GiftCoreClient, @selector(onGiftIsOffLine:), onGiftIsOffLine:message);
        }
    }];
}

- (void)sendAllMicroGiftByUids:(NSString *)uids
                    microCount:(NSInteger)microCount
                        giftId:(NSInteger)giftId
                  gameGiftType:(GameRoomGiftType)gameGiftType
                       giftNum:(NSInteger)giftNum
                       roomUid:(NSInteger)roomUid
                           msg:(NSString *)msg{
    @weakify(self);
    [HttpRequestHelper sendAllMicroGiftByUids:uids giftId:giftId giftNum:giftNum gameGiftType:gameGiftType roomUid:roomUid msg:msg success:^(GiftAllMicroSendInfo *info) {
        @strongify(self);
        if (giftId != info.giftInfo.giftId) {
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:@"网络异常，请重试");
            if(gameGiftType == GameRoomGiftType_GiftPack){
                NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum: microCount:), onUpdatePackGiftWithGiftId:giftId giftNum:giftNum microCount:1);
            }else {
                GiftInfo *giftInfo = [GetCore(GiftCore)findGiftInfoByGiftId:giftId];
                info.giftInfo = giftInfo;
                info.giftId = giftId;
                [self minusGold:info];
            }
            return;
        }
        Attachment *attachement = [[Attachment alloc]init];
        attachement.first = Custom_Noti_Header_ALLMicroSend;
        attachement.second = Custom_Noti_Sub_AllMicroSend;
        attachement.data = [info model2dictionary];
        
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        
        if(gameGiftType == GameRoomGiftType_GiftPack){
            NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum:microCount:), onUpdatePackGiftWithGiftId:info.giftId giftNum:giftNum microCount:microCount);
        }else {
            [self minusGold:info];
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if ([resCode integerValue] == 8000) {
            [self requestGiftList];
            NotifyCoreClient(GiftCoreClient, @selector(onGiftIsOffLine:), onGiftIsOffLine:message);
        }
    }];
}



- (void)sendRoomGift:(NSInteger)giftId
        gameGiftType:(GameRoomGiftType)gameGiftType
           targetUid:(UserID)targetUid
                type:(SendGiftType)type
             giftNum:(NSInteger)giftNum
                 msg:(NSString *)msg{
    @weakify(self);
    [HttpRequestHelper sendGift:giftId targetUid:targetUid giftNum:giftNum gameGiftType:gameGiftType type:type msg:msg success:^(GiftAllMicroSendInfo *info) {
        @strongify(self);
        if (giftId != info.giftInfo.giftId) {
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:@"网络异常，请重试");
            if(gameGiftType == GameRoomGiftType_GiftPack){
                NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum: microCount:), onUpdatePackGiftWithGiftId:giftId giftNum:giftNum microCount:1);
            }else {
                GiftInfo *giftInfo = [GetCore(GiftCore)findGiftInfoByGiftId:giftId];
                info.targetUid = targetUid;
                info.giftInfo = giftInfo;
                info.giftId = giftId;
                [self minusGold:info];
            }
            return;
        }
        Attachment *attachement = [[Attachment alloc]init];
        attachement.first = Custom_Noti_Header_Gift;
        attachement.second = Custom_Noti_Sub_Gift_Send;
        attachement.data = [info model2dictionary];
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        if(gameGiftType == GameRoomGiftType_GiftPack){
            NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum: microCount:), onUpdatePackGiftWithGiftId:info.giftId giftNum:giftNum microCount:1);
        }else {
            [self minusGold:info];
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);   
        if ([resCode integerValue] == 8000) {
            [self requestGiftList];
            NotifyCoreClient(GiftCoreClient, @selector(onGiftIsOffLine:), onGiftIsOffLine:message);
        }
    }];
}

// 赠送礼物
- (void)sendRoomGift:(NSInteger)giftId
           targetUid:(UserID)targetUid
                type:(SendGiftType)type
             giftNum:(NSInteger)giftNum
                 msg:(NSString *)msg {
    @weakify(self);
    [HttpRequestHelper sendGift:giftId targetUid:targetUid giftNum:giftNum type:type msg:msg success:^(GiftAllMicroSendInfo *info) {
        @strongify(self);
        if (giftId != info.giftInfo.giftId) {
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:@"网络异常，请重试");
            
            GiftInfo *giftInfo = [GetCore(GiftCore)findGiftInfoByGiftId:giftId];
            info.targetUid = targetUid;
            info.giftInfo = giftInfo;
            info.giftId = giftId;
            [self minusGold:info];
            
            return;
        }
        Attachment *attachement = [[Attachment alloc]init];
        attachement.first = Custom_Noti_Header_Gift;
        attachement.second = Custom_Noti_Sub_Gift_Send;
        attachement.data = [info model2dictionary];
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        
        [self minusGold:info];
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if ([resCode integerValue] == 8000) {
            [self requestGiftList];
            NotifyCoreClient(GiftCoreClient, @selector(onGiftIsOffLine:), onGiftIsOffLine:message);
        }
    }];
}

//有了礼物背包的情况下 传一个新的类型 不改变以前的方法 在原来的方法上 重新写一个方法（防止出问题）
- (void)sendChatGift:(NSInteger)giftID
                info:(UserInfo *)info
             giftNum:(NSInteger)giftNum
        gameGiftType:(GameRoomGiftType)gameGiftType
           targetUid:(UserID)targetUid
                 msg:(NSString *)msg {
    
    __block NSInteger giftId = giftID;
    __block UserID targetUID = targetUid;
    __block UserInfo *userInfo = info;
    @weakify(self);
    [HttpRequestHelper sendGift:giftId targetUid:targetUID giftNum:giftNum type:SendGiftType_RoomToPerson msg:msg gameGiftType:gameGiftType  success:^(GiftAllMicroSendInfo *info) {
        if (giftId != info.giftInfo.giftId) {
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:@"网络异常，请重试");
            if(gameGiftType == GameRoomGiftType_GiftPack){
                NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum: microCount:), onUpdatePackGiftWithGiftId:giftId giftNum:giftNum microCount:1);
            }else {
                GiftInfo *giftInfo = [GetCore(GiftCore)findGiftInfoByGiftId:giftId];
                info.targetUid = targetUid;
                info.giftInfo = giftInfo;
                info.giftId = giftId;
                [self minusGold:info];
            }
            return;
        }
        if (userInfo.nick.length > 0) {
            
            Attachment *attachement = [[Attachment alloc]init];
            attachement.first = Custom_Noti_Header_Gift;
            attachement.second = Custom_Noti_Sub_Gift_Send;
            attachement.data = [info model2dictionary];
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%lld",targetUID] type:NIMSessionTypeP2P needApns:YES apnsContent:[NSString stringWithFormat:@"%@给你送了%ld个礼物",userInfo.nick,giftNum]];
            if(gameGiftType == GameRoomGiftType_GiftPack){
                NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum: microCount:), onUpdatePackGiftWithGiftId:info.giftId giftNum:giftNum microCount:1);
            }else {
                [self minusGold:info];
            }
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if ([resCode integerValue] == 8000) {
            [self requestGiftList];
            NotifyCoreClient(GiftCoreClient, @selector(onGiftIsOffLine:), onGiftIsOffLine:message);
        }
    }];
    
}

- (void)sendPublicChatGift:(NSInteger)giftID
                   giftNum:(NSInteger)giftNum
             gameGiftType:(GameRoomGiftType)gameGiftType
                 targetUid:(UserID)targetUid
                       msg:(NSString *)msg {
    
     __block NSInteger giftId = giftID;
    
    @weakify(self);
    [HttpRequestHelper sendPublicChatGift:giftId targetUid:targetUid giftNum:giftNum msg:msg gameGiftType:gameGiftType success:^(GiftAllMicroSendInfo *info) {
        if (giftId != info.giftInfo.giftId) {
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:@"网络异常，请重试");
            if(gameGiftType == GameRoomGiftType_GiftPack){
                NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum: microCount:), onUpdatePackGiftWithGiftId:giftId giftNum:giftNum microCount:1);
            }else {
                GiftInfo *giftInfo = [GetCore(GiftCore)findGiftInfoByGiftId:giftId];
                info.targetUid = targetUid;
                info.giftInfo = giftInfo;
                info.giftId = giftId;
                [self minusGold:info];
            }
            return;
        }
        if (info.nick.length > 0) {
            Attachment *attachement = [[Attachment alloc]init];
            attachement.first = Custom_Noti_Header_PublicChatroom;
            attachement.second = Custom_Noti_Sub_PublicChatroom_Send_Gift;
            attachement.data = [info model2dictionary];
            [attachement.data removeObjectForKey:@"gift"];
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom];
            if(gameGiftType == GameRoomGiftType_GiftPack){
                NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum: microCount:), onUpdatePackGiftWithGiftId:info.giftId giftNum:giftNum microCount:1);
            }else {
                [self minusGold:info];
            }
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if ([resCode integerValue] == 8000) {
            [self requestGiftList];
            NotifyCoreClient(GiftCoreClient, @selector(onGiftIsOffLine:), onGiftIsOffLine:message);
        }
    }];

}



- (void)sendChatGift:(NSInteger)giftID
        gameGiftType:(GameRoomGiftType)gameGiftType
                info:(UserInfo *)info
             giftNum:(NSInteger)giftNum
           targetUid:(UserID)targetUid
                 msg:(NSString *)msg{

    __block NSInteger giftId = giftID;
    __block UserID targetUID = targetUid;
    __block UserInfo *userInfo = info;
    @weakify(self);

    [HttpRequestHelper sendGift:giftId  targetUid:targetUID giftNum:giftNum gameGiftType:gameGiftType type:SendGiftType_Person msg:msg success:^(GiftAllMicroSendInfo *info) {
        @strongify(self);
        if (giftId != info.giftInfo.giftId) {
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:@"网络异常，请重试");
            if(gameGiftType == GameRoomGiftType_GiftPack){
                NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum: microCount:), onUpdatePackGiftWithGiftId:giftId giftNum:giftNum microCount:1);
            }else {
                GiftInfo *giftInfo = [GetCore(GiftCore)findGiftInfoByGiftId:giftId];
                info.targetUid = targetUid;
                info.giftInfo = giftInfo;
                info.giftId = giftId;
                [self minusGold:info];
            }
            return;
        }
            if (userInfo.nick.length > 0) {
                Attachment *attachement = [[Attachment alloc]init];
                attachement.first = Custom_Noti_Header_Gift;
                attachement.second = Custom_Noti_Sub_Gift_Send;
                attachement.data = [info model2dictionary];

                [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%lld",targetUID] type:NIMSessionTypeP2P needApns:YES apnsContent:[NSString stringWithFormat:@"%@给你送了%ld个礼物",userInfo.nick,giftNum]];
                if(gameGiftType == GameRoomGiftType_GiftPack){
                    NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum:microCount:), onUpdatePackGiftWithGiftId:info.giftId giftNum:giftNum microCount:1);
                    
                }else {
                    [self minusGold:info];
                }
            }
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if ([resCode integerValue] == 8000) {
            [self requestGiftList];
            NotifyCoreClient(GiftCoreClient, @selector(onGiftIsOffLine:), onGiftIsOffLine:message);
        }
    }];
    
}

#pragma mark - 查询礼物信息
/// 查询缓存中的普通礼物
/// @param giftId 礼物id
- (GiftInfo *)findGiftInfoByGiftId:(NSInteger)giftId {
    
    return [self findGiftInfoByGiftId:giftId type:GameRoomGiftType_Normal];
}
/// 查询缓存中的萝卜礼物
/// @param giftId 礼物id
- (GiftInfo *)findPrizeGiftByGiftId:(NSInteger)giftId {
    
    return [self findGiftInfoByGiftId:giftId type:GameRoomGiftType_PearGift];
}

/// 查询缓存中的礼物
/// @param giftId 礼物id
/// @param type 礼物类型 0普通礼物，4萝卜礼物
- (GiftInfo *)findGiftInfoByGiftId:(NSInteger)giftId type:(GameRoomGiftType)type {
    
    // 默认是礼物列表
    NSArray<GiftInfo *> *gifts = self.giftInfos;
    
    // 如果是盲盒奖品列表
    if (type == GameRoomGiftType_PearGift) {
        gifts = self.prizeGifts;
    }
    
    // 根据礼物id 遍历查找对应的gift
    __block GiftInfo *findGift;
    [gifts enumerateObjectsUsingBlock:^(GiftInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.giftId == giftId) {
            findGift = obj;
        }
    }];

    return findGift;
}

/**
 兔兔统一送礼物接口, 兼容 房间/私聊/公聊大厅 送 单人/多人/全麦 的 普通/萝卜/背包/贵族礼物
 
 @param uids 收礼人uids
 @param microCount 收礼人数 背包礼物时使用
 @param giftInfo 礼物
 @param gameGiftType 礼物类型 (普通/贵族/背包)
 @param gameRoomSendType 赠送类型
 @param gameRoomSendGiftType 送礼物的类型(单人/多人/全麦)
 @param giftNum 礼物数量
 @param roomUid 房间uid 在房间时需要传
 @param msg 喊话内容
 */
- (void)sendGiftByUids:(NSString *)uids
            microCount:(NSInteger)microCount
              giftInfo:(GiftInfo *)giftInfo
          gameGiftType:(GameRoomGiftType)gameGiftType
      gameRoomSendType:(GameRoomSendType)gameRoomSendType
  gameRoomSendGiftType:(GameRoomSendGiftType)gameRoomSendGiftType
               giftNum:(NSInteger)giftNum
               roomUid:(NSInteger)roomUid
                   msg:(NSString *)msg {
    [self sendGiftByUids:uids microCount:microCount giftInfo:giftInfo gameGiftType:gameGiftType gameRoomSendType:gameRoomSendType gameRoomSendGiftType:gameRoomSendGiftType giftNum:giftNum roomUid:roomUid msg:msg sessionId:nil];
}

/**
 群聊送礼物 添加了一个群聊的id
 
 其他的和上面的 一致
 */
- (void)sendGiftByUids:(NSString *)uids
            microCount:(NSInteger)microCount
              giftInfo:(GiftInfo *)giftInfo
          gameGiftType:(GameRoomGiftType)gameGiftType
      gameRoomSendType:(GameRoomSendType)gameRoomSendType
  gameRoomSendGiftType:(GameRoomSendGiftType)gameRoomSendGiftType
               giftNum:(NSInteger)giftNum
               roomUid:(NSInteger)roomUid
                   msg:(NSString *)msg
             sessionId:(nullable NSString *)sessionId {
    @weakify(self);
    [HttpRequestHelper sendGiftByUids:uids giftId:giftInfo.giftId gameGiftType:gameGiftType gameRoomSendType:gameRoomSendType giftNum:giftNum roomUid:roomUid msg:msg sessionId:sessionId success:^(GiftAllMicroSendInfo *info, NSDictionary *dict) {
        @strongify(self);
        if (giftInfo.giftId != info.giftInfo.giftId) {
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:@"网络异常，请重试");
            if (gameGiftType == GameRoomGiftType_GiftPack) {
                NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum: microCount:), onUpdatePackGiftWithGiftId:giftInfo.giftId giftNum:giftNum microCount:1);
            } else {
                info.giftInfo = giftInfo;
                info.giftId = giftInfo.giftId;
                [self minusGold:info];
            }
            return;
        }
        
        Attachment *attachement = [[Attachment alloc] init];
        if (gameRoomSendGiftType == GameRoomSendGiftType_AllMic || gameRoomSendGiftType == GameRoomSendGiftType_MutableOnMic) { // 全麦
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data addEntriesFromDictionary:dict];
            // 兼容旧版处理逻辑
            if (!info.targetUids) {
                NSMutableArray *uids = [NSMutableArray array];
                if (info.targetUsers.count == 1) {
                    [info.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [data setObject:[NSString stringWithFormat:@"%lld",obj.uid] forKey:@"targetUid"];
                        [data setObject:obj.nick forKey:@"targetNick"];
                        [data setObject:obj.avatar forKey:@"targetAvatar"];
                        [data setObject:[NSString stringWithFormat:@"%ld",obj.receiveGiftId] forKey:@"receiveGiftId"];
                        [uids addObject:@(obj.uid)];
                    }];
                } else {
                    [info.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [uids addObject:@(obj.uid)];
                    }];
                }
                // 这里本来是传入 info ，但是数据太大，超过了 自定义消息能携带的体积上限。所以现在直接将 data 传出，并且组装好需要的数据格式。
                info.targetUids = uids;
                [data setObject:uids forKey:@"targetUids"];
            }
            
            attachement.first = Custom_Noti_Header_ALLMicroSend;
            attachement.second = Custom_Noti_Sub_AllMicroSend;
            attachement.data = data;
        
            if (gameRoomSendGiftType == GameRoomSendGiftType_MutableOnMic) { // 多人非全麦
                // 多人非全麦
                attachement.second = Custom_Noti_Sub_AllBatchSend;
            }

        } else if (gameRoomSendGiftType == GameRoomSendGiftType_ToOne) { // 单人
            attachement.first = Custom_Noti_Header_Gift;
            attachement.second = Custom_Noti_Sub_Gift_Send;
            // 兼容旧版单人送礼逻辑
            if (info.targetUid == 0) {
                [info.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    info.targetUid = obj.uid;
                    info.targetNick = obj.nick;
                    info.targetAvatar = obj.avatar;
                    info.receiveGiftId = obj.receiveGiftId;
                    if (info.targetUids.count == 0) {
                        info.targetUids = @[[NSString stringWithFormat:@"%lld",obj.uid]];
                    }
                }];
            }
            
            attachement.data = [info model2dictionary];
        }
        
        if (gameRoomSendType == GameRoomSendType_PublicChat) { // 公聊大厅
            [info.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                info.targetNick = obj.nick;
            }];
            
            // 因为数据结构不一样，需要数据重新赋值
            attachement.data = [info model2dictionary];
            attachement.first = Custom_Noti_Header_PublicChatroom;
            attachement.second = Custom_Noti_Sub_PublicChatroom_Send_Gift;
            [attachement.data removeObjectForKey:@"gift"];
            
            [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom];
            
        } else if (gameRoomSendType == GameRoomSendType_Chat) { // 私信
            attachement.first = Custom_Noti_Header_Gift;
            attachement.second = Custom_Noti_Sub_Gift_Send;
            attachement.data = [info model2dictionary];
            
            __block UserInfo *userInfo;
            [info.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                userInfo = obj;
            }];
            UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
            UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:myUid];
            
            [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%lld", userInfo.uid] type:NIMSessionTypeP2P needApns:YES apnsContent:[NSString stringWithFormat:@"%@给你送了%zd个礼物", myInfo.nick, giftNum]];
            
        }else if (gameRoomSendType == GameRoomSendType_Team) {
            attachement.first = Custom_Noti_Header_Gift;
            attachement.second = Custom_Noti_Sub_Gift_Send;
            attachement.data = [info model2dictionary];
            __block UserInfo *userInfo;
            [info.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                userInfo = obj;
            }];
            UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
            UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:myUid];
            [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:sessionId type:NIMSessionTypeTeam needApns:YES apnsContent:[NSString stringWithFormat:@"%@给你送了%zd个礼物", myInfo.nick, giftNum]];
        } else { // 房间
            NSString *sessionID = [NSString stringWithFormat:@"%zd", GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
            [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        }
        
        // 处理背包礼物数据
        if (gameGiftType == GameRoomGiftType_GiftPack) {
            NotifyCoreClient(GiftCoreClient, @selector(onUpdatePackGiftWithGiftId:giftNum:microCount:), onUpdatePackGiftWithGiftId:giftInfo.giftId giftNum:giftNum microCount:microCount);
        } else {
            // 处理金币/萝卜数据
            [self minusGold:info];
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if ([resCode integerValue] == 8000) {
            [self requestGiftListWithRoomUid:roomUid];
            NotifyCoreClient(GiftCoreClient, @selector(onGiftIsOffLine:), onGiftIsOffLine:message);
        } else if (resCode.integerValue == kNotCarrotCode) {
            // 如果是萝卜不足
            NotifyCoreClient(GiftCoreClient, @selector(onGiftNotCarrotToPay:), onGiftNotCarrotToPay:message);
        } else if ([resCode integerValue] == 30002) {
            
            [TTPopup dismiss];
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            
            config.message = @"为了营造更安全的网络环境，保护您和他人的财产安全，请先进行实名认证";
            config.messageLineSpacing = 4;
            config.confirmButtonConfig.title = @"前往认证";
            config.confirmButtonConfig.titleColor = UIColor.whiteColor;
            config.confirmButtonConfig.backgroundColor = [XCTheme getTTMainColor];

            [TTPopup alertWithConfig:config confirmHandler:^{
                TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
                web.urlString = [NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kIdentityURL), GetCore(AuthCore).getUid];
                [[[XCCurrentVCStackManager shareManager]currentNavigationController] pushViewController:web animated:YES];
            } cancelHandler:^{
            }];
        } else if ([resCode integerValue] == 8411) { // 送礼限额
            [TTPopup dismiss];
            TTSendGiftLimitView *limitView = [[TTSendGiftLimitView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            limitView.limitType = ConsumptionLimit_Daily;
            [TTPopup popupView:limitView style:TTPopupStyleAlert];
        } else if ([resCode integerValue] == 8412) { // 送礼限额
            [TTPopup dismiss];
            TTSendGiftLimitView *limitView = [[TTSendGiftLimitView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            limitView.limitType = ConsumptionLimit_Month;
            [TTPopup popupView:limitView style:TTPopupStyleAlert];
        } else {
            [XCHUDTool showErrorWithMessage:message];
        }
    }];
}
#pragma mark - RoomCoreClient
//收到系统广播
- (void)onReceiveGiftBoardcast:(NSString *)content {
    NSDictionary *giftDic = [NSString dictionaryWithJsonString:content];
    Attachment *attachment = [Attachment yy_modelWithJSON:giftDic[@"body"]];
    GiftChannelNotifyInfo *giftNotifyInfo = [GiftChannelNotifyInfo modelWithJSON:attachment.data];
    NotifyCoreClient(GiftCoreClient, @selector(onReceiveGiftChannelNotify:), onReceiveGiftChannelNotify:giftNotifyInfo);
    
}


#pragma mark - ImMessageCoreClient
- (void)onWillSendMessage:(NIMMessage *)msg {
    if (msg.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
        if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)obj.attachment;
            if (attachment.first == Custom_Noti_Header_Gift) {
                if (attachment.second == Custom_Noti_Sub_Gift_Send || attachment.second == Custom_Noti_Sub_Gift_LuckySend) {
                    if (msg.session.sessionType == NIMSessionTypeChatroom) {
                        [self onRecvChatRoomCustomMsg:msg];
                    }else if (msg.session.sessionType == NIMSessionTypeP2P) {
                        [self onRecvP2PCustomMsg:msg];
                    }
                }
            }else if (attachment.first == Custom_Noti_Header_ALLMicroSend) {
                if (attachment.second == Custom_Noti_Sub_AllMicroSend || attachment.second == Custom_Noti_Sub_AllMicroLuckySend || attachment.second == Custom_Noti_Sub_AllBatchSend) {
                    if (msg.session.sessionType == NIMSessionTypeChatroom) {
                        [self onRecvChatRoomCustomMsg:msg];
                    }else if (msg.session.sessionType == NIMSessionTypeP2P) {
                        [self onRecvP2PCustomMsg:msg];
                    }
                }
            }else if (attachment.first == Custom_Noti_Header_Box) {
                //开箱子爆全麦
                if (attachment.second == Custom_Noti_Sub_Box_InRoom_AllMicSend) {
                    [self onRecvChatRoomCustomMsg:msg];
                }
            } else if (attachment.first == Custom_Noti_Header_Segment_AllMicSend) {
                if (attachment.second == Custom_Noti_Sub_Segment_AllMicSend_LuckBag) {
                    if (msg.session.sessionType == NIMSessionTypeChatroom) {
                        [self onRecvChatRoomCustomMsg:msg];
                    }else if (msg.session.sessionType == NIMSessionTypeP2P) {
                        [self onRecvP2PCustomMsg:msg];
                    }
                }
            }
        }
        
    }

}

- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg
{
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.roomId != [msg.session.sessionId integerValue]) {
        return;
    }
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        if (attachment.first == Custom_Noti_Header_Gift){

            GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
            if (info.giftInfo.consumeType == GiftConsumeTypeBox) { // 盲盒礼物
                UserInfo *targetInfo = [info.targetUsers firstObject];
                
                NSInteger receiveGiftId = targetInfo ? targetInfo.receiveGiftId : info.receiveGiftId;
                
                __block GiftInfo *receiveGift = [self findPrizeGiftByGiftId:receiveGiftId];
                
                if (!receiveGift) {
                    [[self getPrizeGiftList] subscribeNext:^(id  _Nullable x) {
                        receiveGift = [self findPrizeGiftByGiftId:receiveGiftId];
                        if (receiveGift) {
                            [GetCore(RoomCoreV2) addMessageToArray:msg];
                            NotifyCoreClient(GiftCoreClient, @selector(onReceiveGift:), onReceiveGift:info);
                        }
                    } error:^(NSError * _Nullable error) {
                        
                    }];
                } else {
                    [GetCore(RoomCoreV2) addMessageToArray:msg];
                    NotifyCoreClient(GiftCoreClient, @selector(onReceiveGift:), onReceiveGift:info);
                }
            } else {
                [GetCore(RoomCoreV2) addMessageToArray:msg];
                NotifyCoreClient(GiftCoreClient, @selector(onReceiveGift:), onReceiveGift:info);
            }
        }else if (attachment.first == Custom_Noti_Header_ALLMicroSend) {
            if (attachment.second == Custom_Noti_Sub_AllMicroSend || attachment.second == Custom_Noti_Sub_AllBatchSend) {

                GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
                info.targetUids = attachment.data[@"targetUids"];
                
                // 如果是多人非全麦
                if (attachment.second == Custom_Noti_Sub_AllBatchSend) {
                    info.isBatch = YES;
                }
                
                NotifyCoreClient(GiftCoreClient, @selector(onReceiveGift:), onReceiveGift:info);
                if (info.gift.consumeType != GiftConsumeTypeBox) {
                    [GetCore(RoomCoreV2)addMessageToArray:msg];
                } else {
                    // 遍历消息公屏
                    __block GiftInfo *receiveGift;
                    __block BOOL isHaveGiftInfo = NO;
                    @weakify(self);
                    [info.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        @strongify(self);
                        receiveGift = [self findPrizeGiftByGiftId:obj.receiveGiftId];
                        if (!receiveGift) {
                            isHaveGiftInfo = YES;
                            *stop = YES;
                        }
                    }];
                    if (isHaveGiftInfo) {
                        [[self getPrizeGiftList] subscribeNext:^(id  _Nullable x) {
                            @strongify(self);
                            [info.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                @strongify(self);
                                NIMMessage *message = [self boxGiftScreenMsg:attachment.data targetInfo:obj message:msg];
                                [GetCore(RoomCoreV2) addMessageToArray:message];
                            }];
                        } error:^(NSError * _Nullable error) {
                            
                        }];
                    } else {
                        [info.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            @strongify(self);
                            NIMMessage *message = [self boxGiftScreenMsg:attachment.data targetInfo:obj message:msg];
                            [GetCore(RoomCoreV2) addMessageToArray:message];
                        }];
                    }
                }
            }
        }else if (attachment.first == Custom_Noti_Header_Box){
            //这里处理 开箱子爆全麦消息
            if (attachment.second == Custom_Noti_Sub_Box_InRoom_NeedAllMicSend) {
                //收到服务端 发来的 爆全麦
                ActivityBoxAllMicroGiftInfo *boxAllMicroInfo = [ActivityBoxAllMicroGiftInfo yy_modelWithJSON: attachment.data];
                [self dealOpenBoxAllMicSendWithBoxGiftInfo:boxAllMicroInfo];
            }else if (attachment.second == Custom_Noti_Sub_Box_InRoom_AllMicSend) {
                GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
                if (projectType() == ProjectType_Pudding ||
                    projectType() == ProjectType_LookingLove ||
                    projectType() == ProjectType_Planet) {
                    
                } else {
                    if (![self findGiftInfoByGiftId:info.giftId]) {
                        [self.giftInfos addObject:info.gift];
                        [self requestGiftList];
                    }
                }
                info.targetUids = attachment.data[@"targetUids"];
                [GetCore(RoomCoreV2)addMessageToArray:msg];
                
                NotifyCoreClient(GiftCoreClient, @selector(onReceiveGift:), onReceiveGift:info);

            }
            
        }else if (attachment.first == Custom_Noti_Header_Segment_AllMicSend) {
            if (attachment.second == Custom_Noti_Sub_Segment_AllMicSend_LuckBag) {
                [GetCore(RoomCoreV2)addMessageToArray:msg];
                NSArray *infoArray = [GiftAllMicroSendInfo modelsWithArray:attachment.data[luckyAllMicroKey]];
                NotifyCoreClient(GiftCoreClient, @selector(onReceiveAllMicroLuckyGift:), onReceiveAllMicroLuckyGift:infoArray);
            }
        }
    }
}

//密聊收到礼物
- (void)onRecvP2PCustomMsg:(NIMMessage *)msg {
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        if (attachment.first == Custom_Noti_Header_Gift) {

        }
    }
}

#pragma mark - OpenBox AllMicSend

//处理开箱子 全麦礼物
- (void)dealOpenBoxAllMicSendWithBoxGiftInfo:(ActivityBoxAllMicroGiftInfo *)boxGiftInfo{
    NSMutableArray *temp = [GetCore(RoomQueueCoreV2) findSendGiftMember];
    NSString *myuid = [GetCore(AuthCore) getUid];
    if (myuid.integerValue != boxGiftInfo.uid) {
        return;
    }
    NSString *uids = [[NSString alloc]init];
    for (ChatRoomMicSequence *item in temp) {
            if (uids.length > 0) {
                uids = [uids stringByAppendingString:@","];
            }
            uids = [uids stringByAppendingString:item.chatRoomMember.userId];
    }
    if (uids.length) {
        [self sendBoxAllMicGiftRecordId:boxGiftInfo.recordId targetUids:uids roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid code:boxGiftInfo.code];
    }
}

#pragma mark - Getter

- (NSMutableArray *)giftInfos {
    if (_giftInfos == nil || _giftInfos.count == 0) {
        _giftInfos =[GiftInfoStorage getGiftInfos];
    }
    return _giftInfos;
}


#pragma mark - Private
- (NIMMessage *)boxGiftScreenMsg:(NSDictionary *)data targetInfo:(UserInfo *)targetInfo message:(NIMMessage *)msg {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data];
    dict[@"targetUsers"] = @[targetInfo];

    Attachment *att = [[Attachment alloc] init];
    att.first = Custom_Noti_Header_Gift;
    att.second = Custom_Noti_Sub_Gift_Send;
    att.data = dict;

    NIMCustomObject *boxObject = [[NIMCustomObject alloc] init];
    boxObject.attachment = att;

    NIMMessage *message = [[NIMMessage alloc] init];
    message.from = msg.from;
    message.messageObject = boxObject;
    message.localExt = msg.localExt;
    [message setValue:@(msg.messageType) forKey:@"messageType"];
    [message setValue:msg.session forKey:@"session"];
    
    return message;
}

- (void)minusGold:(GiftAllMicroSendInfo *)allMicroSendInfo {
    dispatch_main_sync_safe(^{
        double needMinusGold = 0;
        GiftInfo * giftInfo = [self findGiftInfoByGiftId:allMicroSendInfo.giftId];
        if (!giftInfo) {
            giftInfo = allMicroSendInfo.giftInfo;
        }
        if (allMicroSendInfo.targetUids.count > 0) { //全麦送
            needMinusGold = allMicroSendInfo.targetUids.count * allMicroSendInfo.giftNum * giftInfo.goldPrice;
        }else { //单人送
            needMinusGold = allMicroSendInfo.giftNum * giftInfo.goldPrice;
        }
        
        // 刷新萝卜
        if (allMicroSendInfo.giftInfo.consumeType == GiftConsumeTypeCarrot) {
            double oldCarrotNum = GetCore(PurseCore).carrotWallet.amount.doubleValue;
            if (oldCarrotNum >= needMinusGold) {
                double newCarrotNum = oldCarrotNum - needMinusGold;
                NSString *newCarrotStr = [NSString stringWithFormat:@"%.f",newCarrotNum];
                GetCore(PurseCore).carrotWallet.amount = newCarrotStr;
                NotifyCoreClient(PurseCoreClient, @selector(getCarrotNum:code:message:), getCarrotNum:GetCore(PurseCore).carrotWallet code:nil message:nil);
            }
        } else { // 刷新金币
            double oldGoldNum = [GetCore(PurseCore).balanceInfo.goldNum doubleValue];
            if (oldGoldNum >= needMinusGold) {
                double newGoldNum = oldGoldNum - needMinusGold;
                NSString *newGoldStr = [NSString stringWithFormat:@"%.2f",newGoldNum];
                GetCore(PurseCore).balanceInfo.goldNum = newGoldStr;
                NotifyCoreClient(PurseCoreClient, @selector(onBalanceInfoUpdate:), onBalanceInfoUpdate:GetCore(PurseCore).balanceInfo);
            }
        }
    });
}




#pragma mark - Test 性能测试

- (void)cancelGiftTimer {
    self.timer = nil;
}

- (void)startGiftTimer {
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.5 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        
        [self sendRandomRoomGift];
        
    });
    // 启动定时器
    dispatch_resume(self.timer);
    
}

- (void)sendRandomRoomGift {
    NSInteger gifIndex = [self getRandomNumber:0 to:(int)self.giftInfos.count];
    if (GetCore(ImRoomCoreV2).micMembers.count <= 0) {
        return;
    }
    NSInteger targetIndex = [self getRandomNumber:0 to:(int)GetCore(ImRoomCoreV2).micMembers.count];
    NIMChatroomMember *memeber = [GetCore(ImRoomCoreV2).micMembers safeObjectAtIndex:targetIndex];
    GiftInfo *giftInfo = [self.giftInfos safeObjectAtIndex:gifIndex];

    if (memeber==nil || giftInfo == nil) {
        return;
    }

    
    [self sendRoomGift:giftInfo.giftId gameGiftType:GameRoomGiftType_Normal targetUid:memeber.userId.userIDValue type:SendGiftType_RoomToPerson giftNum:66 msg:@""];

}

/**
 生成随机数
 
 @param from 最小值
 @param to 最大值
 @return 随机数
 */
- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - getter
- (NSCache<NSNumber *,NSArray *> *)roomGiftCache {
    if (!_roomGiftCache) {
        _roomGiftCache = [[NSCache alloc] init];
        // 设置缓存数据的数目
        _roomGiftCache.countLimit = 10;
    }
    return _roomGiftCache;
}

@end
