//
//  FaceCore.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "FaceCore.h"
#import "HttpRequestHelper+Face.h"
#import "FaceInfoStorage.h"

#import "FaceReceiveInfo.h"
#import "FaceSendInfo.h"
#import "FaceInfo.h"
#import "RoomInfo.h"
#import "FacePlayInfo.h"
#import "FaceConfigInfo.h"

#import "YYWebResourceDownloader.h"
#import "CommonFileUtils.h"
#import "SSCustomKeychain.h"
#import "XCSSZipArchive.h"

#import "Attachment.h"
#import "NSObject+YYModel.h"

#import "VersionCore.h"
#import "RoomQueueCore.h"
#import "ImRoomCoreV2.h"
#import "RoomCoreV2.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "FaceCoreClient.h"
#import "FaceSourceClient.h"
#import "AuthCoreClient.h"
#import "AppInitClient.h"


@interface FaceCore()
<
ImMessageCoreClient,
AuthCoreClient,
SSZipArchiveDelegate,
AppInitClient
>

#define RETRYCOUNT 5;

@property(nonatomic, strong)NSMutableArray *faceInfos; //FaceConfigInfo
@property(nonatomic, strong)NSMutableArray *tempFaceInfos; //获取下来的新数据，需要等新的zip包下载完才会去复制到faceInfos
@property (nonatomic ,strong)dispatch_source_t timer;
@property (nonatomic ,strong)dispatch_source_t testTimer; //测试用定时器
@property(atomic, strong)NSMutableArray *receiveFace;
@property (strong, nonatomic) NSCache *faceCache;
@property (nonatomic, assign) NSInteger *requestJsonCount; //请求json重试计数器
@property (nonatomic,assign) NSInteger retryDelay;

@end

@implementation FaceCore
{
    dispatch_queue_t zipQueue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(AuthCoreClient, self);
        AddCoreClient(AppInitClient, self);
        zipQueue = dispatch_queue_create("com.yy.face.xcface.unzipFace", DISPATCH_QUEUE_SERIAL);
        _faceInfos = [FaceInfoStorage getFaceInfos];

    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)cleanFaceMemoryCache {
    [self.faceCache removeAllObjects];
}

- (void)faceDownloadManager {
    NSString *version = [[NSUserDefaults standardUserDefaults]objectForKey:@"faceJsonVersion"];
    if (version) {
        if ([version integerValue] < [self.version integerValue]) {
            [self downloadZipForFace];
            return;
        }else {
            self.isLoadFace = YES;
            [self syncTheTmpJsonToNormalJson];//save
            self.destinationUrl = [self getDestinationUrlStr];
            NotifyCoreClient(FaceSourceClient, @selector(loadFaceSourceSuccess), loadFaceSourceSuccess);
        }
    }else {
        [self downloadZipForFace];
    }
}

- (void)syncTheTmpJsonToNormalJson {
    self.faceInfos = [self.tempFaceInfos mutableCopy];
    [FaceInfoStorage saveFaceInfos:[self.faceInfos yy_modelToJSONString]];
}

