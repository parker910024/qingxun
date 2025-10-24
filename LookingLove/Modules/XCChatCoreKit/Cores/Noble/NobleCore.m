//
//  PeeragesCore.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "NobleCore.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "AppInitClient.h"
#import "YYWebResourceDownloader.h"
#import "CommonFileUtils.h"
#import "XCSSZipArchive.h"
#import "NobleInfoStorage.h"
#import "NobleSourceName.h"
#import "ImRoomCoreClient.h"
#import "ImRoomCoreV2.h"
#import "NobleCoreClient.h"
#import "NSString+JsonToDic.h"
#import "RoomCoreClient.h"

#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "NobleBroadcastInfo.h"

#import "NobleNotifyAttachment.h"
#import "UserCore.h"

#import "NobleSourceTool.h"

#import "NSDictionary+JSON.h"
#import "PurseCore.h"

#import "RoomQueueCoreV2.h"

#import "RoomQueueCoreClient.h"

#import "IAPHelper.h"
#import "IAPShare.h"

@interface NobleCore ()
<
AppInitClient,
ImRoomCoreClient,
ImMessageCoreClient,
RoomCoreClient
>

@property (nonatomic, strong) NSCache *nobleCache;
@end

@implementation NobleCore
{
    dispatch_queue_t zipQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(AppInitClient, self);
        AddCoreClient(ImRoomCoreClient, self);
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(RoomCoreClient, self);
        zipQueue = dispatch_queue_create("com.yy.face.xcface.unzipNoble", DISPATCH_QUEUE_SERIAL);
        self.privilegeDict = [NobleInfoStorage getNobleInfos];
    }
    return self;
}

#pragma mark - memory

- (void)cleanNobleMemoryCache {
    [self.nobleCache removeAllObjects];
}

#pragma mark - request
- (void)requestRoomNobleUserList:(NSString *)roomUid {
    [HttpRequestHelper requestRoomNobleUserList:roomUid success:^(NSArray *list) {
         NotifyCoreClient(NobleCoreClient, @selector(onRequestRoomNobleUserListSuccess:), onRequestRoomNobleUserListSuccess:list);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(NobleCoreClient, @selector(onRequestRoomNobleUserListFailth:), onRequestRoomNobleUserListFailth:message);
    }];
}

