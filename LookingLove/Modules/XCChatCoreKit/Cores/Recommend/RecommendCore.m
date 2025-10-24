//
//  RecommendCore.m
//  XCChatCoreKit
//
//  Created by zoey on 2019/1/2.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "RecommendCore.h"
#import "HttpRequestHelper+Recommend.h"
#import "RecommendClient.h"

@implementation RecommendCore

//获取我的推荐卡
- (void)getMyRecommendCarState:(RecommendState)status page:(int)page state:(int)state{
    [HttpRequestHelper requestMyRecommendCardStatus:status page:(int)page success:^(NSArray<RecommendModel *> *list) {

        NotifyCoreClient(RecommendClient, @selector(onRecommendMyRecommendState:page:state:list:), onRecommendMyRecommendState:status page:page state:state list:list);
    } failure:^(NSNumber *ecode, NSString *msg) {
        NotifyCoreClient(RecommendClient, @selector(onRecommendMyRecommendFailthState:page:), onRecommendMyRecommendFailthState:status page:page);
    }];
}


- (RACSignal *)getRecommendCanUseByTime:(NSString *)time {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [HttpRequestHelper requestRecommendCanUsebyTime:time success:^(NSNumber *canUsenumber) {
                    [subscriber sendNext:canUsenumber];
                    [subscriber sendCompleted];
                } failure:^(NSNumber *errorCode, NSString *msg) {
                    [subscriber sendError:[NSError errorWithDomain:msg code:errorCode.intValue userInfo:nil]];
                }];
                return nil;
            }];
}

//使用推荐位卡
- (RACSignal *)useRecommendByRecommendCard:(RecommendModel *)model useTime:(NSString *)useTime {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestRecommendUsebyCardvalidStartTime:model.validStartTime validEndTime:model.validEndTime useStartTime:useTime success:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        } failure:^(NSNumber *errorCode, NSString *msg) {
            [subscriber sendError:[NSError errorWithDomain:msg code:errorCode.intValue userInfo:nil]];
        }];
        return nil;
    }];
}



@end