- (void)downloadZipForFace {
    if ([self.zipUrl absoluteString].length > 0 && [[self.zipUrl absoluteString] containsString:@"http"]) {
        @weakify(self);
        [[YYWebResourceDownloader sharedDownloader]downloadWithURL:self.zipUrl fileName:@"face.zip" options:(YYWebResourceDownloaderOptions)YYWebResourceDownloaderProgressiveDownload progress:^(int64_t received, int64_t expected, CGFloat progress) {
            
        } completion:^(NSURL *filePath, NSError *error, BOOL finished) {

            @strongify(self);
            if (error == nil) {
                NSString *desPath = [self getFaceImagePath];
                [CommonFileUtils createDirForPath:desPath];
                NSString *filePathStr = [filePath path];
                NSString *fileMD5Str = [CommonFileUtils getFileMD5WithPath:filePathStr];
                fileMD5Str = [fileMD5Str uppercaseString];
                if (![self.zipMd5 isEqualToString:fileMD5Str]) { //MD5校验 如果不相等就重新下载
                    [self performSelector:@selector(downloadZipForFace) withObject:nil afterDelay:3];
                }else {
                    dispatch_async(self->zipQueue, ^{ //子线程解压

                        [XCSSZipArchive unzipFileAtPath:filePathStr toDestination:desPath overwrite:YES password:nil progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                            
                        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                            dispatch_main_sync_safe(^{
                                if (succeeded) {
                                    self.isLoadFace = YES;
                                    [self syncTheTmpJsonToNormalJson];
                                    self.destinationUrl = [self getDestinationUrlStr];
                                    [[NSUserDefaults standardUserDefaults]setObject:self.version forKey:@"faceJsonVersion"];
                                    NotifyCoreClient(FaceSourceClient, @selector(loadFaceSourceSuccess), loadFaceSourceSuccess);
                                }else {
                                    [self performSelector:@selector(downloadZipForFace) withObject:nil afterDelay:3];
                                }
                                
                            });

                        }];
                        
                    });
                    
                }
            }else {
                [self performSelector:@selector(downloadZipForFace) withObject:nil afterDelay:3];
            }
            
            
        }];
    }else {
        self.isLoadFace = NO;
    }
    
}

- (NSString *)getFaceImagePath {
    NSString *path = @"Documents/Face/";
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    return savePath;
}

