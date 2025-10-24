//
//  UserCar+WCTColumnCoding.mm
//  BberryCore
//
//  Created by 卫明何 on 2018/2/27.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "UserCar.h"
#import <Foundation/Foundation.h>
#import "WCDBObjc.h"

@interface UserCar (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation UserCar (WCTColumnCoding)

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
