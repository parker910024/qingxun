//
//  HttpRequestHelper+Room.m
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Room.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "RoomInfo.h"
#import "ImRoomCoreV2.h"
#import "RewardInfo.h"
#import "MicroListInfo.h"
#import "MicroUserListInfo.h"
//#import "RoomBounsListInfo.h"
#import "DESEncrypt.h"
#import "XCMacros.h"
#import "StrangerRoomInfo.h"
#import "StrangerCoupleInfo.h"
#import "NSString+NTES.h"

@implementation HttpRequestHelper (Room)



/**
 获取龙珠
 
 @param roomUid 房间id
 @param uid 用户id
 */
+ (void)getDragonBallWithRoomUid:(UserID )roomUid uid:(UserID )uid success:(void (^)( NSArray* ballList, BOOL isNew))success failure:(void (^)(NSNumber *code, NSString *msg))failure {
    NSString *method = @"dragonBall/gen";
    
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:ticket forKey:@"ticket"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
//        [NSArray yy_modelWithJSON:data]
        if ([data[@"value"] isKindOfClass:[NSString class]]) {
            NSString *state = [NSString stringWithFormat:@"%@",data[@"isGen"]];
            BOOL isNew = state.integerValue;
            NSArray* ballList =  [(NSString *)data[@"value"] componentsSeparatedByString:@","];
            if (ballList.count == 3) {
                if (success) {
                    success(ballList,isNew);
                }
            }else {
                if (failure) {
                    failure(0, @"龙珠个数出错");
                }
            }
            
        }else{
            if (failure) {
                failure(0, @"格式错误");
            }
        }
        
     
        
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

/**
 清除龙珠状态
 
 @param roomUid 房间id
 @param uid 用户id
 */
+ (void)clearDragonBallWithRoomUid:(UserID )roomUid uid:(UserID )uid  success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *code, NSString *msg))failure; {
    NSString *method = @"dragonBall/clear";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:ticket forKey:@"ticket"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark - 更新房间信息

+ (void)updateRoomInfo:(NSDictionary *)infoDict
                  type:(UpdateRoomInfoType)type
    hasAnimationEffect:(BOOL)hasAnimationEffect
          audioQuality:(AudioQualityType)audioQuality
               success:(void (^)(RoomInfo *))success
               failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"room/update";
    if (type == UpdateRoomInfoTypeManager) {
        method = @"room/updateByAdmin";
    } else if (type == UpdateRoomInfoTypeUser)  {
        method = @"room/update";
    }
    
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserID roomUid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:ticket forKey:@"ticket"];
    
    [params setObject:@([GetCore(AuthCore) getUid].userIDValue) forKey:@"uid"];
    // 标题
    if ([[infoDict allKeys] containsObject:@"title"]) {
        [params setObject:infoDict[@"title"] forKey:@"title"];
    } else {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.title.length > 0) {
            [params setObject:GetCore(ImRoomCoreV2).currentRoomInfo.title forKey:@"title"];
        }
    }
    
    // 主题
    if ([[infoDict allKeys] containsObject:@"roomDesc"]) {
        [params setObject:infoDict[@"roomDesc"] forKey:@"roomDesc"];
    } else {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.roomDesc.length > 0) {
            [params setObject:GetCore(ImRoomCoreV2).currentRoomInfo.roomDesc forKey:@"roomDesc"];
        }
    }
    
    // 房间介绍
    if ([[infoDict allKeys] containsObject:@"introduction"]) {
        [params setObject:infoDict[@"introduction"] forKey:@"introduction"];
    } else {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.introduction.length > 0) {
            [params setObject:GetCore(ImRoomCoreV2).currentRoomInfo.introduction forKey:@"introduction"];
        }
    }
    
    // 房间背景
    if ([[infoDict allKeys] containsObject:@"backPic"]) {
        [params setObject:infoDict[@"backPic"] forKey:@"backPic"];
    } else {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.backPic.length > 0) {
            [params setObject:GetCore(ImRoomCoreV2).currentRoomInfo.backPic forKey:@"backPic"];
        }
    }
    
    // 房间密码
    if ([[infoDict allKeys] containsObject:@"roomPwd"]) {
        NSString *roomPwd = (NSString *)infoDict[@"roomPwd"];
        if (projectType() == ProjectType_Haha  ||
            projectType() == ProjectType_TuTu ||
            projectType() == ProjectType_Pudding ||
            projectType() == ProjectType_LookingLove ||
            projectType() == ProjectType_Planet) {
            if (roomPwd.length>0) {
                if ([DESEncrypt encryptUseDES:infoDict[@"roomPwd"] key:keyWithType(KeyType_PwdEncode, NO)].length > 0) {
                    [params setObject:[DESEncrypt encryptUseDES:infoDict[@"roomPwd"] key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"roomPwd"];
                }
            } else {
                [params setObject:@"" forKey:@"roomPwd"];
            }
            
        } else {
            [params setObject:infoDict[@"roomPwd"] forKey:@"roomPwd"];
        }
    } else {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.roomPwd.length > 0) {
            NSString *roomPwd = GetCore(ImRoomCoreV2).currentRoomInfo.roomPwd;
            if (projectType() == ProjectType_Haha  ||
                projectType() == ProjectType_TuTu ||
                projectType() == ProjectType_Pudding ||
                projectType() == ProjectType_LookingLove ||
                projectType() == ProjectType_Planet) {
                if (roomPwd.length>0) {
                    if ([DESEncrypt encryptUseDES:roomPwd key:keyWithType(KeyType_PwdEncode, NO)].length > 0) {
                        [params setObject:[DESEncrypt encryptUseDES:roomPwd key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"roomPwd"];
                    }
                } else {
                    [params setObject:@"" forKey:@"roomPwd"];
                }
            } else {
                if (roomPwd.length>0) {
                    [params setObject:roomPwd forKey:@"roomPwd"];
                } else {
                    [params setObject:@"" forKey:@"roomPwd"];
                }
            }
        }
    }
    
    // tag
    if ([[infoDict allKeys] containsObject:@"tagId"]) {
        [params setObject:infoDict[@"tagId"] forKey:@"tagId"];
    } else {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.tagId > 0) {
            [params setObject:@(GetCore(ImRoomCoreV2).currentRoomInfo.tagId) forKey:@"tagId"];
        }
    }
    
    if ([[infoDict allKeys] containsObject:@"limitType"]) {
        [params setObject:infoDict[@"limitType"] forKey:@"limitType"];
    }else {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.limitType.length > 0) {
            [params setObject:GetCore(ImRoomCoreV2).currentRoomInfo.limitType forKey:@"limitType"];
        }
    }
    
    //红包开关
     if ([[infoDict allKeys] containsObject:@"closeRedPacket"]) {
         [params setObject:infoDict[@"closeRedPacket"] forKey:@"closeRedPacket"];
     }
    
    // 纯净模式
    if ([[infoDict allKeys] containsObject:@"isPureMode"]) {
        [params setObject:infoDict[@"isPureMode"] forKey:@"isPureMode"];
    }else {
        [params setObject:@(GetCore(ImRoomCoreV2).currentRoomInfo.isPureMode) forKey:@"isPureMode"];
    }
    
    [params safeSetObject:@(hasAnimationEffect) forKey:@"hasAnimationEffect"];
    [params safeSetObject:@(audioQuality) forKey:@"audioQuality"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        RoomInfo *roomInfo = [RoomInfo modelDictionary:data];
        if (roomInfo != nil) {
            success(roomInfo);
        } else {
            failure(@(10), @"ticket为空");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 开启房间离开模式
 interface room/leave/mode/open
 @param roomUid 房主uid
 */
+ (void)requestChangeRoomLeaveMode:(long long)roomUid
                       leaveMode:(BOOL)leaveMode
                         success:(void (^)(BOOL))success
                         failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"room/leave/mode/open"; // 开启
    if (!leaveMode) {
        method = @"room/leave/mode/close"; // 关闭
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark - 统计相关
/**
 用户退出房间上报
 
 @param success 成功
 @param failure 失败
 */
+ (void)reportUserOutRoomSuccess:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"userroom/outV2";
    
    ProjectType type =  projectType();
    if (type == ProjectType_MengSheng || projectType() == ProjectType_BB) {
        method = @"userroom/out";
    }
    if (type == ProjectType_VKiss) {//不需要
        return;
    }
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    NSString *roomUid = [NSString stringWithFormat:@"%lld",GetCore(ImRoomCoreV2).currentRoomInfo.uid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:roomUid forKey:@"roomUid"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//房间统计埋点
+ (void)recordTheRoomTime:(UserID)uid roomUid:(UserID)roomUid {
    NSString *method = @"basicusers/record";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid > 0) {
        [params setObject:@(uid) forKey:@"uid"];
    }
    if (roomUid > 0) {
        [params setObject:@(roomUid) forKey:@"roomUid"];
    }
    
    if (ticket.length > 0) {
        [params setObject:ticket forKey:@"ticket"];
    }
    
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

/**
 用户进入房间上报
 
 @param success 成功
 @param failure 失败
 */
+ (void)reportUserInterRoomSuccess:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    ProjectType type =  projectType();
    NSString *method = @"userroom/inV2";
    if (type == ProjectType_MengSheng || projectType() == ProjectType_BB ) {
        method = @"userroom/in";
    }
    if (type == ProjectType_VKiss) {//不需要
        return;
    }
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    UserID roomUid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}



#pragma mark - 开房&关房
//开竞拍房
+ (void) rewardForRoom:(UserID)uid servDura:(NSInteger)servDura rewardMonye:(NSInteger)rewardMonye success:(void (^)(RewardInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"reward/save";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(servDura) forKey:@"servDura"];
    [params setObject:@(rewardMonye) forKey:@"rewardMonye"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        RewardInfo *rewardInfo = [RewardInfo modelDictionary:data];
        if (rewardInfo != nil) {
            success(rewardInfo);
        } else {
            failure(@(10), @"ticket为空");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
//开房
+ (void)openRoom:(UserID)uid type:(RoomType)type title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString *)backPic rewardId:(NSString *)rewardId success:(void (^)(RoomInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"room/open";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    if (title.length <= 0) {
        NSString *nick = [GetCore(UserCore) getUserInfoInDB:uid].nick;
        title = [NSString stringWithFormat:@"%@的房间", nick];
    }
    [params setObject:title forKey:@"title"];
    
    if (type != RoomType_Game && type != RoomType_CP) {
        [params setObject:@"" forKey:@"roomPwd"];
    }
    
    if (roomDesc.length > 0) {
        [params setObject:roomDesc forKey:@"roomDesc"];
    }else {
        [params setObject:@"" forKey:@"roomDesc"];
    }
    
    if (backPic.length > 0) {
        [params setObject:backPic forKey:@"backPic"];
    }else {
        [params setObject:@"" forKey:@"backPic"];
    }
    
    if (rewardId.length > 0) {
        [params setObject:rewardId forKey:@"rewardId"];
    }
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        RoomInfo *roomInfo = [RoomInfo modelDictionary:data];
        if (roomInfo != nil) {
            success(roomInfo);
        } else {
            failure(@(10), @"ticket为空");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)closeRoom:(UserID)uid success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"room/close";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark - 获取房间信息相关
//获取房间信息
+ (void)getRoomInfo:(UserID)uid success:(void (^)(RoomInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"room/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(GetCore(AuthCore).getUid.userIDValue) forKey:@"intoUid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        RoomInfo *roomInfo = [RoomInfo modelDictionary:data];
        if (roomInfo != nil && roomInfo.uid > 0 && roomInfo.title != nil) {
            
            //这里设置保证是从接口获取的数据，注意云信不下发该字段
            GetCore(RoomCoreV2).hideRedPacket = roomInfo.hideRedPacket;
            
            success(roomInfo);
            
        }else if (roomInfo == nil || roomInfo.title == nil || roomInfo.title.length == 0) {
            success(nil);
        }else {
            failure(@(10), @"ticket为空");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
            NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:Room_get,@"uid":[GetCore(AuthCore)getUid].length>0?[GetCore(AuthCore)getUid]:@"0",@"targetUid":[NSString stringWithFormat:@"%lld",uid]} error:error topic:BussinessLog logLevel:XCLogLevelError];
            failure(resCode, message);
        }
    }];
}
//获取房间信息
+ (void)getRoomInfoByUids:(NSArray *)uids success:(void (^)(NSArray<RoomInfo *> *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"/room/list";
    NSString *uidsStr = [[NSString alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    uidsStr = [uids componentsJoinedByString:@","];
    [params setObject:uidsStr forKey:@"uids"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *item in data) {
            RoomInfo *roominfo = [RoomInfo modelDictionary:item];
            [tempArr addObject:roominfo];
        }
        success(tempArr);
        
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

//  CP 房间邀请
+ (void)getRoomInviteByUids:(NSArray *)uids getRoomInfo:(UserID)uid success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"/room/invite";
    
    NSString *uidsStr = [[NSString alloc]init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    uidsStr = [uids componentsJoinedByString:@","];
    [params setObject:uidsStr forKey:@"uids"];
    [params setObject:@(uid) forKey:@"roomUid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

/**
 获取用户所在房间信息
 
 @param uid uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestUserInRoomInfoBy:(UserID)uid Success:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"userroom/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        RoomInfo *info = [RoomInfo modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*
 更新房间关闭公屏状态
 */
+ (void)updateRoomMessageViewState:(UserID)uid
                     isCloseScreen:(BOOL)isCloseScreen
                           success:(void (^)(RoomInfo *info))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/setCloseScreen";
    NSString *roomId = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:roomId forKey:@"roomId"];
    [params safeSetObject:@([GetCore(AuthCore)getUid].userIDValue) forKey:@"uid"];
    [params safeSetObject:@(isCloseScreen) forKey:@"isCloseScreen"];
    [params safeSetObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {

        RoomInfo *info = [RoomInfo modelDictionary:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

#pragma mark - 麦序操作
//上麦
+ (void)upMicro:(UserID)uid roomId:(UserID)roomId position:(NSInteger)position success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"room/mic/upmic";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"micUid"];
    [params setObject:@(roomId) forKey:@"roomId"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//下麦/用户自行离开麦序
+ (void)leftMicro:(UserID)uid roomId:(UserID)roomId position:(NSInteger)position
          success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"room/mic/downmic";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"micUid"];
    [params setObject:@(roomId) forKey:@"roomId"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 锁坑位/取消操作
 */
+ (void)micPlace:(NSInteger)position roomOwnerUid:(UserID)roomOwnerUid state:(NSInteger)state
         success:(void (^)(void))success
         failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/mic/lockpos";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomOwnerUid) forKey:@"roomUid"];
    [params setObject:@(state) forKey:@"state"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];

    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
/**
 锁麦/开麦操作
 */
+ (void)micState:(NSInteger)position roomOwnerUid:(UserID)roomOwnerUid state:(NSInteger)state
         success:(void (^)(void))success
         failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/mic/lockmic";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomOwnerUid) forKey:@"roomUid"];
    [params setObject:@(state) forKey:@"state"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//房主邀请上麦
+ (void)inviteUpMicroWithUid:(UserID)uid position:(int)position roomId:(int)roomId success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"room/mic/invitemic";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *ownerUid = [GetCore(AuthCore) getUid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ownerUid forKey:@"roomUid"];
    [params setObject:@(uid) forKey:@"micUid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:@(roomId) forKey:@"roomId"];
    
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
    
}

//房主踢用户下麦
+ (void)ownerKickUserByUid:(NSString *)uid position:(int)position roomId:(int)roomId success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"room/mic/kickmic";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *ownerUid = [GetCore(AuthCore) getUid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ownerUid forKey:@"roomUid"];
    [params setObject:uid forKey:@"micUid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:@(roomId) forKey:@"roomId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


#pragma mark - 暂时未使用

//申请上麦

+(void)applyMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"micro/apply";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(roomOwnerUid) forKey:@"roomUid"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
//请求麦序
+ (void)requestMicroList:(UserID)roomOwnerUid success:(void (^)(MicroListInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"micro/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomOwnerUid) forKey:@"uid"];
    [params setObject:@(3) forKey:@"type"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        MicroListInfo *microListInfo = [MicroListInfo yy_modelWithJSON:data];
        success(microListInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
//拒绝申请
+ (void)denyApplyMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"micro/denyapply";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomOwnerUid) forKey:@"uid"];
    [params setObject:@(uid) forKey:@"applyUid"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
//更新麦序
+(void) updateMicroList:(UserID)roomOwnerUid curUids:(NSArray *)curUids type:(NSInteger)type
                success:(void (^)(void))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;
{
    NSString *method = @"micro/update";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    
    NSMutableString *strUidList = [[NSMutableString alloc] init];
    for (int i=0; i<curUids.count; i++) {
        NSNumber *uid = curUids[i];
        if (uid.userIDValue > 0) {
            [strUidList appendString:[NSString stringWithFormat:@"%lld",uid.userIDValue]];
            [strUidList appendString:@","];
        }
    }
    [strUidList deleteCharactersInRange:NSMakeRange([strUidList length]-1, 1)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomOwnerUid) forKey:@"uid"];
    [params setObject:strUidList forKey:@"curUids"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//用户同意上麦
+ (void)userAgreeUpMicroRoomUid:(NSString *)roomUid success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"microV2/accept";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *uid = [GetCore(AuthCore) getUid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:roomUid forKey:@"roomUid"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);

    }];

}

//获取麦序列表
+ (void)fetchMicroListInfoByOwnerUid:(NSString *)ownerUid success:(void (^)(NSMutableArray *userList))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"microV2/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ownerUid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSMutableArray *userList = [NSMutableArray array];
//        [NSArray yy_modelArrayWithClass:[UserInfo class] json:data];
        [userList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MicroUserListInfo class] json:data]];
        NSMutableArray *finallyUserList = [NSMutableArray array];
        
        for (MicroUserListInfo *info in userList) {
            if (info.status == 2) {
                [finallyUserList addObject:info];
            }
        }
        
        success(finallyUserList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//用户离开麦序
+ (void)userLeftMicroWithRoomUid:(UserID)roomUid {
    NSString *method = @"microV2/userleft";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *uid = [GetCore(AuthCore) getUid];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:uid forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

#pragma mark - CP陌生人房间
+ (void)requestStrangerWithCreateSuccess:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSString *message))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    

    [HttpRequestHelper POST:@"room/createStrangerRoom" params:params success:^(id data) {
        RoomInfo * info = [RoomInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)requestDynamicStrangerWithCreateSuccess:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSString *message))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [HttpRequestHelper POST:@"room/createDynamicStrangerRoom" params:params success:^(id data) {
        RoomInfo * info = [RoomInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)requestStrangeJoinRoomWithRoomUid:(UserID)roomUid success:(void (^)(void))success failure:(void (^)(NSString *message))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomUid] forKey:@"roomUid"];
    
    [HttpRequestHelper POST:@"room/joinRoom" params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)requestStrangerLeaveRoomWithRoomUid:(UserID)roomUid withUid:(UserID)uid success:(void (^)(void))success failure:(void (^)(NSString *message))failure{
 
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomUid] forKey:@"roomUid"];
    
    [HttpRequestHelper POST:@"room/leaveRoom" params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}



+ (void)requestStrangerListRoomWithStart:(NSUInteger)pageNum
                                pageSize:(NSUInteger)pageSize
                                 success:(void (^)(NSArray<StrangerRoomInfo*>* roomInfoList))success
                                 failure:(void (^)(NSString *message))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:pageNum] forKey:@"pageNum"];
    [params safeSetObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    
    [HttpRequestHelper POST:@"room/list" params:params success:^(id data) {
        
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[StrangerRoomInfo class] json:data];
        success(dataArray);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}


+ (void)requestStrangerWithFindRoomSuccess:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSString *message))failure{
    NSDictionary * param = @{
                             @"uid": [GetCore(AuthCore) getUid]
                             };
    [HttpRequestHelper POST:@"room/findRoom" params:param success:^(id data) {
        RoomInfo * info = [RoomInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)requestStrangerRoomInfo:(UserID)roomId title:(NSString *)title success:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSString *message))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:title forKey:@"title"];
    [params safeSetObject:[NSNumber numberWithInteger:roomId] forKey:@"roomId"];
    
    
    [HttpRequestHelper POST:@"room/updateRoomTitile" params:params success:^(id data) {
        RoomInfo * info = [RoomInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)requestStrangerBindCpWithRoomInfo:(UserID)roomId coupleUid:(UserID)coupleUid withType:(int)type success:(void (^)(StrangerCoupleInfo * coupleInfo))success failure:(void (^)(NSString *message))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomId] forKey:@"roomId"];
    [params safeSetObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [params safeSetObject:[NSNumber numberWithInteger:coupleUid] forKey:@"coupleUid"];
    
    [HttpRequestHelper POST:@"push/requestCp" params:params success:^(id data) {

        StrangerCoupleInfo * info = [StrangerCoupleInfo yy_modelWithJSON:data];
        success(info);
//        success([cpUid userIDValue],[roomId userIDValue]);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}


+ (void)requeStrangerMessageWishCoupleUid:(UserID)coupleUid withType:(int)type success:(void (^)(StrangerCoupleInfo * coupleInfo))success failure:(void (^)(NSString *message))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [params safeSetObject:[NSNumber numberWithInteger:coupleUid] forKey:@"coupleUid"];
    
    [HttpRequestHelper POST:@"push/becomeCp" params:params success:^(id data) {
        
        StrangerCoupleInfo * info = [StrangerCoupleInfo yy_modelWithJSON:data];
        success(info);
        
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}
+ (void)requeStrangerMessageAgreeCoupleUid:(UserID)coupleUid withRoomId:(NSInteger)roomId success:(void (^)(StrangerCoupleInfo * coupleInfo))success failure:(void (^)(NSString *message))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:coupleUid] forKey:@"coupleUid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomId] forKey:@"roomId"];

    [HttpRequestHelper POST:@"push/agreeCp" params:params success:^(id data) {
        
        StrangerCoupleInfo * info = [StrangerCoupleInfo yy_modelWithJSON:data];
        success(info);
        
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)requestSettingHideRoom:(BOOL)hideFlag success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"super/hide/room";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(GetCore(ImRoomCoreV2).roomOwnerInfo.uid) forKey:@"roomUid"];
    [params setObject:@(hideFlag) forKey:@"type"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestSettingUnlockRoomLimitType:(NSString *)limitType roomPwd:(NSString *)roomPwd success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"super/update/room/limit";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(GetCore(ImRoomCoreV2).roomOwnerInfo.uid) forKey:@"roomUid"];
    [params setObject:limitType forKey:@"limitType"];
    [params setObject:roomPwd forKey:@"roomPwd"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success();
        
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 超管设置房间角色
 @param roomUid 房间的Uid
 @param targetUid 目标的id
 @param opt //1: 设置为管理员;2:设置普通等级用户;-1:设为黑名单用户;-2:设为禁言用户
 @param success 成功
 @param failure 失败
 */
+ (void)requestSettingRoomAdminWithRoomUid:(UserID)roomUid targetUid:(UserID)targetUid opt:(int)opt notifyExt:(NSString *)notifyExt  success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"super/set/chatroom/role";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(opt) forKey:@"opt"];
    if (notifyExt) {
     [params setObject:notifyExt forKey:@"notifyExt"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark -
#pragma mark 超管操作记录统计
/// 超管操作的事项进行统计
/// @param operateType 超管操作类型
/// @param uid 当前操作的超管 uid
/// @param roomUid 房间id
/// @param targetUid 对某一目标执行的 uid
/// @param success 成功
/// @param failure 失败
+ (void)recordSuperAdminOperate:(SuperAdminOperateType)operateType
                  superAdminUid:(UserID)uid
                        roomUid:(UserID)roomUid
                      targetUid:(UserID)targetUid
                        success:(void (^)(void))success
                        failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"super/admin/operate/save";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(uid) forKey:@"uid"];
    [dict setObject:@(roomUid) forKey:@"roomUid"];
    [dict setObject:@(operateType) forKey:@"operateType"];
    if (targetUid) {
        [dict setObject:@(targetUid) forKey:@"targetUid"];
    }

    [HttpRequestHelper POST:method params:dict success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/// 进房记录
+ (void)requestRoomVisitRecordOnCompletion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"userroom/getInRoomRecord";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self request:path
           method:HttpRequestHelperMethodGET
           params:params
       completion:completion];
}

/// 进房记录清除
+ (void)requestRoomVisitRecordCleanOnCompletion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"userroom/deleteInRoomRecord";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/// 进房欢迎语
/// 接收方uid
+ (void)requestRoomEnterGreetingToUid:(NSString *)toUid
                           completion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"welcome/room/msg/getOne";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:toUid forKey:@"toUid"];

    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/// 获取红包配置信息
+ (void)requestRoomRedConfigCompletion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"room/redpacket/config";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];

    [self request:path
           method:HttpRequestHelperMethodGET
           params:params
       completion:completion];
}

/// 红包分享
/// @param roomUid 房主uid
/// @param packetId 红包id
+ (void)requestRoomRedShare:(NSString *)packetId
                    roomUid:(NSString *)roomUid
                 completion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"room/redpacket/share";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:roomUid forKey:@"roomUid"];
    [params setValue:packetId forKey:@"packetId"];

    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/// 获取房间内可抢的红包列表
/// @param roomUid 房主uid
+ (void)requestRoomRedList:(NSString *)roomUid
                completion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"room/redpacket/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:roomUid forKey:@"roomUid"];

    [self request:path
           method:HttpRequestHelperMethodGET
           params:params
       completion:completion];
}

/// 获取红包详情
/// @param packetId 红包id
+ (void)requestRoomRedDetail:(NSString *)packetId
                  completion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"room/redpacket/detail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:packetId forKey:@"packetId"];

    [self request:path
           method:HttpRequestHelperMethodGET
           params:params
       completion:completion];
}

/// 抢红包
/// @param packetId 红包id
+ (void)requestRoomRedDraw:(NSString *)packetId
                completion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"room/redpacket/receive";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:packetId forKey:@"packetId"];

    //加签名
    NSString *sign = [self sign:params];
    [params setValue:sign forKey:@"sign"];

    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/// 发红包
/// @param roomUid 房主uid
/// @param amount 金币数
/// @param num 红包个数
/// @param requirementType 红包条件
/// @param notifyText 喊话文案
+ (void)requestRoomSendRedByRoomUid:(UserID)roomUid amount:(NSInteger)amount num:(NSInteger)num requirementType:(int)requirementType notifyText:(NSString *)notifyText
                completion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"room/redpacket/send";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:notifyText forKey:@"callText"];
    [params setValue:@(num) forKey:@"num"];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:@(roomUid) forKey:@"roomUid"];
    [params setValue:@(amount) forKey:@"amount"];
    [params setValue:@(requirementType) forKey:@"requirementType"];
    
    
    //加签名
    NSString *sign = [self sign:params];
    [params setValue:sign forKey:@"sign"];
    
    

    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

#pragma mark - Private
/// 参数签名
/// @param dic 加密参数
+ (NSString *)sign:(NSMutableDictionary *)dic {
//    NSDate *datenow = [NSDate date];
//    [dic setObject:[NSString stringWithFormat:@"%lld", (long long)[datenow timeIntervalSince1970]*1000] forKey:@"pub_timestamp"];
//    [dic setObject:[self uuidString] forKey:@"uuid"];
    
    NSMutableString *string = [NSMutableString string];
    //按字典key升序排序
    NSArray *sortKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    //拼接格式 “key0=value0&key1=value1&key2=value2”
    for (NSString *key in sortKeys) {
        [string appendString:[NSString stringWithFormat:@"%@=%@&", key, dic[key]]];
    }
    //拼接参数加密签名 PARAMSSECRET
    [string appendString:[NSString stringWithFormat:@"key=%@", @"grmpv7hgp1u8wyygjj963qfmb7poj3pn"]];
    //MD5加密签名
    NSString *sign = [string MD5String];
    //返回大写字母
    return sign.uppercaseString;
}

+ (NSString *)uuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}
@end
