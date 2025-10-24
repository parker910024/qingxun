//
//  NTESSessionUtil.m
//  NIMDemo
//
//  Created by ght on 15-1-27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionUtil.h"
#import "NIMKit.h"
#import "NIMKitInfoFetchOption.h"
#import "NIMExtensionHelper.h"


static NSString *const NTESRecentSessionAtMark  = @"NTESRecentSessionAtMark";
static NSString *const NTESRecentSessionTopMark = @"NTESRecentSessionTopMark";


@implementation NTESSessionUtil


+ (void)addRecentSessionMark:(NIMSession *)session type:(NTESRecentSessionMarkType)type
{
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
    if (recent)
    {
        NSDictionary *localExt = recent.localExt?:@{};
        NSMutableDictionary *dict = [localExt mutableCopy];
        NSString *key = [NTESSessionUtil keyForMarkType:type];
        [dict setObject:@(YES) forKey:key];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:dict recentSession:recent];
    }


}

+ (void)removeRecentSessionMark:(NIMSession *)session type:(NTESRecentSessionMarkType)type
{
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
    if (recent) {
        NSMutableDictionary *localExt = [recent.localExt mutableCopy];
        NSString *key = [NTESSessionUtil keyForMarkType:type];
        [localExt removeObjectForKey:key];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recent];
    }
}

+ (BOOL)recentSessionIsMark:(NIMRecentSession *)recent type:(NTESRecentSessionMarkType)type
{
    NSDictionary *localExt = recent.localExt;
    NSString *key = [NTESSessionUtil keyForMarkType:type];
    return [localExt[key] boolValue] == YES;
}

+ (NSString *)keyForMarkType:(NTESRecentSessionMarkType)type
{
    static NSDictionary *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @{
                 @(NTESRecentSessionMarkTypeAt)  : NTESRecentSessionAtMark,
                 @(NTESRecentSessionMarkTypeTop) : NTESRecentSessionTopMark
                 };
    });
    return [keys objectForKey:@(type)];
}




-(void)TheThereEstablishmentUsThats{   
    UIImage *ThatsYearsDecidedTheNamedHonor = [UIImage new];
}
 
@end
