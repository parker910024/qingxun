//
//  DiscoveryCore.m
//  BberryCore
//
//  Created by Macx on 2018/3/5.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "DiscoveryCore.h"
#import <AFNetworkReachabilityManager.h>
#import "DiscoveryCoreClient.h"
#import "HttpRequestHelper+Discovery.h"
#import "DiscoveryBannerInfo.h"
#import "DiscoverTofuInfo.h"
#import "DiscoveryHeadLineNews.h"
#import "DiscoveryMainData.h"
@implementation DiscoveryCore


- (void)requestDiscoverAdListWithUid:(NSString *)uid {
    
    [HttpRequestHelper requestDisCoveryAdListWithUid:uid success:^(NSArray *list) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(onDiscoveryAdListSuccess:), onDiscoveryAdListSuccess:list);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(onDiscoverAdlistFailth:),onDiscoverAdlistFailth:message);
    }];

}

//上周 周星榜
- (void)getLastWeekGiftListWith
{
    [HttpRequestHelper requstLastWeekGiftListsuccess:^(NSArray *list) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(hhDiscoverLastWeekGiftListSuccess:), hhDiscoverLastWeekGiftListSuccess:list);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(hhDiscoverLastWeekGiftListFail:), hhDiscoverLastWeekGiftListFail:message);
    }];
}

- (void)getDiscoverTypeList
{
    [HttpRequestHelper requestDiscoverTypeListSuccess:^(NSArray<DiscoverListModel *> *list) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(hhDiscoverTypeListSuccess:), hhDiscoverTypeListSuccess:list);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(hhDiscoverTypeListFail:), hhDiscoverTypeListFail:message);
    }];
}

//新秀玩友
- (void)getNewUserListWith:(int)page pageSize:(int)pageSize status:(int)status
{
    [HttpRequestHelper requestNewUserListWith:page pageSize:pageSize gender:0 success:^(NSArray<UserInfo *> *list) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(hhDiscoverNewUserListSuccess:status:), hhDiscoverNewUserListSuccess:list status:status);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(hhDiscoverNewUserListFail:status:), hhDiscoverNewUserListFail:message status:status);
    }];
}

//新秀玩友
- (void)getNewUserListWith:(int)page pageSize:(int)pageSize status:(int)status isTotal:(BOOL)isTotal
{
    [HttpRequestHelper requestNewUserListWith:page pageSize:pageSize gender:0 success:^(NSArray<UserInfo *> *list) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(hhDiscoverNewUserListSuccess:status:isTotal:), hhDiscoverNewUserListSuccess:list status:status isTotal:isTotal);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(hhDiscoverNewUserListFail:status:isTotal:), hhDiscoverNewUserListFail:message status:status isTotal:isTotal);
    }];
}


//萌新 新秀玩友
- (void)getNewUserListWith:(int)page pageSize:(int)pageSize gender:(int)gender status:(int)status {
    [HttpRequestHelper requestNewUserListWith:page pageSize:pageSize gender:gender success:^(NSArray<UserInfo *> *list) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(msDiscoverNewUserListSuccess:gender:status:), msDiscoverNewUserListSuccess:list gender:gender status:status);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(DiscoveryCoreClient, @selector(msDiscoverNewUserListFail:gender:status:), msDiscoverNewUserListFail:message gender:gender status:status);
    }];
}


#pragma mark -
#pragma mark 2019-03-29  公会线添加
/**
 获取发现页信息 v2
 interface discovery/v2/get
 */
- (void)requestDiscoverV2Info {
    [HttpRequestHelper requestDiscoverV2InfoAndCompletionHandler:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {
       
        NSArray *bannerVos = [NSArray yy_modelArrayWithClass:DiscoveryBannerInfo.class json:resultObject[@"bannerVos"]];
        NSArray *banners = [NSArray yy_modelArrayWithClass:DiscoverTofuInfo.class json:resultObject[@"banners"]];
        NSArray *headLineNews = [NSArray yy_modelArrayWithClass:DiscoveryHeadLineNews.class json:resultObject[@"topLineVos"]];
        XCFamily *family = [XCFamily yy_modelWithJSON:resultObject[@"family"]];
        
        DiscoveryMainData *mainData = [DiscoveryMainData yy_modelWithJSON:resultObject];
        
        NotifyCoreClient(DiscoveryCoreClient, @selector(getDiscoveryInfoV2:code:message:), getDiscoveryInfoV2:mainData code:code.integerValue message:msg);
        NotifyCoreClient(DiscoveryCoreClient, @selector(getDiscoveryInfoV2:tofuBanners:family:code:message:), getDiscoveryInfoV2:bannerVos tofuBanners:banners family:family code:code.integerValue message:msg);
    }];
}

@end
