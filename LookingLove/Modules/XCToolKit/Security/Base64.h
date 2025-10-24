//
//  Base64.h
//  XChatFramework
//
//  Created by chenran on 2017/5/4.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

+(NSString *)encode:(NSData *)data;
+(NSData *)decode:(NSString *)dataString;

@end
