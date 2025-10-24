//
//  TTPositionCoreManager.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionCoreManager.h"
#import "TTPositionUIManager.h"
#import "TTPositionHelper.h"
#import "TTRoomPositionConfig.h"
#import "XCConst.h"
//view
#import "TTPositionItem.h"
//core
#import "RoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "MeetingCore.h"
#import "FaceCore.h"
#import "FaceImageTool.h"
#import "FaceSendInfo.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "TTGameStaticTypeCore.h"
#import "RoomOnMicGiftValue.h"
#import "RoomGiftValueCore.h"
#import "ImMessageCore.h"
#import "RoomGiftValueCore.h"
#import "ImRoomCoreV2.h"
#import "TTBlindDateCore.h"

#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"
#import "RoomCoreClient.h"
#import "MeetingCoreClient.h"
#import "FaceCoreClient.h"
#import "RoomQueueCoreClient.h"
#import "RoomMagicCoreClient.h"
#import "GiftCoreClient.h"
#import "RoomGiftValueCoreClient.h"
#import "TTBlindDateCoreClient.h"

static TTPositionCoreManager * coreManager;
static dispatch_once_t onceToken;

@interface TTPositionCoreManager ()
<ImRoomCoreClient,
ImRoomCoreClientV2,
RoomCoreClient,
RoomQueueCoreClient,
MeetingCoreClient,
FaceCoreClient,
RoomGiftValueCoreClient,
RoomMagicCoreClient,
GiftCoreClient,
TTBlindDateCoreClient
>

/** 麦位信息 key麦位 value 坑位信息*/
@property (strong, nonatomic) NSMutableDictionary<NSString *, ChatRoomMicSequence *> *mircoList;

/** 礼物值*/
@property (nonatomic, strong) RoomOnMicGiftValue *giftValue;

/** 房间公告*/
@property (nonatomic, strong) TTPositionTopicModel *topicModel;

@end

@implementation TTPositionCoreManager

+ (instancetype)shareCoreManager{
    
    dispatch_once(&onceToken, ^{
        coreManager = [[TTPositionCoreManager alloc] init];
    });
    return coreManager;
}

- (instancetype)init {
    [self addCore];
    return self;
}

- (void)addCore {
    AddCoreClient(ImRoomCoreClient, self);
    AddCoreClient(ImRoomCoreClientV2, self);
    AddCoreClient(RoomCoreClient, self);
    AddCoreClient(MeetingCoreClient, self);
    AddCoreClient(FaceCoreClient, self);
    AddCoreClient(RoomQueueCoreClient, self);
    AddCoreClient(RoomMagicCoreClient, self);
    AddCoreClient(GiftCoreClient, self);
    AddCoreClient(RoomGiftValueCoreClient, self);
    AddCoreClient(TTBlindDateCoreClient, self);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterRoomFromMini) name:kEnterRoomFromMiniRoomNotification object:nil];
}

#pragma mark - public method
- (void)initCoreManagerConfig {
    //这个只有在 最小化 房间的时候 点进来  因为没有调用任何通知的方法 但是保存的有当前的房间信息
    if (GetCore(RoomCoreV2).getCurrentRoomInfo) {
        //房间介绍
        [self roomInfoUpdateChageTopicContent];
        //更换模式的时候 更新模式的布局
        [self roomInfoUpdateChangeRoomType];
        //设置房间模式
        [self.dataInteractor updateRoomPositionTypeWith:[[TTPositionHelper shareHelper] configTTRoomPositionViewType:self.style]];
        self.showGiftValue = NO;
        [self.dataInteractor updatePostionMicWithSqueue:GetCore(ImRoomCoreV2).micQueue];
    }
}


#pragma mark - private method
//点击房间最小化进来的
- (void)enterRoomFromMini {
    [self onCurrentRoomInfoChanged];
}

