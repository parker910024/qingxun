//
//  TTGameRoomViewController+LittleWorldMessage.m
//  XC_TTRoomMoudle
//
//  Created by apple on 2019/7/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+LittleWorldMessage.h"
#import "LittleWorldCore.h"
#import "TTWorldletRoomModel.h"
#import "XCLittleWorldRoomAttachment.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "PraiseCore.h"
#import "TTMessageDisplayModel.h"

#import "XCHUDTool.h"
#import "XCMacros.h"

#import "TTDisplayModelMaker.h"
#import "TTDisplayModelMaker+LittleWorld.h"

#import "TTStatisticsService.h"

@implementation TTGameRoomViewController (LittleWorldMessage)

- (void)showBackChatGroup {
    self.backGroupChatBtn.hidden = YES;
    
    if (self.roomInfo.worldId > 0 && self.roomInfo.type != RoomType_CP) {
        self.backGroupChatBtn.hidden = NO;
    }
}

/** 在公屏上展示 小世界 信息 (邀请加入小世界) */
- (void)showLittleWorldMessage {
    
    dispatch_queue_t queue = dispatch_queue_create(0, 0);
    
    self.joinWorldTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.joinWorldTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    @weakify(self);
    dispatch_source_set_event_handler(self.joinWorldTimer, ^{
        @strongify(self);
        self.joinWorldCount++;
        if (self.joinWorldCount >= 120) {
            self.joinWorldCount = 0;
            dispatch_cancel(self.joinWorldTimer);
         
            dispatch_async(dispatch_get_main_queue(), ^{
                if (GetCore(AuthCore).getUid.userIDValue == GetCore(RoomCoreV2).getCurrentRoomInfo.uid) {
                    return;
                }
                if (!GetCore(RoomCoreV2).getCurrentRoomInfo.worldId) {
                    return;
                }
                [[GetCore(LittleWorldCore) requestUserInWorldletWithWorldId:GetCore(RoomCoreV2).getCurrentRoomInfo.worldId uid:GetCore(AuthCore).getUid.userIDValue] subscribeNext:^(id x) {
                    if (x) {
                        TTWorldletRoomModel *model = x;
                        if (!model.inWorld) { // 非世界成员
                            NIMMessage *customMessage = [[NIMMessage alloc] init];
                            XCLittleWorldRoomAttachment *attc = [[XCLittleWorldRoomAttachment alloc] init];
                            attc.first = Custom_Noti_Header_Game_LittleWorld;
                            attc.second = Custom_Noti_Sub_Little_World_Room_Lead_Notify;
                            attc.worldName = model.worldName;
                            attc.data = [model yy_modelToJSONString];
                            NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
                            customObject.attachment = attc;
                            customMessage.messageObject = customObject;
                            
                            NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%ld",GetCore(RoomCoreV2).getCurrentRoomInfo.roomId] type:NIMSessionTypeChatroom];
                            
                            [customMessage setValue:session forKey:@"session"];
                            [GetCore(RoomCoreV2) addMessageToArray:customMessage];
                        }
                    }
                } error:^(NSError *error) {
                    [XCHUDTool showErrorWithMessage:error.domain];
                }];
            });
        }
    });
    dispatch_resume(self.joinWorldTimer);
}

/** 在公屏上展示 小世界 信息 (关注房主) */
- (void)showLittleWorldAttendRoomMessage {
    
    dispatch_queue_t queue = dispatch_queue_create(0, 0);
    
    self.attendTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.attendTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    @weakify(self);
    dispatch_source_set_event_handler(self.attendTimer, ^{
        @strongify(self);
        self.attendCount++;
        
        if (self.attendCount >= 120) {
            self.attendCount = 0;
            dispatch_cancel(self.attendTimer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (GetCore(AuthCore).getUid.userIDValue == GetCore(RoomCoreV2).getCurrentRoomInfo.uid) {
                    return;
                }
                
                [GetCore(PraiseCore) isUid:GetCore(AuthCore).getUid.userIDValue isLikeUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid success:^(BOOL isLike) {
                    if (isLike) { // 关注了
                        
                    } else { // 还没有关注
                        NIMMessage *praiseMessage = [[NIMMessage alloc] init];
                        XCLittleWorldRoomAttachment *attc = [[XCLittleWorldRoomAttachment alloc] init];
                        attc.first = Custom_Noti_Header_Game_LittleWorld;
                        attc.second = Custom_Noti_Sub_Little_World_Room_Praise_Notify;
                        attc.isFollowRoomOwner = NO;
                        attc.title = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
                        NIMCustomObject *praiseObject = [[NIMCustomObject alloc]init];
                        praiseObject.attachment = attc;
                        praiseMessage.messageObject = praiseObject;
                        
                        NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%ld",GetCore(RoomCoreV2).getCurrentRoomInfo.roomId] type:NIMSessionTypeChatroom];
                        
                        [praiseMessage setValue:session forKey:@"session"];
                        
                        [GetCore(RoomCoreV2) addMessageToArray:praiseMessage];
                    }
                }];
            });
        }
    });
    dispatch_resume(self.attendTimer);
}


