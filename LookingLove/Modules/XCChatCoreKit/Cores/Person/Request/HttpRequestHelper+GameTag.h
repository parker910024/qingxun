//
//  HttpRequestHelper+GameTag.h
//  XCChatCoreKit
//
//  Created by new on 2019/3/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (GameTag)

/**
 个人资料101标签 使用或者删除
 
 @param liveId 主键id--个人资料页获取
 @param status 操作 1-删除|2-使用
 
 @return 结果
 */

+ (void)personPageGameTagDeleteOrUserWithLiveId:(NSInteger )liveId WithStatus:(NSInteger )status
                                 success:(void (^)(BOOL success))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end

NS_ASSUME_NONNULL_END
