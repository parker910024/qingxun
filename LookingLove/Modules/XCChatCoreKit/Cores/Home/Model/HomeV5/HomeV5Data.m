//
//  HomeV5Data.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HomeV5Data.h"

@implementation HomeV5Data

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"nobleUsers": SingleNobleInfo.class,
             @"userLevelVo": LevelInfo.class,
             @"roomVo": HomeV5RoomData.class,
             @"userInfoSkillVo": CertificationModel.class
             };
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}

@end

@implementation HomeV5RoomData

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}

@end
