//
//  HomeCore.m
//  BberryCore
//
//  Created by chenran on 2017/6/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HomeCore.h"
#import "HomeCoreClient.h"
#import "HttpRequestHelper+Home.h"
#import <AFNetworkReachabilityManager.h>
#import "VersionCore.h"
#import "Attachment.h"
#import "AuthCore.h"
#import "RoomCoreClient.h"
#import "BannerInfo.h"
#import "HomeRankingInfo.h"
#import "HomePageInfo.h"
#import "RoomCategoryData.h"
#import "HomeV5CategoryRoom.h"

#import "HomeV5Category.h"
#import "HomeV5Banner.h"
#import "HomeV5Data.h"

#import "XCTheme.h"


#import "NSString+JsonToDic.h"
#import "CommonFileUtils.h"

static  NSString const * Home_Rload = @"Home_reload";

@interface HomeCore ()<RoomCoreClient>
@property (nonatomic,assign) BOOL reachableViaWWANFirst;
@property (nonatomic,assign) BOOL reachableViaWiFiFirst;
@end

@implementation HomeCore

- (instancetype)init
{
    self = [super init];
    if (self) {
         AddCoreClient(RoomCoreClient, self);
        @weakify(self);
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            @strongify(self);
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    [[BaiduMobStat defaultStat]logEvent:@"lost_network_event" eventLabel:@"断网"];
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    if (self.reachableViaWWANFirst) {
                        NotifyCoreClient(HomeCoreClient, @selector(networkReconnect), networkReconnect);
                    }
                    self.reachableViaWWANFirst = YES;
                }
                    
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    {
                        if (self.reachableViaWiFiFirst) {
                            NotifyCoreClient(HomeCoreClient, @selector(networkReconnect), networkReconnect);
                        }
                        self.reachableViaWiFiFirst = YES;
                    }
                    
                    break;
                default:
                    break;
            }
        }];
    }
    return self;
}

//请求首页hot数据

- (void)requestHomeHotDataState:(int)state page:(int)page pageSize:(int)pageSize {
    [HttpRequestHelper requestHomeHotDataState:state page:page pageSize:pageSize success:^(NSMutableDictionary *dictionary) {
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeHotDataListState:success:), requestHomeHotDataListState:state success:dictionary);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeHotDataListState:failth:), requestHomeHotDataListState:state failth:message);
    }];

}
- (void)requestHomeHotDataState:(int)state page:(int)page{
    [HttpRequestHelper requestHomeHotDataState:state page:page pageSize:20 success:^(NSMutableDictionary *dictionary) {
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeHotDataListState:success:), requestHomeHotDataListState:state success:dictionary);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeHotDataListState:failth:), requestHomeHotDataListState:state failth:message);
    }];
}
- (void)requestForcedUpdate
{
    [HttpRequestHelper requestForcedUpdate:^(BOOL result) {
        NotifyCoreClient(HomeCoreClient, @selector(onRequestForcedUpdateSuccess:), onRequestForcedUpdateSuccess:result);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(onRequestForcedUpdateFailth:), onRequestForcedUpdateFailth:message);
    }];
}

//======================new=================================
//请求首页tag
- (void)requestHomeTag{
    [HttpRequestHelper requestHomeTag:^(NSArray *list) {
        [CommonFileUtils writeObject:list toUserDefaultWithKey:kHomeTagUserDefaultKey];
        NotifyCoreClient(HomeCoreClient, @selector(onRequestHomeTagListSuccess:), onRequestHomeTagListSuccess:list);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(onRequestHomeTagListFailth:), onRequestHomeTagListFailth:message);
    }];
}

//请求所有房间tag
- (void)requestRoomAllTag {
    [HttpRequestHelper requestRoomAllTag:^(NSArray *list) {
        NotifyCoreClient(HomeCoreClient, @selector(requestRoomAllTagListSuccess:), requestRoomAllTagListSuccess:list);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(requestRoomAllTagListFailth:), requestRoomAllTagListFailth:message);
    }];
}

