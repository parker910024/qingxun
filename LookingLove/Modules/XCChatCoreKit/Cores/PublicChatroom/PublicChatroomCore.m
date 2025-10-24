//
//  PublicChatroomCore.m
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/1.
//

#import "PublicChatroomCore.h"

#import <NIMSDK/NIMSDK.h>

#import "ImPublicChatroomCore.h"
#import "ImMessageCore.h"

//client
#import "ImPublicChatroomClient.h"
#import "PublicChatroomMessageClient.h"
#import "PublicChatroomCoreClient.h"
#import "ImMessageCoreClient.h"

#import "XCATAttachment.h"

@interface PublicChatroomCore ()
<
    ImPublicChatroomClient,
    PublicChatroomMessageClient
>

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) dispatch_source_t timer;
//vkiss 公聊限制三秒
@property (assign, nonatomic) NSTimeInterval timerMax;
@end

@implementation PublicChatroomCore


- (instancetype)init {
    self = [super init];
    if (self) {
        AddCoreClient(ImPublicChatroomClient, self);
        AddCoreClient(PublicChatroomMessageClient, self);
        if (projectType() == ProjectType_VKiss ) {
            self.timerMax = 3;
        } else if (projectType() == ProjectType_BB ||
                   projectType() == ProjectType_MengSheng ||
                   projectType() == ProjectType_Haha) {
            self.timerMax = 12;
        } else {
            self.timerMax = 5;
        }
        
        self.canSenMsg = YES;
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - public method

- (void)fetchAtMeMessageByChatroomid:(NSString *)chatroomId
                               count:(NSInteger)count
                           pageCount:(NSInteger)pageCount
                             success:(void (^)(NSArray<NIMMessage *> *))success
                             failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure{
    [HttpRequestHelper fetchPublicMessageWithType:TTPublicHistoryMessageDataProviderType_AtMe byChatroomid:chatroomId count:count pageCount:pageCount success:^(NSArray<NIMMessage *> * _Nonnull messages) {
        success(messages);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        failure(resCode,message);
    }];
}

- (void)fetchSendFromMeMessageByChatroomid:(NSString *)chatroomId
                                     count:(NSInteger)count
                                 pageCount:(NSInteger)pageCount
                                   success:(void (^)(NSArray<NIMMessage *> *))success
                                   failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure{
    [HttpRequestHelper fetchPublicMessageWithType:TTPublicHistoryMessageDataProviderType_FromMe byChatroomid:chatroomId count:count pageCount:pageCount success:^(NSArray<NIMMessage *> * _Nonnull messages) {
        success(messages);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        failure(resCode,message);
    }];
}

- (void)searchAtFriendNoticeFans:(NSString *)key {
    if (key.length <= 0) {
        return;
    }
    [HttpRequestHelper searchAtFriendNoticeFansKey:key Success:^(NSArray<SearchResultInfo *> * _Nonnull result) {
        NotifyCoreClient(PublicChatroomCoreClient, @selector(searchAtFriendNoticeFansSuccess:), searchAtFriendNoticeFansSuccess:result);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}

- (void)onSendPublicChatAtMessage:(PublicChatAtMemberAttachment *)attachment {
    if (!self.canSenMsg) {
        return;
    }
    Attachment *att = [[Attachment alloc]init];
    att.first = Custom_Noti_Header_PublicChatroom;
    att.second = Custom_Noti_Sub_PublicChatroom_Send_At;
    att.data = [attachment model2dictionary];
    [GetCore(ImMessageCore)sendCustomMessageAttachement:att sessionId:[NSString stringWithFormat:@"%ld",GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom yidunEnabled:YES needApns:NO apnsContent:nil];
    NSInteger nameIndex = 0;
    for (NSString *uid in attachment.atUids) {
        XCATAttachment *privateAtt = [[XCATAttachment alloc]init];
        privateAtt.roomId = [NSString stringWithFormat:@"%ld",GetCore(ImPublicChatroomCore).publicChatroomId];
        privateAtt.atUid = uid;
        privateAtt.atName = [attachment.atNames objectAtIndex:nameIndex];
        privateAtt.routerType = 15;
        privateAtt.routerValue = @"";
        privateAtt.content = @"我在交友大厅发现好玩的东西！ @你了 快点过来看看~";
        
        Attachment *at = [[Attachment alloc]init];
        at.first = Custom_Noti_Header_PublicChatroom;
        at.second = Custom_Noti_Sub_PublicChatroom_Send_Private_At;
        at.data = [privateAtt model2dictionary];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:at sessionId:uid type:NIMSessionTypeP2P];
        nameIndex ++;
    }
    [self openCountdown:self.timerMax];
}

- (void)onSendPublicChatTextMessage:(NSString *)text {
    if (!self.canSenMsg) {
        return;
    }
    [GetCore(ImMessageCore)sendTextMessage:text nick:nil sessionId:[NSString stringWithFormat:@"%ld",GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom];
    [self openCountdown:self.timerMax];
}

- (void)onSendPublicChatGameMessage:(XCCPGamePrivateAttachment *)attachment{
    [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:[NSString stringWithFormat:@"%ld",GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom];
}

- (void)onSendPublicChatGameOverMessage:(XCCPGamePrivateSysNotiAttachment *)attachment{
    [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:[NSString stringWithFormat:@"%ld",GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom];
}


- (void)publicChatRoomNotMessage:(UserID)targetUid
                        duration:(int)duration
                          remark:(NSString *)remark{
    [HttpRequestHelper repuestPublicChatRoomNotMessage:targetUid duration:duration remark:remark success:^{
        
        NotifyCoreClient(PublicChatroomCoreClient, @selector(onPublicChatRoomNotMessageSuccess), onPublicChatRoomNotMessageSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}

#pragma mark - private method

- (void)openCountdown:(NSInteger)countDown{
    self.canSenMsg = NO;
    __block NSInteger time = countDown; //倒计时时间
    
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            @weakify(self);
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                self.canSenMsg = YES;
                NotifyCoreClient(PublicChatroomCoreClient, @selector(onPublicChatSenderCountDownFinish), onPublicChatSenderCountDownFinish);
                
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                NotifyCoreClient(PublicChatroomCoreClient, @selector(onPublicChatSenderCountDown:), onPublicChatSenderCountDown:seconds);
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - PublicChatroomMessageClient


#pragma mark - ImPublicChatroomClient

@end