- (NSString *)getDestinationUrlStr {
    NSString *path = @"Documents/Face/";
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    NSFileManager *fm =  [NSFileManager defaultManager];
    NSArray *arr = [fm contentsOfDirectoryAtPath:savePath error:nil];
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSString *item in arr) {
        if (![item containsString:@"."]) {
            [tempArr addObject:item];
        }
    }
    
    while(tempArr.count < 5 && tempArr){
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


- (FaceConfigInfo *)findFaceInfoById:(NSInteger)faceId{
    if (self.faceInfos != nil) {
        for (int i = 0; i < self.faceInfos.count; i++) {
            FaceConfigInfo *faceInfo = self.faceInfos[i];
            if (faceInfo.id == faceId) {
                return faceInfo;
            }
        }
    }
    return nil;
}


//根据id查找表情iCON图片对象
- (UIImage *)findFaceIconImageById:(NSInteger)faceId {
    FaceConfigInfo *configInfo = [self findFaceInfoById:faceId];
    NSString *faceName = [NSString stringWithFormat:@"%@_%d_%ld",configInfo.pinyin,configInfo.id,configInfo.iconPos];
    UIImage  *face;
    face = [self.faceCache objectForKey:faceName];
    if (face) {
        return face;
    }else {
        NSString *dirName = [NSString stringWithFormat:@"%@_%d",configInfo.pinyin,configInfo.id];
        NSString *targetPath = [NSString stringWithFormat:@"%@/%@/%@",self.destinationUrl,dirName,faceName];
        face = [UIImage imageWithContentsOfFile:targetPath];
        if (face) {
            [self.faceCache setObject:face forKey:faceName];
        }
        return face;
    }
}

//查找图片数组
- (NSMutableArray<UIImage *> *)findFaceFrameArrByFaceId:(NSInteger)faceId {
    FaceConfigInfo *configInfo = [self findFaceInfoById:faceId];
    return [self findFaceFrameArrByConfig:configInfo];
}

//查找图片数组
- (NSMutableArray<UIImage *> *)findFaceFrameArrByConfig:(FaceConfigInfo *)configInfo {
    NSMutableArray *faceArr = [NSMutableArray array];
    for (int i = (short)configInfo.animStartPos; i <= (short)configInfo.animEndPos; i++) {
        [faceArr addObject:[self findFaceImageByConfig:configInfo index:i]];
    }
    return faceArr;
}

//查找图片
- (UIImage *)findFaceImageById:(NSInteger)faceId index:(NSInteger)index {
    FaceConfigInfo *configInfo = [self findFaceInfoById:faceId];
    return [self findFaceImageByConfig:configInfo index:index];
}

//查找图片
- (UIImage *)findFaceImageByConfig:(FaceConfigInfo *)configInfo index:(NSInteger)index {
    NSString *faceName = [NSString stringWithFormat:@"%@_%d_%ld",configInfo.pinyin,configInfo.id,(long)index];
    UIImage  *face;
    face = [self.faceCache objectForKey:faceName];
    if (face) {
        return face;
    }else {
        NSString *dirName = [NSString stringWithFormat:@"%@_%d",configInfo.pinyin,configInfo.id];
        NSString *targetPath = [NSString stringWithFormat:@"%@/%@/%@",self.destinationUrl,dirName,faceName];
        face = [UIImage imageWithContentsOfFile:targetPath];
        if (face) {
            [self.faceCache setObject:face forKey:faceName];
        }
        return face;
    }
}

- (NSMutableArray *)sortFaceInfosWithfaceInfoArr:(NSMutableArray *)faceInfoArr {
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *temp2 = [NSMutableArray array]; //运气表情
    for (FaceConfigInfo *item in faceInfoArr) {
        if (item.resultCount <= 0) {
            [temp addObject:item];
        }else {
            [temp2 addObject:item];
        }
    }
    [temp addObjectsFromArray:temp2];
    return temp;
}

- (NSMutableArray *)getFaceInfosType:(RoomFaceType)faceType {
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *resultArr = [NSMutableArray array];
    
    if(projectType() == ProjectType_MengSheng ||
       projectType() == ProjectType_Haha ||
       projectType() == ProjectType_TuTu ||
       projectType() == ProjectType_Pudding ||
       projectType() == ProjectType_BB ||
       projectType() == ProjectType_LookingLove ||
       projectType() == ProjectType_Planet){
        for (int i = 0; i < self.faceInfos.count; i++) {
            
            FaceConfigInfo *item = self.faceInfos[i];
            
            if (faceType == RoomFaceTypeNormal && !item.isNobleFace) {
                
                if (GetCore(VersionCore).loadingData) {
                    if (!item.isLuckFace && item.faceType == XCFaceType_Face) {
                        [arr addObject:item];
                    }
                }else{
                    if (item.faceType == XCFaceType_Face) {
                        [arr addObject:item];
                    }
                }
                
            }else if(faceType == RoomFaceTypeNoble && item.isNobleFace){
                
                UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
                if (myInfo.nobleUsers.level<=0) {
                    if (item.nobleId<=1) {
                        [arr addObject:item];
                    }
                }else{
                    if (myInfo.nobleUsers.level>=item.nobleId) {
                        [arr addObject:item];
                    }
                }
            }
            
            
            if (arr.count == 15) {
                [resultArr addObject:arr];
                arr = [NSMutableArray array];
            }
            if ( i%15 != 0 && i == self.faceInfos.count - 1) {
                if (arr.count) {
                    [resultArr addObject:arr];
                }
            }
        }
        
    }else {
        
        for (int i = 0; i < self.faceInfos.count; i++) {
            FaceConfigInfo *item = self.faceInfos[i];
            if (faceType == RoomFaceTypeNormal &&!item.isNobleFace) {
                
                if (GetCore(VersionCore).loadingData) {
                    //审核中隐藏 骰子 魔法卡 龙珠
                    if (item.id != 20 && item.id != 23 && item.id != 26) {
                        [arr addObject:item];
                    }
                }else{
                    if (item.id != 26) {
                        [arr addObject:item];
                    }
                }
                
            }else if(faceType == RoomFaceTypeNoble && item.isNobleFace){
                if (GetCore(VersionCore).loadingData) {
                    if ( item.nobleId<=1) {
                        [arr addObject:item];
                    }
                }else{
                    [arr addObject:item];
                }
                
            }
            
            
            if (arr.count == 15) {
                [resultArr addObject:arr];
                arr = [NSMutableArray array];
            }
            if ( i%15 != 0 && i == self.faceInfos.count - 1) {
                if (arr.count) {
                    [resultArr addObject:arr];
                }
            }
        
        }
    }
    
    
    return resultArr;
}

//一起玩
- (void)sendAllFace:(FaceConfigInfo *)faceInfo {
    if (faceInfo) {
        if (GetCore(ImRoomCoreV2).isInRoom) {
            NSMutableArray *chatroomMembers = GetCore(ImRoomCoreV2).micMembers;
            NSMutableArray *faceRecieveInfos = [NSMutableArray array];
            //        FaceConfigInfo *child = [[FaceConfigInfo alloc]init];
            //麦序成员的配置
            if (chatroomMembers != nil && chatroomMembers.count > 0) {
                for (int i = 0; i < chatroomMembers.count; i++) {
                    FaceReceiveInfo *faceRecieveInfo = [[FaceReceiveInfo alloc]init];
                    if (faceInfo.resultStartPos > 0 && faceInfo.resultEndPos > 0) {
                        int value = [self getRandomNumber:(short)faceInfo.resultStartPos to:(short)faceInfo.resultEndPos];
                        //插入结果
                        faceRecieveInfo.resultIndexes = [@[@(value)]mutableCopy];
                    }
                    NIMChatroomMember *chatRoomMember = chatroomMembers[i];
                    
                    faceRecieveInfo.nick = chatRoomMember.roomNickname;
                    faceRecieveInfo.uid = chatRoomMember.userId.userIDValue;
                    faceRecieveInfo.faceId = faceInfo.id;
                    //                if (child != nil) {
                    //                    faceRecieveInfo.faceId = child.faceId;
                    //                }else {
                    //                    faceRecieveInfo.faceId = faceInfo.faceId;
                    //                }
                    
                    [faceRecieveInfos addObject:faceRecieveInfo];
                    
                }
            }

            FaceSendInfo *sendInfo = [[FaceSendInfo alloc]init];
            sendInfo.data = faceRecieveInfos;
            //        sendInfo.uid = info.uid;
            sendInfo.uid = [GetCore(AuthCore)getUid].userIDValue;
            
            Attachment *attachment = [[Attachment alloc]init];
            attachment.first = Custom_Noti_Header_Face;
            attachment.second = Custom_Noti_Sub_Face_Send;
            attachment.data = sendInfo.encodeAttachemt;
            
            NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionID type:NIMSessionTypeChatroom];
        }
    }
    
}


