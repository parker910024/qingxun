//
//  TTPublicChatDataHelper.m
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatDataHelper.h"

#import "ImRoomExtMapKey.h"

//tool
#import <YYModel/NSObject+YYModel.h>

@implementation TTPublicChatDataHelper

+ (SingleNobleInfo *)disposeRoomExtToModel:(NSDictionary *)roomExt uid:(NSString *)uid {
    SingleNobleInfo *nobleInfo = [SingleNobleInfo yy_modelWithJSON:roomExt[uid]];
    return nobleInfo;
}
+ (LevelInfo *)disposeRoomExtToLevelModel:(NSDictionary *)roomExt uid:(NSString *)uid {
    LevelInfo *levelInfo = [LevelInfo yy_modelWithJSON:roomExt[uid]];
    return levelInfo;
}

+ (BOOL)disposeNewUserToLevelModel:(NSDictionary *)roomExt uid:(NSString *)uid {
    BOOL newUser = [UserInfo yy_modelWithJSON:roomExt[uid]].newUser;
    return newUser;
}

+ (AccountType)disposeAccountType:(NSDictionary *)roomExt uid:(NSString *)uid {
    AccountType accountType = [UserInfo yy_modelWithJSON:roomExt[uid]].defUser;
    return accountType;
}

+ (BOOL)disposeHasPrettyNo:(NSDictionary *)roomExt uid:(NSString *)uid {
    BOOL hasPrettyNo = [UserInfo yy_modelWithJSON:roomExt[uid]].hasPrettyErbanNo;
    return hasPrettyNo;
}

//获取官方主播认证信息
+ (UserOfficialAnchorCertification *)disposeOfficialAnchorCertification:(NSDictionary *)roomExt uid:(NSString *)uid {
    
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
