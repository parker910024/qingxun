//
//  NSArray+WCTColumnCoding.mm
//  BberryCore
//
//  Created by 卫明何 on 2017/11/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDBObjc.h"

@interface NSArray (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation NSArray (WCTColumnCoding)

+ (instancetype)unarchiveWithWCTValue:(NSData *)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

- (NSData *)archivedWCTValue
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

//+ (WCTColumnType)columnTypeForWCDB
//{
//    return WCTColumnTypeBinary;
//}

+ (WCTColumnType)columnTypeForWCDB
{
    //@xiaoxiao WCTColumnTypeBinary
    return WCTColumnTypeData;
}

@end