- (void)updateTopicLabelContentWith:(NIMChatroomMember *)chatRoomMember {
    if (chatRoomMember.userId.userIDValue == GetCore(AuthCore).getUid.userIDValue) {
         BOOL showEditIcon = ((chatRoomMember.type == NIMChatroomMemberTypeCreator || chatRoomMember.type == NIMChatroomMemberTypeManager) && [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole != XCUserInfoPlatformRoleSuperAdmin) ? YES : NO;
        self.topicModel.isEdit = showEditIcon;
        [self.dataInteractor updatePositionTopicLableWith:self.topicModel];
    }
}

- (void)roomInfoUpdateChageTopicContent {
    RoomInfo * info = GetCore(RoomCoreV2).getCurrentRoomInfo;
    NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
    NSString *topic = @" 暂无房间话题";
    BOOL showEditIcon = ((myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) && [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole != XCUserInfoPlatformRoleSuperAdmin) ? YES : NO;
    
    if (info.roomDesc.length > 0) {
        topic = info.roomDesc;
    } else {
        if (myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) {
            topic = @" 点击设置房间话题";
        }
    }
    self.topicModel.roomTag = info.roomTag;
    self.topicModel.tagPict = info.tagPict;
    self.topicModel.isEdit = showEditIcon;
    self.topicModel.topicString = topic;
    [self.dataInteractor updatePositionTopicLableWith:self.topicModel];
}
//房间信息更新的时候 坑位模式的改变
- (void)roomInfoUpdateChangeRoomType {
    RoomInfo * info = GetCore(RoomCoreV2).getCurrentRoomInfo;
    TTRoomPositionViewType roomPositionType;
    //这个type没有什么实际的作用 只是为了表示从什么模式切换的什么模式 需要刷新坑位的frame
    if (self.style == TTRoomPositionViewLayoutStyleNormal) {
        roomPositionType = TTRoomPositionViewTypeNormal;
    } else if (self.style == TTRoomPositionViewLayoutStyleCP){
        if (info.isOpenGame){
            roomPositionType = TTRoomPositionViewTypeCPGame;
        }else{
            roomPositionType = TTRoomPositionViewTypeCP;
        }
    } else if (self.style == TTRoomPositionViewLayoutStyleLove) {
        roomPositionType = TTRoomPositionViewTypeLove;
    } else {
        roomPositionType = TTRoomPositionViewTypeNormal;
    }
    [self.uiInteractor updateRoomPositionTypeWith:roomPositionType];
}

#pragma mark - ImRoomCoreClientV2
#pragma mark - 获取队列
//获取房间队列

- (void)onGetPreRoomQueueSuccessV2:(NSMutableDictionary*)info {
    
    [self onGetRoomQueueSuccessV2:info];
}

//获取了chatroommember后
- (void)onGetRoomQueueSuccessV2:(NSMutableDictionary*)info {
    self.mircoList = info;
    [self.dataInteractor clearMicNotPeopelDragon];
    [self.dataInteractor updatePostionMicWithSqueue:info];
    //是不是有土豪位
    if (GetCore(RoomCoreV2).getCurrentRoomInfo) {
        [self.uiInteractor isShowPositionVipViewWithRoomInfor:GetCore(RoomCoreV2).getCurrentRoomInfo];
    }
    //房间信息 变更 是不是显示礼物值
    [self updateGiftValueConfig];
}

//房间信息变更的时候
- (void)onCurrentRoomInfoChanged {
    //更换模式的时候 更新模式的布局
    [self roomInfoUpdateChangeRoomType];
    //设置房间模式
    [self.dataInteractor updateRoomPositionTypeWith:[[TTPositionHelper shareHelper] configTTRoomPositionViewType:self.style]];
    //更新离开模式
    [self.uiInteractor configRoonInfoUpdateToUpOwnerPositionView];
    
   //房间信息 变更是不是限制里礼物值
    [self updateGiftValueConfig];
     //房间介绍
    [self roomInfoUpdateChageTopicContent];
     // 更新麦序
    
    [self.dataInteractor updatePostionMicWithSqueue:GetCore(ImRoomCoreV2).micQueue];
    
    //是不是显示土豪位(房间的信息更新 可能是更换了模式)
    [self.uiInteractor isShowPositionVipViewWithRoomInfor:GetCore(RoomCoreV2).getCurrentRoomInfo];
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
        [self.uiInteractor onCurrentRoomInfoUpdate];
    }
}

//进房成功
- (void)onMeInterChatRoomSuccess {
    //设置房间模式
//    [self.dataInteractor updateRoomPositionTypeWith:[[TTPositionHelper shareHelper] configTTRoomPositionViewType:self.style]];
    //进房成功的时候 变更 是不是显示礼物值
//    [self updateGiftValueConfig];
}
#pragma mark - RoomQueueCoreClient
//麦序状态更新
- (void)onMicroQueueUpdate:(NSMutableDictionary *)micQueue {
    self.mircoList = GetCore(ImRoomCoreV2).micQueue;
     [self.dataInteractor updatePostionMicWithSqueue:micQueue];
    [self.dataInteractor clearMicNotPeopelDragon];
    
    //是不是显示土豪位(如果是锁麦的话)
    [self.uiInteractor isShowPositionVipViewWithRoomInfor:GetCore(RoomCoreV2).getCurrentRoomInfo];
}

/// 上麦成功
/// @param position 上麦的坑位
/// @param uid 谁上麦了
/// @param isReConnect 是否是断网重连上麦了
- (void)onMicroUpMicSuccessWithPosition:(NSString *)position uid:(UserID)uid isReConnect:(BOOL)isReConnect {
    UserID roomUID = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
    if (!isReConnect) {
//        [GetCore(RoomGiftValueCore) requestRoomGiftValueStatusUpMicWithRoomUid:roomUID micUid:uid position:position];
    }
//    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
//        [GetCore(TTBlindDateCore) requestLoveRoomUpMicWithRoomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid uid:GetCore(AuthCore).getUid.userIDValue position:position.integerValue];
//    }
}

/// 下麦成功
/// @param position 下麦的坑位
//- (void)onMicroDownMicSuccessWithPosition:(NSString *)position {
//    
//}

/**
 队列变更回调
 
 @param userId 队列变更的uid
 @param position 队列变更的位置
 @param updateType 队列变更类型
 */
- (void)onRoomQueueUpdate:(UserID)userId position:(int)position type:(RoomQueueUpateType)updateType {
    
    if (userId == GetCore(AuthCore).getUid.userIDValue && GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
        [self.uiInteractor getRoomOnMicStatus:updateType position:position];
    }
    
    if (!self.isShowGiftValue) {
        return;
    }
    
    //清空当前上下坑位礼物值
    for (TTPositionItem *item in [TTPositionUIManager shareUIManager].positionItems) {
        if (item.position.intValue == position) {
            [item resetGiftValue];
        }
    }
    
    ///当开启礼物值，坑位变更是当前用户时，发送上下坑接口
//    if (GetCore(AuthCore).getUid.userIDValue == userId) {
//        UserID roomUID = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
//        if (updateType == RoomQueueUpateTypeRemove) {
//            [GetCore(RoomGiftValueCore) requestRoomGiftValueStatusDownMicWithRoomUid:roomUID micUid:userId position:@(position).stringValue];
//        } else {
//            [GetCore(RoomGiftValueCore) requestRoomGiftValueStatusUpMicWithRoomUid:roomUID micUid:userId position:@(position).stringValue];
//        }
//    }
    
}

#pragma mark - MeetCoreClient
//audio回调
- (void)onSpeakUsersReport:(NSArray *)userInfos {
    [self.dataInteractor reloadTheSpeakingView];
}
//加入声网
- (void)onJoinMeetingSuccess {
    self.mircoList = GetCore(ImRoomCoreV2).micQueue;
//    [self updatePositionItemUI];
}


#pragma mark - RoomCoreClient
//权限管理
- (void)onManagerAdd:(NIMChatroomMember *)member{
    self.mircoList = GetCore(ImRoomCoreV2).micQueue;
   //设置为管理员的时候 有了修改房间公告的权利
    [self updateTopicLabelContentWith:member];
    if (member.userId.userIDValue == [GetCore(AuthCore) getUid].userIDValue) {
        if ([GetCore(RoomQueueCoreV2) findThePositionByUid:member.userId.userIDValue].intValue == -1) {
            [self.uiInteractor updateCurrentUserRole:YES];
        }
    }
}

- (void)onManagerRemove:(NIMChatroomMember *)member{
    self.mircoList = GetCore(ImRoomCoreV2).micQueue;
    //取消管理员的时候 没有了修改房间公告的权利
    [self updateTopicLabelContentWith:member];
    if (member.userId.userIDValue == [GetCore(AuthCore) getUid].userIDValue) {
        if ([GetCore(RoomQueueCoreV2) findThePositionByUid:member.userId.userIDValue].intValue == -1) {
            [self.uiInteractor updateCurrentUserRole:NO];
        }
    }
}

- (void)userBeAddBlack:(NIMChatroomMember *)member{
    self.mircoList = GetCore(ImRoomCoreV2).micQueue;
//    [self updatePositionItemUI];
}
- (void)userBeRemoveBlack:(NSString *)userId{
    self.mircoList = GetCore(ImRoomCoreV2).micQueue;
//    [self updatePositionItemUI];
}

#pragma mark - FaceCoreClient
//收到表情
- (void)onReceiveFace:(NSMutableArray<FaceReceiveInfo *> *)faceRecieveInfos {
    [self.dataInteractor showFaceInPositionViewWith:faceRecieveInfos];
}

//收到龙珠
- (void)onRecvChatRoomDragonMsg:(NIMMessage *)message {
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    if (attachment.second == Custom_Noti_Sub_Queue_Kick) {//踢下麦
        // 自己 被踢下麦
        return;
    }
    FaceSendInfo *faceattachement = [FaceSendInfo modelWithJSON:attachment.data];
    NSMutableArray *arr = [faceattachement.data mutableCopy];
    [self.dataInteractor dealDragonWithRecieveInfos:arr state:attachment.second];
}

#pragma mark --- TTBlindDateCoreClient ---
- (void)updateLoveRoomPublicLoveWithPosition:(NSString *)position choosePosition:(NSString *)chooseUid chooseMic:(NSString *)chooseMic {
    Attachment *attachement = [[Attachment alloc] init];
    attachement.first = Custom_Noti_Header_RoomLoveModelFirst;
    attachement.second = Custom_Noti_Sub_Room_LoveModel_Sec_PublicLoveEffect;
    NSDictionary *dict = @{@"startMic":position,@"chooseUid":chooseUid,@"chooseMic":chooseMic};
    attachement.data = dict;
    NSString *sessionID = [NSString stringWithFormat:@"%zd", GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
}

#pragma mark - 礼物值
- (void)updateGiftValueConfig {
    if (GetCore(RoomCoreV2).getCurrentRoomInfo) {
         self.showGiftValue = GetCore(RoomCoreV2).getCurrentRoomInfo.showGiftValue && [GetCore(ImRoomCoreV2) canOpenGiftValue];
        if (self.isShowGiftValue) {
            if (self.giftValue == nil) {
                UserID uid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
                [GetCore(RoomGiftValueCore) requestRoomMicGiftValueForRoomUid:uid];
            }
            //清空关闭了离开模式后 房主坑删的礼物信息
            [self.uiInteractor clearOwnerPositionGiftValueWhenOffLeaveMode];
        }
        if (self.showGiftValue) {
            ///进房拿到麦序成员后，请求礼物值
            UserID uid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
            [GetCore(RoomGiftValueCore) requestRoomMicGiftValueForRoomUid:uid];
        }
    }else {
        self.showGiftValue = NO;
    }
}

/*
 接收到清除礼物值同步消息
 @param giftValue 清除后麦位礼物值信息 */
- (void)onReceiveCleanGiftValueSync:(RoomOnMicGiftValue *)giftValue {

    if (![giftValue isKindOfClass:RoomOnMicGiftValue.class]) {
        return;
    }
    for (RoomOnMicGiftValueDetail *value in giftValue.giftValueVos) {
        [self.dataInteractor updatePostionItemGiftValue:value.giftValue
                                     uid:value.uid
                              updateTime:giftValue.currentTime];
    }
}

#pragma mark - GiftCoreClient
- (void)onReceiveGift:(GiftAllMicroSendInfo *)giftReceiveInfo {

    if (![giftReceiveInfo isKindOfClass:GiftAllMicroSendInfo.class]) {
        return;
    }

    //监听收到礼物，当开启礼物值时，更新礼物值
    if (!self.isShowGiftValue) {
        return;
    }

    for (RoomOnMicGiftValueDetail *value in giftReceiveInfo.giftValueVos) {
        [self.dataInteractor updatePostionItemGiftValue:value.giftValue
                                     uid:value.uid
                              updateTime:giftReceiveInfo.currentTime];
    }
}

#pragma mark - RoomMagicCoreClient
- (void)onReceiveRoomMagic:(RoomMagicInfo *)roomMagicInfo {
    if (![roomMagicInfo isKindOfClass:RoomMagicInfo.class]) {
        return;
    }
    //监听收到礼物，当开启礼物值时，更新礼物值
    if (!self.isShowGiftValue) {
        return;
    }

    for (RoomOnMicGiftValueDetail *value in roomMagicInfo.giftValueVos) {
        [self.dataInteractor updatePostionItemGiftValue:value.giftValue
                                     uid:value.uid
                              updateTime:roomMagicInfo.currentTime];
    }
}

#pragma mark - RoomGiftValueCoreClient
/**
 获取房间所有麦序用户礼物值

 @param data 信息
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomOnMicGiftValue:(RoomOnMicGiftValue *)data errorCode:(NSNumber *)code msg:(NSString *)msg {

    if (data == nil) {
        return;
    }

    self.giftValue = data;

    for (RoomOnMicGiftValueDetail *value in data.giftValueVos) {
        [self.dataInteractor updatePostionItemGiftValue:value.giftValue
                                     uid:value.uid
                              updateTime:data.currentTime];
    }
}

/**
 关闭房间礼物值开关
 
 @param success 操作是否成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueClose:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (!success) {
        return;
    }
    
    for (TTPositionItem *item in [TTPositionUIManager shareUIManager].positionItems) {
        [item updateGiftValue:0 updateTime:nil];
    }
}

/**
 清除礼物值
 @param micUid 被清除对象uid
 @param data 信息
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueClean:(UserID)micUid giftValue:(RoomOnMicGiftValue *)data errorCode:(NSNumber *)code msg:(NSString *)msg {

    if (data == nil) {
        return;
    }

    [self.dataInteractor cleanGiftValueSyncCustomNotify:data];

    for (RoomOnMicGiftValueDetail *value in data.giftValueVos) {
        [self.dataInteractor updatePostionItemGiftValue:value.giftValue
                                     uid:value.uid
                              updateTime:data.currentTime];
    }
}

/**
 礼物值打开情况下，下麦

 @param success 操作是否成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueStatusDownMic:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg {

}

/**
 礼物值打开情况下，上麦

 @param success 操作是否成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueStatusUpMic:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg {

}
#pragma mark - TTPositionViewUIProtocol
//viewdelloc的时候 销毁单例
- (void)positionViewDelloc{
    RemoveCoreClientAll(self);
    self.showGiftValue = NO;
    onceToken = 0;
    coreManager = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:kEnterRoomFromMiniRoomNotification];
}

- (void)positionViwLayoutSubViews {
//    [self roomInfoUpdateChangeRoomType];
//    //重新更新一下 麦位的东西 防止麦位上的东西 因为没有frmae 造成异常
//    [self onGetPreRoomQueueSuccessV2:GetCore(ImRoomCoreV2).micQueue];
}

#pragma mark - setters and getters
- (TTPositionTopicModel *)topicModel {
    if (!_topicModel) {
        _topicModel = [[TTPositionTopicModel alloc] init];
    }
    return _topicModel;
}

@end
