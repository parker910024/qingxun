//
//  TTMessageHelper.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageHelper.h"
#import "NobleCore.h"
#import "UserCore.h"
#import "NSDictionary+JSON.h"
#import "NSString+JsonToDic.h"
#import "UserCar.h"
#import "ImRoomExtMapKey.h"

@implementation TTMessageHelper

+ (NSMutableDictionary *)handleWholeMicroRoomExtBy:(NSString *)roomExt {
    NSDictionary *ext = [NSDictionary yy_modelDictionaryWithClass:[SingleNobleInfo class] json:roomExt];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *item in ext.allKeys) {
        SingleNobleInfo *nobleInfo = [ext objectForKey:item];
        [tempDic setObject:nobleInfo forKey:item];
    }
    return tempDic;
}

+ (SingleNobleInfo *)handleRoomExtToModel:(NSDictionary *)roomExt uid:(NSString *)uid {
    SingleNobleInfo *nobleInfo = [SingleNobleInfo yy_modelWithJSON:roomExt[uid]];
    return nobleInfo;
}
+ (LevelInfo *)handleRoomExtToLevelModel:(NSDictionary *)roomExt uid:(NSString *)uid {
    LevelInfo *levelInfo = [LevelInfo yy_modelWithJSON:roomExt[uid]];
    return levelInfo;
}

+ (BOOL)handelNewUserToLevelModel:(NSDictionary *)roomExt uid:(NSString *)uid {
    //    BOOL newUser = [roomExt[uid] boolValue];
    BOOL newUser = [UserInfo yy_modelWithJSON:roomExt[uid]].newUser;
    return newUser;
}


+ (SingleNobleInfo *)handleRoomExtStrToModel:(NSString *)roomExt uid:(NSString *)uid {
    NSDictionary * tempInfo = [NSString dictionaryWithJsonString:roomExt];
    SingleNobleInfo *nobleInfo = [SingleNobleInfo yy_modelWithJSON:tempInfo[uid]];
    return nobleInfo;
}
+ (LevelInfo *)handleRoomExtStrToLevelModel:(NSString *)roomExt uid:(NSString *)uid {
    NSDictionary * tempInfo = [NSString dictionaryWithJsonString:roomExt];
    LevelInfo *levelInfo = [LevelInfo yy_modelWithJSON:tempInfo[uid]];
    return levelInfo;
}
+ (NSString *)handleRoomExtStrToCarModel:(NSString *)roomExt uid:(NSString *)uid {
    NSDictionary * tempInfo = [NSString dictionaryWithJsonString:roomExt];
    NSString *carInfo = tempInfo[uid][@"carName"];
    return carInfo;
}

+ (BOOL)handleRoomExtStrToNewUser:(NSString *)roomExt uid:(NSString *)uid {
    NSDictionary * tempInfo = [NSString dictionaryWithJsonString:roomExt];
    UserInfo *userInfo = [UserInfo yy_modelWithJSON:tempInfo[uid]];
    return userInfo.newUser;
}

//获取官方主播认证信息
+ (UserOfficialAnchorCertification *)handleOfficialAnchorCertification:(NSDictionary *)roomExt uid:(NSString *)uid {
    
    NSString *name = [roomExt[uid] objectForKey:ImRoomExtKeyOfficialAnchorCertificationName];
    NSString *icon = [roomExt[uid] objectForKey:ImRoomExtKeyOfficialAnchorCertificationIcon];
    if (name == nil || icon == nil) {
        return nil;
    }
    
    UserOfficialAnchorCertification *cert = [[UserOfficialAnchorCertification alloc] init];
    cert.fixedWord = name;
    cert.iconPic = icon;
    return cert;
}

@end
