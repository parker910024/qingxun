//
//  RecommendModel.m
//  XCChatCoreKit
//
//  Created by zoey on 2019/1/2.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "RecommendModel.h"
#import "NSDate+TimeCategory.h"

@implementation RecommendModel
//后端返回时间戳 是毫秒级别

- (NSString *)getValidStartTime {
    NSString *startTime = [NSDate dateStrFromCstampTime:_validStartTime.longLongValue/1000 withDateFormat:@"yyyy.MM.dd"];
    return startTime;
}

- (NSString *)getValidEndTime {
    NSString *endTime = [NSDate dateStrFromCstampTime:_validEndTime.longLongValue/1000 withDateFormat:@"yyyy.MM.dd"];
    return endTime;
}

- (NSString *)getUseStartTime {
    NSString *startTime = [NSDate dateStrFromCstampTime:_useStartTime.longLongValue/1000 withDateFormat:@"yyyy.MM.dd HH:mm"];
    return startTime;
}

- (NSString *)getUseEndTime {
    NSString *endTime = [NSDate dateStrFromCstampTime:_useEndTime.longLongValue/1000 withDateFormat:@"yyyy.MM.dd HH:mm"];
    return endTime;
}


@end
