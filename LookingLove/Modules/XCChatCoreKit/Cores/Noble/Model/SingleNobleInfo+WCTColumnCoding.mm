//
//  SingleNobleInfo+WCTColumnCoding.mm
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "SingleNobleInfo.h"
#import <Foundation/Foundation.h>
#import "WCDBObjc.h"
#import "NobleSourceTool.h"
#import <NSObject+YYModel.h>

@interface SingleNobleInfo (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation SingleNobleInfo (WCTColumnCoding)

+ (instancetype)unarchiveWithWCTValue:(NSData *)value
{
    NSMutableDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:value];
    SingleNobleInfo *result = [SingleNobleInfo yy_modelWithJSON:info];
    return result;
}

- (NSData *)archivedWCTValue
{
    NSMutableDictionary *nobleInfo = [NobleSourceTool sortStringWithNobleInfo:self];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:nobleInfo];
    
    return data;
}

+ (WCTColumnType)columnTypeForWCDB
{
    return WCTColumnTypeData;
}

@end
