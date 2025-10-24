//
//  RoomMagicCore.m
//  BberryCore
//
//  Created by Mac on 2018/3/16.
//  Copyright © 2018年 chenran. All rights reserved.
//


#import "RoomMagicCore.h"
//model
#import "RoomMagicInfoStorage.h"

#import "TTSendGiftLimitView.h"
#import "TTWKWebViewViewController.h"
#import "XCCurrentVCStackManager.h"
#import "XCHtmlUrl.h"

#import "XCHUDTool.h"
#import "TTPopup.h"
#import "XCTheme.h"
#import "AuthCore.h"
//core
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "ImRoomCoreV2.h"
#import "RoomMagicCoreClient.h"
#import "RoomCoreV2.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
//t
#import "HttpRequestHelper+RoomMagic.h"
#import <YYModel.h>
#import "NSArray+Safe.h"
@interface RoomMagicCore()<ImMessageCoreClient>

@property (nonatomic, strong)NSMutableArray *roomMagicInfos;
@property (nonatomic, strong) dispatch_source_t timer; //计时器
@property (strong, nonatomic) NSTimer *retryTimer;
@property (nonatomic,assign) NSInteger retryCount;
@end

@implementation RoomMagicCore

#pragma mark - life cycle

- (instancetype)init{
    
    self = [super init];
    if (self) {
        AddCoreClient(ImMessageCoreClient, self);
        self.roomMagicInfos = [RoomMagicInfoStorage getRoomMagicInfos];
        [self requestRoomMagicList];
    }
    return self;
}

- (void)dealloc{
    
    RemoveCoreClientAll(self);
}

- (RoomMagicInfo *)queryMagicByid:(NSString *)magicId {
    for (RoomMagicInfo *info in self.roomMagicInfos) {
        if ([magicId integerValue] == info.magicId) {
            return info;
        }
    }
    return nil;
}

#pragma mark - ImMessageCoreClient
/*
 NIMMessage *message = [[NIMMessage alloc]init];
 NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
 customObject.attachment = attachment;
 message.messageObject = customObject;
 */
- (void)onWillSendMessage:(NIMMessage *)msg {
    //房间自定义消息
    if (msg.messageType == NIMMessageTypeCustom && msg.session.sessionType == NIMSessionTypeChatroom) {
        NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
        //自定义消息附件是Attachment类型且有值
        if (customObject.attachment != nil && [customObject.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)customObject.attachment;
            //房间魔法消息
            if (attachment.first == Custom_Noti_Header_RoomMagic && attachment.second == Custom_Noti_Sub_Magic_Send) {
                [self onRecvChatRoomCustomMsg:msg];//由于自己收不到自己发的消息，模拟收到自己发送的消息
            }else if (attachment.first == Custom_Noti_Header_RoomMagic && attachment.second == Custom_Noti_Sub_AllMicro_MagicSend){ //全麦魔法消息
                [self onRecvChatRoomCustomMsg:msg];
            }else if (attachment.first == Custom_Noti_Header_RoomMagic && attachment.second == Custom_Noti_Sub_Batch_MagicSend){ //全麦魔法消息
                [self onRecvChatRoomCustomMsg:msg];
            }
        }
    }
}

- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg{
    //过滤不是当前房间的消息
    if (GetCore(ImRoomCoreV2).currentRoomInfo.roomId != [msg.session.sessionId integerValue]) {
        return;
    }
    //房间自定义消息
    if (msg.messageType == NIMMessageTypeCustom && msg.session.sessionType == NIMSessionTypeChatroom) {
        NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
        //自定义消息附件是Attachment类型且有值
        if (customObject.attachment != nil && [customObject.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)customObject.attachment;
            if (attachment.first == Custom_Noti_Header_RoomMagic) {
                //房间魔法消息
                if (attachment.second == Custom_Noti_Sub_Magic_Send) {
                    RoomMagicInfo *info = [RoomMagicInfo yy_modelWithDictionary:attachment.data];
                    
                    //                if (![self findLocalMagicListsByMagicId:info.magicId]) {
                    
                    if (![self findLocalMagicListsByMagicId:info.giftMagicId]) {
                        
                        [self.roomMagicInfos addObject:info];
                        [self requestRoomMagicList];
                    }
                    [GetCore(RoomCoreV2) addMessageToArray:msg];
                    NotifyCoreClient(RoomMagicCoreClient, @selector(onReceiveRoomMagic:), onReceiveRoomMagic:info);
                    
                }else if (attachment.second == Custom_Noti_Sub_AllMicro_MagicSend || attachment.second == Custom_Noti_Sub_Batch_MagicSend) {//全麦魔法消息
                    
                    RoomMagicInfo *info = [RoomMagicInfo yy_modelWithDictionary:attachment.data];
                    if (attachment.second == Custom_Noti_Sub_Batch_MagicSend) {
                        // 将targetUsers中的uid抽出填充targetUids, 后面很多计算需要用到
                        NSMutableArray *uids = [NSMutableArray array];
                        for (UserInfo *user in info.targetUsers) {
                            [uids addObject:@(user.uid)];
                        }
                        info.targetUids = uids;
                        info.isBatch = YES;
                    }
                    //                if (![self findLocalMagicListsByMagicId:info.magicId]) {
                    if (![self findLocalMagicListsByMagicId:info.giftMagicId]) {
                        [self.roomMagicInfos addObject:info];
                        [self requestRoomMagicList];
                    }
                    
                    [GetCore(RoomCoreV2) addMessageToArray:msg];
                    NotifyCoreClient(RoomMagicCoreClient, @selector(onReceiveRoomMagic:), onReceiveRoomMagic:info);
                }
            }
        }
    }
}

#pragma mark - puble method

- (NSMutableArray *)getRoomMagicType:(RoomMagicType)type{
    NSMutableArray *arr = [NSMutableArray array];
    for (RoomMagicInfo *item in self.roomMagicInfos) {
        
        if (type == RoomMagicTypeNormal && item.nobleId == 0) {
            [arr addObject:item];
        }else if(type == RoomMagicTypeNoble && item.nobleId != 0){
            [arr addObject:item];
        }
    }
    return arr;
}

- (void)requestRoomMagicList{
    if (self.retryTimer != nil) {
        [self.retryTimer invalidate];
        self.retryTimer = nil;
    }

    [HttpRequestHelper requestRoomMagicList:^(NSArray *infos) {
        self.roomMagicInfos = [infos mutableCopy];
        [RoomMagicInfoStorage saveRoomMagicInfos:[infos yy_modelToJSONString]];
        NotifyCoreClient(RoomMagicCoreClient, @selector(onRoomMagicListNeedRefresh), onRoomMagicListNeedRefresh);
    } failure:^(NSNumber *resCode, NSString *message) {

        if (self.retryCount < 3) {
            self.retryCount++;
            self.retryTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(requestRoomMagicList) userInfo:nil repeats:NO];
        }
    }];
}

- (void)requestPersonMagicListByUid:(UserID)uid {
    [HttpRequestHelper requesrPersonMagicListWithUid:uid success:^(NSArray *data) {
        NotifyCoreClient(RoomMagicCoreClient, @selector(onRequestPersonMagicListSuccessWithUid:andList:), onRequestPersonMagicListSuccessWithUid:uid andList:data);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RoomMagicCoreClient, @selector(onRequestPersonMagicListFailth:), onRequestPersonMagicListFailth:message);
    }];
}

/**
 房间内赠送多人魔法
 
 @param targetUids 接收者的uid
 @param magicId 魔法id
 @param roomUid 房间id
 @param gameRoomSendGiftType 全麦/多人非全麦/单人
 */
