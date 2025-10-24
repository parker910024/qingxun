//
//  HttpRequestHelper+Discovery.h
//  BberryCore
//
//  Created by Macx on 2018/3/5.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "DiscoverGiftRankModel.h"
#import "UserInfo.h"
#import "DiscoverListModel.h"
typedef void(^HttpResponseHelperDiscoverCompletionHandler)(id _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg);

@interface HttpRequestHelper (Discovery)


//======================new home ui=================================
/**
 请求发现页面广告列表
 */
+ (void)requestDisCoveryAdListWithUid:(NSString *_Nullable)uid
                              success:(void (^_Nullable)(NSArray * _Nullable list))success
                              failure:(void (^_Nullable)(NSNumber * _Nullable resCode, NSString *message))failure;


/**
 哈哈 发现页 礼物周星榜

 @param success 成功
 @param failure 失败
 */
+ (void)requstLastWeekGiftListsuccess:(void (^_Nullable)(NSArray<DiscoverGiftRankModel *> * _Nullable list))success
                              failure:(void (^_Nullable)(NSNumber * _Nullable resCode, NSString * _Nullable message))failure;


/**
 发现页的类型

 @param success 成功
 @param failure 失败
 */
+ (void)requestDiscoverTypeListSuccess:(void (^_Nullable)(NSArray<DiscoverListModel *> * _Nullable list))success
                               failure:(void (^_Nullable)(NSNumber * _Nullable resCode, NSString * _Nullable message))failure;

/**
 新秀玩友

 @param page 当前页数
 @param pageSize 一页的数量
 @param gender 性别，1-男性，2-女性，0-全部（不传时也查询所有)
 @param success 成功
 @param failure 失败
 */
+ (void)requestNewUserListWith:(int)page
                      pageSize:(int)pageSize
                        gender:(int)gender
                       success:(void (^_Nullable)(NSArray<UserInfo *> * _Nullable list))success
                       failure:(void (^_Nullable)(NSNumber * _Nullable resCode, NSString * _Nullable message))failure;

#pragma mark -
#pragma mark 2019-03-29  公会线添加
/**
 获取发现页信息 v2
 interface discovery/v2/get
 */
+ (void)requestDiscoverV2InfoAndCompletionHandler:(HttpResponseHelperDiscoverCompletionHandler)completionHandler;
@end
