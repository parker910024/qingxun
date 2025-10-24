//
//  UserHeadWear+WCTColumnCoding.m
//  BberryCore
//
//  Created by Macx on 2018/5/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "UserHeadWear.h"
#import <Foundation/Foundation.h>
#import "WCDBObjc.h"

@interface UserHeadWear (WCTColumnCoding) <WCTColumnCoding>
@end


@implementation UserHeadWear (WCTColumnCoding)

+ (instancetype)unarchiveWithWCTValue:(NSData *)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

- (NSData *)archivedWCTValue
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (WCTColumnType)columnTypeForWCDB
{
    return WCTColumnTypeData;
}
@end
