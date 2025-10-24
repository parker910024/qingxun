//
//  HttpRequestHelper+Home.m
//  BberryCore
//
//  Created by chenran on 2017/6/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Home.h"
#import "HomePageInfo.h"
#import "BannerInfo.h"
#import "HomeTag.h"
#import "HomeRankingInfo.h"
#import "AuthCore.h"
#import "RoomCoreV2.h"
#import "YYUtility.h"
#import "PurseCore.h"
#import "VersionCore.h"
#import "HomeDataInfor.h"
#import "TTHomeRecommendData.h"
#import "TTHomeRecommendDetailData.h"
#import "MSHomeRecommendData.h"
#import "TTHomeV4Data.h"
#import "TTHomeV4DetailData.h"
#import "RoomCategory.h"
#import "RoomCategoryData.h"

#import "HomeV5Category.h"
#import "HomeV5Banner.h"
#import "HomeV5Data.h"
#import "HomeV5CategoryRoom.h"
#import "PopularTicket.h"

@implementation HttpRequestHelper (Home)


+ (void)requestForcedUpdate:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"appstore/forceupdate";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *version = [YYUtility appVersion];
    [params setObject:version forKey:@"version"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSNumber *result = (NSNumber *)data;
        success(result.boolValue);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}


//======================new=================================

//请求首页tag数据
+ (void)requestHomeTag:(void (^)(NSArray *))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/tag/top";
    if (projectType() == ProjectType_TuTu ||
        projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) { // tutu
        method = @"room/tag/v3/top";
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {

        NSArray *homeTags = [HomeTag modelsWithArray:data];
        success(homeTags);

    } failure:^(NSNumber *resCode, NSString *message) {
        
        failure(resCode, message);
    }];
}
 //请求房间所有tag数据
+ (void)requestRoomAllTag:(void (^)(NSArray *))success
                  failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"room/tag/all";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (projectType() == ProjectType_TuTu ||
        projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        method = @"room/tag/v4/all";
        [params setObject:@(GetCore(RoomCoreV2).getCurrentRoomInfo.uid) forKey:@"uid"];
    }
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *romeTags = [HomeTag modelsWithArray:data];
        success(romeTags);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//请求首页common数据
+ (void)requestHomeCommonData:(int)type state:(int)state page:(int)page
                      success:(void (^)(NSArray *list,int type))success
                      failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"home/v2/tagindex";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(type) forKey:@"tagId"];
    [params setObject:@(page) forKey:@"pageNum"];
    [params setObject:@(10) forKey:@"pageSize"];
    

    [HttpRequestHelper GET:method params:params success:^(id data) {

        NSArray *commonPageInfos = [HomePageInfo modelsWithArray:data];
        success(commonPageInfos,type);
    } failure:^(NSNumber *resCode, NSString *message) {

        failure(resCode, message);
    }];
}

/**
 请求首页分类房间list数据, (2018.11.08 目前兔兔首页使用)
 */
+ (void)requestHomeRoomListData:(int)type state:(int)state page:(int)page size:(int)size
                        success:(void (^)(NSArray *roomList, NSArray *bannerList, int type))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"home/v3/tagindex";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(type) forKey:@"tagId"];
    [params setObject:@(page) forKey:@"pageNum"];
    [params setObject:@(size) forKey:@"pageSize"];
    
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray *commonPageInfos = [HomePageInfo modelsWithArray:data[@"rooms"]];
        NSArray *bannerInfos = [BannerInfo modelsWithArray:data[@"banners"]];
        success(commonPageInfos, bannerInfos, type);
    } failure:^(NSNumber *resCode, NSString *message) {
        
        failure(resCode, message);
    }];
}