#pragma mark - TTMessageViewDelegate
// 点击关注
- (void)messageTableView:(TTMessageView *)messageTableView littleWorldPraiseWithModel:(TTMessageDisplayModel *)messageModel {
    GetCore(LittleWorldCore).inviteFollowRoomOwnerMessageModel = messageModel;
    [GetCore(PraiseCore) praise:GetCore(AuthCore).getUid.userIDValue bePraisedUid:self.roomInfo.uid];
    [TTStatisticsService trackEvent:@"room-focus-on-homeowner" eventDescribe:@"公屏"];
}

// 点击加入
- (void)messageTableView:(TTMessageView *)messageTableView littleWorldWithModel:(TTMessageDisplayModel *)messageModel {
    
    if (!self.roomInfo.worldId) {
        [XCHUDTool showErrorWithMessage:@"该房间不存在小世界"];
        return;
    }
    
    GetCore(LittleWorldCore).inviteJoinLittleWorldMessageModel = messageModel;
    [TTStatisticsService trackEvent:@"room-join-the-world" eventDescribe:@"语音房-加入小世界"];
    UIViewController *worldVC = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:[NSString stringWithFormat:@"%lld",self.roomInfo.worldId] isFromRoom:YES];
    [self.navigationController pushViewController:worldVC animated:YES];
}

#pragma mark - LittleWorldCoreClient
/** 加入小世界成功 */
- (void)smallSecretaryJoinWorldletSuccessWithWorldId:(long long)worldId isFromRoom:(BOOL)isFromRoom {
    if (!isFromRoom) {
        return;
    }
    
    if (worldId != self.roomInfo.worldId) {
        return;
    }
    
    TTMessageDisplayModel *messageModel = GetCore(LittleWorldCore).inviteJoinLittleWorldMessageModel;
    if (!messageModel) {
        return;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)messageModel.message.messageObject;
    XCLittleWorldRoomAttachment *attachment = (XCLittleWorldRoomAttachment *)obj.attachment;
    if (![attachment isKindOfClass:[XCLittleWorldRoomAttachment class]]) {
        return;
    }
    
    TTWorldletRoomModel *customModel = [TTWorldletRoomModel yy_modelWithJSON:attachment.data];
    customModel.inWorld = YES;
    attachment.data = [customModel yy_modelToJSONString];
    
    [[TTDisplayModelMaker shareMaker] makeLittleWorldWithMessage:messageModel.message model:messageModel];

    [self.messageView.tableView reloadData];
}

#pragma mark - PraiseCoreClient
// 关注
- (void)onPraiseSuccess:(UserID)uid {
    [XCHUDTool showSuccessWithMessage:@"关注成功" inView:self.view];
    
    if (uid != self.roomInfo.uid) {
        return;
    }
    
    TTMessageDisplayModel *messageModel = GetCore(LittleWorldCore).inviteFollowRoomOwnerMessageModel;
    if (!messageModel) {
        return;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)messageModel.message.messageObject;
    XCLittleWorldRoomAttachment *attachment = (XCLittleWorldRoomAttachment *)obj.attachment;
    if (![attachment isKindOfClass:[XCLittleWorldRoomAttachment class]]) {
        return;
    }
    attachment.isFollowRoomOwner = YES;
    
    [[TTDisplayModelMaker shareMaker] makeLittleWorldWithMessage:messageModel.message model:messageModel];
    
    [self.messageView.tableView reloadData];
}

- (void)onPraiseFailth:(NSString *)msg {
    [XCHUDTool showErrorWithMessage:msg inView:self.view];
}

@end
