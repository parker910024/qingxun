//
//  TabBarConfigManager.m
//  LookingLove
//
//  Created by lvjunhang on 2020/12/4.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TabBarConfigManager.h"

#import <YYCache/YYCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import "SVGA.h"

static NSString *const kCacheKey = @"kTabBarConfigCacheNameKey";
static NSString *const kStoreKey = @"kkTabBarConfigStoreKey";

@interface TabBarConfigManager()
@property (nonatomic, strong) SVGAParser *parser;
@end

@implementation TabBarConfigManager

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static TabBarConfigManager *sharedInstance;
    dispatch_once(&once, ^{
        if (sharedInstance == NULL) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

- (TabBarConfig *)config {
    YYCache *cache = [YYCache cacheWithName:kCacheKey];
    TabBarConfig *conf = (TabBarConfig *)[cache objectForKey:kStoreKey];
    return conf;
}

- (void)updateConfig:(TabBarConfig *)config {
    
    if (!config) {
        return;
    }
    
    YYCache *cache = [YYCache cacheWithName:kCacheKey];
    TabBarConfig *conf = (TabBarConfig *)[cache objectForKey:kStoreKey];
    if (conf && conf.version >= config.version) {
        //已有缓存，不再处理
        return;
    }
    
    //下载新资源
    [self downloadSource:config];
}

- (void)downloadSource:(TabBarConfig *)config {
        
    dispatch_group_t group = dispatch_group_create();
    
    for (TabBarConfigItem *item in config.tabVos) {
        [self downloadImage:item group:group];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        YYCache *cache = [YYCache cacheWithName:kCacheKey];
        [cache removeAllObjects];
        [cache setObject:config forKey:kStoreKey];
    });
}

- (void)downloadImage:(TabBarConfigItem *)item group:(dispatch_group_t)group {
    
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:item.checkIcon] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (data) {
            item.checkIconData = data;
            dispatch_group_leave(group);
        }
    }];
    
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:item.uncheckIcon] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (data) {
            item.uncheckIconData = data;
            dispatch_group_leave(group);
        }
    }];
        
    if (item.svgaUrl) {
        [self.parser parseWithURL:[NSURL URLWithString:item.svgaUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        } failureBlock:^(NSError * _Nullable error) {
        }];
    }
}

- (SVGAParser *)parser {
    if (!_parser) {
        _parser = [[SVGAParser alloc] init];
    }
    return _parser;
}

@end
