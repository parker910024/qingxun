//
//  RecommendClient.h
//  XCChatCoreKit
//
//  Created by zoey on 2019/1/2.
//  Copyright © 2019年 KevinWang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RecommendModel.h"

@protocol RecommendClient<NSObject>

@optional

//我的推荐卡
- (void)onRecommendMyRecommendState:(RecommendState)status page:(int)page state:(int)state list:(NSArray<RecommendModel *>*)list;

- (void)onRecommendMyRecommendFailthState:(RecommendState)state page:(int)page;




@end



