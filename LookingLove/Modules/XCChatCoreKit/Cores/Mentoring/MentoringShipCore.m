//
//  MentoringShip.m
//  XCChatCoreKit
//
//  Created by gzlx on 2019/1/21.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "MentoringShipCore.h"
#import "MentoringShipCoreClient.h"
#import "ImMessageCoreClient.h"
#import "Attachment.h"
#import "NotificationCoreClient.h"
#import "XCMentoringShipAttachment.h"
#import "AuthCore.h"
#import "GiftCoreClient.h"
#import "ImMessageCore.h"
#import "UserCore.h"
#import "GiftInfo.h"
#import "GiftAllMicroSendInfo.h"

@interface MentoringShipCore ()<NotificationCoreClient, ImMessageCoreClient>
/** 正在被抢徒弟的数组, core 内部管理 */
@property (nonatomic, strong) NSMutableArray<MentoringGrabModel *> *grabApprenticesModels;

/** 抢徒弟的倒计时 */
@property (strong, nonatomic) dispatch_source_t grabApprenticesTimer;
/** 抢徒弟倒计时的时间 */
@property (nonatomic, assign) NSInteger grabApprenticesCurrentTime;
@end

@implementation MentoringShipCore

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (id)init{
    if (self = [super init]) {
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(NotificationCoreClient, self);
    }
    return self;
}

/**
 是不是可以收徒
 */
- (void)canHarvestApprenticeWithUid:(UserID)uid{
    [HttpRequestHelper userCanHarvestApprenticeWithUid:uid success:^(NSDictionary * _Nonnull dic) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(checkUserCanHarvestApprenticeingSuceess:), checkUserCanHarvestApprenticeingSuceess:dic);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(checkUserCanHarvestApprenticeingFail:), checkUserCanHarvestApprenticeingFail:message);
    }];
}


/**
 请求收徒
 */
- (void)applyToHarvestApprcnticeWithUid:(UserID)uid{
    [HttpRequestHelper requstToHarvestApprcnticeWithUid:uid success:^(NSDictionary * _Nonnull dic) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(requestHarvestApprenticeingSuccess:), requestHarvestApprenticeingSuccess:dic);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(requestHarvestApprenticeingFail:), requestHarvestApprenticeingFail:message);
    }];
}


/**
 请求师徒关系的b跑马灯
 
 @param page 当前的页数
 @param pageSize 一页的个数
 */
- (void)getMasterAndApprenticeRelationShipListWithPage:(int)page pageSize:(int)pageSize{
    [HttpRequestHelper getMasterAndApprenticeRelationShipListWithPage:page pageSize:pageSize success:^(NSArray * _Nonnull ships) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(getMasterAndApprenticeRelationShipListSuccess:), getMasterAndApprenticeRelationShipListSuccess:ships);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(getMasterAndApprenticeRelationShipListFail:), getMasterAndApprenticeRelationShipListFail:message);
    }];
}


/**
 上报任务三
 @param userId 师傅的uid
 @param apprenticeUid 徒弟的Uid
 */
- (void)reportTheMentoringShipTaskThreeWithMasterUid:(UserID)userId apprenticeUid:(UserID)apprenticeUid{
    [HttpRequestHelper reportTheMentoringShipTaskThreeWithMasterUid:userId apprenticeUid:apprenticeUid success:^(NSDictionary * _Nonnull dic) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(reportTheMentoringShipTaskThreeWithMasteSuccess:), reportTheMentoringShipTaskThreeWithMasteSuccess:dic);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(reportTheMentoringShipTaskThreeWithMasteFail:), reportTheMentoringShipTaskThreeWithMasteFail:message);
    }];
}
/**
 建立师徒关系
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的Uid
 @param type 1 同意 2 拒绝
 */
- (void)bulidMentoringShipWithMasterUid:(UserID)masterUid
                          apprenticeUid:(UserID)apprenticeUid
                                   type:(int)type{
    [HttpRequestHelper bulidMentoringShipWithMasterUid:masterUid apprenticeUid:apprenticeUid type:type success:^(NSDictionary * _Nonnull dic) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(bulidMentoringShipWithMasterSuccess:type:), bulidMentoringShipWithMasterSuccess:dic type:type);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(bulidMentoringShipWithMasterFail:code:type:), bulidMentoringShipWithMasterFail:message code:failCode type:type);
    }];
}




