//
//  CommunityMusicInfo.m
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "CommunityMusicInfo.h"

@implementation CommunityMusicCatalog

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

@end

@implementation CommunityMusicInfo

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

@end

@implementation CommunityMusicData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"musicList" : CommunityMusicInfo.class
             };
}

@end
