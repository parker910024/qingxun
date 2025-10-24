//
//  AppleAccountInfo.m
//  XCChatCoreKit
//
//  Created by Lee on 2019/12/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "AppleAccountInfo.h"

@implementation FullName


@end

@implementation AppleAccountInfo
- (NSString *)appleFullName {
    return [NSString stringWithFormat:@"%@%@", self.fullName.familyName, self.fullName.givenName];
}

@end
