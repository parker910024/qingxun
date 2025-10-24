//
//  DiscoveryCoreClient.h
//  BberryCore
//
//  Created by Macx on 2018/3/5.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiscoverGiftRankModel.h"
#import "UserInfo.h"
#import "DiscoverListModel.h"
#import "DiscoveryBannerInfo.h"
#import "DiscoverTofuInfo.h"
#import "XCFamily.h"
#import "DiscoveryMainData.h"

@protocol DiscoveryCoreClient <NSObject>
@optional


- (void)onDiscoveryAdListSuccess:(NSArray *)list;//请求广告列表成功
- (void)onDiscoverAdlistFailth:(NSString *)msg;//请求广告列表失败

#pragma mark -
#pragma mark 2019-03-29 公会线添加
- (void)getDiscoveryInfoV2:(NSArray<DiscoveryBannerInfo *> *)headBanners tofuBanners:(NSArray<DiscoverTofuInfo *> *)banners family:(XCFamily *)family code:(NSInteger)code message:(NSString *)mssage;

- (void)getDiscoveryInfoV2:(DiscoveryMainData *)mainData code:(NSInteger)code message:(NSString *)mssage;

#pragma mark - 哈哈
- (void)hhDiscoverLastWeekGiftListSuccess:(NSArray<DiscoverGiftRankModel *> *)lists;//请求礼物周星榜成功
- (void)hhDiscoverLastWeekGiftListFail:(NSString *)message;;//请求礼物周星榜失败

- (void)hhDiscoverTypeListSuccess:(NSArray<DiscoverListModel *> *)lists;//请求发现页的类型成功
- (void)hhDiscoverTypeListFail:(NSString *)message;//请求发现页的类型失败

//新秀玩友成功
- (void)hhDiscoverNewUserListSuccess:(NSArray<UserInfo *> *)userList status:(int)status;
//新秀玩友失败
- (void)hhDiscoverNewUserListFail:(NSString * )message status:(int)status;

//新秀玩友成功
- (void)hhDiscoverNewUserListSuccess:(NSArray<UserInfo *> *)userList status:(int)status isTotal:(BOOL)isTotal;
//新秀玩友失败
- (void)hhDiscoverNewUserListFail:(NSString * )message status:(int)status isTotal:(BOOL)isTotal;



//新秀玩友成功
- (void)msDiscoverNewUserListSuccess:(NSArray<UserInfo *> *)userList gender:(int)gender status:(int)status;
//新秀玩友失败
- (void)msDiscoverNewUserListFail:(NSString * )message gender:(int)gender status:(int)status;

@end
