//
//  CarCore.m
//  BberryCore
//
//  Created by 卫明何 on 2018/3/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "CarCore.h"
#import "CarCoreClient.h"
#import "HttpRequestHelper+Car.h"
#import "UserCache.h"
#import "UserCore.h"
#import "UserCoreClient.h"
#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "AuthCore.h"

#import <NSObject+YYModel.h>

#import "XCDBManager.h"
#import "P2PInteractiveAttachment.h"


@implementation CarCore

- (instancetype)init {
    if (self = [super init]) {
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(ImRoomCoreClient, self);
        AddCoreClient(ImRoomCoreClientV2, self);
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)requestCarListByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state {
    [HttpRequestHelper getCarListWithPageSize:pageSize page:page Success:^(NSArray *data) {
        NotifyCoreClient(UserCoreClient, @selector(onGetCarListSuccess:state:), onGetCarListSuccess:data state:state);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onGetCarListFailth:), onGetCarListFailth:message);
    }];
}

- (void)requestUserCar:(UserCarPlaceType)placeType uid:(NSString *)uid {
    [HttpRequestHelper getUserCarList:uid success:^(NSArray *data) {
        NotifyCoreClient(UserCoreClient, @selector(onGetOwnCarList:success:), onGetOwnCarList:placeType success:data);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onGetOwnCarList:failth:), onGetOwnCarList:placeType failth:message);
    }];
}

