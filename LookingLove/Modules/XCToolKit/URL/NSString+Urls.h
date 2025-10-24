//
//  NSString+Urls.h
//  YYMobileFramework
//
//  Created by Jeanson on 2015/3/16.
//  Copyright (c) 2015年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Urls)

/**
 *  从String中寻找url段
 *
 *  @return NSTextCheckingResult
 */
- (NSArray*) matchUrls;

@end
