//
//  UserID.m
//  YYFaceCore
//
//  Created by zhangji on 9/1/16.
//  Copyright © 2016 com.yy.face. All rights reserved.
//

#import "UserID.h"

@implementation NSNumber (UserID)

+ (instancetype)numberWithUserID:(UserID)userID
{
    return [NSNumber numberWithLongLong:userID];
}

- (UserID)userIDValue
{
    return self.longLongValue;
}

@end

@implementation NSString (UserID)

- (UserID)userIDValue
{
    return [self longLongValue];
}

@end