- (void)requestNobleOrderByProductId:(NSString *)productId nobleId:(NSNumber *)nobleId nobleOptType:(OrderNobleType)nobleOptType{
    
    [HttpRequestHelper requestNobleOrderByNobleId:nobleId nobleOptType:nobleOptType success:^(NSString *orderID) {
        NSLog(@"%@",orderID);
        
        if (orderID) {
    
            NSSet* dataSet = [[NSSet alloc] initWithObjects:productId, nil];
            
            [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
            
            [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {
                
                if (response != nil) {
                    NotifyCoreClient(NobleCoreClient, @selector(entryNobleRequestProductProgressStatus:), entryNobleRequestProductProgressStatus:YES);
                } else {
                    NotifyCoreClient(NobleCoreClient, @selector(entryNobleRequestProductProgressStatus:), entryNobleRequestProductProgressStatus:NO);
                }
                
                if (response.products.firstObject) {
                    
                    [[IAPShare sharedHelper].iap buyProduct:response.products.firstObject orderId:orderID onCompletion:^(SKPaymentTransaction *transcation) {//transactionIdentifier
                        
                        NSLog(@"%@",transcation.error.description);
                        
                        switch(transcation.transactionState) {
                                
                            case SKPaymentTransactionStatePurchased: {
                                NSLog(@"付款完成状态, 要做出相关的处理");
                                NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                
                                [[SKPaymentQueue defaultQueue] finishTransaction:transcation];
                                
                                NotifyCoreClient(NobleCoreClient, @selector(entryNoblePurchaseProcessStatus:), entryNoblePurchaseProcessStatus:XCPaymentStatusPurchased);
                                
                                //同步返回购买成功后，需要请求服务器二次校验
                                [HttpRequestHelper checkReceiptWithReceipt:receipt nobleRecordId:orderID transcationId:transcation.transactionIdentifier success:^(NSString *orderStatus) {
                                    
                                    
                                    NotifyCoreClient(NobleCoreClient, @selector(entryNobleCheckReceiptSuccess), entryNobleCheckReceiptSuccess);
                                } failure:^(NSNumber *resCode, NSString *message) {
                                    NSLog(@"message%@",message);
                                    
                                    NotifyCoreClient(NobleCoreClient, @selector(entryNobleCheckReceiptFaildWithMessage:), entryNobleCheckReceiptFaildWithMessage:message);
                                }];
                                break;
                            }
                            case SKPaymentTransactionStateRestored: {
                                NSLog(@"恢复状态, 要做出相关的处理");
                                [[SKPaymentQueue defaultQueue] finishTransaction:transcation];
                                break;
                            }
                            case SKPaymentTransactionStateFailed: {
                                [[SKPaymentQueue defaultQueue] finishTransaction:transcation];
                                NSLog(@"购买失败");
                                NotifyCoreClient(NobleCoreClient, @selector(entryNoblePurchaseProcessStatus:), entryNoblePurchaseProcessStatus:XCPaymentStatusFailed);
                                break;
                            }
                            case SKPaymentTransactionStatePurchasing: {
                                NSLog(@"正在购买中");
                                NotifyCoreClient(NobleCoreClient, @selector(entryNoblePurchaseProcessStatus:), entryNoblePurchaseProcessStatus:XCPaymentStatusPurchasing);
                                break;
                            }
                            default: {
                                [[SKPaymentQueue defaultQueue] finishTransaction:transcation];
                                NotifyCoreClient(NobleCoreClient, @selector(entryNoblePurchaseProcessStatus:), entryNoblePurchaseProcessStatus:XCPaymentStatusDeferred);
                                NSLog(@"其它");
                            }
                        }
                        
                    }];
                }
            }];
            
            
        }
        
    } failure:^(NSNumber *code, NSString *message) {
        NotifyCoreClient(NobleCoreClient, @selector(addNobleRechargeOrderFail:), addNobleRechargeOrderFail:message);
    }];
}


#pragma mark - puble method
- (void)deleteNobleSource {
    NSString *nobleDir = [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(), @"Noble"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:nobleDir error:nil];
}

- (id)findRecommondUrl{
    NobleInfo *info = self.privilegeDict[@"7"];
    return  info.recommend.values.firstObject;
   
}

- (RACSignal *)queryPrivilege:(UserID)uid {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[GetCore(UserCore)getUserInfoByUid:uid refresh:NO]subscribeNext:^(id x) {
            UserInfo *info = (UserInfo *)x;
            if (info) {
                NobleInfo *nobleInfo = [self.privilegeDict objectForKey:[NSString stringWithFormat:@"%ld",(long)info.nobleUsers]];
                if (nobleInfo) {
                    [subscriber sendNext:nobleInfo];
                }else {
                    [subscriber sendNext:nil];
                }
                
            }
        }];
        return nil;
    }];
}

- (NSMutableDictionary<NSNumber *,NobleSourceInfo *> *)singleNobleInfoByUserNoble:(SingleNobleInfo *)info type:(NSArray *)type {
    if (info) {
        NSMutableDictionary<NSNumber *,NobleSourceInfo *> *source = [NSMutableDictionary dictionary];
        for (NSNumber *item in type) {
            [self addSourceToDict:source withSingleNobleInfo:info andType:(NobleSource)[item integerValue]];
        }
        return source;
    }else {
        return nil;
    }
}

