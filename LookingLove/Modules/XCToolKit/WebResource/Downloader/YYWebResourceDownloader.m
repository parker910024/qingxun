//
//  YYWebResourceDownloader.m
//  YYMobileFramework
//
//  Created by wuwei on 14/6/12.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "YYWebResourceDownloader.h"
#import <AFURLSessionManager.h>
#import "FBKVOController.h"

#if TRAFFIC_DATA
#import "../../../../YYMobileCore/YYMobileCore/Cores/CoreManager.h"
#import "../../../../YYMobileCore/YYMobileCore/Cores/Carrier/ICarrierService.h"
#import "../../../../YYMobileCore/YYMobileCore/Cores/Carrier/CarrierServiceTypes.h"
#endif

#define ENABLE_UNICOM_PROXY 0

static NSString * const kProgressCallbackKey = @"progress";
static NSString * const kCompletionCallbackKey = @"completed";

#if TRAFFIC_DATA
extern NSString * const CarrierDataTrafficPackageSubscribeStateUpdateNotification;
#endif

static const NSTimeInterval kDefaultDownloadTimeout = 15.0f;

@interface YYWebResourceDownloadOperation ()

- (instancetype)initWithTask:(NSURLSessionTask *)task;
- (instancetype)initWithTask:(NSURLSessionTask *)task cancelledBlock:(dispatch_block_t)cancelBlock;

@end

@implementation YYWebResourceDownloadOperation
{
    NSURLSessionTask *_task;
    dispatch_block_t _cancelBlock;
}

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    self = [super init];
    if (self) {
        _task = task;
    }
    return self;
}

- (instancetype)initWithTask:(NSURLSessionTask *)task cancelledBlock:(dispatch_block_t)cancel
{
    self = [self initWithTask:task];
    if (self) {
        _cancelBlock = cancel;
    }
    return self;
}

- (void)cancel {
    [super cancel];
    
    [_task cancel];
    if (_cancelBlock) {
        _cancelBlock();
    }
}

@end

@interface YYWebResourceDownloader ()

@property (nonatomic, strong, readonly) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

@property (nonatomic, strong, readonly) dispatch_queue_t barrierQueue;
@property (nonatomic, strong, readonly) NSMutableDictionary *URLCallbacks;
@property (nonatomic, strong, readonly) NSMutableDictionary *HTTPHeaders;
@property (nonatomic, strong, readonly) NSMapTable *downloadingTasks;

@end

@implementation YYWebResourceDownloader

@synthesize barrierQueue = _barrierQueue;
@synthesize URLCallbacks = _URLCallbacks;
@synthesize HTTPHeaders =_HTTPHeaders;
@synthesize downloaderName = _downloaderName;
@synthesize sessionManager = _sessionManager;

+ (instancetype)sharedDownloader
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithName:@"default"];
    });
    return instance;
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _downloaderName = name;
        _downloadingTasks = [NSMapTable strongToWeakObjectsMapTable];
        
#if TRAFFIC_DATA
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnCarrierDataTrafficPackageSubscribeStateUpdate:) name:CarrierDataTrafficPackageSubscribeStateUpdateNotification object:nil];
#endif
        
        NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        /*
         defaultConfiguration.connectionProxyDictionary = @{
         (NSString *)kCFStreamPropertyHTTPProxyHost: @"huanjushidai.gzproxy.10155.com",
         (NSString *)kCFStreamPropertyHTTPProxyPort: @(8080)};
         
         defaultConfiguration.HTTPAdditionalHeaders = @{@"Authorization": @"Basic MzAwMDAwNDU0NDo5OEI4NTU5MDI0ODYwQkE1NDE2MTUwNDM4NzA2NjdGMQ=="};
         */
        
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfiguration];
        _downloadTimeout = kDefaultDownloadTimeout;
        _URLCallbacks = [NSMutableDictionary dictionary];
        _HTTPHeaders = [NSMutableDictionary dictionary];
        // Create a queue using the downloader name
        name = name ? : @"<anonymous>";
        NSString *queueName = [NSString stringWithFormat:@"com.yy.webResourceDownloader.%@.barrierQueue", name];
        _barrierQueue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_CONCURRENT);
        
        static char kBarrierQueueSpecificKey;
        dispatch_queue_set_specific(self.barrierQueue, &kBarrierQueueSpecificKey, (__bridge void *)self, NULL);
    }
    return self;
}