- (void)sendBatchMagicByUids:(NSString *)targetUids magicId:(NSInteger)magicId roomUid:(NSInteger)roomUid gameRoomSendGiftType:(GameRoomSendGiftType)gameRoomSendGiftType {
    
    [HttpRequestHelper sendBatchMagicByUids:targetUids magicId:magicId roomUid:roomUid success:^(RoomMagicInfo *receiveRoomMagicInfo, NSDictionary *dataM) {
        
        Attachment *attachement = [[Attachment alloc] init];
        if (gameRoomSendGiftType == GameRoomSendGiftType_AllMic) { // 全麦
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data addEntriesFromDictionary:dataM];
            // 兼容旧版处理逻辑
            if (!receiveRoomMagicInfo.targetUids) {
                
                NSMutableArray *uids = [NSMutableArray array];
                [receiveRoomMagicInfo.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [uids addObject:@(obj.uid)];
                }];
                
                // 这里本来是传入 info ，但是数据太大，超过了 自定义消息能携带的体积上限。所以现在直接将 data 传出，并且组装好需要的数据格式。
                receiveRoomMagicInfo.targetUids = uids;
                [data setObject:uids forKey:@"targetUids"];
            }
            attachement.first = Custom_Noti_Header_RoomMagic;
            attachement.second = Custom_Noti_Sub_AllMicro_MagicSend;
            attachement.data = data;
            
        } else if (gameRoomSendGiftType == GameRoomSendGiftType_MutableOnMic) { // 多人非全麦
            // 兼容旧版处理逻辑
            if (!receiveRoomMagicInfo.targetUids) {
                NSMutableArray *uids = [NSMutableArray array];
                [receiveRoomMagicInfo.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [uids addObject:@(obj.uid)];
                }];
                
                receiveRoomMagicInfo.targetUids = uids;
            }
            // 多人非全麦
            attachement.first = Custom_Noti_Header_RoomMagic;
            attachement.second = Custom_Noti_Sub_Batch_MagicSend;
            attachement.data = dataM;
            
        } else if (gameRoomSendGiftType == GameRoomSendGiftType_ToOne) { // 单人
            attachement.first = Custom_Noti_Header_RoomMagic;
            attachement.second = Custom_Noti_Sub_Magic_Send;
            // 兼容旧版单人送礼逻辑
            if (receiveRoomMagicInfo.targetUid == 0) {
                [receiveRoomMagicInfo.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    receiveRoomMagicInfo.targetUid = obj.uid;
                    receiveRoomMagicInfo.targetNick = obj.nick;
                    receiveRoomMagicInfo.targetAvatar = obj.avatar;
                }];
            }
            attachement.data = [receiveRoomMagicInfo model2dictionary];
        }
        
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:sessionID type:NIMSessionTypeChatroom];
        [self minusGold:receiveRoomMagicInfo];
    } failure:^(NSNumber *resCode, NSString *message) {
        if ([resCode integerValue] == 8000) {
            [self requestRoomMagicList];
            NotifyCoreClient(RoomMagicCoreClient, @selector(onRoomMagicDidOffLine:), onRoomMagicDidOffLine:message);
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

- (void)sendAllMicroMagicByUids:(NSString *)targetUids magicId:(NSInteger)magicId roomUid:(NSInteger)roomUid{
    
    [HttpRequestHelper sendAllMicroMagicByUids:targetUids magicId:magicId roomUid:roomUid success:^(RoomMagicInfo *receiveRoomMagicInfo) {
        
        RoomMagicInfo *sendInfo = [self findLocalMagicListsByMagicId:magicId];
        receiveRoomMagicInfo.magicSvgUrl = sendInfo.magicSvgUrl;
        receiveRoomMagicInfo.effectSvgUrl = sendInfo.effectSvgUrl;
        receiveRoomMagicInfo.playPosition = sendInfo.playPosition;
        
        Attachment *attachment = [[Attachment alloc] init];
        attachment.first = Custom_Noti_Header_RoomMagic;
        attachment.second = Custom_Noti_Sub_AllMicro_MagicSend;
        attachment.data = [receiveRoomMagicInfo model2dictionary];
        
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore) sendCustomMessageAttachement:attachment sessionId:sessionID type:NIMSessionTypeChatroom];
        [self minusGold:receiveRoomMagicInfo];
    } failure:^(NSNumber *resCode, NSString *message) {
        if ([resCode integerValue] == 8000) {
            [self requestRoomMagicList];
            NotifyCoreClient(RoomMagicCoreClient, @selector(onRoomMagicDidOffLine:), onRoomMagicDidOffLine:message);
        }

    }];
}

