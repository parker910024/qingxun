//
//  CommunityCommentInfo.m
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "CommunityCommentInfo.h"
#import "NSString+Utils.h"
#import "XCMacros.h"

@implementation CommunityCommentInfo

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"replies" : CommunityCommentInfo.class
             };
}

- (NSMutableArray *)repliyComments{
    if (!_repliyComments) {
        _repliyComments = [NSMutableArray array];
    }
    return _repliyComments;
}

@end


@implementation CommunityPublishCommentInfo

@end