- (void)sendFace:(FaceConfigInfo *)faceInfo {
    RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
    if (info != nil) {
        FaceReceiveInfo *faceRecieveInfo = [[FaceReceiveInfo alloc]init];
        NSMutableArray *resultIndexs = [NSMutableArray array];
        if (faceInfo.resultStartPos > 0 && faceInfo.resultEndPos > 0) {
            int value;
            if (faceInfo.canResultRepeat) { //结果可以重复
                for (int i = 0; i < faceInfo.resultCount; i++) {
                    value = [self getRandomNumber:(short)faceInfo.resultStartPos to:(short)faceInfo.resultEndPos];
                    [resultIndexs addObject:@(value)];
                    faceRecieveInfo.resultIndexes = [resultIndexs copy];
                }
                
            }else {
                faceRecieveInfo.resultIndexes = [[self randomArray:(short)faceInfo.resultStartPos to:(short)faceInfo.resultEndPos count:(short)faceInfo.resultCount] mutableCopy];
            }
            
        }
        
        //        UserInfo *info = [GetCore(UserCore)getUserInfo:[GetCore(AuthCore)getUid].userIDValue refresh:NO];
        UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue];
        NSMutableArray *faceRecieveInfos = [NSMutableArray array];
        
        faceRecieveInfo.nick = info.nick;
        faceRecieveInfo.faceId = faceInfo.id;
        faceRecieveInfo.uid = info.uid;
        [faceRecieveInfos addObject:faceRecieveInfo];
        
        FaceSendInfo *sendInfo = [[FaceSendInfo alloc]init];
        sendInfo.data = faceRecieveInfos;
        sendInfo.uid = info.uid;
        
        Attachment *attachment = [[Attachment alloc]init];
        attachment.first = Custom_Noti_Header_Face;
        attachment.second = Custom_Noti_Sub_Face_Send;
        attachment.data = sendInfo.encodeAttachemt;
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionID type:NIMSessionTypeChatroom];
        
    }
}
- (void)sendToCpFace:(FaceConfigInfo *)faceInfo {
    GetCore(ImRoomCoreV2).myMember.roomExt = @"";
    if ( GetCore(ImRoomCoreV2).p2pUid > 0) {
        FaceReceiveInfo *faceRecieveInfo = [[FaceReceiveInfo alloc]init];
        NSMutableArray *resultIndexs = [NSMutableArray array];
        if (faceInfo.resultStartPos > 0 && faceInfo.resultEndPos > 0) {
            int value;
            if (faceInfo.canResultRepeat) { //结果可以重复
                for (int i = 0; i < faceInfo.resultCount; i++) {
                    value = [self getRandomNumber:(short)faceInfo.resultStartPos to:(short)faceInfo.resultEndPos];
                    [resultIndexs addObject:@(value)];
                    faceRecieveInfo.resultIndexes = [resultIndexs copy];
                }
                
            }else {
                faceRecieveInfo.resultIndexes = [[self randomArray:(short)faceInfo.resultStartPos to:(short)faceInfo.resultEndPos count:(short)faceInfo.resultCount] mutableCopy];
            }
            
        }
        
        //        UserInfo *info = [GetCore(UserCore)getUserInfo:[GetCore(AuthCore)getUid].userIDValue refresh:NO];
        UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue];
        NSMutableArray *faceRecieveInfos = [NSMutableArray array];
        
        faceRecieveInfo.nick = info.nick;
        faceRecieveInfo.faceId = faceInfo.id;
        faceRecieveInfo.uid = info.uid;
        [faceRecieveInfos addObject:faceRecieveInfo];
        
        FaceSendInfo *sendInfo = [[FaceSendInfo alloc]init];
        sendInfo.data = faceRecieveInfos;
        sendInfo.uid = info.uid;
        
        Attachment *attachment = [[Attachment alloc]init];
        attachment.first = Custom_Noti_Header_Face;
        attachment.second = Custom_Noti_Sub_Face_Send;
        attachment.data = sendInfo.encodeAttachemt;
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).p2pUid];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionID type:NIMSessionTypeP2P];
        
    }
}


