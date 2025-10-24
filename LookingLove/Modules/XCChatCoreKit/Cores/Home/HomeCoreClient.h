//
//  HomeCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/6/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoomCategoryData;
@class HomeV5CategoryRoom;
@class BannerInfo;
@class HomeV5Category;
@class HomeV5Banner;
@class HomeV5Data;

@protocol HomeCoreClient <NSObject>
@optional

// update
- (void)onRequestForcedUpdateSuccess:(BOOL)result;
- (void)onRequestForcedUpdateFailth:(NSString *)msg;


//network
- (void)networkReconnect;

//======================new home ui=================================
//请求首页tag
- (void)onRequestHomeTagListSuccess:(NSArray *)list;
- (void)onRequestHomeTagListFailth:(NSString *)msg;
//请求所有房间tag
- (void)requestRoomAllTagListSuccess:(NSArray *)list;
- (void)requestRoomAllTagListFailth:(NSString *)msg;
//请求首页hot数据
- (void)requestHomeHotDataListState:(int)state success:(NSMutableDictionary *)list;
- (void)requestHomeHotDataListState:(int)state failth:(NSString *)msg;
//用于其他页面 请求刷新banner
- (void)onRequestHomeTagBannerListSuccess:(NSMutableDictionary *)bannerlist;

//请求首页others数据
- (void)requestHomeCommonDataListState:(int)state success:(NSArray *)list type:(int)type;
- (void)requestHomeCommonDataListState:(int)state failth:(NSString *)msg;

/*
 新的首页请求数据
 */

- (void)requestNewHomeRoomListSuccess:(NSArray *)list;
- (void)requestNewHomeRoomListFailth:(NSString *)msg;

/*
 猜你喜欢
 */
- (void)requestPersonalLikeListSuccess:(NSArray *)list;
- (void)requestPersonalLikeListFailth:(NSString *)msg;

//当收到广播的时候刷新首页
- (void)reloadHomePageWhenReceviceBoardcast;

// 请求首页房间分类下房间列表数据  (2018.11.08 目前兔兔首页使用)
- (void)requestHomeRoomCategoryDataListState:(int)state roomList:(NSArray *)roomList bannerList:(NSArray *)bannerList type:(int)type;
- (void)requestHomeRoomCategoryDataListState:(int)state type:(int)type failth:(NSString *)msg;

//兔兔改版，首页推荐数据 Modify at:@2018-11-10
- (void)responseHomeRecommendData:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg;

//兔兔改版，首页佛系交友换一换 Modify at:@2018-11-10
- (void)responseHomeRandomChatList:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg;

//兔兔首页数据v4 Modify at:@2019-02-15
- (void)responseTTHomeV4Data:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg;
//兔兔获取首页房间标题列表(房间分类列表)v4 Modify at:@2019-02-15
- (void)responseTTHomeV4RoomCategory:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg;
//兔兔分页获取标题对应列表数据(某分类下房间列表+banner)v4 Modify at:@2019-02-15
- (void)responseTTHomeV4RoomCategoryRoomData:(RoomCategoryData *)data errorCode:(NSNumber *)code msg:(NSString *)msg;
//兔兔分页获取首页热门推荐v4 Modify at:@2019-02-15
- (void)responseTTHomeV4HotRoom:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg;

//萌声改版首页数据 Modify at:@2018-12-21
- (void)responseMSHomeRecommendData:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg;

// 请求banner数据的回调
- (void)responseBannerData:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg;

#pragma mark v5
// 首页导航列表
- (void)responseHomeV5Category:(HomeV5Category *)data errorCode:(NSNumber *)code msg:(NSString *)msg;
// 首页banner
- (void)responseHomeV5Banner:(NSArray<BannerInfo *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;
// 轻寻的首页导航和 banner
- (void)responseLLHomeV5CategoryBanner:(HomeV5Category *)data errorCode:(NSNumber *)code msg:(NSString *)msg;
//首页数据
- (void)responseHomeV5Data:(NSArray<HomeV5Data *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;
//首页分类房间列表数据
- (void)responseHomeV5CategoryRoomData:(NSArray<HomeV5CategoryRoom *> *)data tabId:(NSString *)tabId errorCode:(NSNumber *)code msg:(NSString *)msg;
//首页分类banner数据
- (void)responseHomeV5CategoryBanner:(NSArray<BannerInfo *> *)data tabId:(NSString *)tabId errorCode:(NSNumber *)code msg:(NSString *)msg;

@end
