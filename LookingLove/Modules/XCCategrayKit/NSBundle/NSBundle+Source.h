//
//  NSBundle+Source.h
//  XC_HaHaSourceMoudle
//
//  Created by Macx on 2018/9/7.
//  Copyright © 2018年 卫明何. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Source)

+ (NSString *)xc_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)xc_localizedStringForKey:(NSString *)key;

@end