//请求首页hot数据
- (void)requestHomeHotDataWithUid:(NSString *)uid state:(int)state page:(int)page isOnlyBanner:(BOOL)refreshBanner{
    
    [HttpRequestHelper requestHomeHotDataWithUid:uid state:state page:page success:^(NSMutableDictionary *dictionary) {
//        if (refreshBanner) {
//            NotifyCoreClient(HomeCoreClient, @selector(onRequestHomeTagBannerListSuccess:), onRequestHomeTagBannerListSuccess:dictionary);
//        }
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeHotDataListState:success:), requestHomeHotDataListState:state success:dictionary);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeHotDataListState:failth:), requestHomeHotDataListState:state failth:message);
    }];
}

/*请求最新 新的首页
 state:0 结束头部刷新。  1 结束底部熟悉
 page:第几页
 */
- (void)requestNewMoreHomepageDataState:(int)state page:(int)page
{
    [HttpRequestHelper requestNewMoreHomePageDataState:state page:page success:^(NSArray *array) {
         NotifyCoreClient(HomeCoreClient, @selector(requestNewHomeRoomListSuccess:), requestNewHomeRoomListSuccess:array);
    } failure:^(NSNumber *number, NSString *str) {
        NotifyCoreClient(HomeCoreClient, @selector(requestNewHomeRoomListFailth:), requestNewHomeRoomListFailth:str);
    }];
}

- (void)requestNewHomepageDataState:(int)state page:(int)page{
    [HttpRequestHelper requestNewHomePageDataState:state page:page success:^(NSArray *dic) {
        
        NotifyCoreClient(HomeCoreClient, @selector(requestNewHomeRoomListSuccess:), requestNewHomeRoomListSuccess:dic);
    } failure:^(NSNumber * number, NSString * str) {
        NotifyCoreClient(HomeCoreClient, @selector(requestNewHomeRoomListFailth:), requestNewHomeRoomListFailth:str);
    }];
}
//猜你喜欢  只有上拉的时候才会调用
- (void)requestPersonalLikeDataCount:(int)count page:(int)page
{
    [HttpRequestHelper requestPersonalLikeDataCount:count page:page success:^(NSArray * array) {
        NotifyCoreClient(HomeCoreClient, @selector(requestPersonalLikeListSuccess:), requestPersonalLikeListSuccess:array);
    } failure:^(NSNumber *number, NSString *des) {
        NotifyCoreClient(HomeCoreClient, @selector(requestPersonalLikeListFailth:), requestPersonalLikeListFailth:des);
    }];
}



//请求首页others数据
- (void)requestHomeCommonData:(int)type state:(int)state page:(int)page{
    [HttpRequestHelper requestHomeCommonData:(int)type state:(int)state page:(int)page success:^(NSArray *list,int type) {
        
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeCommonDataListState:success:type:), requestHomeCommonDataListState:state success:list type:type);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeCommonDataListState:failth:), requestHomeCommonDataListState:state failth:message);
    }];
}

/*
 请求首页房间分类下房间列表数据  (2018.11.08 目前兔兔首页使用)
 state:0 结束头部刷新。  1 结束底部熟悉
 type: 标签类型
 */
- (void)requestHomeRoomListData:(int)type state:(int)state page:(int)page {
    [self requestHomeRoomListData:type state:state page:page size:10];
}

- (void)requestHomeRoomListData:(int)type state:(int)state page:(int)page size:(int)size {
    [HttpRequestHelper requestHomeRoomListData:(int)type state:(int)state page:(int)page size:size success:^(NSArray *list, NSArray *banner, int type) {
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeRoomCategoryDataListState:roomList:bannerList:type:), requestHomeRoomCategoryDataListState:state roomList:list bannerList:banner type:type);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(requestHomeRoomCategoryDataListState:type:failth:), requestHomeRoomCategoryDataListState:state type:type failth:message);
    }];
}

