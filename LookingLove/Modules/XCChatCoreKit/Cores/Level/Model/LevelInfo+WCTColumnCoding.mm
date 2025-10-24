//
//  LevelInfo+WCTColumnCoding.mm
//  BberryCore
//
//  Created by 卫明何 on 2018/1/29.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "LevelInfo.h"
#import <Foundation/Foundation.h>
#import "WCDBObjc.h"

@interface LevelInfo (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation LevelInfo (WCTColumnCoding)

+ (instancetype)unarchiveWithWCTValue:(NSData *)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

- (NSData *)archivedWCTValue
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}

+ (WCTColumnType)columnTypeForWCDB
{
    return WCTColumnTypeData;
}

@end
