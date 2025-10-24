//
//  TTCPGamePrivateChatCore.m
//  TTPlay
//
//  Created by new on 2019/2/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCPGamePrivateChatCore.h"
#import "TTCPGamePrivateChatClient.h"
#import "TTCPGameOverAndSelectClient.h"
#import "AuthCore.h"
#import "ImMessageCore.h"
#import "TTGameCPPrivateChatModel.h"
#import "HttpRequestHelper+CPGamePrivateChat.h"
#import "XCCPGamePrivateAttachment.h"
#import "PublicGameCache.h"
#import "TTGameStaticTypeCore.h"
#import "NormalRoomGameCache.h"

#import <NIMSDK/NIMSDK.h>

@implementation TTCPGamePrivateChatCore


- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (instancetype)init{
    if (self = [super init]) {
        AddCoreClient(TTCPGamePrivateChatClient, self);
        self.myMessageDic = [NSMutableDictionary dictionary];
        self.youMessageDic = [NSMutableDictionary dictionary];
        self.publicMyMessageDic = [NSMutableDictionary dictionary];
        self.normalRoomDic = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)startTimer{
    if (!self.privateTimer) {
        
        self.privateTimer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            for (int i = 0; i < GetCore(TTGameStaticTypeCore).privateMessageArray.count; i++) {
                id model = [GetCore(TTGameStaticTypeCore).privateMessageArray objectAtIndex:i];
                NIMMessage *meesage = (NIMMessage *)[model message];
                if ([meesage.messageObject isKindOfClass:NIMCustomObject.class]) {
                    NIMCustomObject *object = (NIMCustomObject *)meesage.messageObject;
                    Attachment *attachment = (Attachment*)object.attachment;
                    if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                        
                        
                    }
                }
            }
            
            
        }];
        
        
    }
    
}


#pragma mark --- 私聊 ---
-(void)onSendCPGamePrivateChatMessageSuccess:(NIMMessage *)message{
    [self.myMessageDic setObject:message forKey:message.messageId];
}

-(void)onReceiveCPGamePrivateChatMessageSuccess:(NIMMessage *)message{
    
    NIMCustomObject *obj = message.messageObject;
    
    Attachment *attachment = (Attachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// * 1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    
    NSDate *dateOld = [NSDate dateWithTimeIntervalSince1970:model.startTime / 1000];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitSecond;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:dateOld toDate:dateNow options:0];
    if (labs(delta.second) < 1800) {
        model.startTime = timeString.userIDValue;
        
        message.localExt = [model model2dictionary];
        
        NotifyCoreClient(TTCPGameOverAndSelectClient, @selector(gameTimeWasWrongAndRrefresh:), gameTimeWasWrongAndRrefresh:message);
    }
    
    [self.youMessageDic setObject:message forKey:message.messageId];
}


