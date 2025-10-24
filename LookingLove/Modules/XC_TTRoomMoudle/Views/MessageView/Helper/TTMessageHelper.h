//
//  TTMessageHelper.h
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NobleCore.h"
#import "UserCore.h"

@interface TTMessageHelper : NSObject

+ (NSMutableDictionary *)handleWholeMicroRoomExtBy:(NSString *)roomExt;
+ (SingleNobleInfo *)handleRoomExtToModel:(NSDictionary *)roomExt uid:(NSString *)uid;
+ (LevelInfo *)handleRoomExtToLevelModel:(NSDictionary *)roomExt uid:(NSString *)uid;

+ (SingleNobleInfo *)handleRoomExtStrToModel:(NSString *)roomExt uid:(NSString *)uid;
+ (LevelInfo *)handleRoomExtStrToLevelModel:(NSString *)roomExt uid:(NSString *)uid;
+ (NSString *)handleRoomExtStrToCarModel:(NSString *)roomExt uid:(NSString *)uid;
+ (BOOL)handelNewUserToLevelModel:(NSDictionary *)roomExt uid:(NSString *)uid;
+ (BOOL)handleRoomExtStrToNewUser:(NSString *)roomExt uid:(NSString *)uid;

//获取官方主播认证信息
+ (UserOfficialAnchorCertification *)handleOfficialAnchorCertification:(NSDictionary *)roomExt uid:(NSString *)uid;

@end
