//
//  CheckinCore.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/3/25.
//

#import "CheckinCore.h"
#import "HttpRequestHelper+Checkin.h"
#import "CheckinCoreClient.h"

@implementation CheckinCore

/**
 签到分享统计接口
 */
- (void)requestCheckinShare {
    [HttpRequestHelper requestCheckinShareOnCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinShare:errorCode:msg:), responseCheckinShare:isSuccess errorCode:code msg:msg);
    }];
}

/**
 领取累计奖励
 
 @param configId 奖励配置id
 */
- (void)requestCheckinReceiveTotalRewardWithConfigId:(NSString *)configId {
    [HttpRequestHelper requestCheckinReceiveTotalRewardWithConfigId:configId completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        CheckinReceiveTotalReward *model = [CheckinReceiveTotalReward yy_modelWithJSON:data];
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinReceiveTotalReward:errorCode:msg:), responseCheckinReceiveTotalReward:model errorCode:code msg:msg);
    }];
}

/**
 瓜分金币
 */
- (void)requestCheckinDraw {
    [HttpRequestHelper requestCheckinDrawOnCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        CheckinDraw *response = [CheckinDraw yy_modelWithJSON:data];
        if (data == nil || ![response isKindOfClass:CheckinDraw.class]) {
            response = nil;
        }
        
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinDraw:errorCode:msg:), responseCheckinDraw:response errorCode:code msg:msg);
    }];
}

/**
 每日签到奖励预告
 */
- (void)requestCheckinRewardTodayNotice {
    [HttpRequestHelper requestCheckinRewardTodayNoticeOnCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:CheckinRewardTodayNotice.class json:data];
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinRewardTodayNotice:errorCode:msg:), responseCheckinRewardTodayNotice:list errorCode:code msg:msg);
    }];
}

/**
 获取签到详情
 */
- (void)requestCheckinSignDetail {
    [HttpRequestHelper requestCheckinSignDetailOnCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        CheckinSignDetail *response = [CheckinSignDetail yy_modelWithJSON:data];
        if (data == nil || ![response isKindOfClass:CheckinSignDetail.class]) {
            response = nil;
        }
        
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinSignDetail:errorCode:msg:), responseCheckinSignDetail:response errorCode:code msg:msg);
    }];
}

/**
 签到接口
 */
- (void)requestCheckinSign {
    [HttpRequestHelper requestCheckinSignOnCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        CheckinSign *response = [CheckinSign yy_modelWithJSON:data];
        if (data == nil || ![response isKindOfClass:CheckinSign.class]) {
            response = nil;
        }
        
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinSign:errorCode:msg:), responseCheckinSign:response errorCode:code msg:msg);
    }];
}

/**
 累计奖励预告
 */
- (void)requestCheckinRewardTotalNotice {
    [HttpRequestHelper requestCheckinRewardTotalNoticeOnCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:CheckinRewardTotalNotice.class json:data];
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinRewardTotalNotice:errorCode:msg:), responseCheckinRewardTotalNotice:list errorCode:code msg:msg);
    }];
}

/**
 瓜分金币通知栏
 */
- (void)requestCheckinDrawNotice {
    [HttpRequestHelper requestCheckinDrawNoticeOnCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:CheckinDrawNotice.class json:data];
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinDrawNotice:errorCode:msg:), responseCheckinDrawNotice:list errorCode:code msg:msg);
    }];
}

/**
 签到提醒(开启/关闭)
 */
- (void)requestCheckinSignRemind {
    [HttpRequestHelper requestCheckinSignRemindOnCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinSignRemind:errorCode:msg:), responseCheckinSignRemind:isSuccess errorCode:code msg:msg);
    }];
}

/**
 获取签到分享图片
 
 @param shareType 分享类型：1普通，2领取礼物，3瓜分金币
 @param day 天数
 @param reward 奖励
 */
- (void)requestCheckinShareImageWithType:(NSInteger)shareType
                                     day:(NSString *)day
                                  reward:(NSString *)reward {
    [HttpRequestHelper requestCheckinShareImageWithType:shareType day:day reward:reward completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinShareImage:errorCode:msg:), responseCheckinShareImage:data errorCode:code msg:msg);
    }];
}

/**
 获取补签信息
 
 @param signDay 第几天补签
 */
- (void)requestCheckinReplenishInfoWithSignDay:(NSUInteger)signDay {
    
    [HttpRequestHelper requestCheckinReplenishInfoWithSignDay:signDay completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        CheckinReplenishInfo *model = [CheckinReplenishInfo yy_modelWithJSON:data];
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinReplenishInfo:errorCode:msg:), responseCheckinReplenishInfo:model errorCode:code msg:msg);
    }];
}

/**
 补签
 
 @param signDay 第几天补签
 */
- (void)requestCheckinReplenishWithSignDay:(NSUInteger)signDay {
    
    [HttpRequestHelper requestCheckinReplenishWithSignDay:signDay completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        CheckinReplenish *model = [CheckinReplenish yy_modelWithJSON:data];
        NotifyCoreClient(CheckinCoreClient, @selector(responseCheckinReplenish:errorCode:msg:), responseCheckinReplenish:model errorCode:code msg:msg);
    }];
}

@end