//兔兔改版首页数据 Modify at:@2018-11-10
- (void)requestHomeRecommendData {
    [HttpRequestHelper requestHomeRecommendDataOnSuccess:^(NSArray *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeRecommendData:errorCode:msg:), responseHomeRecommendData:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeRecommendData:errorCode:msg:), responseHomeRecommendData:nil errorCode:code msg:msg);
    }];
}

//兔兔改版-首页佛系交友 Modify at:@2018-11-10
- (void)requestHomeRandomChatList {
    [HttpRequestHelper requestHomeRandomChatListOnSuccess:^(NSArray *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeRecommendData:errorCode:msg:), responseHomeRandomChatList:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeRecommendData:errorCode:msg:), responseHomeRandomChatList:nil errorCode:code msg:msg);
    }];
}

//兔兔首页数据v4 Modify at:@2019-02-15
- (void)requestTTHomeV4Data {
    [HttpRequestHelper requestHomeDataV4OnSuccess:^(NSArray *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseTTHomeV4Data:errorCode:msg:), responseTTHomeV4Data:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(HomeCoreClient, @selector(responseTTHomeV4Data:errorCode:msg:), responseTTHomeV4Data:nil errorCode:code msg:msg);
    }];
}

//兔兔获取首页房间标题列表(房间分类列表)v4 Modify at:@2019-02-15
- (void)requestTTHomeV4RoomCategory {
    [HttpRequestHelper requestTTHomeV4RoomCategoryOnSuccess:^(NSArray *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseTTHomeV4RoomCategory:errorCode:msg:), responseTTHomeV4RoomCategory:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(HomeCoreClient, @selector(responseTTHomeV4RoomCategory:errorCode:msg:), responseTTHomeV4RoomCategory:nil errorCode:code msg:msg);
    }];
}

//兔兔分页获取标题对应列表数据(某分类下房间列表)v4 Modify at:@2019-02-15
- (void)requestTTHomeV4RoomCategoryRoomDataWithTitleId:(NSString *)titleId pageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize {
    [HttpRequestHelper requestTTHomeV4RoomCategoryRoomDataWithTitleId:titleId pageNum:pageNum pageSize:pageSize success:^(RoomCategoryData *model) {
        NotifyCoreClient(HomeCoreClient, @selector(responseTTHomeV4RoomCategoryRoomData:errorCode:msg:), responseTTHomeV4RoomCategoryRoomData:model errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(HomeCoreClient, @selector(responseTTHomeV4RoomCategoryRoomData:errorCode:msg:), responseTTHomeV4RoomCategoryRoomData:nil errorCode:code msg:msg);
    }];
}

//兔兔分页获取首页热门推荐v4 Modify at:@2019-02-15
- (void)requestTTHomeV4HotRoomWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize {
    [HttpRequestHelper requestTTHomeV4HotRoomWithPageNum:pageNum pageSize:pageSize success:^(NSArray *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseTTHomeV4HotRoom:errorCode:msg:), responseTTHomeV4HotRoom:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(HomeCoreClient, @selector(responseTTHomeV4HotRoom:errorCode:msg:), responseTTHomeV4HotRoom:nil errorCode:code msg:msg);
    }];
}

//萌声改版首页数据 Modify at:@2018-12-21
- (void)requestMSHomeRecommendData {
    [HttpRequestHelper requestMSHomeRecommendDataOnSuccess:^(NSArray *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseMSHomeRecommendData:errorCode:msg:), responseMSHomeRecommendData:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(HomeCoreClient, @selector(responseMSHomeRecommendData:errorCode:msg:), responseMSHomeRecommendData:nil errorCode:code msg:msg);
    }];
}

//萌声改版首页数据 Modify at:@2019-2-20
- (void)requestMSHomeRecommendDataV2 {
    [HttpRequestHelper requestMSHomeRecommendDataV2OnSuccess:^(NSArray *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseMSHomeRecommendData:errorCode:msg:), responseMSHomeRecommendData:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(HomeCoreClient, @selector(responseMSHomeRecommendData:errorCode:msg:), responseMSHomeRecommendData:nil errorCode:code msg:msg);
    }];
}


