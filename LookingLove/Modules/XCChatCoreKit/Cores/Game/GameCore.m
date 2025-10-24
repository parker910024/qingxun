//
//  GameCore.m
//  BberryCore
//
//  Created by 卫明何 on 2018/3/29.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "GameCore.h"
#import "GameCoreClient.h"
#import "HttpRequestHelper+Game.h"

#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"

#import "AppInitClient.h"
#import "RoomCoreClient.h"
#import "RoomMagicCore.h"
#import "AuthCore.h"
#import "VersionCore.h"


#import "XCLoggerTool.h"
#import "XCLogger.h"

#import "NSString+JsonToDic.h"
#import <NSObject+YYModel.h>

@interface GameCore ()
<   ImMessageCoreClient,
    ImRoomCoreClient,
    RoomCoreClient,
    AppInitClient
>
@property (nonatomic, strong) dispatch_source_t timer; //计时器
@end

@implementation GameCore

- (instancetype)init {
    self = [super init];
    if (self) {
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(ImRoomCoreClient, self);
        AddCoreClient(RoomCoreClient, self);
        AddCoreClient(AppInitClient, self);
    }
    return self;
}
#pragma mark - Public
- (RACSignal *)requestRoomConfig:(long long)roomId {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HttpRequestHelper getRoomConfig:roomId success:^(CPGameListModel * _Nonnull config) {
            [subscriber sendNext:config];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(RoomCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}



- (void)requestMonsterInfoByMonsterIds:(NSString *)monsterIds{
    if (monsterIds==nil || monsterIds.length<=0) {
        return;
    }
    [HttpRequestHelper requesrMonsterInfoByMonsterIds:monsterIds success:^(NSArray *data) {
        self.monsterLists = data;
        NotifyCoreClient(GameCoreClient, @selector(onGetMonsterInfosSuccess:), onGetMonsterInfosSuccess:data);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GameCoreClient, @selector(onGetMonsterInfosFailth:), onGetMonsterInfosFailth:message);
    }];
}

//请求房间正在攻击的怪兽
- (void)getOnGoingMonsterByRoomUid:(NSString *)roomUid fromClassStr:(NSString *)classStr{
    if (roomUid == nil || roomUid.length<=1 || GetCore(VersionCore).loadingData) {
        return;
    }

    [HttpRequestHelper requestMonsterByRoomUID:roomUid Success:^(MonsterGameModel *monster) {
        if ([monster.appearRoomUid integerValue] == GetCore(ImRoomCoreV2).currentRoomInfo.uid) {
            self.currentMonster = monster;
        }
        NotifyCoreClient(GameCoreClient, @selector(onGetRoomMonsterInfoSuccess:classStr:), onGetRoomMonsterInfoSuccess:monster classStr:classStr);
        if (monster) {
            monster = [XCLoggerTool completeLogData:monster];
            [[XCLogger shareXClogger]sendLog:@{@"monsterId":monster.monsterId,@"monsterStatus":[NSString stringWithFormat:@"%d",monster.monsterStatus],@"beforeDisappearSeconds":[NSString stringWithFormat:@"%d",monster.beforeDisappearSeconds],@"remainBlood":[NSString stringWithFormat:@"%ld",monster.remainBlood],EVENT_ID:Monster_onGoingMonster} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        
        NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:Monster_onGoingMonster} error:error topic:BussinessLog logLevel:XCLogLevelVerbose];
        NotifyCoreClient(GameCoreClient, @selector(onGetRoomMonsterInfoFailth:), onGetRoomMonsterInfoFailth:message);
    }];
}

- (void)getMonsterListByRoomUid:(NSString *)roomUid{
    
    [HttpRequestHelper requestMonsterListByRoomId:roomUid Success:^(NSArray *monsterlist) {
        NSMutableArray *array = [NSMutableArray array];
        for (MonsterGameModel *monster in monsterlist) {
            if (monster.beforeAppearSeconds<=180) {
                [array addObject:monster];
            }
        }
        self.monsterLists = [array copy];
        NotifyCoreClient(GameCoreClient, @selector(onGetRoomMonsterListSuccess:), onGetRoomMonsterListSuccess:self.monsterLists);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GameCoreClient, @selector(onGetRoomMonsterListFailth:), onGetRoomMonsterListFailth:message);
    }];
}