- (RACSignal *)singleNobleInfoBy:(UserID)uid type:(NSArray *)type {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        UserExtensionRequest *request = [[UserExtensionRequest alloc]init];
        request.type = QueryUserInfoExtension_Full;
        request.needRefresh = YES;
        [[GetCore(UserCore)queryExtensionUserInfoByWithUserID:uid requests:@[request]]subscribeNext:^(id x) {
            UserInfo *info = (UserInfo *)x;
            if (info) {
                NSMutableDictionary<NSNumber *,NobleSourceInfo *> *source = [NSMutableDictionary dictionary];
                for (NSNumber *item in type) {
                    [self addSourceToDict:source withSingleNobleInfo:info.nobleUsers andType:(NobleSource)[item integerValue]];
                }
                [source safeSetObject:info forKey:@"userInfo"];
                [subscriber sendNext:source];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (void)addSourceToDict:(NSMutableDictionary<NSNumber *,NobleSourceInfo *> *)dict withSingleNobleInfo:(SingleNobleInfo *)singleNobleInfo andType:(NobleSource)type {
    NobleSourceInfo *sourceInfo = [[NobleSourceInfo alloc]init];
    switch (type) {
        case NobleSource_badge:
        {
            sourceInfo.source = singleNobleInfo.badge;
            if ([singleNobleInfo.badge isKindOfClass:[UIColor class]]) {
                sourceInfo.sourceType = NobleSourceTypeColor;
                
            }else if([singleNobleInfo.badge isKindOfClass:[NSURL class]]){
                sourceInfo.sourceType = NobleSourceTypeURL;
            }else {
                sourceInfo.sourceType = NobleSourceTypeID;
                sourceInfo.source = [self findNobleSourceBySourceId:[NSString stringWithFormat:@"%@",singleNobleInfo.badge]];
            }
        }
            
            break;
        case NobleSource_headerwear:
        {
            sourceInfo.source = singleNobleInfo.headwear;
            if ([singleNobleInfo.headwear isKindOfClass:[UIColor class]]) {
                sourceInfo.sourceType = NobleSourceTypeColor;
                
            }else if([singleNobleInfo.headwear isKindOfClass:[NSURL class]]){
                sourceInfo.sourceType = NobleSourceTypeURL;
            }else {
                sourceInfo.sourceType = NobleSourceTypeID;
                sourceInfo.source = [self findNobleSourceBySourceId:[NSString stringWithFormat:@"%@",singleNobleInfo.headwear]];
            }
        }
            break;
        case NobleSource_cardbg:
        {
            sourceInfo.source = singleNobleInfo.cardbg;
            if ([singleNobleInfo.cardbg isKindOfClass:[UIColor class]]) {
                sourceInfo.sourceType = NobleSourceTypeColor;
                
            }else if([singleNobleInfo.cardbg isKindOfClass:[NSURL class]]){
                sourceInfo.sourceType = NobleSourceTypeURL;
            }else {
                sourceInfo.sourceType = NobleSourceTypeID;
                sourceInfo.source = [self findNobleSourceBySourceId:[NSString stringWithFormat:@"%@",singleNobleInfo.cardbg]];
            }
        }
            break;
        case NobleSource_zonebg:
        {
            sourceInfo.source = singleNobleInfo.zonebg;
            if ([singleNobleInfo.zonebg isKindOfClass:[UIColor class]]) {
                sourceInfo.sourceType = NobleSourceTypeColor;
                
            }else if([singleNobleInfo.zonebg isKindOfClass:[NSURL class]]){
                sourceInfo.sourceType = NobleSourceTypeURL;
            }else {
                sourceInfo.sourceType = NobleSourceTypeID;
                sourceInfo.source = [self findNobleSourceBySourceId:[NSString stringWithFormat:@"%@",singleNobleInfo.zonebg]];
            }
        }
            
            break;
        case NobleSource_open_effect:
        {
            sourceInfo.source = singleNobleInfo.open_effect;
            if ([singleNobleInfo.open_effect isKindOfClass:[UIColor class]]) {
                sourceInfo.sourceType = NobleSourceTypeColor;
                
            }else if([singleNobleInfo.open_effect isKindOfClass:[NSURL class]]){
                sourceInfo.sourceType = NobleSourceTypeURL;
            }else {
                sourceInfo.sourceType = NobleSourceTypeID;
                sourceInfo.source = [self findNobleSourceBySourceId:[NSString stringWithFormat:@"%@",singleNobleInfo.open_effect]];
            }
        }
            break;
        case NobleSource_banner:
        {
            sourceInfo.source = singleNobleInfo.banner;
            if ([singleNobleInfo.banner isKindOfClass:[UIColor class]]) {
                sourceInfo.sourceType = NobleSourceTypeColor;
                
            }else if([singleNobleInfo.banner isKindOfClass:[NSURL class]]){
                sourceInfo.sourceType = NobleSourceTypeURL;
            }else {
                sourceInfo.sourceType = NobleSourceTypeID;
                sourceInfo.source = [self findNobleSourceBySourceId:[NSString stringWithFormat:@"%@",singleNobleInfo.banner]];
            }
        }
            break;
        case NobleSource_bubble:
        {
            sourceInfo.source = singleNobleInfo.bubble;
            if ([singleNobleInfo.bubble isKindOfClass:[UIColor class]]) {
                sourceInfo.sourceType = NobleSourceTypeColor;
                
            }else if([singleNobleInfo.bubble isKindOfClass:[NSURL class]]){
                sourceInfo.sourceType = NobleSourceTypeURL;
            }else {
                sourceInfo.sourceType = NobleSourceTypeID;
                sourceInfo.source = [self findNobleSourceBySourceId:[NSString stringWithFormat:@"%@",singleNobleInfo.bubble]];
            }
        }
            break;
        case NobleSource_halo:
        {
            sourceInfo.source = singleNobleInfo.halo;
            if ([singleNobleInfo.halo isKindOfClass:[UIColor class]]) {
                sourceInfo.sourceType = NobleSourceTypeColor;
                
            }else if([singleNobleInfo.halo isKindOfClass:[NSURL class]]){
                sourceInfo.sourceType = NobleSourceTypeURL;
            }else {
                sourceInfo.sourceType = NobleSourceTypeID;
                sourceInfo.source = [self findNobleSourceBySourceId:[NSString stringWithFormat:@"%@",singleNobleInfo.halo]];
            }
            
        }
            break;
        case NobleSource_wingBadge:
        {
            sourceInfo.source = singleNobleInfo.wingBadge;
            if ([singleNobleInfo.wingBadge isKindOfClass:[UIColor class]]) {
                sourceInfo.sourceType = NobleSourceTypeColor;
                
            }else if([singleNobleInfo.wingBadge isKindOfClass:[NSURL class]]){
                sourceInfo.sourceType = NobleSourceTypeURL;
            }else {
                sourceInfo.sourceType = NobleSourceTypeID;
                sourceInfo.source = [self findNobleSourceBySourceId:[NSString stringWithFormat:@"%@",singleNobleInfo.wingBadge]];
            }
            
        }
            break;

        default:
            break;
    }
    [dict setObject:sourceInfo forKey:@(type)];
}

- (UIImage *)findNobleSourceBySourceId:(NSString *)sourceId {
    NSMutableString *sourceDirName = [[NSString stringWithFormat:@"%@",sourceId] mutableCopy];
    UIImage  *sourceImage;
    sourceImage = [self.nobleCache objectForKey:sourceDirName];
    if (sourceImage) {
        return sourceImage;
    }else {
        if ([sourceDirName containsString:@"bubble"]) {
            [sourceDirName appendString:@"_ios"];
        }
        NSString *targetPath = [NSString stringWithFormat:@"%@/%@",self.destinationUrl,sourceDirName];
        sourceImage = [UIImage imageWithContentsOfFile:targetPath];
        if (sourceImage) {
            [self.nobleCache setObject:sourceImage forKey:sourceDirName];
        }
        return sourceImage;
    }
}

- (void)nobleResourceDownloadManager {
    NSString *version = [[NSUserDefaults standardUserDefaults]objectForKey:@"nobleJsonVersion"];
    if (version) {
        if ([version integerValue] < self.version) {
            [self downloadZipForNoble];
            return;
        }else {
            //            self.isLoadFace = YES;
            [self syncTheTmpJsonToNormalJson];
            self.destinationUrl = [self getDestinationUrlStr];
            //            NotifyCoreClient(FaceSourceClient, @selector(loadFaceSourceSuccess), loadFaceSourceSuccess);
        }
    }else {
        [self downloadZipForNoble];
    }
}

- (void)downloadZipForNoble {
    if (self.zipUrl.length > 0 && [self.zipUrl containsString:@"http"]) {
        @weakify(self);
        [self deleteNobleSource];
        [[YYWebResourceDownloader sharedDownloader]downloadWithURL:[NSURL URLWithString:self.zipUrl] fileName:@"noble.zip" options:(YYWebResourceDownloaderOptions)YYWebResourceDownloaderProgressiveDownload progress:^(int64_t received, int64_t expected, CGFloat progress) {
            
        } completion:^(NSURL *filePath, NSError *error, BOOL finished) {
            
            @strongify(self);
            if (error == nil) {
                NSString *desPath = [self getNobleResourcePath];
                [CommonFileUtils createDirForPath:desPath];
                NSString *filePathStr = [filePath path];
                
                dispatch_async(zipQueue, ^{ //子线程解压
                    //                        BOOL unzipSuccess = [SSZipArchive unzipFileAtPath:filePathStr toDestination:desPath];
                    [XCSSZipArchive unzipFileAtPath:filePathStr toDestination:desPath overwrite:YES password:nil progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                        
                    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                        dispatch_main_sync_safe(^{
                            if (succeeded) {
                                //                                    self.isLoadFace = YES;
                                [self syncTheTmpJsonToNormalJson];
                                self.destinationUrl = [self getDestinationUrlStr];
                                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)self.version] forKey:@"nobleJsonVersion"];
                                //                                    NotifyCoreClient(FaceSourceClient, @selector(loadFaceSourceSuccess), loadFaceSourceSuccess);
                            }else {
                                [self performSelector:@selector(downloadZipForNoble) withObject:nil afterDelay:3];
                            }
                            
                        });
                        
                    }];
                    
                });
                
                
            }else {
                [self performSelector:@selector(downloadZipForNoble) withObject:nil afterDelay:3];
            }
            
            
        }];
    }else {
        //        self.isLoadFace = NO;
    }
    
}

