//
//  UserGiftAchievementList.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/2/24.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "UserGiftAchievementList.h"

@implementation UserGiftAchievementList

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    
    return @{@"giftList": UserGiftAchievementItem.class,
             };
}

@end

@implementation UserGiftAchievementItem

@end
