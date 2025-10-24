//
//  TTServiceCoreClient.h
//  TTPlay
//
//  Created by fengshuo on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <XCThirdPartyFrameworks/QYSDK.h>
NS_ASSUME_NONNULL_BEGIN

@protocol TTServiceCoreClient <NSObject>
@optional
//- (void)onReceiveQYMessage:(QYMessageInfo *)message;

- (void)onQYUnreadCountChanged:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