- (RACSignal *)buyCarByCarId:(NSString *)carId {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper buyOrRenewCarByCarId:carId Success:^(BOOL success) {
            @strongify(self);
            self.hasNewCarOrder = YES;
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}



/**
 赠送座驾
 
 @param carId 座驾Id
 @param targetUid 被赠送者Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)presentCarByCarId:(NSString *)carId targetUid:(UserID)targetUid {
//    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper presneteCarByCarId:carId targetUid:targetUid Success:^(BOOL success) {
            //            @strongify(self);
            //            self.hasNewCarOrder = YES;
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
}


- (void)userCarByCarId:(NSString *)carId {
    [HttpRequestHelper userCarByCarId:carId Success:^(BOOL success) {
        NotifyCoreClient(UserCoreClient, @selector(onUseCarSuccess), onUseCarSuccess)
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onUseCarFailth:), onUseCarFailth:message);
    }];
}

- (void)userCarByCarId:(NSString *)carId andUserCar:(UserCar *)userCar {
    [HttpRequestHelper userCarByCarId:carId Success:^(BOOL success) {
        [self updateUserCar:userCar];
        NotifyCoreClient(UserCoreClient, @selector(onUseCarSuccess), onUseCarSuccess)
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onUseCarFailth:), onUseCarFailth:message);
    }];
}


- (RACSignal *)getCarDetailByCarId:(NSString *)carId {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getCarDetailWithCarid:carId Success:^(UserCar *car) {
            if (car) {
                [subscriber sendNext:car];
                [subscriber sendCompleted];
            }else {
                NSError *error = [[NSError alloc]initWithDomain:@"获取的座驾数据为空" code:400 userInfo:nil];
                [subscriber sendError:error];
            }
            
        } failure:^(NSNumber *resCode, NSString *message) {
            
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

#pragma mark -
#pragma mark v2 版本
// ***********  2019-03-25 公会线添加  v2 版本接口(赠送，购买) *************/

/**
 购买座驾 v2 ，
 interface /car/pay/v2/buy
 
 @param carId 座驾id
 @param currencyType 支付货币类型：0金币，1萝卜
 @return complete就是成功 error就是失败
 */
- (RACSignal *)buyCarByCarId:(NSString *)carId
                currencyType:(BuyGoodsType)currencyType {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper buyCarWithCarID:carId currencyType:currencyType Success:^(BOOL success) {
            @strongify(self);
            self.hasNewCarOrder = YES;
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc] initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 赠送座驾 v2 版本
 interface car/pay/v2/giveCar
 @param carId 座驾id
 @param targetUid 被赠送者 uid
 @param currencyType 支付货币类型：0金币，1萝卜
 @return complete就是成功 error就是失败
 */
- (RACSignal *)presentCarByCarId:(NSString *)carId
                       targetUid:(UserID)targetUid
                    currencyType:(BuyGoodsType)currencyType {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper presneteCarByCarId:carId targetUid:targetUid currencyType:currencyType Success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

#pragma mark -

- (void)onMeInterChatRoomSuccess {
    
    [GetCore(UserCore)getUserInfo:[GetCore(AuthCore) getUid].userIDValue refresh:NO success:^(UserInfo *info) {
        Attachment *attachment = [[Attachment alloc]init];
        attachment.first = Custom_Noti_Header_CarNotify;
        attachment.second = Custom_Noti_Sub_Car_EnterRoom;
        if ([info.carport.carID integerValue] > 0 && info.carport && !info.nobleUsers.enterHide) {
            NSMutableDictionary *att = [NSMutableDictionary dictionary];
            [att safeSetObject:info.carport.effect forKey:@"effect"];
            [att safeSetObject:[GetCore(AuthCore) getUid] forKey:@"nick"];
            [att safeSetObject:info.nick forKey:@"nick"];
            attachment.data = att;
            NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - ImMessageCoreClient

- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg {
    
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        
        Attachment *attachment = (Attachment *)obj.attachment;
        
        if (attachment.first == Custom_Noti_Header_CarNotify &&
            attachment.second == Custom_Noti_Sub_Car_EnterRoom) {
            
            UserInfo *info = [GetCore(UserCore) getUserInfoInDB:msg.from.userIDValue];
            BOOL superAdmin = info.platformRole == XCUserInfoPlatformRoleSuperAdmin;
            
            //超管进房不显示座驾
            if (!superAdmin) {

                
                UserCar *carInfo = [UserCar modelWithJSON:attachment.data];
                NotifyCoreClient(CarCoreClient, @selector(userEnterRoomWithDrivingCarEffect:), userEnterRoomWithDrivingCarEffect:carInfo);
            }
        }
    }
}


- (void)onSendChatRoomMessageSuccess:(NIMMessage *)msg {
    if (msg.session.sessionType == NIMSessionTypeChatroom) {
        [self onRecvChatRoomCustomMsg:msg];
    }
}

- (void)onRecvP2PCustomMsg:(NIMMessage *)msg
{
    //房间自定义消息
    if (msg.messageType == NIMMessageTypeCustom && msg.session.sessionType == NIMSessionTypeP2P) {
        NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
        //自定义消息附件是Attachment类型且有值
        if (customObject.attachment != nil && [customObject.attachment isKindOfClass:[P2PInteractiveAttachment class]]) {
            P2PInteractiveAttachment * p2p = (P2PInteractiveAttachment *)customObject.attachment;
            if (p2p.routerType == P2PInteractive_SkipType_Car || p2p.routerType == P2PInteractive_SkipType_Headwear) {
                //是不是已经看过了 重置一下状态
                NSString * isreadKey = [NSString stringWithFormat:@"%@%@", kDressNewMessageReadKey, [GetCore(AuthCore) getUid]];
                [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:isreadKey];
            }
        }
    }
}

#pragma mark - private method
- (void)updateUserCar:(UserCar *)userCar {
    if ([userCar.carID isEqualToString:@"0"]) {
        userCar = nil;
    }
    UserInfo *myInfo = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue];
    myInfo.carport = userCar;
    [[XCDBManager defaultManager]creatOrUpdateUser:myInfo complete:nil];
    [[UserCache shareCache]saveUserInfo:myInfo];
}

- (void)requestNameplateListByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state {
    [HttpRequestHelper getNameplateListWithPageSize:pageSize page:page Success:^(NSArray *data) {
        NotifyCoreClient(UserCoreClient, @selector(onGetNameplateListSuccess:state:), onGetNameplateListSuccess:data state:state);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onGetNameplateListFailth:), onGetNameplateListFailth:message);
    }];
}

/**
制作铭牌

@param fixedWord 文案
@param namePlateId 铭牌库id
*/
- (void)requestMakeNameplate:(NSString *)namePlateId fixedWord:(NSString *)fixedWord {
    [HttpRequestHelper getMakeNamePlate:namePlateId fixedWord:fixedWord success:^(bool isSuccess) {
        NotifyCoreClient(UserCoreClient, @selector(onMakeNameplateSuccess:), onMakeNameplateSuccess:isSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onMakeNameplateFailth:), onMakeNameplateFailth:message);
    }];
}

/**
使用/摘下铭牌

@param used 操作(0 -- 摘下, 1 -- 使用)
@param namePlateId 铭牌库id
*/
- (void)requestUseNameplate:(NSString *)namePlateId used:(NSInteger)used {
    [HttpRequestHelper getUseNamePlate:namePlateId used:used success:^(bool isSuccess) {
        NotifyCoreClient(UserCoreClient, @selector(onUseNameplateSuccess:used:), onUseNameplateSuccess:isSuccess used:used);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onUseNameplateFailth:), onUseNameplateFailth:message);
    }];
}


@end