/**
a师傅给徒弟打招呼
 
 @param uid 操作者的uid
 @param likedUid 关注的那个人的Uid
 */
- (void)mentoringShipFocusOrGreetToUser:(UserID)uid
                                likeUid:(UserID)likedUid{
    [HttpRequestHelper mentoringShipFocusOrGreetToUser:uid likeUid:likedUid success:^(NSDictionary * _Nonnull dic) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(mentoringShipFocusOrGreetToUserSuccess:), mentoringShipFocusOrGreetToUserSuccess:dic);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(mentoringShipFocusOrGreetToUserFail:), mentoringShipFocusOrGreetToUserFail:message);
    }];
}

/**
 请求师徒关系的 我的师徒列表
 
 @param page 当前的页数
 @param pageSize 一页的个数
 */
- (void)getMyMasterAndApprenticeList:(int)page pageSize:(int)pageSize state:(int)state {
    [HttpRequestHelper getMyMasterAndApprenticeList:page pageSize:pageSize success:^(NSArray * _Nonnull list) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(getMyMasterAndApprenticeListSuccess:page:state:), getMyMasterAndApprenticeListSuccess:list page:page state:state);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(getMyMasterAndApprenticeListFail:page:state:), getMyMasterAndApprenticeListFail:message page:page state:state);
    }];
}

/**
 请求师徒关系的 获取名师榜数据
 
 @param page 当前的页数
 @param pageSize 一页的个数
 @param state 下拉or上啦
 @param type 查询类型（1：本周名师榜，2：上周名师榜
 */
- (void)getMasterAndApprenticeRankingList:(int)page pageSize:(int)pageSize state:(int)state type:(int)type {
    [HttpRequestHelper getMasterAndApprenticeRankingList:page pageSize:pageSize type:type success:^(NSArray * _Nonnull list) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(getMasterAndApprenticeRankingListSuccess:page:state:type:), getMasterAndApprenticeRankingListSuccess:list page:page state:pageSize type:type);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(getMasterAndApprenticeRankingListFail:page:state:type:), getMasterAndApprenticeRankingListFail:message page:page state:state type:type);
    }];
}

/**
 发送师徒关系邀请
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
- (void)masterSendInviteRequestWithMasterUid:(UserID)masterUid
                               apprenticeUid:(UserID)apprenticeUid {
    [HttpRequestHelper masterSendInviteRequestWithMasterUid:masterUid apprenticeUid:apprenticeUid success:^{
        NotifyCoreClient(MentoringShipCoreClient, @selector(masterSendInviteRequestSuccess), masterSendInviteRequestSuccess);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(masterSendInviteRequestFail:), masterSendInviteRequestFail:message);
    }];
}

/**
 解除师徒关系
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
- (void)masterSendDeleteRequestWithMasterUid:(UserID)masterUid
                               apprenticeUid:(UserID)apprenticeUid
                                     operUid:(UserID)operUid {
    [HttpRequestHelper masterSendDeleteRequestWithMasterUid:masterUid apprenticeUid:apprenticeUid operUid:operUid success:^{
        NotifyCoreClient(MentoringShipCoreClient, @selector(masterSendDeleteRequestSuccess), masterSendDeleteRequestSuccess);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(masterSendDeleteRequestFail:), masterSendDeleteRequestFail:message);
    }];
}


/**
 师徒关系送礼物（师傅给徒弟送）

 @param giftID 礼物的id
 @param gameGiftType 礼物的类型
 @param giftNum 礼物的数量
 @param targetUid 目标
 */
