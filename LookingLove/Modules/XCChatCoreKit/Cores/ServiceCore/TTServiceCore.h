//
//  TTServiceCore.h
//  TTPlay
//
//  Created by fengshuo on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseCore.h"
//#import <XCThirdPartyFrameworks/QYSDK.h>


NS_ASSUME_NONNULL_BEGIN
@class UserInfo;
@interface TTServiceCore : BaseCore
//- (QYSessionViewController *)getQYSessionViewController;
/** 未读数*/
//- (NSInteger)getQYServiceUnreadCount;

/** 得到回话的最后一条*/
//- (QYSessionInfo *)getLastQYSessionInfo;

//设置用户的CRM
//- (void)setQYUserinforWith:(UserInfo *)info;

/**更新推送的deviceToken*/
- (void)updateDeviceTokenWith:(NSData *)deviceToken;

@end

NS_ASSUME_NONNULL_END
