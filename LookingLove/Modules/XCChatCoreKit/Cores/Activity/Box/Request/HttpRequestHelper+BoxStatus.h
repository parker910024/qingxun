//
//  HttpRequestHelper+BoxStatus.h
//  XCChatCoreKit
//
//  Created by JarvisZeng on 2019/5/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "BoxStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (BoxStatus)
/*
 获取钻石宝箱活动状态
 */
+ (void)requestDiamondBoxActivityStatus:(void (^)(BoxStatus *status))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end

NS_ASSUME_NONNULL_END