//发送龙珠
- (void)sendDragonWithState:(CustomNotificationDragon)state {
    
    if (state == Custom_Noti_Sub_Dragon_Start) {
        RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
        UserID uid = GetCore(AuthCore).getUid.longLongValue;
        
        @weakify(self);
        [GetCore(RoomCoreV2) getDragonWithRoomUid:info.uid uid:uid success:^(NSArray *ballList,BOOL isNew) {
            @strongify(self);
            FaceConfigInfo *dragonInfo = self.dragonConfigInfo;
            if (info != nil) {
                FaceReceiveInfo *faceRecieveInfo = [[FaceReceiveInfo alloc]init];
                NSMutableArray *resultIndexs = [NSMutableArray array];
                if (dragonInfo.resultStartPos > 0 && dragonInfo.resultEndPos > 0) {
                    for (NSString *number in ballList) {
                        [resultIndexs addObject:@(number.intValue+dragonInfo.resultStartPos)];
                    }
                    faceRecieveInfo.resultIndexes = [resultIndexs copy];
                    
                }
                UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue];
                NSMutableArray *faceRecieveInfos = [NSMutableArray array];
                
                faceRecieveInfo.nick = info.nick;
                faceRecieveInfo.faceId = dragonInfo.id;
                faceRecieveInfo.uid = info.uid;
                [faceRecieveInfos addObject:faceRecieveInfo];
                
                
                
                // 17,34,40
                FaceSendInfo *sendInfo = [[FaceSendInfo alloc]init];
                sendInfo.data = faceRecieveInfos;
                sendInfo.uid = info.uid;
                
                //保存当前结果 用于发送 开启龙珠 或 放弃龙珠
                
                GetCore(RoomCoreV2).currenDragonFaceSendInfo = sendInfo;
                Attachment *attachment = [[Attachment alloc]init];
                attachment.first = Custom_Noti_Header_Dragon;
                if (isNew) {
                    attachment.second = Custom_Noti_Sub_Dragon_Start;
                }else {
                    attachment.second = Custom_Noti_Sub_Dragon_Continue;
                }
                attachment.data = sendInfo.encodeAttachemt;
                NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
                [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionID type:NIMSessionTypeChatroom];
            }
        } failure:^(NSNumber *code, NSString *msg) {
            
            
            
        }];
        
        
        
        
    }else {
        //开启龙珠或是 弃牌
        if (!GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
            return;
        }
        Attachment *attachment = [[Attachment alloc]init];
        attachment.first = Custom_Noti_Header_Dragon;
        attachment.second = state;
        attachment.data = GetCore(RoomCoreV2).currenDragonFaceSendInfo.encodeAttachemt;
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionID type:NIMSessionTypeChatroom];
    }
    
    
}



