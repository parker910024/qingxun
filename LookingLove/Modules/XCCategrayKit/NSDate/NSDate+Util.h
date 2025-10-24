//
//  NSDate+Util.h
//  XChat
//
//  Created by chenran on 2017/5/22.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)
+ (NSInteger) getMonth:(long )time;
+ (NSInteger) getDay:(long) time;
+(NSString *)calculateConstellationWithMonth:(long)time;
@end
