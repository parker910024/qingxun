//
//  TTPublicChatDataHelper.h
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//core
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicChatDataHelper : NSObject

+ (LevelInfo *)disposeRoomExtToLevelModel:(NSDictionary *)roomExt uid:(NSString *)uid;

+ (SingleNobleInfo *)disposeRoomExtToModel:(NSDictionary *)roomExt uid:(NSString *)uid;

+ (BOOL)disposeNewUserToLevelModel:(NSDictionary *)roomExt uid:(NSString *)uid;

+ (AccountType)disposeAccountType:(NSDictionary *)roomExt uid:(NSString *)uid;

+ (BOOL)disposeHasPrettyNo:(NSDictionary *)roomExt uid:(NSString *)uid;

//获取官方主播认证信息
+ (UserOfficialAnchorCertification *)disposeOfficialAnchorCertification:(NSDictionary *)roomExt uid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