- (void)mentoringShipSendChatGift:(NSInteger)giftID
        gameGiftType:(GameRoomGiftType)gameGiftType
             giftNum:(NSInteger)giftNum
           targetUid:(UserID)targetUid
           giftModel:(MentoringGiftModel *)giftModel{
    
    __block NSInteger giftId = giftID;
    __block UserID targetUID = targetUid;
    @weakify(self);
    [HttpRequestHelper sendMentoringShipGift:giftId  targetUid:targetUID giftNum:giftNum gameGiftType:gameGiftType type:SendGiftType_Person msg:@"" success:^(GiftAllMicroSendInfo *info) {
        @strongify(self);
        [self mastersSendGiftToApprenticeSendCustomMessageWith:giftModel targetUid:targetUid];
        NotifyCoreClient(MentoringShipCoreClient, @selector(onUpdatePackGiftWithGiftIdWhenMentoringShip), onUpdatePackGiftWithGiftIdWhenMentoringShip);
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if ([resCode integerValue] == 8000) {
            NotifyCoreClient(GiftCoreClient, @selector(onGiftIsOffLine:), onGiftIsOffLine:message);
        }
    }];
    
}

/**
 师徒任务3 邀请进房判断师徒任务是否有效
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
- (void)mentoringShipInviteEnableWithMasterUid:(UserID)masterUid apprenticeUid:(UserID)apprenticeUid isMaster:(BOOL)isMaster{
    
    [HttpRequestHelper mentoringShipInviteEnableWithMasterUid:masterUid apprenticeUid:apprenticeUid success:^{
        NotifyCoreClient(MentoringShipCoreClient, @selector(mentoringShipInviteEnableSuccessisMaster:), mentoringShipInviteEnableSuccessisMaster:isMaster);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(mentoringShipInviteEnableFail:isMaster:), mentoringShipInviteEnableFail:message isMaster:isMaster);
    }];
}

/**
 抢徒弟
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
- (void)mentoringShipGrabApprenticeWithMasterUid:(UserID)masterUid apprenticeUid:(UserID)apprenticeUid {
    [HttpRequestHelper mentoringShipGrabApprenticeWithMasterUid:masterUid apprenticeUid:apprenticeUid success:^{
        NotifyCoreClient(MentoringShipCoreClient, @selector(mentoringShipGrabApprenticeSuccess:), mentoringShipGrabApprenticeSuccess:apprenticeUid);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(MentoringShipCoreClient, @selector(mentoringShipGrabApprenticeFail:errorCode:), mentoringShipGrabApprenticeFail:message errorCode:failCode);
    }];
}

- (void)mastersSendGiftToApprenticeSendCustomMessageWith:(MentoringGiftModel *)giftInfo targetUid:(UserID)targetUid{
    Attachment * attach = [[Attachment alloc] init];
    attach.first = Custom_Noti_Header_Gift;
    attach.second = Custom_Noti_Sub_Gift_Send;
    
    GiftInfo * gift = [[GiftInfo alloc] init];
    gift.giftName = giftInfo.giftName;
    gift.giftUrl = giftInfo.picUrl;
    gift.giftId = giftInfo.giftId;
    
    GiftAllMicroSendInfo * sendInfo = [[GiftAllMicroSendInfo alloc] init];
    sendInfo.gift = gift;
    sendInfo.giftNum = 1;
    attach.data = [sendInfo model2dictionary];
    
    UserInfo * info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
    [GetCore(ImMessageCore)sendCustomMessageAttachement:attach sessionId:[NSString stringWithFormat:@"%lld",targetUid] type:NIMSessionTypeP2P needApns:YES apnsContent:[NSString stringWithFormat:@"%@给你送了%d个礼物",info.nick,1]];
    
}

- (void)onSendMessageSuccess:(NIMMessage *)msg{
    if (msg.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
        if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)obj.attachment;
            if (attachment.first == Custom_Noti_Header_Mentoring_RelationShip && attachment.second ==Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite) {
                self.masterUid = 0;
                self.inviteApprenticeUid = 0;
            }
        }
    }
}


/**
 更新消息主控制器 头部选中的菜单 0:选中消息 1:选中联系人
 
 @param index 0:选中消息 1:选中联系人
 */
- (void)updateMessageMainViewControllerSelectIndex:(NSInteger)index {
    NotifyCoreClient(MentoringShipCoreClient, @selector(updateMessageMainViewControllerSelectIndex:), updateMessageMainViewControllerSelectIndex:index);
}

