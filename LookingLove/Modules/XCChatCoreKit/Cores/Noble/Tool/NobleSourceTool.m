//
//  NobleSourceTool.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "NobleSourceTool.h"
#import "UIColor+UIColor_Hex.h"
#import "NSMutableDictionary+Safe.h"
#import <objc/runtime.h>

@implementation NobleSourceTool

+ (id)sortStringWithid:(id)sourceStr {
    if (![sourceStr isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *str = sourceStr;
    if (str.length<=4) {
        return nil;
    }
    if ([[str substringToIndex:4] containsString:@"http"]) {
        return [NSURL URLWithString:str];
    }else if ([[str substringToIndex:1] containsString:@"#"]) {
        return [UIColor colorWithHexString:sourceStr];
    }
    else {
        return [NSString stringWithFormat:@"%@",sourceStr];
    }
    return str;
}

+ (NSMutableDictionary *)sortStringWithNobleInfo:(SingleNobleInfo *)info {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    u_int count = 0;
    objc_property_t *properties = class_copyPropertyList([info class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        if (![propertyName isEqualToString:@"encodeAttachemt"]) {
            id propertyValue = [info valueForKey:(NSString *)propertyName];
            if ([propertyValue isKindOfClass:[UIColor class]]) {
                propertyValue = [UIColor hexStringFromColor:propertyValue];
                //            [info setValue:propertyValue forKey:(NSString *)propertyName];
            }
            [tempDic safeSetObject:propertyValue forKey:propertyName];
        }
        
//        [tempDic setObject:propertyValue forKey:propertyName];
        
    }
    free(properties);
    return tempDic;
}



@end