// 发送约战已取消
-(void)onSendCPGamePrivateChatCancelGameMessageSuccess:(NIMMessage *)message{
    NSArray *array = [GetCore(ImMessageCore) getMessagesInSession:message.session message:nil limit:20];
    NSMutableArray *effectiveGameArray = [NSMutableArray array];
    NSDictionary *dict = self.myMessageDic;
    if (dict.allKeys.count <= 0) {
        // 收到约战已取消，但是本地并没有存到对方发的消息，这个时候要从游戏列表中取到游戏，然后更新消息状态
        for (int i = 0; i < array.count; i++) {
            NIMMessage *myMessage = array[i];
            if (![myMessage.messageObject isKindOfClass:NIMCustomObject.class]) {
                continue;
            }
            NIMCustomObject *object = (NIMCustomObject *)myMessage.messageObject;
            XCCPGamePrivateAttachment *customObject = (XCCPGamePrivateAttachment*)object.attachment;
            if (customObject.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                if (myMessage.localExt == nil) {
                    [effectiveGameArray addObject:myMessage.messageId];
                    TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
                    launchGameModel.status = 3;
                    launchGameModel.uuId = myMessage.messageId;
                    myMessage.localExt = [launchGameModel model2dictionary];
                    [GetCore(ImMessageCore) updateMessage:myMessage
                                                  session:myMessage.session];
                }
            }
        }
    }else{
        for (int i = 0; i < dict.allKeys.count; i++) {
            if(dict.allKeys.count > 0){
                NIMMessage *myMessage = [dict objectForKey:dict.allKeys[i]];
                NIMCustomObject *object = (NIMCustomObject *)myMessage.messageObject;
                XCCPGamePrivateAttachment *customObject = (XCCPGamePrivateAttachment*)object.attachment;
                TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
                launchGameModel.status = 3;
                launchGameModel.uuId = myMessage.messageId;
                myMessage.localExt = [launchGameModel model2dictionary];
                [GetCore(ImMessageCore) updateMessage:myMessage
                                              session:myMessage.session];
                [effectiveGameArray addObject:myMessage.messageId];
            }
        }
    }
    
    
    [[self requestCancelGameInviteWith:GetCore(AuthCore).getUid.userIDValue MsgIds:[effectiveGameArray componentsJoinedByString:@","]] subscribeError:^(NSError *error) {
        
    }];
}
// 收到约战已取消
-(void)onReceiveCPGamePrivateChatCancelGameMessageSuccess:(NIMMessage *)message{
    NSArray *array = [GetCore(ImMessageCore) getMessagesInSession:message.session message:nil limit:20];
    
    NSDictionary *dict = self.youMessageDic;
    if (dict.allKeys.count <= 0) {
        for (int i = 0; i < array.count; i++) {
            NIMMessage *youMessage = array[i];
            if (![youMessage.messageObject isKindOfClass:NIMCustomObject.class]) {
                continue;
            }
            NIMCustomObject *object = (NIMCustomObject *)youMessage.messageObject;
            XCCPGamePrivateAttachment *customObject = (XCCPGamePrivateAttachment*)object.attachment;
            if (customObject.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                if (youMessage.localExt == nil) {
                    if(![youMessage.from isEqualToString:GetCore(AuthCore).getUid]){
                        
                        TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
                        launchGameModel.status = 3;
                        launchGameModel.uuId = youMessage.messageId;
                        youMessage.localExt = [launchGameModel model2dictionary];
                        [GetCore(ImMessageCore) updateMessage:youMessage
                                                      session:youMessage.session];
                    }else{
                        NSLog(@"不能取消自己的游戏");
                    }
                }
            }
        }
    }else{
        for (int i = 0; i < dict.allKeys.count; i++) {
            if(dict.allKeys.count > 0){
                NIMMessage *youMessage = [dict objectForKey:dict.allKeys[i]];
                NIMCustomObject *object = (NIMCustomObject *)youMessage.messageObject;
                XCCPGamePrivateAttachment *customObject = (XCCPGamePrivateAttachment*)object.attachment;
                TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
                launchGameModel.status = 3;
                launchGameModel.uuId = youMessage.messageId;
                youMessage.localExt = [launchGameModel model2dictionary];
                [GetCore(ImMessageCore) updateMessage:youMessage
                                              session:youMessage.session];
            }
        }
    }
}





- (RACSignal *)requestGameUrlFromPrivateChatUid:(UserID )uid Name:(NSString *)name ReceiveUid:(UserID )receiveUid ReceiveName:(NSString *)receiveName GameId:(NSString *)gameId ChannelId:(NSString *)channelId MessageId:(NSString *)messageId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameUrlFromPrivateChatUid:uid Name:name ReceiveUid:receiveUid ReceiveName:receiveName GameId:gameId ChannelId:channelId MessageId:messageId success:^(NSDictionary *dataDict) {
            [subscriber sendNext:dataDict];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


- (RACSignal *)requestCPGamePrivateChatList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCPGamePrivateChatList:uid PageNum:num PageSize:size success:^(NSArray * _Nonnull list) {
            NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onCPGamePrivateChatList:), onCPGamePrivateChatList:list);
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)requestCPGamePublicChatAndNormalRoomList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCPGamePublicChatAndNormalRoomList:uid PageNum:num PageSize:size success:^(NSArray * _Nonnull list) {
            NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onCPGamePrivateChatList:), onCPGamePrivateChatList:list);
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