#pragma mark -
- (void)onRecvCustomP2PNoti:(NIMCustomSystemNotification *)notification{
    Attachment *attachment = [Attachment yy_modelWithJSON:notification.content];
    if (attachment.first == Custom_Noti_Header_Mentoring_RelationShip){
        XCMentoringShipAttachment * mentoringAttach = [XCMentoringShipAttachment yy_modelWithJSON:attachment.data];
        if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master) {
            [[BaiduMobStat defaultStat] logEvent:@"news_task_one_start" eventLabel:@"任务一开始"];
            //师傅的第一个任务
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.apprenticeUid];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Apprentice){
            //徒弟的第一个任务
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.masterUid];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master_Tips){
            //师傅完成了第一个任务 先发一个 tips给徒弟
             [self createNimmessageWith:attachment sessionUid:mentoringAttach.sessionId];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Tips){
            [[BaiduMobStat defaultStat] logEvent:@"news_task_one_complete" eventLabel:@"任务一完成"];
            //d徒弟完成了第一个任务 先发一个 tips给师傅
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.sessionId];
        }else if(attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Master){
            [[BaiduMobStat defaultStat] logEvent:@"news_task_two_start" eventLabel:@"任务二开始"];
            //师傅收到的任务2
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.apprenticeUid];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Apprentice){
            //徒弟收到的任务2
             [[BaiduMobStat defaultStat] logEvent:@"news_task_two_complete" eventLabel:@"任务二完成"];
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.masterUid];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Master){
            //师傅收到的第三个任务
            [[BaiduMobStat defaultStat] logEvent:@"news_task_three_start" eventLabel:@"任务三开始"];
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.apprenticeUid];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Apprentice){
            //徒弟收到的第三个任务
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.masterUid];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Master){
            //师傅收到的第四个任务
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.apprenticeUid];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Apprentice){
            [[BaiduMobStat defaultStat] logEvent:@"news_task_four_start" eventLabel:@"任务四开始"];
            //徒弟收到的第四个任务
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.masterUid];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Result){
            //收徒结果
            NotifyCoreClient(MentoringShipCoreClient, @selector(setupMentoringShipSucess), setupMentoringShipSucess);
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.sessionId];
            [[BaiduMobStat defaultStat] logEvent:@"news_successful_apprentice" eventLabel:@"收徒成功"];
        }else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Fail_Tips){
            //任务失败
            [self createNimmessageWith:attachment sessionUid:mentoringAttach.sessionId];
            [[BaiduMobStat defaultStat] logEvent:@"news_failure_apprentice" eventLabel:@"收徒失败"];
        } else if (attachment.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Grab) {
            
            NSArray<MentoringGrabModel *> *apprentices = [NSArray yy_modelArrayWithClass:[MentoringGrabModel class] json:attachment.data[@"apprentices"]];
            NSInteger countdown = [attachment.data[@"countdown"] integerValue];
            for (MentoringGrabModel *model in apprentices) {
                model.countdown = countdown;
            }
            [self.grabApprenticesModels addObjectsFromArray:apprentices];
            NotifyCoreClient(MentoringShipCoreClient, @selector(onRecvCustomP2PGrabApprenticeNoti:), onRecvCustomP2PGrabApprenticeNoti:apprentices);
            [self continueGrabApprenticesCountdownWithTime:countdown];
        }
    }
}


//创建一个消息回话 并且保存到本地
- (void)createNimmessageWith:(Attachment *)attachment sessionUid:(UserID)sessionUid{
    NIMMessage * message = [[NIMMessage alloc] init];
    NIMCustomObject * customObject = [[NIMCustomObject alloc] init];
    customObject.attachment = attachment;
    message.messageObject = customObject;
    message.localExt = [attachment model2dictionary];
    message.from = [NSString stringWithFormat:@"%lld", sessionUid];
    NIMSession * session =  [NIMSession session:[NSString stringWithFormat:@"%lld", sessionUid] type:NIMSessionTypeP2P];
    [message setValue:session forKey:@"session"];
    NSArray * messages = @[message];
    [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:session completion:^(NSError * _Nullable error) {
        if (error== nil) {
            NotifyCoreClient(MentoringShipCoreClient, @selector(addMeesageToChatUIWith:), addMeesageToChatUIWith:messages);
        }
    }];
}