- (void)sendMaigc:(NSInteger)magicId targetUid:(UserID)targetUid roomUid:(NSInteger)roomUid{

    [HttpRequestHelper sendMaigc:magicId targetUid:targetUid roomUid:roomUid success:^(RoomMagicInfo *receiveRoomMagicInfo) {
        
        RoomMagicInfo *sendInfo = [self findLocalMagicListsByMagicId:magicId];
        receiveRoomMagicInfo.magicSvgUrl = sendInfo.magicSvgUrl;
        receiveRoomMagicInfo.effectSvgUrl = sendInfo.effectSvgUrl;
        receiveRoomMagicInfo.playPosition = sendInfo.playPosition;
        
        Attachment *attachment = [[Attachment alloc] init];
        attachment.first = Custom_Noti_Header_RoomMagic;
        attachment.second = Custom_Noti_Sub_Magic_Send;
        attachment.data = [receiveRoomMagicInfo model2dictionary];
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore) sendCustomMessageAttachement:attachment sessionId:sessionID type:NIMSessionTypeChatroom];
        [self minusGold:receiveRoomMagicInfo];
    } failure:^(NSNumber *resCode, NSString *message) {
        if ([resCode integerValue] == 8000) {
            [self requestRoomMagicList];
            NotifyCoreClient(RoomMagicCoreClient, @selector(onRoomMagicDidOffLine:), onRoomMagicDidOffLine:message);
        }

    }];
}

#pragma mark - private method
//本地计算金币
- (void)minusGold:(RoomMagicInfo *)receiveRoomMagicInfo {

    dispatch_main_sync_safe(^{
        double needMinusGold = 0;
        RoomMagicInfo *info = [self findLocalMagicListsByMagicId:receiveRoomMagicInfo.giftMagicId];
        if (receiveRoomMagicInfo.targetUids.count > 0) { //全麦送
            needMinusGold = receiveRoomMagicInfo.targetUids.count * receiveRoomMagicInfo.giftMagicNum * info.magicPrice;
        }else { //单人送
            needMinusGold = receiveRoomMagicInfo.giftMagicNum * info.magicPrice;
        }
        double oldGoldNum = [GetCore(PurseCore).balanceInfo.goldNum doubleValue];
        if (oldGoldNum >= needMinusGold) {
            double newGoldNum = oldGoldNum - needMinusGold;
            NSString *newGoldStr = [NSString stringWithFormat:@"%.2f",newGoldNum];
            GetCore(PurseCore).balanceInfo.goldNum = newGoldStr;
            NotifyCoreClient(PurseCoreClient, @selector(onBalanceInfoUpdate:), onBalanceInfoUpdate:GetCore(PurseCore).balanceInfo);
        }
    });
}
//检查本地魔法列表是否包含收到的魔法
- (RoomMagicInfo *)findLocalMagicListsByMagicId:(NSInteger)magicId {
    for (RoomMagicInfo *info in self.roomMagicInfos) {
        if (info.magicId == magicId) {
            return info;
        }
    }
    return nil;
}


#pragma mark - Getter & Setter
- (NSMutableArray *)roomMagicInfos {
    if (_roomMagicInfos == nil || _roomMagicInfos.count == 0) {
        _roomMagicInfos =[RoomMagicInfoStorage getRoomMagicInfos];
    }
    return _roomMagicInfos;
}



#pragma mark - Test 性能测试
- (void)cancelMagicTimer {
    self.timer = nil;
}

- (void)startMagicTimer {

    dispatch_queue_t queue = dispatch_get_main_queue();
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.5 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        
        [self sendRandomRoomMagic];
        
    });
    // 启动定时器
    dispatch_resume(self.timer);
    
}

- (int)getMagicCount {
    return self.roomMagicInfos.count;
}

- (void)addAMagicInLocalStorage:(RoomMagicInfo *)magic {
    [self.roomMagicInfos addObject:magic];
    [self requestRoomMagicList];
}

- (void)sendRandomRoomMagic {
    NSInteger magicIndex = [self getRandomNumber:0 to:(int)self.roomMagicInfos.count];
    if (GetCore(ImRoomCoreV2).micMembers.count <= 0) {
        return;
    }
    NSInteger targetIndex = [self getRandomNumber:0 to:(int)GetCore(ImRoomCoreV2).micMembers.count];
    NIMChatroomMember *memeber = [GetCore(ImRoomCoreV2).micMembers safeObjectAtIndex:targetIndex];
    RoomMagicInfo *magicInfo = [self.roomMagicInfos safeObjectAtIndex:magicIndex];
    if (memeber==nil || magicInfo == nil) {
        return;
    }
    [self sendMaigc:magicInfo.magicId targetUid:memeber.userId.userIDValue roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid];
}


- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}


@end