- (void)sendMagicToAttackMonster:(NSString *)monsterId magicId:(NSString *)magicId{
    [HttpRequestHelper sendMagicToAttackMonsterWithMagicId:magicId andMonsterId:monsterId success:^(MonsterAttack *data) {
        
        RoomMagicInfo *magic = [GetCore(RoomMagicCore)queryMagicByid:magicId];
        data.magicIcon = magic.magicIcon;
        Attachment *attachment = [[Attachment alloc]init];
        attachment.first = Custom_Noti_Header_Game;
        attachment.second = Custom_Noti_Sub_Game_Attack;
        attachment.data = [data model2dictionary];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:GetCore(ImRoomCoreV2).currentChatRoom.roomId type:NIMSessionTypeChatroom];
        [self minusGold:data];
    } failure:^(NSNumber *resCode, NSString *message) {
        
        NotifyCoreClient(GameCoreClient, @selector(onMonsterAttackFail:), onMonsterAttackFail:message);
    }];
}

- (void)requestGameResult:(NSString *)monsterId{
    [HttpRequestHelper queryMonsterGameResultByMonsterId:monsterId success:^(GameLuckyResult *result) {
        
        NotifyCoreClient(GameCoreClient, @selector(onRequestGameResultSuccess:monsterId:), onRequestGameResultSuccess:result monsterId:monsterId);
        
        result = [XCLoggerTool completeLogData:result];
        [[XCLogger shareXClogger]sendLog:@{@"uid":GetCore(AuthCore).getUid,@"monsterId":monsterId,EVENT_ID:Monster_gameResult} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
        
    } failure:^(NSNumber *resCode, NSString *message) {
        NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:Monster_gameResult} error:error topic:BussinessLog logLevel:XCLogLevelVerbose];
        NotifyCoreClient(GameCoreClient, @selector(onRequestGameResultFail:), onRequestGameResultFail:message);
    }];
}