/**
 请求banner信息
 */
- (void)requestBannerData {
    [HttpRequestHelper requestBannerDataOnSuccess:^(NSArray *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseBannerData:errorCode:msg:), responseBannerData:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(HomeCoreClient, @selector(responseBannerData:errorCode:msg:), responseBannerData:nil errorCode:code msg:msg);
    }];
}

#pragma mark v5
// 首页导航列表
- (void)requestHomeV5Category {
    
    [HttpRequestHelper requestHomeV5CategoryOnSuccess:^(HomeV5Category *data) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5Category:errorCode:msg:), responseHomeV5Category:data errorCode:nil msg:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5Category:errorCode:msg:), responseHomeV5Category:nil errorCode:resCode msg:message);
    }];
}

// 首页banner
- (void)requestHomeV5Banner {
    
    [HttpRequestHelper requestHomeV5BannerOnSuccess:^(NSArray<BannerInfo *> *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5Banner:errorCode:msg:), responseHomeV5Banner:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5Banner:errorCode:msg:), responseHomeV5Banner:nil errorCode:resCode msg:message);
    }];
}

//轻寻的首页导航和banner
- (void)requestLLHomeV5CategoryBanner {
    
    [HttpRequestHelper requestLLHomeV5CategoryBannerOnSuccess:^(HomeV5Category *data) {
        NotifyCoreClient(HomeCoreClient, @selector(responseLLHomeV5CategoryBanner:errorCode:msg:), responseLLHomeV5CategoryBanner:data errorCode:nil msg:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(responseLLHomeV5CategoryBanner:errorCode:msg:), responseLLHomeV5CategoryBanner:nil errorCode:resCode msg:message);
    }];
}

//首页数据 labelType:标签类型，1男神，2女神，3男神女神
- (void)requestHomeV5DataWithLabelType:(NSInteger)labelType
                           currentPage:(NSInteger)currentPage
                              pageSize:(NSInteger)pageSize {
    
    [HttpRequestHelper requestHomeV5DataWithLabelType:labelType currentPage:currentPage pageSize:pageSize success:^(NSArray<HomeV5Data *> *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5Data:errorCode:msg:), responseHomeV5Data:modelArray errorCode:nil msg:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5Data:errorCode:msg:), responseHomeV5Data:nil errorCode:resCode msg:message);
    }];
}

/**
 首页分类房间列表数据
 
 @param tabId tab主键
 @param currentPage 当前页
 @param pageSize 页面大小
 */
- (void)requestHomeV5CategoryRoomData:(NSString *)tabId
                          currentPage:(NSInteger)currentPage
                             pageSize:(NSInteger)pageSize {
    
    [HttpRequestHelper requestHomeV5CategoryRoomData:tabId currentPage:currentPage pageSize:pageSize success:^(NSArray<HomeV5CategoryRoom *> *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5CategoryRoomData:tabId:errorCode:msg:), responseHomeV5CategoryRoomData:modelArray tabId:tabId errorCode:nil msg:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5CategoryRoomData:tabId:errorCode:msg:), responseHomeV5CategoryRoomData:nil tabId:tabId errorCode:resCode msg:message);
    }];
}

/**
 首页分类banner数据
 
 @param tabId tab主键
 */
- (void)requestHomeV5CategoryBanner:(NSString *)tabId {
    [HttpRequestHelper requestHomeV5CategoryBanner:tabId success:^(NSArray<BannerInfo *> *modelArray) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5CategoryBanner:tabId:errorCode:msg:), responseHomeV5CategoryBanner:modelArray tabId:tabId errorCode:nil msg:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(HomeCoreClient, @selector(responseHomeV5CategoryBanner:tabId:errorCode:msg:), responseHomeV5CategoryBanner:nil tabId:tabId errorCode:resCode msg:message);
    }];
}

