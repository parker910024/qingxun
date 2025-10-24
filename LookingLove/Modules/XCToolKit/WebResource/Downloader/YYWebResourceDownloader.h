//
//  YYWebResourceDownloader.h
//  YYMobileFramework
//
//  Created by wuwei on 14/6/12.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, YYWebResourceDownloaderOptions) {
    YYWebResourceDownloaderProgressiveDownload = 1 << 1,
    YYWebResourceDownloaderUseNSURLCache = 1 << 2,
    YYWebResourceDownloaderIgnoreCachedResponse = 1 << 3,
    YYWebResourceDownloaderContinueInBackground = 1 << 4,
    YYWebResourceDownloaderHandleCookies = 1 << 5,
};

/**
 *  下载的进度回调
 *
 *  @param received
 *  @param expected
 */
typedef void(^YYWebResourceDownloaderProgressBlock)(int64_t received, int64_t expected, CGFloat progress);

/**
 *  下载完成回调Block
 *
 *  @param filePath      下载完成后文件的URL(fileURL)
 *  @param error         下载过程中的错误
 *  @param finished      是否完成
 */
typedef void(^YYWebResourceDownloaderCompletionBlock)(NSURL *filePath, NSError *error, BOOL finished);

@class YYWebResourceDownloader;
@class YYWebResourceDownloadOperation;

@interface YYWebResourceDownloadOperation : NSOperation

@end

NS_AVAILABLE_IOS(7_0) @interface YYWebResourceDownloader : NSObject

+ (instancetype)sharedDownloader;

/**
 *  The designated initializer
 *
 *  @param name name of the downloader
 *
 *  @return The initialized YYWebResourceDownloader instance
 */
- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, strong, readonly) NSString *downloaderName;

// default is 15.0
@property (nonatomic, assign) NSTimeInterval downloadTimeout;

@property (nonatomic, strong) NSDictionary*(^headerFilter)(NSURL *url, NSDictionary *headers);

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

- (YYWebResourceDownloadOperation *)downloadWithURL:(NSURL *)url
                                           fileName:(NSString *)fileName
                                            options:(YYWebResourceDownloaderOptions)options
                                           progress:(YYWebResourceDownloaderProgressBlock)progress
                                         completion:(YYWebResourceDownloaderCompletionBlock)completion;

@end
