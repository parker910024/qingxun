//
//  HomeCore.h
//  BberryCore
//
//  Created by chenran on 2017/6/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "PopularTicket.h"

@interface HomeCore : BaseCore

//萌声UI
@property (strong , nonatomic) NSDictionary *tagNameColorDic;//首页颜色


//用分类名字 获取颜色
- (UIColor *)getColorWithTagName:(NSString *)tagName;

//update
- (void)requestForcedUpdate;

//======================new home ui=================================
- (void)requestHomeTag;             //请求首页tag
- (void)requestRoomAllTag;          //请求所有房间tag
/*请求首页hot数据
 state:0 结束头部刷新。  1 结束底部熟悉
 refreshBanner : YES  只会回调刷新首页banner的监听方法  NO 回调刷新首页数据的方法
 */
- (void)requestHomeHotDataState:(int)state page:(int)page;
- (void)requestHomeHotDataState:(int)state page:(int)page pageSize:(int)pageSize;
- (void)requestHomeHotDataWithUid:(NSString *)uid state:(int)state page:(int)page isOnlyBanner:(BOOL)refreshBanner;
/*请求首页others数据
 state:0 结束头部刷新。  1 结束底部熟悉
 type: 标签类型
 */
- (void)requestHomeCommonData:(int)type state:(int)state page:(int)page;


/*请求新的首页
 state:0 结束头部刷新。  1 结束底部熟悉
 page:第几页
 */
- (void)requestNewHomepageDataState:(int)state page:(int)page;

/*猜你喜欢  只有上拉的时候才会调用
 state:第一次请求返回的数据的个数
 type: 第几页
 */
//
- (void)requestPersonalLikeDataCount:(int)count page:(int)page;


/*请求最新 新的首页
 state:0 结束头部刷新。  1 结束底部熟悉
 page:第几页
 */
- (void)requestNewMoreHomepageDataState:(int)state page:(int)page;

/*
 请求首页房间分类下房间列表数据  (2018.11.08 目前兔兔首页使用)
 state:0 结束头部刷新。  1 结束底部熟悉
 type: 标签类型
 */
- (void)requestHomeRoomListData:(int)type state:(int)state page:(int)page;
- (void)requestHomeRoomListData:(int)type state:(int)state page:(int)page size:(int)size;

//兔兔改版-首页数据 Modify at:@2018-11-10
- (void)requestHomeRecommendData;

//兔兔改版-首页佛系交友 Modify at:@2018-11-10
- (void)requestHomeRandomChatList;

//兔兔首页数据v4 Modify at:@2019-02-15
- (void)requestTTHomeV4Data;
//兔兔获取首页房间标题列表(房间分类列表)v4 Modify at:@2019-02-15
- (void)requestTTHomeV4RoomCategory;
//兔兔分页获取标题对应列表数据(某分类下房间列表)v4 Modify at:@2019-02-15
- (void)requestTTHomeV4RoomCategoryRoomDataWithTitleId:(NSString *)titleId pageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize;
//兔兔分页获取首页热门推荐v4 Modify at:@2019-02-15
- (void)requestTTHomeV4HotRoomWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize;

//萌声改版首页数据 Modify at:@2018-12-21
- (void)requestMSHomeRecommendData;
//萌声改版首页数据 Modify at:@2019-2-20
- (void)requestMSHomeRecommendDataV2;

/**
 请求banner信息
 */
- (void)requestBannerData;

#pragma mark v5
// 首页导航列表
- (void)requestHomeV5Category;

// 首页banner
- (void)requestHomeV5Banner;

//轻寻的首页导航和banner
- (void)requestLLHomeV5CategoryBanner;

//首页数据 labelType:标签类型，1男神，2女神，3男神女神
- (void)requestHomeV5DataWithLabelType:(NSInteger)labelType
                           currentPage:(NSInteger)currentPage
                              pageSize:(NSInteger)pageSize;

/**
 首页分类房间列表数据
 
 @param tabId tab主键
 @param currentPage 当前页
 @param pageSize 页面大小
 */
- (void)requestHomeV5CategoryRoomData:(NSString *)tabId
                          currentPage:(NSInteger)currentPage
                             pageSize:(NSInteger)pageSize;

/**
 首页分类banner数据
 
 @param tabId tab主键
 */
- (void)requestHomeV5CategoryBanner:(NSString *)tabId;


/// 领取人气票礼物
/// @param completion 完成回调
- (void)requestHomePopularTicketCompletion:(void(^)(PopularTicket *data, NSNumber *errorCode, NSString *msg))completion;

@end