- (NSString *)getNobleResourcePath {
    NSString *path = @"Documents/Noble/";
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    return savePath;
}

- (void)syncTheTmpJsonToNormalJson {
    self.privilegeDict = [self.tempPrivilegeDict mutableCopy];
    [NobleInfoStorage saveNobleInfos:self.privilegeDict];
}

- (NSString *)getDestinationUrlStr {
    NSString *path = @"Documents/Noble/";
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    NSFileManager *fm =  [NSFileManager defaultManager];
    NSArray *arr = [fm contentsOfDirectoryAtPath:savePath error:nil];
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSString *item in arr) {
        if (![item containsString:@"."]) {
            [tempArr addObject:item];
        }
    }
    
    if (tempArr.count == 0) {
        [self downloadZipForNoble];
        return nil;
    }
    
    while(tempArr.count < 5 && tempArr.count > 0){
        if (tempArr.count > 0) {
            for (NSString *item in arr) {
                if (![item containsString:@"."]) {
                    savePath = [savePath stringByAppendingString:[NSString stringWithFormat:@"/%@",tempArr[0]]];
                }
            }
            
        }
        
        tempArr = [[fm contentsOfDirectoryAtPath:savePath error:nil] mutableCopy];
    }
    
    return savePath;
}

#pragma mark - RoomCoreClient
//收到系统广播
- (void)onReceiveNobleBroadcastMsg:(NSString *)content {
    NSDictionary *boardcastDic = [NSString dictionaryWithJsonString:content];
    //      attachment.first  attachment.second
    //nobel 14                143

    NobleNotifyAttachment *attachment = [NobleNotifyAttachment yy_modelWithJSON:boardcastDic[@"body"]];
    
    NobleBroadcastInfo *nobleInfo = [NobleBroadcastInfo yy_modelWithJSON:attachment.data];
    [GetCore(PurseCore) requestBalanceInfo:GetCore(AuthCore).getUid.userIDValue];
    BalanceInfo * balanceInfo = GetCore(PurseCore).balanceInfo;
    NotifyCoreClient(NobleCoreClient, @selector(onReceiveNobleBoardcast:), onReceiveNobleBoardcast:nobleInfo);
    NotifyCoreClient(PurseCoreClient, @selector(onBalanceInfoUpdate:), onBalanceInfoUpdate:balanceInfo);
}

