//
//  CertificationModel+WCTColumnCoding.m
//  XCChatCoreKit
//
//  Created by new on 2019/3/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "CertificationModel.h"
#import <Foundation/Foundation.h>
#import "WCDBObjc.h"

@interface CertificationModel (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation CertificationModel (WCTColumnCoding)

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