/// 领取人气票礼物
/// @param completion 完成回调
- (void)requestHomePopularTicketCompletion:(void(^)(PopularTicket *data, NSNumber *errorCode, NSString *msg))completion {
    
    [HttpRequestHelper requestHomePopularTicketWithSuccess:^(PopularTicket *model) {
        !completion ?: completion(model, nil, nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        !completion ?: completion(nil, resCode, message);
    }];
}

#pragma mark - RoomCoreClient
//收到怪兽相关广播
- (void)onReceiveAllBoardcast:(NSString *)content{
   
    NSInteger uid = [GetCore(AuthCore).getUid userIDValue];
    
    //保存现在的时间
    NSString * dateStr = [self dateStringWithDate:[NSDate date]];
    //和用户id 绑定
    NSString * key= [NSString stringWithFormat:@"%@%ld", Home_Rload, uid];
   NSString * oldDataStr = [CommonFileUtils readObjectFromUserDefaultWithKey:key];
    if (oldDataStr != nil && oldDataStr.length > 0) {
        NSInteger time  =[self checkDataWith:dateStr andOldDate:oldDataStr];
        NSLog(@"%ld", time);
        if (time >=5 ) {
            //刷新首页
            [CommonFileUtils writeObject:dateStr toUserDefaultWithKey:key];
            NotifyCoreClient(HomeCoreClient, @selector(reloadHomePageWhenReceviceBoardcast), reloadHomePageWhenReceviceBoardcast);
        }
    }else{
        //如果是第一次的话
        [CommonFileUtils writeObject:dateStr toUserDefaultWithKey:key];
        NotifyCoreClient(HomeCoreClient, @selector(reloadHomePageWhenReceviceBoardcast), reloadHomePageWhenReceviceBoardcast);
        
    }
}

- (void)dealloc
{
      NSInteger uid = [GetCore(AuthCore).getUid userIDValue];
    NSString * key= [NSString stringWithFormat:@"%@%ld", Home_Rload, uid];
    [CommonFileUtils readObjectFromUserDefaultWithKey:key];
}


- (NSInteger)checkDataWith:(NSString  *)currentStr andOldDate:(NSString *)oldStr
{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *currentData = [formatter dateFromString:currentStr];
    NSDate *oldDate = [formatter dateFromString:oldStr];
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitSecond;
    NSDateComponents * cmps = [calendar components:type fromDate:oldDate toDate:currentData options:0];
    return cmps.second;
}


- (NSString *)dateStringWithDate:(NSDate *)date
{
    if (date == nil) {
        return nil;
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}




- (UIColor *)getColorWithTagName:(NSString *)tagName {
    UIColor *color = self.tagNameColorDic[tagName];
    if (color) {
        return color;
    }else {
       return UIColorFromRGB(0x9A8DF0);
    }
}



- (NSDictionary *)tagNameColorDic {
    if (!_tagNameColorDic) {
        _tagNameColorDic = @{
                             @"相亲":UIColorFromRGB(0x9A8DF0),
                             @"娱乐":UIColorFromRGB(0x9A8DF0),
                             @"吃鸡":UIColorFromRGB(0xF8B52A),
                             @"游戏":UIColorFromRGB(0xF8B52A),
                             @"电台":UIColorFromRGB(0x58C05C),
                             @"连麦睡":UIColorFromRGB(0x58C05C),
                             @"陪玩":UIColorFromRGB(0xEF89AC),
                             @"处CP":UIColorFromRGB(0xEF89AC),
                             @"处cp":UIColorFromRGB(0xEF89AC),
                             @"王者":UIColorFromRGB(0x2AB0D1),
                             @"音乐":UIColorFromRGB(0x2AB0D1),
                             @"真心话":UIColorFromRGB(0x3ACFD3),
                             @"聊天":UIColorFromRGB(0x3ACFD3),
                             };
    }
    return _tagNameColorDic;
}



@end
