//
//  HttpRequestHelper+MessageCore.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (MessageCore)

/**
 获取互动消息列表
 */
+ (void)requestMessageDynamicListWithId:(NSString *)dynamicId pageSize:(NSInteger)pageSize completion:(HttpRequestHelperCompletion)completion;

@end

NS_ASSUME_NONNULL_END