#pragma mark - RoomCoreClient
//收到怪兽相关广播
- (void)onReceiveMonsterGameBoardcast:(NSString *)content{
    if (GetCore(VersionCore).loadingData) {
        return;
    }
    NSDictionary *msgDictionary = [NSString dictionaryWithJsonString:content];
    Attachment *attachment = [Attachment yy_modelWithJSON:msgDictionary[@"body"]];
    if (attachment.first == Custom_Noti_Header_Game) {
        if (attachment.second == Custom_Noti_Sub_Game_Start) {
            MonsterGameModel *monster = [MonsterGameModel yy_modelWithJSON:attachment.data];
            if ([monster.appearRoomUid integerValue] == GetCore(ImRoomCoreV2).currentRoomInfo.uid) {
                self.currentMonster = monster;
            }
            if (monster.monsterStatus == MonsterStatus_WillAppear) {
                NotifyCoreClient(GameCoreClient, @selector(onMonsterWillAppear:), onMonsterWillAppear:monster);
                
                monster = [XCLoggerTool completeLogData:monster];
                [[XCLogger shareXClogger]sendLog:@{@"uid":GetCore(AuthCore).getUid,@"monsterId":monster.monsterId,@"monsterStatus":[NSString stringWithFormat:@"%d",monster.monsterStatus],@"beforeAppearSeconds":[NSString stringWithFormat:@"%d",monster.beforeAppearSeconds],EVENT_ID:Monster_willAppear} error:nil topic:BussinessLog logLevel:XCLogLevelInfo];
            }else if (monster.monsterStatus == MonsterStatus_DidDead){
//                [self reset];
                NotifyCoreClient(GameCoreClient, @selector(onMonsterDidDead:), onMonsterDidDead:monster);
            }else if (monster.monsterStatus == MonsterStatus_DidLeave) {
//                [self reset];
                NotifyCoreClient(GameCoreClient, @selector(onMonsterDidLeave:), onMonsterDidLeave:monster);
            }else if (monster.monsterStatus == MonsterStatus_DidAppear){
//                [self reset];
                NotifyCoreClient(GameCoreClient, @selector(onMonsterDidAppear:), onMonsterDidAppear:monster);
            }
        }else if (attachment.second == Custom_Noti_Sub_Game_End) {
            MonsterGameModel *monster = [MonsterGameModel yy_modelWithJSON:attachment.data];
            if ([monster.appearRoomUid integerValue] == GetCore(ImRoomCoreV2).currentRoomInfo.uid) {
                self.currentMonster = monster;
            }
            if (monster.monsterStatus == MonsterStatus_DidDead){
//                [self reset];
                NotifyCoreClient(GameCoreClient, @selector(onMonsterDidDead:), onMonsterDidDead:monster);
            }else if (monster.monsterStatus == MonsterStatus_DidLeave) {
//                [self reset];
                NotifyCoreClient(GameCoreClient, @selector(onMonsterDidLeave:), onMonsterDidLeave:monster);
            }
            
        }else if (attachment.second == Custom_Noti_Sub_Game_Result) {
            GameLuckyResult *result = [GameLuckyResult yy_modelWithJSON:attachment.data];
            NotifyCoreClient(GameCoreClient, @selector(onRequestGameResultSuccess:monsterId:), onRequestGameResultSuccess:result monsterId:self.currentMonster.monsterId);
            
            
            result = [XCLoggerTool completeLogData:result];
            if (result.monster==nil) {
                [[XCLogger shareXClogger]sendLog:@{@"uid":GetCore(AuthCore).getUid,@"monsterId":@"",@"monsterStatus":@"",@"luckMan_erbanNo":@"",EVENT_ID:Monster_gameResult} error:nil topic:BussinessLog logLevel:XCLogLevelInfo];
            }else{
                [[XCLogger shareXClogger]sendLog:@{@"uid":GetCore(AuthCore).getUid,@"monsterId":result.monster.monsterId,@"monsterStatus":[NSString stringWithFormat:@"%d",result.monster.monsterStatus],@"luckMan_erbanNo":result.luckyDog.erbanNo?result.luckyDog.erbanNo:@"",EVENT_ID:Monster_gameResult} error:nil topic:BussinessLog logLevel:XCLogLevelInfo];
            }
            
        }else if (attachment.second == Custom_Noti_Sub_Game_Attack) {
            MonsterAttack *attack = [MonsterAttack yy_modelWithJSON:attachment.data];
            NotifyCoreClient(GameCoreClient, @selector(onMonsterBeAttackBy:), onMonsterBeAttackBy:attack)
        }
    }
}

#pragma mark - ImMessageCoreClient
- (void)onRecvP2PCustomMsg:(NIMMessage *)msg {
    
}

- (void)onSendChatRoomMessageSuccess:(NIMMessage *)msg {
    if (msg.messageType == NIMMessageTypeCustom && msg.session.sessionType == NIMSessionTypeChatroom) {
        NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
        //自定义消息附件是Attachment类型且有值
        if (customObject.attachment != nil && [customObject.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)customObject.attachment;
            //房间魔法消息
            if (attachment.first == Custom_Noti_Header_Game && attachment.second == Custom_Noti_Sub_Game_Attack) {
                [self onRecvChatRoomCustomMsg:msg];//由于自己收不到自己发的消息，模拟收到自己发送的消息
            }
        }
    }
}

- (void)onWillSendMessage:(NIMMessage *)msg {
    
    
}

- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg {
    //过滤不是当前房间的消息
    if (GetCore(ImRoomCoreV2).currentRoomInfo.roomId != [msg.session.sessionId integerValue]) {
        return;
    }
    if (GetCore(VersionCore).loadingData) {
        return;
    }
    //房间自定义消息
    if (msg.messageType == NIMMessageTypeCustom && msg.session.sessionType == NIMSessionTypeChatroom) {
        NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
        //自定义消息附件是Attachment类型且有值
        if (customObject.attachment != nil && [customObject.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)customObject.attachment;

            if (attachment.first == Custom_Noti_Header_Game) {
                if (attachment.second == Custom_Noti_Sub_Game_Start) {
                    MonsterGameModel *monster = [MonsterGameModel yy_modelWithJSON:attachment.data];
                    if ([monster.appearRoomUid integerValue] == GetCore(ImRoomCoreV2).currentRoomInfo.uid) {
                        self.currentMonster = monster;
                    }
                    if (monster.monsterStatus == MonsterStatus_WillAppear) {
                        
                        NotifyCoreClient(GameCoreClient, @selector(onMonsterWillAppearInRoom:), onMonsterWillAppearInRoom:monster);
                        
                        monster = [XCLoggerTool completeLogData:monster];
                         [[XCLogger shareXClogger]sendLog:@{@"uid":GetCore(AuthCore).getUid,@"monsterId":monster.monsterId,@"monsterStatus":[NSString stringWithFormat:@"%d",monster.monsterStatus],@"beforeAppearSeconds":[NSString stringWithFormat:@"%d",monster.beforeAppearSeconds],EVENT_ID:Monster_willAppear} error:nil topic:BussinessLog logLevel:XCLogLevelInfo];
                        
                    }else if (monster.monsterStatus == MonsterStatus_DidDead){
                        [self reset];
                        NotifyCoreClient(GameCoreClient, @selector(onMonsterDidDeadInRoom:), onMonsterDidDeadInRoom:monster);
                    }else if (monster.monsterStatus == MonsterStatus_DidLeave) {
                        [self reset];
                        NotifyCoreClient(GameCoreClient, @selector(onMonsterDidLeaveInRoom:), onMonsterDidLeaveInRoom:monster);
                    }else if (monster.monsterStatus == MonsterStatus_DidAppear){
                        [self reset];
                        NotifyCoreClient(GameCoreClient, @selector(onMonsterDidAppearInRoom:), onMonsterDidAppearInRoom:monster);
                    }
                }else if (attachment.second == Custom_Noti_Sub_Game_End) {
                    MonsterGameModel *monster = [MonsterGameModel yy_modelWithJSON:attachment.data];
                    if ([monster.appearRoomUid integerValue] == GetCore(ImRoomCoreV2).currentRoomInfo.uid) {
                        self.currentMonster = monster;
                    }
                    if (monster.monsterStatus == MonsterStatus_DidDead){
                        //                [self reset];
                        NotifyCoreClient(GameCoreClient, @selector(onMonsterDidDeadInRoom:), onMonsterDidDeadInRoom:monster);
                    }else if (monster.monsterStatus == MonsterStatus_DidLeave) {
                        //                [self reset];
                        NotifyCoreClient(GameCoreClient, @selector(onMonsterDidLeaveInRoom:), onMonsterDidLeaveInRoom:monster);
                    }
                    
                }else if (attachment.second == Custom_Noti_Sub_Game_Result) {
                    GameLuckyResult *result = [GameLuckyResult yy_modelWithJSON:attachment.data];
                    NotifyCoreClient(GameCoreClient, @selector(onRequestGameResultSuccessInRoom:monsterId:), onRequestGameResultSuccessInRoom:result monsterId:self.currentMonster.monsterId);
                    
                    result = [XCLoggerTool completeLogData:result];
                    if (result.monster==nil) {
                        [[XCLogger shareXClogger]sendLog:@{@"uid":GetCore(AuthCore).getUid,@"monsterId":@"",@"monsterStatus":@"",@"luckMan_erbanNo":@"",EVENT_ID:Monster_gameResult} error:nil topic:BussinessLog logLevel:XCLogLevelInfo];
                    }else{
                        [[XCLogger shareXClogger]sendLog:@{@"uid":GetCore(AuthCore).getUid,@"monsterId":result.monster.monsterId,@"monsterStatus":[NSString stringWithFormat:@"%d",result.monster.monsterStatus],@"luckMan_erbanNo":result.luckyDog.erbanNo?result.luckyDog.erbanNo:@"",EVENT_ID:Monster_gameResult} error:nil topic:BussinessLog logLevel:XCLogLevelInfo];
                    }
                    
                    
                }else if (attachment.second == Custom_Noti_Sub_Game_Attack) {
                    
                    
                    MonsterAttack *attack = [MonsterAttack yy_modelWithJSON:attachment.data];
                    if (![GetCore(RoomMagicCore)findLocalMagicListsByMagicId:[attack.magicId integerValue]]) {
                        [GetCore(RoomMagicCore)requestRoomMagicList];
                    }
                    
                    NotifyCoreClient(GameCoreClient, @selector(onMonsterBeAttackBy:), onMonsterBeAttackBy:attack);
                }
            }
        }
    }
}
#pragma mark - AppInitClient
- (void)onGetMonsterWillShow:(NSArray *)monsterArr{
    if (monsterArr.count<=0) {
        self.hasMonster = NO;
        return;
    }
    self.hasMonster = YES;
    NSMutableString *monsterIds = [NSMutableString string];
    for (MonsterGameModel *monster in monsterArr) {
        [monsterIds appendString:monster.monsterId];
        [monsterIds appendString:@","];
    }
    if (monsterIds.length>0) {
        self.monsterIds = [monsterIds substringToIndex:(monsterIds.length-1)];
        [self requestMonsterInfoByMonsterIds:self.monsterIds];
    }
    
}