#pragma mark - 倒计时相关方法
- (void)stopCountDown {
    if (self.timer != nil) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    self.currentTime = 0;
}

- (void)openCountdownWithTime:(long)time {
    
    __block long tempTime = time; //倒计时时间
    __weak typeof(self) weakSelf = self;
    if (self.timer != nil) {
        dispatch_source_cancel(self.timer);
    }
    
    self.currentTime = tempTime;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(self.timer, ^{
        typeof(weakSelf) self = weakSelf;
        
        if(tempTime <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (GetCore(AuthCore).getUid.userIDValue == self.apprenticeUid) {
                    [GetCore(MentoringShipCore) reportTheMentoringShipTaskThreeWithMasterUid:self.masterUid apprenticeUid:self.apprenticeUid];
                }
                NotifyCoreClient(MentoringShipCoreClient, @selector(mentoringShipCutdownFinishWithMasterUid:apprenticeUid:), mentoringShipCutdownFinishWithMasterUid:self.masterUid apprenticeUid:self.apprenticeUid);
                // 倒计时结束
                self.currentTime = 0;
                self.masterUid = 0;
                self.apprenticeUid = 0;
                self.countDownStatus = TTMasterCountDownStatusEnd;
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                NotifyCoreClient(MentoringShipCoreClient, @selector(mentoringShipCutdownOpen:), mentoringShipCutdownOpen:tempTime);
            });
            self.currentTime = tempTime;
            tempTime--;
            self.countDownStatus = TTMasterCountDownStatusIng;
        }
    });
    dispatch_resume(self.timer);
}


/**
 继续抢徒弟的倒计时

 @param time 增加倒计时的时间
 */
- (void)continueGrabApprenticesCountdownWithTime:(long)time {
    
    self.grabApprenticesCurrentTime += time;
    if (self.grabApprenticesTimer != nil) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.grabApprenticesTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.grabApprenticesTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(self.grabApprenticesTimer, ^{
        typeof(weakSelf) self = weakSelf;
        
        if(self.grabApprenticesCurrentTime <= 0){ //倒计时结束，关闭
            [self grabApprenticesStopCountDown];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.grabApprenticesModels removeAllObjects];
                NotifyCoreClient(MentoringShipCoreClient, @selector(updateGrabApprenticeData:), updateGrabApprenticeData:self.grabApprenticesModels);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *grabModels = [self.grabApprenticesModels copy];
                for (MentoringGrabModel *grabModel in grabModels) {
                    if (grabModel.countdown <= 0) {
                        [self.grabApprenticesModels removeObject:grabModel];
                    }
                    grabModel.countdown -= 1;
                }
                if (grabModels.count != self.grabApprenticesModels.count) {
                    NotifyCoreClient(MentoringShipCoreClient, @selector(updateGrabApprenticeData:), updateGrabApprenticeData:self.grabApprenticesModels);
                }
                NotifyCoreClient(MentoringShipCoreClient, @selector(grabApprenticeCutdownAction), grabApprenticeCutdownAction);
            });
            self.grabApprenticesCurrentTime -= 1;
        }
    });
    dispatch_resume(self.grabApprenticesTimer);
}

/**
 停止可抢徒弟的倒计时
 */
- (void)grabApprenticesStopCountDown {
    if (self.grabApprenticesTimer != nil) {
        dispatch_source_cancel(_grabApprenticesTimer);
        _grabApprenticesTimer = nil;
    }
    self.grabApprenticesCurrentTime = 0;
}

#pragma mark - getter
- (NSMutableArray<MentoringGrabModel *> *)grabApprenticesModels {
    if (!_grabApprenticesModels) {
        _grabApprenticesModels = [NSMutableArray array];
    }
    return _grabApprenticesModels;
}

@end
