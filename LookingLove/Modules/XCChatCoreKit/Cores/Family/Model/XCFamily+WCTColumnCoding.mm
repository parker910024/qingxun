//
//  XCFamily+WCTColumnCoding.mm
//  BberryCore
//
//  Created by 卫明何 on 2018/5/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCFamily.h"
#import <Foundation/Foundation.h>
#import "WCDBObjc.h"

@interface XCFamily (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation XCFamily (WCTColumnCoding)

+ (instancetype)unarchiveWithWCTValue:(NSData *)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];;
}

- (NSData *)archivedWCTValue
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (WCTColumnType)columnTypeForWCDB
{
    //@xiaoxiao WCTColumnTypeBinary
    return WCTColumnTypeData;
}

@end
