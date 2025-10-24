//
//  RecommendCore.h
//  XCChatCoreKit
//
//  Created by zoey on 2019/1/2.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "BaseCore.h"
#import "HttpRequestHelper+Recommend.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RecommendCore : BaseCore

//获取我的推荐卡
- (void)getMyRecommendCarState:(RecommendState)status page:(int)page state:(int)state;
//该时间段可用推荐位个数
- (RACSignal *)getRecommendCanUseByTime:(NSString *)time;
//使用推荐位卡
- (RACSignal *)useRecommendByRecommendCard:(RecommendModel *)model useTime:(NSString *)useTime;

@end