- (instancetype)init
{
    return [self initWithName:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    if (value) {
        self.HTTPHeaders[field] = value;
    }
    else {
        [self.HTTPHeaders removeObjectForKey:field];
    }
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field
{
    return self.HTTPHeaders[field];
}

- (YYWebResourceDownloadOperation *)downloadWithURL:(NSURL *)url
                                           fileName:(NSString *)fileName
                                            options:(YYWebResourceDownloaderOptions)options
                                           progress:(YYWebResourceDownloaderProgressBlock)progress
                                         completion:(YYWebResourceDownloaderCompletionBlock)completion
{
#if TRAFFIC_DATA
    //处理缓存的Session的代理配置
    if(!_sessionManager)
    {
        NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        BOOL isDataTrafficeFree = [GetCoreI(ICarrierService) isDataTrafficFree];
        if(isDataTrafficeFree)
        {
            CarrierProxyConfiguration* httpProxyConfiguration = [GetCoreI(ICarrierService) getProxyConfiguration];
            if(httpProxyConfiguration)
            {
                defaultConfiguration.connectionProxyDictionary  =  @{ (NSString *)kCFStreamPropertyHTTPProxyHost: httpProxyConfiguration.serverAddress,
                                                                      (NSString *)kCFStreamPropertyHTTPProxyPort: @(httpProxyConfiguration.serverPort)};
                defaultConfiguration.HTTPAdditionalHeaders      = @{@"Authorization": [NSString stringWithFormat:@"Basic %@", httpProxyConfiguration.authenticationString]};
            }
            self.sessionConfiguration = defaultConfiguration;
        }
        
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:self.sessionConfiguration];
        
        [_sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request) {
            
            NSMutableURLRequest *redirectRequest = [request mutableCopy];
            if(isDataTrafficeFree)
            {
                CarrierProxyConfiguration* httpProxyConfiguration = [GetCoreI(ICarrierService) getProxyConfiguration];
                [redirectRequest addValue:[NSString stringWithFormat:@"Basic %@", httpProxyConfiguration.authenticationString] forHTTPHeaderField:@"Authorization"];
            }
            return redirectRequest;
        }];
    }
#endif
    
    __block YYWebResourceDownloadOperation *downloadOperation = nil;
    __weak YYWebResourceDownloader *wself = self;
    
    [self _addProgressCallback:progress andCompletionBlock:completion forURL:url createCallback:^{
        NSTimeInterval timeoutInterval = wself.downloadTimeout;
        if (timeoutInterval == 0.0) {
            timeoutInterval = kDefaultDownloadTimeout;
        }
        
        // In order to prevent from potential duplicate caching (NSURLCache + YYImageCache), we disable the cache for image requests if told otherwise
        NSURLRequestCachePolicy cachePolicy = (options & YYWebResourceDownloaderUseNSURLCache) ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                    cachePolicy:cachePolicy
                                                                timeoutInterval:timeoutInterval];
        request.HTTPShouldHandleCookies = (options & YYWebResourceDownloaderHandleCookies);
        request.HTTPShouldUsePipelining = YES;
        if (wself.headerFilter) {
            request.allHTTPHeaderFields = wself.headerFilter(url, [wself.HTTPHeaders copy]);
        }
        else {
            request.allHTTPHeaderFields = [wself.HTTPHeaders copy];
        }
        
        __block NSProgress *progress;
        __block FBKVOController *controller = [FBKVOController controllerWithObserver:wself];
        
        __block NSURLSessionTask *sessionTask = [wself.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            progress = downloadProgress;
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//            return [targetPath URLByAppendingPathExtension:@"download"];
            NSString *fullPath;
            if (fileName.length > 0 || fileName) {
                fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
            }else {
                fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
            }
            
            return [NSURL fileURLWithPath:fullPath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
//                [YYLogger debug:TAG(THTTP,TNetSend) message:@"[Task: %@] Download %@ failed with error %@", sessionTask, url, error];
            } else {
//                [YYLogger debug:TAG(THTTP,TNetSend) message:@"[Task: %@] Download %@ successfully, store to %@", sessionTask, url, filePath];
            }
            
            if (error.code == NSURLErrorCancelled) {
                // Cancel由YYWebResourceOperation的cancelBlock处理
                return;
            }
            
            if (!wself) return;     // return if deallocated
            __strong __typeof__(wself) sself = wself;
            NSArray *callbacksForURL = [sself _callbacksForURL:url];
            [sself _removeCallbacksForURL:url];
            for (NSDictionary *callbacks in callbacksForURL) {
                YYWebResourceDownloaderCompletionBlock complete = callbacks[kCompletionCallbackKey];
                if (complete) {
                    complete(filePath, error, YES);
                }
            }
            
            // 移除文件
            [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            
            // Remove KVO
            controller = nil;

        }];
        
        // Observe the fractionCompleted property of the progress
        [controller observe:progress keyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            if (!wself) return;     // return if deallocated
            __strong __typeof__(wself) sself = wself;
            NSArray *callbacksForURL = [sself _callbacksForURL:url];
            for (NSDictionary *callbacks in callbacksForURL) {
                YYWebResourceDownloaderProgressBlock progressBlock = callbacks[kProgressCallbackKey];
                if (progressBlock) {
                    progressBlock(progress.completedUnitCount, progress.totalUnitCount, progress.fractionCompleted);
                }
            }
        }];
        
        
//        [YYLogger debug:TAG(THTTP,TNetSend)message:@"[Task: %@] download %@ DID START!", sessionTask, url];
        
        downloadOperation = [[YYWebResourceDownloadOperation alloc] initWithTask:sessionTask cancelledBlock:^{
            __strong __typeof__(wself) sself = wself;
            if (sself) {
                [sself _removeCallbacksForURL:url];
            }
        }];
        
        //        [wself.downloadingTasks setObject:downloadOperation forKey:url];
        
        // start the task
        [sessionTask resume];
    }];
    
    return downloadOperation;
}

