//
//  LittleWorldListModel.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LittleWorldListModel.h"

@implementation LittleWorldListModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    
    return @{@"records": LittleWorldListItem.class,
             };
}

@end

@implementation LittleWorldListItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"worldId": @"id",
             @"desc": @"description"
             };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    
    return @{@"members": LittleWorldListItemMember.class,@"currentMember":LittleWorldListItemMember.class,
             };
}

@end

@implementation LittleWorldListItemMember

@end
