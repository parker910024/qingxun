//
//  UserID.h
//  YYFaceCore
//
//  Created by zhangji on 9/1/16.
//  Copyright © 2016 com.yy.face. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef long long UserID;

#define UserID_Unknown 0xFFFFFFFF

@interface NSNumber (UserID)

+ (instancetype)numberWithUserID:(UserID)userID;
- (UserID)userIDValue;

@end

@interface NSString (UserID)

- (UserID)userIDValue;

@end
