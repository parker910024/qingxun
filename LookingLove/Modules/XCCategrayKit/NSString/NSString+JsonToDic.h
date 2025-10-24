//
//  NSString+JsonToDic.h
//  XChatFramework
//
//  Created by 卫明何 on 2017/9/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonToDic)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (id)idWithJsonString:(NSString *)str;
@end