//请求首页hot数据
+ (void)requestHomeHotDataWithUid:(NSString *)uid
                             state:(int)state
                             page:(int)page
                          success:(void (^)(NSMutableDictionary *))success
                          failure:(void (^)(NSNumber *, NSString *))failure{
    
    NSString *method = @"home/v2/hotindex";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!uid) {
        uid = @"0";
    }
    [params setObject:@(page) forKey:@"pageNum"];
    [params setObject:@(12) forKey:@"pageSize"];
    [params setObject:uid forKey:@"uid"];

    
    [HttpRequestHelper GET:method params:params success:^(id data) {

        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        //banners

        NSArray *bannerInfos = [BannerInfo modelsWithArray:data[@"banners"]];
        if (bannerInfos.count>0) {
            [dictionary setObject:bannerInfos forKey:@"banners"];
        }
        //rankHome
        NSDictionary *rankHome = [self handleRankData:data[@"rankHome"]];
        if (rankHome.allKeys>0) {
            [dictionary setObject:rankHome forKey:@"rankHome"];
        }
        
        //hot
        NSArray *hotList = [self handleHotList:data[@"hotRooms"]];
        if (hotList.count>0) {
             [dictionary setObject:hotList forKey:@"hotRooms"];
        }
        //common
        NSArray *commonList = [self handleCommonListData:data[@"listRoom"]];
        if (commonList.count>0) {
             [dictionary setObject:commonList forKey:@"listRoom"];
        }
        
        // botBanners
        NSArray *botBannersList = [BannerInfo modelsWithArray:data[@"botBanners"]];
        if (botBannersList.count > 0) {
            [dictionary setObject:botBannersList forKey:@"botBanners"];
        }
        success(dictionary);
    } failure:^(NSNumber *resCode, NSString *message) {
        
        failure(resCode, message);
    }];
}

//请求首页hot数据
+ (void)requestHomeHotDataState:(int)state
                           page:(int)page
                       pageSize:(int)pageSize
                        success:(void (^)(NSMutableDictionary *))success
                        failure:(void (^)(NSNumber *, NSString *))failure{
    
    NSString *method = @"home/v2/hotindex";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"pageNum"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        //        NSLog(@"%@",data);
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        //banners
        NSArray *bannerInfos = [NSArray yy_modelArrayWithClass:[BannerInfo class] json:data[@"banners"]];
        if (bannerInfos.count>0) {
            [dictionary setObject:bannerInfos forKey:@"banners"];
        }
        //rankHome
        NSDictionary *rankHome = [self handleRankData:data[@"rankHome"]];
        if (rankHome.allKeys>0) {
            [dictionary setObject:rankHome forKey:@"rankHome"];
        }
        
        //hot
        NSArray *hotList = [self handleHotList:data[@"hotRooms"]];
        if (hotList.count>0) {
            [dictionary setObject:hotList forKey:@"hotRooms"];
        }
        //common
        NSArray *commonList = [self handleCommonListData:data[@"listRoom"]];
        if (commonList.count>0) {
            [dictionary setObject:commonList forKey:@"listRoom"];
        }
        success(dictionary);
    } failure:^(NSNumber *resCode, NSString *message) {
        NSLog(@"%@",message);
        failure(resCode, message);
    }];
}

//请新首页hot数据
+ (void)requestNewHomePageDataState:(int)state page:(int)page
                        success:(void (^)(NSArray *))success
                        failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"home/v2/home";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *version = [YYUtility appVersion];
    [params setObject:version forKey:@"appVersion"];
    [params setObject:@"ios" forKey:@"os"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * dataArray = (NSArray *)data;
        NSArray<HomeDataInfor *> * array = [NSArray yy_modelArrayWithClass:[HomeDataInfor class] json:dataArray];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


//新的首页接口
+ (void)requestNewMoreHomePageDataState:(int)state page:(int)page
                                success:(void (^)(NSArray *))success
                                failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"home/v2/homeV2";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSString *version = [YYUtility appVersion];
//    [params setObject:version forKey:@"appVersion"];
//    [params setObject:@"ios" forKey:@"os"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray<HomeDataInfor *> * array = [HomeDataInfor modelsWithArray:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//猜你喜欢的页面
+ (void)requestPersonalLikeDataCount:(int)count page:(int)page
                            success:(void (^)(NSArray *))success
                            failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"home/v2/findByPermit";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(count) forKey:@"skip"];
    [params safeSetObject:@(page) forKey:@"pageNum"];
    [params safeSetObject:@(12) forKey:@"pageSize"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[HomebaseModel class] json:data];
        success(dataArray);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//兔兔改版首页数据 Modify at:@2018-11-10