#pragma mark - ImMessageCoreClient

- (void)onSendChatRoomMessageSuccess:(NIMMessage *)msg {
    if (msg.session.sessionType == NIMSessionTypeChatroom) {
        [self onRecvChatRoomCustomMsg:msg];
    }
}


- (void)onRecvP2PCustomMsg:(NIMMessage *)msg {
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        if (attachment.first == Custom_Noti_Header_NobleNotify) {
            if (attachment.second == Custom_Noti_Sub_NobleNotify_Open_Success || attachment.second == Custom_Noti_Sub_NobleNotify_Renew_Success || attachment.second == Custom_Noti_Sub_NobleNotify_Already_OutDate) {
                [[GetCore(UserCore)getUserInfoByRac:[GetCore(AuthCore) getUid].userIDValue refresh:YES]subscribeNext:^(id x) {
                    if (x) {
                        UserInfo *userInfo = (UserInfo *)x;
                        NIMChatroomMemberInfoUpdateRequest *request = [[NIMChatroomMemberInfoUpdateRequest alloc]init];
                        if (userInfo.nobleUsers) {
                            SingleNobleInfo *nobleInfo = userInfo.nobleUsers;
                            NSMutableDictionary *extSource = [NobleSourceTool sortStringWithNobleInfo:nobleInfo];
                            [extSource removeObjectForKey:@"zoneBg"];
                            [extSource removeObjectForKey:@"cardBg"];
                            NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithObject:extSource forKey:[GetCore(AuthCore) getUid]];
                            
                            
                            request.updateInfo = [NSDictionary dictionaryWithObject:[ext toJSONWithPrettyPrint:YES] forKey:@(NIMChatroomMemberInfoUpdateTagExt)];
                            request.notifyExt = [ext yy_modelToJSONString];

                        }else {
                            NSDictionary *empty = [NSDictionary dictionary];
                            request.updateInfo = [NSDictionary dictionaryWithObject:[empty yy_modelToJSONString] forKey:@(NIMChatroomMemberInfoUpdateTagExt)];
                            request.notifyExt = @"";
                        }
                        [GetCore(ImRoomCoreV2)updateMyRoomMemberInfoWithrequest:request];
                    }
                }];
                
//                NSLog(@"%@",attachment.data);
//                NSDictionary *nobleDic = attachment.data;
//                NSString *nick = [NSString stringWithFormat:@"%@",nobleDic[@"nick"]];
//                SingleNobleInfo *memberNobleInfo = [SingleNobleInfo yy_modelWithJSON:nobleDic[@"nobleInfo"]];
//                if (memberNobleInfo && !memberNobleInfo.enterHide) {
//                    NotifyCoreClient(NobleCoreClient, @selector(onNobleUserInterChatRoomSuccrss:andNick:), onNobleUserInterChatRoomSuccrss:memberNobleInfo andNick:nick);
//                }
            }else if (attachment.second == Custom_Noti_Sub_NobleNotify_BoardCastBonus) {
                [GetCore(PurseCore) requestBalanceInfo:[GetCore(AuthCore) getUid].userIDValue];
            }
        }
    }

}

- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg {
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        if (attachment.first == Custom_Noti_Header_NobleNotify) {
            if (attachment.second == Custom_Noti_Sub_NobleNotify_Welocome) {
                NSLog(@"%@",attachment.data);
                NSDictionary *nobleDic = attachment.data;
                NSString *nick = [NSString stringWithFormat:@"%@",nobleDic[@"nick"]];
                SingleNobleInfo *memberNobleInfo = [SingleNobleInfo yy_modelWithJSON:nobleDic[@"nobleInfo"]];
                if (memberNobleInfo && !memberNobleInfo.enterHide) {
                    PrivilegeInfo *privilegeInfo = [self.privilegeDict objectForKey:[NSString stringWithFormat:@"%ld",(long)memberNobleInfo.level]].privilegeInfo;
                    if (privilegeInfo.enterNotice) {
                        NotifyCoreClient(NobleCoreClient, @selector(onNobleUserEnterChatRoomSuccess:andNick:), onNobleUserEnterChatRoomSuccess:memberNobleInfo andNick:nick);
                    }
                }
            }
        }
    }
}

#pragma mark - ImRoomCoreClient

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
                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroQueueUpdate:), onMicroQueueUpdate:GetCore(ImRoomCoreV2).micQueue);
            }
        }else {
            
        }
    }];
    
}

