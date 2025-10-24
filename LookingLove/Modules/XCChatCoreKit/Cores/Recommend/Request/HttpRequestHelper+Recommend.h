//
//  HttpRequestHelper+Recommend.h
//  XCChatCoreKit
//
//  Created by zoey on 2019/1/2.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "RecommendModel.h"


@interface HttpRequestHelper (Recommend)
//我的推荐位
+ (void)requestMyRecommendCardStatus:(RecommendState)status page:(int)page success:(void (^)(NSArray<RecommendModel *> *))success  failure:(void (^)(NSNumber *, NSString *))failure;

/**
 申请推荐
 时间格式 yyyy-mm-dd
**/
+ (void)requestRecommendUsebyCardvalidStartTime:(NSString *)validStartTime validEndTime:(NSString *)validEndTime useStartTime:(NSString*)useStartTime  success:(void (^)(BOOL))success  failure:(void (^)(NSNumber *, NSString *))failure;

//获取指定时间点的推荐位可用数  时间格式
+ (void)requestRecommendCanUsebyTime:(NSString*)time  success:(void (^)(NSNumber *))success  failure:(void (^)(NSNumber *, NSString *))failure;

@end
