//
//  HttpRequestHelper+Home.h
//  BberryCore
//
//  Created by chenran on 2017/6/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"

@class RoomCategoryData;
@class HomeV5CategoryRoom;
@class BannerInfo;
@class HomeV5Category;
@class HomeV5Banner;
@class HomeV5Data;
@class PopularTicket;

@interface HttpRequestHelper (Home)


/**
 是否强制更新
 
 @param success 成功
 @param failure 失败
 */
+(void)requestForcedUpdate:(void (^)(BOOL))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;



//======================new home ui=================================
/**
 请求首页tag数据
 */
+ (void)requestHomeTag:(void (^)(NSArray *))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 请求房间所有tag数据
 */
+ (void)requestRoomAllTag:(void (^)(NSArray *))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 请求首页hot数据
 */
+ (void)requestHomeHotDataWithUid:(NSString *)uid
                            state:(int)state
                             page:(int)page
                          success:(void (^)(NSMutableDictionary *))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 请求首页hot数据
 */
+ (void)requestHomeHotDataState:(int)state
                           page:(int)page
                       pageSize:(int)pageSize
                        success:(void (^)(NSMutableDictionary *))success
                        failure:(void (^)(NSNumber *, NSString *))failure;
/**
 请求首页common数据
 */
+ (void)requestHomeCommonData:(int)type state:(int)state page:(int)page
                      success:(void (^)(NSArray *list,int type))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

//请新首页hot数据
+ (void)requestNewHomePageDataState:(int)state page:(int)page
                            success:(void (^)(NSArray *))success
                            failure:(void (^)(NSNumber *, NSString *))failure;

//猜你喜欢的页面
+ (void)requestPersonalLikeDataCount:(int)count page:(int)page
                             success:(void (^)(NSArray *))success
                             failure:(void (^)(NSNumber *, NSString *))failure;

//新的首页接口
+ (void)requestNewMoreHomePageDataState:(int)state page:(int)page
                                success:(void (^)(NSArray *))success
                                failure:(void (^)(NSNumber *, NSString *))failure;

/**
 请求首页分类房间list数据, (2018.11.08 目前兔兔首页使用)
 */
+ (void)requestHomeRoomListData:(int)type state:(int)state page:(int)page size:(int)size
                        success:(void (^)(NSArray *roomList, NSArray *bannerList, int type))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;

//兔兔改版-首页数据 Modify at:@2018-11-10
+ (void)requestHomeRecommendDataOnSuccess:(void (^)(NSArray *modelArray))success
                                  failure:(void (^)(NSNumber *code, NSString *msg))failure;
//兔兔改版-首页佛系交友换一换 Modify at:@2018-11-10
+ (void)requestHomeRandomChatListOnSuccess:(void (^)(NSArray *modelArray))success
                                  failure:(void (^)(NSNumber *code, NSString *msg))failure;

//兔兔首页数据v4 Modify at:@2019-02-15
+ (void)requestHomeDataV4OnSuccess:(void (^)(NSArray *modelArray))success
                           failure:(void (^)(NSNumber *code, NSString *msg))failure;

//兔兔获取首页房间标题列表(房间分类列表)v4 Modify at:@2019-02-15
+ (void)requestTTHomeV4RoomCategoryOnSuccess:(void (^)(NSArray *modelArray))success
                                     failure:(void (^)(NSNumber *code, NSString *msg))failure;
//兔兔分页获取标题对应列表数据(某分类下房间列表)v4 Modify at:@2019-02-15
+ (void)requestTTHomeV4RoomCategoryRoomDataWithTitleId:(NSString *)titleId
                                               pageNum:(NSUInteger)pageNum
                                              pageSize:(NSUInteger)pageSize
                                               success:(void (^)(RoomCategoryData *))success
                                               failure:(void (^)(NSNumber *, NSString *))failure;
//兔兔分页获取首页热门推荐v4 Modify at:@2019-02-15
+ (void)requestTTHomeV4HotRoomWithPageNum:(NSUInteger)pageNum
                                 pageSize:(NSUInteger)pageSize
                                  success:(void (^)(NSArray *))success
                                  failure:(void (^)(NSNumber *, NSString *))failure;

//萌声改版首页数据 Modify at:@2018-12-21
+ (void)requestMSHomeRecommendDataOnSuccess:(void (^)(NSArray *modelArray))success
                                    failure:(void (^)(NSNumber *code, NSString *msg))failure;
//萌声改版首页数据 Modify at:@2019-2-20
+ (void)requestMSHomeRecommendDataV2OnSuccess:(void (^)(NSArray *modelArray))success
                                      failure:(void (^)(NSNumber *code, NSString *msg))failure;

//请求banner数据
+ (void)requestBannerDataOnSuccess:(void (^)(NSArray *modelArray))success
                           failure:(void (^)(NSNumber *code, NSString *msg))failure;

#pragma mark v5
// 首页导航列表
+ (void)requestHomeV5CategoryOnSuccess:(void (^)(HomeV5Category *data))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;

// 首页banner
+ (void)requestHomeV5BannerOnSuccess:(void (^)(NSArray<BannerInfo *> *modelArray))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;

// 轻寻的首页导航和banner
+ (void)requestLLHomeV5CategoryBannerOnSuccess:(void (^)(HomeV5Category *data))success
                                       failure:(void (^)(NSNumber *resCode, NSString *message))failure;

//首页数据 labelType:标签类型，1男神，2女神，3男神女神
+ (void)requestHomeV5DataWithLabelType:(NSInteger)labelType
                           currentPage:(NSInteger)currentPage
                              pageSize:(NSInteger)pageSize
                               success:(void (^)(NSArray<HomeV5Data *> *modelArray))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 首页分类房间列表数据
 
 @param tabId tab主键
 @param currentPage 当前页
 @param pageSize 页面大小
 */
+ (void)requestHomeV5CategoryRoomData:(NSString *)tabId
                          currentPage:(NSInteger)currentPage
                             pageSize:(NSInteger)pageSize
                              success:(void (^)(NSArray<HomeV5CategoryRoom *> *modelArray))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 首页分类banner数据
 
 @param tabId tab主键
 */
+ (void)requestHomeV5CategoryBanner:(NSString *)tabId
                            success:(void (^)(NSArray<BannerInfo *> *modelArray))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 领取人气票礼物
+ (void)requestHomePopularTicketWithSuccess:(void(^)(PopularTicket *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end