#pragma mark - ImMessageCoreClient
- (void)onSendMessageSuccess:(NIMMessage *)msg {
    if (msg.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
        if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)obj.attachment;
            if (attachment.first == Custom_Noti_Header_Face) {
                if (attachment.second == Custom_Noti_Sub_Face_Send) {
                    FaceSendInfo *faceattachement = [FaceSendInfo yy_modelWithJSON:attachment.data];
                    NSMutableArray *arr = [faceattachement.data mutableCopy];
                    NotifyCoreClient(FaceCoreClient, @selector(onReceiveFace:), onReceiveFace:arr);
                    if (arr.count > 0) {
                        FaceReceiveInfo *faceRecieveInfo = arr.firstObject;
                        FaceConfigInfo *faceInfo = [self findFaceInfoById:faceRecieveInfo.faceId];
                        if (faceInfo.id > 1 && faceInfo != nil && faceRecieveInfo.resultIndexes.count > 0) {
                            FacePlayInfo *playInfo = [[FacePlayInfo alloc]init];
                            playInfo.delay = 3;
                            playInfo.faceReceiveInfo = arr.firstObject;
                            playInfo.message = msg;
                            for (FaceReceiveInfo *item in arr) {
                                if (item.uid == [GetCore(AuthCore) getUid].userIDValue) {
                                    self.isShowingFace = YES;
                                }
                            }
                            
                            [self handleFaceMessage:playInfo];
                        }
                    }
                }
            }else if (attachment.first == Custom_Noti_Header_Dragon){
                //模拟自己接受自己的信息
                NotifyCoreClient(RoomCoreClient, @selector(onRecvChatRoomDragonMsg:), onRecvChatRoomDragonMsg:msg);
                
            }
        }
    }
}

- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg {
    if (msg.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
        if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)obj.attachment;
            if (attachment.first == Custom_Noti_Header_Face) {
                if (attachment.second == Custom_Noti_Sub_Face_Send) {
                    FaceSendInfo *faceattachement = [FaceSendInfo yy_modelWithJSON:attachment.data];
                    
                    NSMutableArray *arr = [faceattachement.data mutableCopy];
                    NotifyCoreClient(FaceCoreClient, @selector(onReceiveFace:), onReceiveFace:arr);
                    if (arr.count > 0) {
                        FaceReceiveInfo *faceRecieveInfo = arr.firstObject;
                        FaceConfigInfo *faceInfo = [self findFaceInfoById:faceRecieveInfo.faceId];
                        if (faceInfo.id > 1 && faceInfo != nil && faceRecieveInfo.resultIndexes.count > 0) {
                            FacePlayInfo *playInfo = [[FacePlayInfo alloc]init];
                            playInfo.delay = 3;
                            playInfo.faceReceiveInfo = arr.firstObject;
                            playInfo.message = msg;
                            for (FaceReceiveInfo *item in arr) {
                                if (item.uid == [GetCore(AuthCore) getUid].userIDValue) {
                                    self.isShowingFace = YES;
                                }
                            }
                            
                            [self handleFaceMessage:playInfo];
                        }

                    }
                }
            }else if (attachment.first == Custom_Noti_Header_Dragon) {
                //龙珠信息
                
            }
        }
        
    }
}


//龙珠 发送成功
- (void)onSendDragonMessageSuccess:(NIMMessage *)msg {
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    if (attachment.second == Custom_Noti_Sub_Dragon_Start || attachment.second == Custom_Noti_Sub_Dragon_Continue) {
        //开始  龙珠
        
    }else {
        
        //放弃龙珠 或是 开龙珠 都要清空
        if(GetCore(RoomCoreV2).currenDragonFaceSendInfo){
            GetCore(RoomCoreV2).currenDragonFaceSendInfo = nil;
            RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
            UserID uid = GetCore(AuthCore).getUid.longLongValue;
            [GetCore(RoomCoreV2) clearDragonWithRoomUid:info.uid uid:uid];
        }
    }
    NotifyCoreClient(FaceCoreClient, @selector(onDragonSendSuccess), onDragonSendSuccess);
}

//龙珠 发送失败
- (void)onSendDragonMessageFailthWithMsg:(NIMMessage *)msg error:(NSError *)error {
    NSString *errormsg = [NSString stringWithFormat:@"错误码%ld,%@",(long)error.code,error.description];
    NotifyCoreClient(FaceCoreClient, @selector(onDragonSendFailth:), onDragonSendFailth:errormsg);
}



#pragma mark - AppInitClient
- (void)onGetFaceDataSuccess:(NSArray *)faceArr {
    self.tempFaceInfos = [self sortFaceInfosWithfaceInfoArr:[faceArr mutableCopy]]; //表情排序
    
    [self faceDownloadManager];
    NotifyCoreClient(FaceCoreClient, @selector(onGetFaceJsonSuccess), onGetFaceJsonSuccess);
}

#pragma mark - Face Play Method

- (void)handleFaceMessage:(FacePlayInfo *)facePlayInfo {
    [self.receiveFace addObject:facePlayInfo];
    if (self.timer== nil) {
        [self startTheFaceQueueScanner];
    }
}

- (void)startTheFaceQueueScanner {
    NSTimeInterval period = 1; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每1秒执行
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        if (self.receiveFace.count > 0) {
            NSMutableArray *tempArr = [NSMutableArray array];
            NSMutableArray *temp = [self.receiveFace mutableCopy];
            for (FacePlayInfo *item in temp) {
                item.delay = item.delay - 1;
                if (item.delay == 0) {
                    self.isShowingFace = NO;
                    if ([NSThread isMainThread])
                    {
                        NotifyCoreClient(FaceCoreClient, @selector(onFaceIsResult:), onFaceIsResult:item);
                    }
                    else
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            //Update UI in UI thread here
                            NotifyCoreClient(FaceCoreClient, @selector(onFaceIsResult:), onFaceIsResult:item);
                            
                            
                        });
                    }
                    
                }else {
                    [tempArr addObject:item];
                }
            }
            self.receiveFace = tempArr;
        } else {
            dispatch_source_cancel(_timer);
            self.timer = nil;
        }
        
    });
    
    dispatch_resume(_timer);
    self.timer = _timer;
}

#pragma mark - Private


/**
 生成固定区间的不重复随机数
 
 @param from 最小值
 @param to 最大值
 @param count 数量
 @return 返回值
 */
