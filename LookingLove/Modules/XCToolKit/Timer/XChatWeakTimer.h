//
//  XChatWeakTimer.h
//  XChatFramework
//
//  Created by Mac on 2017/12/30.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XCWeakTimerHandler) (id userInfo);


@interface XCWeakTimerTarget : NSObject

@end

@interface XChatWeakTimer : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(XCWeakTimerHandler)block userInfo:(id)userInfo repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;
@end
