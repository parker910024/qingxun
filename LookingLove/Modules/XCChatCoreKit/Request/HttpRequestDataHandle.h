//
//  HttpRequestDataHandle.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/1/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestDataHandle : NSObject

+ (instancetype)defaultHandle;

- (void)handleRequestSuccessData:(NSString *)method response:(id)responseObject;

- (void)handleRequestFailData:(NSString *)method errorInfo:(ErrorInfo *)errorInfo;
@end

NS_ASSUME_NONNULL_END
