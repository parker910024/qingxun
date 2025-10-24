//
//  NSURLSession+proxy.m
//  XCCategrayKit
//
//  Created by 卫明 on 2019/3/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "NSURLSession+proxy.h"
#import "objc/runtime.h"

@implementation NSURLSession (proxy)


+ (void)load {
#ifdef DEBUG
#else
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method method1 = class_getClassMethod([NSURLSession class],@selector(sessionWithConfiguration:));
        
        Method method2 = class_getClassMethod([NSURLSession class],@selector(hm_sessionWithConfiguration:));
        
        method_exchangeImplementations(method1, method2);

        Method method3 = class_getClassMethod([NSURLSession class],@selector(sessionWithConfiguration:delegate:delegateQueue:));
        
        Method method4 = class_getClassMethod([NSURLSession class],@selector(hm_sessionWithConfiguration:delegate:delegateQueue:));
        
        method_exchangeImplementations(method3, method4);
        
    });
#endif
}

+ (NSURLSession*)hm_sessionWithConfiguration:(NSURLSessionConfiguration*)configuration delegate:(nullable id)delegate delegateQueue:(nullable NSOperationQueue*)queue {
    
    if(configuration) configuration.connectionProxyDictionary = @{};
    return [self hm_sessionWithConfiguration:configuration delegate:delegate delegateQueue:queue];
}


+ (NSURLSession*)hm_sessionWithConfiguration:(NSURLSessionConfiguration*)configuration {
    
    if(configuration) configuration.connectionProxyDictionary = @{};
    return [self hm_sessionWithConfiguration:configuration];
    
}


@end
