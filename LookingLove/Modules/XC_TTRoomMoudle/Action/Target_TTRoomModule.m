//
//  Target_TTRoomModule.m
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "Target_TTRoomModule.h"

#import "TTRoomModuleCenter.h"
#import "TTRoomKTVAlerView.h"

#import "RoomInfo.h"
#import "RoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "ImRoomCoreV2.h"
#import "AuthCore.h"
#import "FaceCore.h"
#import "MeetingCore.h"
#import "MentoringShipCore.h"
#import "LittleWorldCore.h"

#import "XCConst.h"
#import "UIView+XCToast.h"
#import "TTPopup.h"
#import "XCHUDTool.h"

@implementation Target_TTRoomModule

/**
 进入房间
 */
- (void)Action_TTRoomModulePresentRoomViewController:(NSDictionary *)params{
    
    BOOL myRoomOpenOrCloseBool = NO;
    if ((GetCore(RoomCoreV2).getCurrentRoomInfo.uid  == [GetCore(AuthCore)getUid].userIDValue) && GetCore(RoomCoreV2).getCurrentRoomInfo.valid && GetCore(RoomCoreV2).getCurrentRoomInfo.type == RoomType_CP) {
        myRoomOpenOrCloseBool = YES;
    }
    
    BOOL needEdgeGesture = [[params objectForKey:@"needEdgeGesture"] boolValue];
    
    if (needEdgeGesture) {
         // 从房间进入嗨聊房、派对匹配
        GetCore(RoomCoreV2).fromType = JoinRoomFromType_PartyRoom;
    } else { // 默认
        GetCore(RoomCoreV2).fromType = JoinRoomFromType_Other;
    }
    
    if (myRoomOpenOrCloseBool) {
        TTRoomKTVAlerView *alertView = [[TTRoomKTVAlerView alloc] initWithFrame:CGRectMake(0, 0, 295, 182) title:@"提示" subTitle:nil attrMessage:nil message:@"退出房间，将解散房间内的用户" backgroundMessage:nil cancel:^{
            [TTPopup dismiss];
        } ensure:^{
            
            [TTPopup dismiss];
            
            [GetCore(RoomCoreV2)closeRoomWithBlock:GetCore(RoomCoreV2).getCurrentRoomInfo.uid Success:^(UserID uid) {//close
                
                UserID roomUid = [[params objectForKey:@"roomUid"] longLongValue];
                // 师徒任务3 记录传递的信息 [这里负责记录 退出房间或者倒计时成功时清除];
                UserID masterUid = [[params objectForKey:@"masterUid"] longLongValue];
                UserID apprenticeUid = [[params objectForKey:@"apprenticeUid"] longLongValue];
                UserID worldId = [[params objectForKey:@"worldId"] longLongValue];
                if (masterUid && apprenticeUid) {
                    [GetCore(MentoringShipCore) stopCountDown];
                    GetCore(MentoringShipCore).masterUid = masterUid;
                    GetCore(MentoringShipCore).apprenticeUid = apprenticeUid;
                } else {
                    [GetCore(MentoringShipCore) stopCountDown];
                    GetCore(MentoringShipCore).masterUid = 0;
                    GetCore(MentoringShipCore).apprenticeUid = 0;
                    
                }
                
                if (worldId) {
                    GetCore(LittleWorldCore).worldId = 0;
                }
                
                [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomOwnerUid:roomUid success:^(RoomInfo *roomInfo) {
                    [XCHUDTool hideHUD];
                    [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomInfo:roomInfo];
                } fail:^(NSString *errorMsg) {
                    [XCHUDTool hideHUD];
                }];
                
            } failure:nil];
        }];
        
        [TTPopup popupView:alertView style:TTPopupStyleAlert];
    }else{
        
        UserID roomUid = [[params objectForKey:@"roomUid"] longLongValue];
        
        // 师徒任务3 记录传递的信息 [这里负责记录 退出房间或者倒计时成功时清除];
        UserID masterUid = [[params objectForKey:@"masterUid"] longLongValue];
        UserID apprenticeUid = [[params objectForKey:@"apprenticeUid"] longLongValue];
        if (masterUid && apprenticeUid) {
            [GetCore(MentoringShipCore) stopCountDown];
            GetCore(MentoringShipCore).masterUid = masterUid;
            GetCore(MentoringShipCore).apprenticeUid = apprenticeUid;
        } else {
            [GetCore(MentoringShipCore) stopCountDown];
            GetCore(MentoringShipCore).masterUid = 0;
            GetCore(MentoringShipCore).apprenticeUid = 0;
            
        }
        
        [XCHUDTool showGIFLoading];
        [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomOwnerUid:roomUid success:^(RoomInfo *roomInfo) {
            [XCHUDTool hideHUD];
            [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomInfo:roomInfo];
        } fail:^(NSString *errorMsg) {
            [XCHUDTool hideHUD];
        }];
    }
    
}

/**
 开启自己房间
 */
- (void)Action_TTRoomModuleOpenRoomViewController:(NSDictionary *)params{
    
    RoomType roomType = [[params objectForKey:@"roomType"] integerValue];
    
     UserID worldId = [[params objectForKey:@"worldId"] longLongValue];
    if (worldId) {
        GetCore(LittleWorldCore).worldId = worldId;
    }
    [[TTRoomModuleCenter defaultCenter] openRoonWithType:roomType];
}

/**
 最小化后进入房间
 */
- (void)Action_TTRoomModuleMaxRoomViewController:(NSDictionary *)params{
    
    RoomInfo *roomInfo = [RoomInfo modelDictionary:params];
    [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomInfo:roomInfo];
     [[NSNotificationCenter defaultCenter] postNotificationName:kEnterRoomFromMiniRoomNotification object:nil];
}

/**
 关闭房间
 */
- (void)Action_TTRoomModuleCloseRoomViewController{
    
    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
    
    [GetCore(MentoringShipCore) stopCountDown];
    GetCore(MentoringShipCore).masterUid = 0;
    GetCore(MentoringShipCore).apprenticeUid = 0;
    GetCore(LittleWorldCore).worldId = 0;
}

/**
 最小化房间
 */
- (void)Action_TTRoomModuleMinRoomViewController:(NSDictionary *)params {

    void(^completeBlock)(void) = params[@"block"];
    
    if (GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
        
        [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
        
        [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO animation:YES completion:completeBlock];
        
    } else {
        
        [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO animation:YES completion:completeBlock];
    }
    
    
}
@end