- (void)_addProgressCallback:(YYWebResourceDownloaderProgressBlock)progress
          andCompletionBlock:(YYWebResourceDownloaderCompletionBlock)completion
                      forURL:(NSURL *)url
              createCallback:(dispatch_block_t)createCallback
{
    NSParameterAssert(createCallback);
    
    if (url == nil) {
        if (completion != nil) {
            completion(nil, nil, NO);
        }
        return;
    }
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        
        BOOL first = NO;
        if (!self.URLCallbacks[url]) {
            self.URLCallbacks[url] = [NSMutableArray new];
            first = YES;
        }
        
        id task = [self.downloadingTasks objectForKey:url];
//        [YYLogger debug:TAG(THTTP,TNetSend) message:@"add Callbacks for url %@, existing task: %@, isFirst: %d", url, task, first];
        
        // Handle single download of simulaneous download request for the same URL
        NSMutableArray *callbacksForURL = self.URLCallbacks[url];
        NSMutableDictionary *callbacks = [NSMutableDictionary new];
        if (progress) {
            callbacks[kProgressCallbackKey] = [progress copy];
        }
        if (completion) {
            callbacks[kCompletionCallbackKey] = [completion copy];
        }
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[url] = callbacksForURL;
        
        if (first) {
            createCallback();
        }
    });
}

- (NSArray *)_callbacksForURL:(NSURL *)url {
    __block NSArray *callbacksForURL;
    dispatch_sync(self.barrierQueue, ^{
        callbacksForURL = self.URLCallbacks[url];
    });
    return [callbacksForURL copy];
}

- (void)_removeCallbacksForURL:(NSURL *)url {
    dispatch_barrier_async(self.barrierQueue, ^{
        [self.URLCallbacks removeObjectForKey:url];
    });
}

#if TRAFFIC_DATA
-(void) OnCarrierDataTrafficPackageSubscribeStateUpdate:(NSNotification*)notification
{
    CarrierProxyConfiguration* httpProxyConfiguration = [notification object];
    if (httpProxyConfiguration && httpProxyConfiguration.serverAddress.length > 0)
    {
        NSURLSessionConfiguration *proxyConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        proxyConfiguration.connectionProxyDictionary  =  @{ (NSString *)kCFStreamPropertyHTTPProxyHost: httpProxyConfiguration.serverAddress,
                                                            (NSString *)kCFStreamPropertyHTTPProxyPort: @(httpProxyConfiguration.serverPort)};
        proxyConfiguration.HTTPAdditionalHeaders      = @{@"Authorization": [NSString stringWithFormat:@"Basic %@", httpProxyConfiguration.authenticationString]};
        
        
        self.sessionConfiguration = proxyConfiguration;
        
        if(!_sessionManager)
        {
            return;
        }
        
        if([_sessionManager.tasks count] > 0)
        {
            [_sessionManager invalidateSessionCancelingTasks:false];
            [[NSNotificationCenter defaultCenter] addObserverForName:AFURLSessionDidInvalidateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(__unused NSNotification *note) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AFURLSessionDidInvalidateNotification object:nil];
                _sessionManager = nil;
            }];
        }
        else
        {
            _sessionManager = nil;
        }
    }
    else
    {
        if(!self.sessionConfiguration)
            return;
        
        if([_sessionManager.tasks count] > 0)
        {
            [_sessionManager invalidateSessionCancelingTasks:false];
            [[NSNotificationCenter defaultCenter] addObserverForName:AFURLSessionDidInvalidateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(__unused NSNotification *note) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AFURLSessionDidInvalidateNotification object:nil];
                self.sessionConfiguration = nil;
                _sessionManager = nil;
            }];
        }
        else
        {
            self.sessionConfiguration = nil;
            _sessionManager = nil;
        }
    }
}
#endif

@end