+ (void)requestHomeRecommendDataOnSuccess:(void (^)(NSArray *modelArray))success
                                  failure:(void (^)(NSNumber *code, NSString *msg))failure
{
    NSString *method = @"home/v3/home";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[TTHomeRecommendData class] json:data];
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//兔兔改版-首页佛系交友换一换 Modify at:@2018-11-10
+ (void)requestHomeRandomChatListOnSuccess:(void (^)(NSArray *modelArray))success
                                   failure:(void (^)(NSNumber *code, NSString *msg))failure
{
    NSString *method = @"home/v3/findByPermit";
    
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[TTHomeRecommendDetailData class] json:data];
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//兔兔首页数据v4 Modify at:@2019-02-15
+ (void)requestHomeDataV4OnSuccess:(void (^)(NSArray *modelArray))success
                                  failure:(void (^)(NSNumber *code, NSString *msg))failure
{
    NSString *method = @"home/v4/home";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[TTHomeV4Data class] json:data];
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//兔兔获取首页房间标题列表(房间分类列表)v4 Modify at:@2019-02-15
+ (void)requestTTHomeV4RoomCategoryOnSuccess:(void (^)(NSArray *modelArray))success
                                     failure:(void (^)(NSNumber *code, NSString *msg))failure
{
    NSString *method = @"home/v4/titleList";
    
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[RoomCategory class] json:data];
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//兔兔分页获取标题对应列表数据(某分类下房间列表)v4 Modify at:@2019-02-15
+ (void)requestTTHomeV4RoomCategoryRoomDataWithTitleId:(NSString *)titleId
                                               pageNum:(NSUInteger)page
                                              pageSize:(NSUInteger)pageSize
                                               success:(void (^)(RoomCategoryData *))success
                                               failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"home/v4/titleIndex";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:titleId forKey:@"titleId"];
    [params safeSetObject:@(MAX(1, page)) forKey:@"page"];
    [params safeSetObject:@(MAX(1, pageSize)) forKey:@"pageSize"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        RoomCategoryData *model = [RoomCategoryData yy_modelWithJSON:data];
        model.titleId = titleId;
        
        if (success) {
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//兔兔分页获取首页热门推荐v4 Modify at:@2019-02-15
+ (void)requestTTHomeV4HotRoomWithPageNum:(NSUInteger)page
                                 pageSize:(NSUInteger)pageSize
                                  success:(void (^)(NSArray *))success
                                  failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"home/v4/topic";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(MAX(1, page)) forKey:@"page"];
    [params safeSetObject:@(MAX(1, pageSize)) forKey:@"pageSize"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSDictionary *json = data[@"rooms"];
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:TTHomeV4DetailData.class json:json];
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//萌声改版首页数据 Modify at:@2018-12-21
+ (void)requestMSHomeRecommendDataOnSuccess:(void (^)(NSArray *modelArray))success
                                  failure:(void (^)(NSNumber *code, NSString *msg))failure
{
    NSString *method = @"home/v2/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[MSHomeRecommendData class] json:data];
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//萌声改版首页数据 Modify at:@2019-2-20
+ (void)requestMSHomeRecommendDataV2OnSuccess:(void (^)(NSArray *modelArray))success
                                    failure:(void (^)(NSNumber *code, NSString *msg))failure
{
    NSString *method = @"home/v2/listV2";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[MSHomeRecommendData class] json:data];
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//请求banner数据
+ (void)requestBannerDataOnSuccess:(void (^)(NSArray *modelArray))success
                           failure:(void (^)(NSNumber *code, NSString *msg))failure {
    NSString *method = @"banner/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[BannerInfo class] json:data];
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark v5
// 首页导航列表
+ (void)requestHomeV5CategoryOnSuccess:(void (^)(HomeV5Category *data))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *path = @"home/v5/getFirstPageBanner";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:@"1" forKey:@"type"];//type: 1-导航列表 2-首页下方的banner

    [HttpRequestHelper GET:path params:params success:^(id data) {
        HomeV5Category *model = [HomeV5Category yy_modelWithJSON:data];
        if (success) {
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

// 首页banner
+ (void)requestHomeV5BannerOnSuccess:(void (^)(NSArray<BannerInfo *> *modelArray))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *path = @"home/v5/getFirstPageBanner";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:@"2" forKey:@"type"];//type: 1-导航列表 2-首页下方的banner
    
    [HttpRequestHelper GET:path params:params success:^(id data) {
        id bannerJSON = [data objectForKey:@"firstPageBannerVos"];
        NSArray *array = [NSArray yy_modelArrayWithClass:BannerInfo.class json:bannerJSON];
        if (success) {
            success(array);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

// 轻寻的首页导航和banner
+ (void)requestLLHomeV5CategoryBannerOnSuccess:(void (^)(HomeV5Category *data))success
                                       failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *path = @"home/v5/getFirstPageBanner";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    //type: 1-导航列表 2-首页下方的banner 3-轻寻导航和banner
    [params setValue:@"3" forKey:@"type"];
    
    [HttpRequestHelper GET:path params:params success:^(id data) {
        HomeV5Category *model = [HomeV5Category yy_modelWithJSON:data];
        if (success) {
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//首页数据 labelType:标签类型，1男神，2女神，3男神女神
+ (void)requestHomeV5DataWithLabelType:(NSInteger)labelType
                           currentPage:(NSInteger)currentPage
                              pageSize:(NSInteger)pageSize
                               success:(void (^)(NSArray<HomeV5Data *> *modelArray))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *path = @"home/v6/user/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:@(currentPage) forKey:@"page"];
    [params setValue:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(labelType) forKey:@"labelType"];
    
    [HttpRequestHelper GET:path params:params success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:HomeV5Data.class json:data];
        if (success) {
            success(array);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

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
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *path = @"home/v5/getTabRoomList";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:tabId forKey:@"tabId"];
    [params setValue:@(currentPage) forKey:@"currentPage"];
    [params setValue:@(pageSize) forKey:@"pageSize"];
    
    [HttpRequestHelper GET:path params:params success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:HomeV5CategoryRoom.class json:data];
        if (success) {
            success(array);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 首页分类banner数据
 
 @param tabId tab主键
 */
+ (void)requestHomeV5CategoryBanner:(NSString *)tabId
                            success:(void (^)(NSArray<BannerInfo *> *modelArray))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *path = @"home/v5/getTabBanner";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:tabId forKey:@"tabId"];
    
    [HttpRequestHelper GET:path params:params success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:BannerInfo.class json:data];
        if (success) {
            success(array);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/// 领取人气票礼物
+ (void)requestHomePopularTicketWithSuccess:(void(^)(PopularTicket *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"activities/annual/receive/gift";

    [HttpRequestHelper POST:method params:@{} success:^(id data) {
        PopularTicket *model = [PopularTicket modelWithJSON:data];
        if (success) {
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark - private method
+ (NSArray *)handleHotList:(id)data{

    NSArray * hotList = [HomePageInfo modelsWithArray:data];
    return hotList;
}

+ (NSArray *)handleCommonListData:(id)data{

    NSArray * commonList = [HomePageInfo modelsWithArray:data];
    return commonList;
}

+ (NSDictionary *)handleRankData:(id)data{
    NSArray *nobleList = [NSArray yy_modelArrayWithClass:[HomeRankingInfo class] json:data[@"nobleList"]];
    NSArray *starList = [NSArray yy_modelArrayWithClass:[HomeRankingInfo class] json:data[@"starList"]];
    NSArray *roomList = [NSArray yy_modelArrayWithClass:[HomeRankingInfo class] json:data[@"roomList"]];
    
    NSMutableDictionary * rankHome = [NSMutableDictionary dictionary];
    if (nobleList.count > 0 && nobleList != nil) {
        [rankHome setObject:nobleList forKey:@"nobleList"];
    }
    if (starList.count > 0 && starList != nil) {
        [rankHome setObject:starList forKey:@"starList"];
    }
    if (roomList.count > 0 && roomList != nil) {
        [rankHome setObject:roomList forKey:@"roomList"];
    }
    return [rankHome copy];
}
@end