- (void)onMeInterChatRoomSuccess {
    if (GetCore(ImRoomCoreV2).myMember) {
        NIMChatroomMember *me = GetCore(ImRoomCoreV2).myMember;
        if (me.roomExt) {
            if (me.roomExt.length > 0) {
                NSDictionary *nobleDic = [NSString dictionaryWithJsonString:me.roomExt];
                
                SingleNobleInfo *memberNobleInfo = [SingleNobleInfo yy_modelWithJSON:nobleDic[me.userId]];
                NSString *nobleLevelStr = [NSString stringWithFormat:@"%ld",(long)memberNobleInfo.level];
//                [GetCore(UserCore)getUserInfo:[GetCore(AuthCore)getUid].userIDValue refresh:YES success:^(UserInfo *info) {
                    PrivilegeInfo *privilegeInfo = self.privilegeDict[nobleLevelStr].privilegeInfo;
                    if (!memberNobleInfo.enterHide && privilegeInfo.enterNotice) {
                        if (memberNobleInfo.level > 0) {
                            Attachment *attachment = [[Attachment alloc]init];
                            attachment.first = Custom_Noti_Header_NobleNotify;
                            attachment.second = Custom_Noti_Sub_NobleNotify_Welocome;
                            
                            NSMutableDictionary *att = [NSMutableDictionary dictionary];
                            [att setObject:me.roomNickname forKey:@"nick"];
                            [att setObject:memberNobleInfo.encodeAttachemt forKey:@"nobleInfo"];
                            [att setObject:me.userId forKey:@"uid"];
                            
                            attachment.data = att;
                            
                            NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
                            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
                        }
                        
                    }
//                } failure:^(NSError *error) {
//
//                }];
//
            }
        }
    }
}



#pragma mark - AppInitClient

- (void)onGetNoblePrivilegeSuccess {
    [self nobleResourceDownloadManager];
}


#pragma mark - Getter

- (NSMutableDictionary<NSString *,NobleInfo *> *)privilegeDict {
    if (_privilegeDict == nil) {
        _privilegeDict = [NSMutableDictionary dictionary];
    }
    return _privilegeDict;
}

- (NSMutableDictionary<NSString *,NobleInfo *> *)tempPrivilegeDict {
    if (_tempPrivilegeDict == nil) {
        _tempPrivilegeDict = [NSMutableDictionary dictionary];
    }
    return _tempPrivilegeDict;
}

- (NSCache *)nobleCache {
    if (_nobleCache == nil) {
        _nobleCache = [[NSCache alloc]init];
    }
    return _nobleCache;
}

@end
