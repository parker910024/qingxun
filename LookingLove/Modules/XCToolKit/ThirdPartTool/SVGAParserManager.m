//
//  SVGAParserManager.m
//  XChat
//
//  Created by 卫明何 on 2018/4/11.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "SVGAParserManager.h"
#import "YYUtility.h"
#import "XCMacros.h"
#import "GCDHelper.h"

static NSInteger retryCount = 3;

@interface SVGAParserManager ()

@property (nonatomic,strong) NSMutableDictionary *parserQueue;
@property (nonatomic,strong) NSMutableDictionary *retryCache;
@property (nonatomic,strong) SVGAParser *parser;

@end

@implementation SVGAParserManager

- (void)loadSvgaWithURL:(NSURL *)url
        completionBlock:(void (^)(SVGAVideoEntity * _Nullable))completionBlock
           failureBlock:(void (^)(NSError * _Nullable))failureBlock {
    if (!url) {
        return;
    }
    @KWeakify(self);
    NSString *key = [self cacheURL:url];
    [self.parser parseWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        dispatch_main_sync_safe(^{
            if (videoItem) {
                completionBlock(videoItem);
                [self removeCacheWithKey:key];
                [self.retryCache removeObjectForKey:key];
            }
        });
    } failureBlock:^(NSError * _Nullable error) {
        @KStrongify(self);
//        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:SVGA_LoadState,@"url":[url absoluteString]?[url absoluteString]:@"nil"} error:error topic:BussinessLog logLevel:XCLogLevelError];
        if (error) {
            if (![self.retryCache objectForKey:key]) {
                [self.retryCache setObject:@(0) forKey:key];
            }
            [self.retryCache setObject:@([[self.retryCache objectForKey:key] integerValue] + 1) forKey:key];
            if ([[self.retryCache objectForKey:key] integerValue] < retryCount) {
                [self retryWithKey:key completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                    completionBlock(videoItem);
                } failureBlock:^(NSError * _Nullable error) {
                    failureBlock(error);
                }];
            }
        }
    }];
    
}

- (void)retryWithKey:(NSString *)key
     completionBlock:(void (^)(SVGAVideoEntity * _Nullable))completionBlock
        failureBlock:(void (^)(NSError * _Nullable))failureBlock  {
    if (key) {
        NSURL *url = [self.parserQueue objectForKey:key];
        [self loadSvgaWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            completionBlock(videoItem);
        } failureBlock:^(NSError * _Nullable error) {
//            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:SVGA_LoadState,@"url":[url absoluteString]?[url absoluteString]:@"nil"} error:error topic:BussinessLog logLevel:XCLogLevelError];
        }];
    }
}


- (NSString *)cacheURL:(NSURL *)url {
    NSString *key = [self getUUid];
    [self.parserQueue setObject:url forKey:key];
    return key;
}

- (void)removeCacheWithKey:(NSString *)key {
    [self.parserQueue removeObjectForKey:key];
}

- (NSString *)getUUid {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

#pragma mark - Getter

- (SVGAParser *)parser {
    if (_parser == nil) {
        _parser = [[SVGAParser alloc]init];
    }
    return _parser;
}

- (NSMutableDictionary *)parserQueue {
    if (_parserQueue == nil) {
        _parserQueue = [NSMutableDictionary dictionary];
    }
    return _parserQueue;
}

- (NSMutableDictionary *)retryCache {
    if (_retryCache == nil) {
        _retryCache = [NSMutableDictionary dictionary];
    }
    return _retryCache;
}

@end