- (RACSignal *)requestCancelGameInviteWith:(UserID )uid MsgIds:(NSString *)msgIds{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCancelGameInviteWith:uid MsgIds:msgIds success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
    
}




- (RACSignal *)requestWatchGameWith:(UserID )uid GameId:(NSString *)gameId ChannelId:(NSString *)channelId MessageId:(NSString *)messageId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestWatchGameWith:uid GameId:gameId ChannelId:channelId MessageId:messageId success:^(NSString *urlString) {
            NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameStartAndMatchGame:), gameStartAndMatchGame:urlString);
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)requestSharePictureWith:(NSString *)avatar ErbanNo:(UserID )erbanNo Nick:(NSString *)nick GameResult:(NSString *)gameResult{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestSharePictureWith:avatar ErbanNo:erbanNo Nick:nick GameResult:gameResult success:^(NSString * _Nonnull urlString) {
            [subscriber sendNext:urlString];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

#pragma mark --- 公聊 ---
-(void)onSendCPGamePublicChatMessageSuccess:(NIMMessage *)message{
    if (self.publicChatType) {
        
        [[PublicGameCache sharePublicGameCache] saveGameInfo:message];
        
        [self.publicMyMessageDic setObject:message forKey:message.messageId];
        
        [[PublicGameCache sharePublicGameCache] saveGameMessageFromMeInfo:self.publicMyMessageDic];
    }
}

- (void)onReceiveCPGamePublicChatMessageSuccess:(NIMMessage *)message{
    
    NIMCustomObject *obj = message.messageObject;
    
    Attachment *attachment = (Attachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// * 1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    
    NSDate *dateOld = [NSDate dateWithTimeIntervalSince1970:model.startTime / 1000];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitSecond;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:dateOld toDate:dateNow options:0];
    if (labs(delta.second) < 1800) {
        model.startTime = timeString.userIDValue;
        
        message.localExt = [model model2dictionary];
        
        NotifyCoreClient(TTCPGameOverAndSelectClient, @selector(gameTimeWasWrongAndRrefresh:), gameTimeWasWrongAndRrefresh:message);
    }
    
    [[PublicGameCache sharePublicGameCache] saveGameInfo:message];
    
    
}


#pragma mark --- 多人房 ---
- (void)storageMessageForNormalRoomGameStatus:(TTMessageDisplayModel *)model{
    if ([model.message.messageObject isKindOfClass:NIMCustomObject.class]) {
        NIMCustomObject *obj = model.message.messageObject;
        Attachment *attach = (Attachment *)obj.attachment;
        if (attach.first == Custom_Noti_Header_CPGAME_PrivateChat) {
            if ([model.message.from isEqualToString:GetCore(AuthCore).getUid]) {
                [self.normalRoomDic setObject:model forKey:model.message.messageId];
                [[NormalRoomGameCache shareNormalGameCache] saveGameMessageFromMeInfo:self.normalRoomDic];
            }
        }
    }
}

/**
 游戏详情
@param gameId 游戏id

@param roomUid 房间uid
*/
- (void)requestGameDetailGameId:(NSString *)gameId roomUid:(UserID)roomUid Success:(void (^)(CPGameListModel *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    [HttpRequestHelper requestGameDetailGameId:gameId roomUid:roomUid Success:^(CPGameListModel * _Nonnull model) {
        success(model);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        failure(resCode,message);
    }];

}

/**
 取消游戏
@param gameId 游戏id

@param roomUid 房间uid
*/
- (void)requestGameCloseByGameId:(NSString *)gameId roomUid:(UserID)roomUid Success:(void (^)(void))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    [HttpRequestHelper requestGameCloseByGameId:gameId roomUid:roomUid Success:^(void) {
        success();
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        failure(resCode,message);
    }];

}

@end