- (NSArray *)randomArray:(int)from to:(int)to count:(int)count {
    
    //随机数从这里边产生
    NSMutableArray *startArray= [NSMutableArray array];
    for (int i = from; i <= to; i++) {
        [startArray addObject:@(i)];
    }
    
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m = count;
    for (int i=0; i<m; i++) {
        int t = arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
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

- (BOOL)isEnableFace:(FaceConfigInfo *)info {
    if (info.displayType != XCFaceDisplayTypeOnlyOne && info.displayType != XCFaceDisplayTypeFlow && info.displayType != XCFaceDisplayTypeOverLay) {
        return NO;
    }else {
        return YES;
    }
    
}

#pragma mark - Getter


- (FaceConfigInfo *)dragonConfigInfo {
    if (_dragonConfigInfo) {
        return _dragonConfigInfo;
    }
    __block FaceConfigInfo *find;
    [self.faceInfos enumerateObjectsUsingBlock:^(FaceConfigInfo*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //龙珠表情
        if(projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB ){
            if (obj.faceType == XCFaceType_Dragon) {
                find = obj;
                *stop = YES;
            }
        }else {
            if (obj.id == 40) {
                find = obj;
                *stop = YES;
            }
        }
       
    }];
    
    _dragonConfigInfo = find;
    return _dragonConfigInfo;
}


- (NSMutableArray *)receiveFace {
    if (_receiveFace == nil) {
        _receiveFace = [NSMutableArray array];
    }
    return _receiveFace;
}

- (BOOL)getShowingFace {
    return self.isShowingFace;
}

- (NSCache *)faceCache {
    if (_faceCache == nil) {
        _faceCache = [[NSCache alloc]init];
    }
    return _faceCache;
}


- (FaceConfigInfo *)getPlayTogetherFace {
    //一起玩
    
    if(projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) {
        if (self.faceInfos != nil && self.faceInfos.count > 0) {
            for (int i = 0; i < self.faceInfos.count; i++) {
                FaceConfigInfo *faceInfo = self.faceInfos[i];
                if (faceInfo.faceType == XCFaceType_PlayTogether) {
                    return faceInfo;
                }
            }
        }else {
            [self requestFaceJson];
        }
        return nil;
    }else {
        if (self.faceInfos != nil && self.faceInfos.count > 0) {
            for (int i = 0; i < self.faceInfos.count; i++) {
                FaceConfigInfo *faceInfo = self.faceInfos[i];
                if (faceInfo.id == 17) {
                    return faceInfo;
                }
            }
        }else {
            [self requestFaceJson];
        }
        return nil;
    }
    
    
}


- (void)requestFaceJson {
    @weakify(self);
    self.isLoadFace = NO;
    self.requestJsonCount += 1;
    [HttpRequestHelper getTheFaceJson:^(NSArray *faceJsonList) {
        @strongify(self);
        self.tempFaceInfos = [self sortFaceInfosWithfaceInfoArr:[faceJsonList mutableCopy]]; //表情排序
        
        [self faceDownloadManager];
        NotifyCoreClient(FaceCoreClient, @selector(onGetFaceJsonSuccess), onGetFaceJsonSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if ((int)self.requestJsonCount < 3) {
            if (self.retryDelay == 0) {
                self.retryDelay = 1;
            }
            [self performSelector:@selector(requestFaceJson) withObject:nil afterDelay:self.retryDelay * 4];
        }
    }];
}

#pragma mark - Test //测试使用
- (void)cancelFaceTimer {
    self.timer = nil;
}

- (void)startFaceTimer {
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.testTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(60.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.testTimer, start, interval, 0);
    
    // 设置回调
    @weakify(self);
    dispatch_source_set_event_handler(self.testTimer, ^{
        @strongify(self);
        [self sendAllFace:[self getPlayTogetherFace]];
    });
    // 启动定时器
    dispatch_resume(self.testTimer);
}



@end
