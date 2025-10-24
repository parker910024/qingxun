//
//  SpriteSheetImageManager.m
//  XChat
//
//  Created by Macx on 2018/5/11.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "SpriteSheetImageManager.h"

#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "XCMacros.h"

#import "GCDHelper.h"
#import "YYUtility.h"

static NSInteger retryCount = 3;
static CGFloat kdeafultFrameDurations = 0.2;

@interface SpriteSheetImageManager()
@property (nonatomic,strong) YYSpriteSheetImage *sprite;
@property (nonatomic,strong) NSMutableDictionary *parserQueue;
@property (nonatomic,strong) NSMutableDictionary *retryCache;
@property (nonatomic, strong) UIImageView  *operationImageView;//
@end

@implementation SpriteSheetImageManager
- (void)loadSpriteSheetImageWithURL:(NSURL *_Nullable)url
                    completionBlock:(void ( ^ _Nonnull )(YYSpriteSheetImage * _Nullable sprit))completionBlock
                       failureBlock:(void ( ^ _Nullable)(NSError * _Nullable error))failureBlock {
    [self loadBaseSpriteSheetImageURL:url frameDurations:kdeafultFrameDurations completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
        if(completionBlock){
            completionBlock(sprit);
        }
    } failureBlock:^(NSError * _Nullable error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}




- (void)retryWithKey:(NSString *)key
     completionBlock:(void (^)(YYSpriteSheetImage * _Nullable))completionBlock
        failureBlock:(void (^)(NSError * _Nullable))failureBlock  {
    if (key) {
        NSURL *url = [self.parserQueue objectForKey:key];
        [self loadSpriteSheetImageWithURL:url completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
            completionBlock(sprit);
        } failureBlock:^(NSError * _Nullable error) {
//            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:SVGA_LoadState,@"url":[url absoluteString]?[url absoluteString]:@"nil"} error:error topic:BussinessLog logLevel:XCLogLevelError];
        }];
    }
}

/**
 * 这里与UI 协定 一张横向长图 每个帧 都是通过高度 来获取 正方形
 **/

+ (YYSpriteSheetImage *)createBaseSpriteSheet:(UIImage *)image {
    return [self createSpriteSheet:image frameDurations:kdeafultFrameDurations];
}

+ (YYSpriteSheetImage *_Nullable)createSpriteSheet:(UIImage *_Nullable)image frameDurations:(CGFloat)frameDurations recetWidth:(CGFloat)width recetHeight:(CGFloat)height spriteCount:(NSInteger)spriteCount {
    
    NSMutableArray *contentRects = [NSMutableArray new];
    NSMutableArray *durations = [NSMutableArray new];
    
    CGFloat xMargin = (image.size.width - width * spriteCount)/spriteCount;
    CGFloat yMargin = (image.size.height - height)/2.0f;
    
    CGFloat oneDuration = frameDurations / spriteCount;
    
    CGFloat left = xMargin;
    
    for (int i = 0; i < spriteCount; i++) {
        CGRect rect;
        rect.size = CGSizeMake(width, height);
        rect.origin.x = left;
        rect.origin.y = yMargin;
        left += width + xMargin;
        [contentRects addObject:[NSValue valueWithCGRect:rect]];
        if (!frameDurations) {
            frameDurations = kdeafultFrameDurations;
        }
        [durations addObject:@(oneDuration)];
    }
    YYSpriteSheetImage *sheetImage = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:image contentRects:contentRects frameDurations:durations loopCount:0];
    return sheetImage;
}




- (void)loadSpriteSheetImageWithURL:(NSURL *_Nullable)url
                     frameDurations:(CGFloat)frameDurations
                    completionBlock:(void ( ^ _Nonnull )(YYSpriteSheetImage * _Nullable sprit))completionBlock
                       failureBlock:(void ( ^ _Nullable)(NSError * _Nullable error))failureBlock {
    [self loadBaseSpriteSheetImageURL:url frameDurations:frameDurations completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
        if(completionBlock){
            completionBlock(sprit);
        }
    } failureBlock:^(NSError * _Nullable error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


/**
 * 这里与UI 协定 一张横向长图 每个帧 都是通过高度 来获取 正方形
 * frameDurations 帧长
 **/

+ (YYSpriteSheetImage *_Nullable)createSpriteSheet:(UIImage *_Nullable)image frameDurations:(CGFloat)frameDurations {
    NSMutableArray *contentRects = [NSMutableArray new];
    NSMutableArray *durations = [NSMutableArray new];
    
    CGFloat imageHeight = image.size.height;
    NSInteger spriteCount =  image.size.width/imageHeight;
    
    for (int i = 0; i < spriteCount; i++) {
        CGRect rect;
        rect.size = CGSizeMake(imageHeight, imageHeight);
        rect.origin.x = imageHeight * i;
        rect.origin.y = 0;
        [contentRects addObject:[NSValue valueWithCGRect:rect]];
        if (!frameDurations) {
            frameDurations = kdeafultFrameDurations;
        }
        [durations addObject:@(frameDurations)];
    }
    YYSpriteSheetImage *sheetImage = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:image contentRects:contentRects frameDurations:durations loopCount:0];
    return sheetImage;
}



#pragma private

- (void)loadBaseSpriteSheetImageURL:(NSURL *_Nullable)url
                     frameDurations:(CGFloat)frameDurations
                    completionBlock:(void ( ^ _Nonnull )(YYSpriteSheetImage * _Nullable sprit))completionBlock
                       failureBlock:(void ( ^ _Nullable)(NSError * _Nullable error))failureBlock{
    
    if (!url) {
        return;
    }
    @KWeakify(self);
    NSString *key = [self cacheURL:url];
    
    [self.operationImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @KStrongify(self);
        if (error) {
            //            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:SVGA_LoadState,@"url":[url absoluteString]?[url absoluteString]:@"nil"} error:error topic:BussinessLog logLevel:XCLogLevelError];
            if (error) {
                if (![self.retryCache objectForKey:key]) {
                    [self.retryCache setObject:@(0) forKey:key];
                }
                [self.retryCache setObject:@([[self.retryCache objectForKey:key] integerValue] + 1) forKey:key];
                if ([[self.retryCache objectForKey:key] integerValue] < retryCount) {
                    [self retryWithKey:key completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
                        completionBlock(sprit);
                        
                    } failureBlock:^(NSError * _Nullable error) {
                        failureBlock(error);
                        
                    }];
                }
            }
            return ;
        }
        
        YYSpriteSheetImage *sheetImage = [SpriteSheetImageManager createSpriteSheet:image frameDurations:frameDurations];
        
        dispatch_main_sync_safe(^{
            if (sheetImage) {
                completionBlock(sheetImage);
                [self removeCacheWithKey:key];
                [self.retryCache removeObjectForKey:key];
                completionBlock(sheetImage);
            }
        });
        
    }];
    
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


- (UIImageView *)operationImageView {
    if (!_operationImageView) {
        _operationImageView = [[UIImageView alloc] init];
    }
    return _operationImageView;
}

@end