#pragma mark - Private
- (void)minusGold:(MonsterAttack *)monsterAttack {
    NSLog(@"[NSThread currentThread] ======== %@",[NSThread currentThread]);
    dispatch_main_sync_safe(^{
        double needMinusGold = 0;
//        GiftInfo * giftInfo = [self findGiftInfoByGiftId:allMicroSendInfo.giftId];
        RoomMagicInfo *magic = [GetCore(RoomMagicCore)findLocalMagicListsByMagicId:[monsterAttack.magicId integerValue]];
            needMinusGold = magic.magicPrice;
        
        double oldGoldNum = [GetCore(PurseCore).balanceInfo.goldNum doubleValue];
        if (oldGoldNum >= needMinusGold) {
            double newGoldNum = oldGoldNum - needMinusGold;
            NSString *newGoldStr = [NSString stringWithFormat:@"%.2f",newGoldNum];
            GetCore(PurseCore).balanceInfo.goldNum = newGoldStr;
            NotifyCoreClient(PurseCoreClient, @selector(onBalanceInfoUpdate:), onBalanceInfoUpdate:GetCore(PurseCore).balanceInfo);
        }
    });
}


#pragma mark - private method
- (void)reset{
    self.hasMonster = NO;
    self.monsterLists = nil;
    self.currentMonster = nil;
}

#pragma mark - Debuger
//调试用
- (void)sendRandomMagicAttack {
    NSInteger magicIndex = [self getRandomNumber:0 to:[GetCore(RoomMagicCore) getMagicCount]];
    RoomMagicInfo *magicInfo = [GetCore(RoomMagicCore) findLocalMagicListsByMagicId:magicIndex];
    if (self.currentMonster.beforeAppearSeconds == 0 && self.currentMonster && GetCore(ImRoomCoreV2).currentRoomInfo.uid == [self.currentMonster.appearRoomUid integerValue] && self.currentMonster.remainBlood > 0) {
        [self sendMagicToAttackMonster:self.currentMonster.monsterId magicId:[NSString stringWithFormat:@"%ld",(long)magicInfo.magicId]];
    }
}

- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}


#pragma mark - Test 性能测试
- (void)cancelAttackTimer {
    self.timer = nil;
}

- (void)startAttackTimer {
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.2 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        
        [self sendRandomMagicAttack];
        
    });
    // 启动定时器
    dispatch_resume(self.timer);
    
}


@end
