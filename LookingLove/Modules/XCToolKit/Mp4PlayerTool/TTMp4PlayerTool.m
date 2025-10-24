//
//  TTMp4PlayerTool.m
//  CeEr
//
//  Created by jiangfuyuan on 2021/7/29.
//  Copyright © 2021 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMp4PlayerTool.h"

#import "BaseCore.h"
#import "TTMp4PlayerClient.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "HttpRequestHelper.h"
#import "CommonFileUtils.h"
#import "NSString+NTES.h"

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <QGVAPlayer/QGVAPlayer.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageManager.h>
#define musicPath @"MP4"

@interface TTMp4PlayerTool ()<HWDMP4PlayDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isDownMp4;
@property (nonatomic, strong) GiftAllMicroSendInfo *playInfo;
@property (nonatomic, strong) UIView *playView;
@end

@implementation TTMp4PlayerTool

+ (instancetype)defaultPlayerTool {
    static TTMp4PlayerTool *playerTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerTool = [[TTMp4PlayerTool alloc] init];
    });
    return playerTool;
}

#pragma mark -- 播放单个 MP4的 操作。不需要做预加载，如气氛灯背景
/// 开始播放mp4
/// @param view 播放MP4的View
/// @param count 播放循环次数
/// @param urlString 播放链接
- (void)playMp4WithView:(UIView *)view withCount:(NSInteger)count andUrlString:(NSString *)urlString {
    @weakify(self);
    [self downMp4WithUrl:urlString success:^(NSString *pathString) {
        @strongify(self);
        if (pathString) {
            self.playView = [[UIView alloc] initWithFrame:view.bounds];
            [view addSubview:self.playView];
            [self.playView playHWDMP4:pathString repeatCount:count delegate:self];
        }
    }];
}

// 单个缓存
- (void)downMp4WithUrl:(NSString *)url success:(void(^)(NSString *pathString))complete {
    NSString *md5String = [url MD5String];
    NSString *filePathString = [[CommonFileUtils documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",musicPath]];
    NSString *filePathUrl = [filePathString stringByAppendingPathComponent:md5String];
    if (![CommonFileUtils isFileExists:filePathUrl]) {
        [CommonFileUtils createDirWithDirPath:filePathString];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [HttpRequestHelper handelDownloadWithFileUrlPath:url saveFilePath:filePathUrl success:^(NSURLResponse *response, NSURL *filePath) {
                if (complete) {
                    complete(filePath.absoluteString);
                }
            } fail:^(NSInteger *resCode, NSString *message) {
                if (complete) {
                    complete(nil);
                }
            }];
        });
    } else {
        if (complete) {
            complete(filePathUrl);
        }
    }
}

#pragma mark -- 需要预加载的MP4, 目前只有礼物，后续有新的类型，需要拓展
/// 开始播放礼物mp4
/// @param view 播放MP4的View
/// @param count 播放循环次数
/// @param info 播放model
- (void)playGiftMp4WithView:(UIView *)view withCount:(NSInteger)count andGiftInfo:(GiftAllMicroSendInfo *)info {
    @weakify(self);
    [self downMp4WithInfo:nil sendInfo:info success:^(NSString *pathString) {
        @strongify(self);
        if (pathString) {
            self.playInfo = info;
            CGFloat mp4Width = 375;
            CGFloat mp4Height = 812;
            CGFloat playWidth = KScreenWidth;
            CGFloat playHeight = playWidth * mp4Height / mp4Width;
            UIView *playView = [[UIView alloc] init];
            [view addSubview:playView];
            playView.width = playWidth;
            playView.height = playHeight;
            playView.center = view.center;
            
            [playView playHWDMP4:pathString repeatCount:count delegate:self];
        }
    }];
}


/// 预加载礼物的mp4资源。预加载之后并不会播放。
- (void)downMp4File {
    if (self.dataArray > 0) {
        @weakify(self);
        self.isDownMp4 = YES;
        [self downMp4WithInfo:[self.dataArray safeObjectAtIndex:0] sendInfo:nil success:^(NSString *pathString) {
            @strongify(self);
            [self.dataArray removeObjectAtIndex:0];
            if (self.dataArray.count > 0) {
                if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
                    [self downMp4File];
                }
            } else {
                self.isDownMp4 = NO;
            }
        }];
    }
}

/// 缓存礼物的MP4回调。 分两种，1、预加载  2、播放时候做缓存判断。
/// @param giftInfo 预加载的礼物实体
/// @param sendInfo 播放礼物的时候的礼物实体
/// @param complete 成功的回调
- (void)downMp4WithInfo:(GiftInfo *)giftInfo sendInfo:(GiftAllMicroSendInfo *)sendInfo success:(void(^)(NSString *pathString))complete {
    if (sendInfo) {
        giftInfo = sendInfo.gift;
    }
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_group_t dispatchGroup = dispatch_group_create();

    if (sendInfo.giftInfo && (sendInfo.giftInfo.giftMp4Key.receiveAvatar.length > 0 || sendInfo.giftInfo.giftMp4Key.sendAvatar.length > 0)) {
        dispatch_group_async(dispatchGroup, dispatchQueue, ^{
            if (sendInfo.avatar.length > 0 && ![[SDImageCache sharedImageCache] diskImageDataExistsWithKey:sendInfo.avatar]) {
                dispatch_group_enter(dispatchGroup);
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:sendInfo.avatar] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:sendInfo.avatar]];//downloadImageWithURL 这个没带缓存，自己缓存一次
                    dispatch_group_leave(dispatchGroup);
                }];
            }
        });
        
        dispatch_group_async(dispatchGroup, dispatchQueue, ^{
            if (sendInfo.targetUsers.firstObject.avatar.length > 0 && ![[SDImageCache sharedImageCache] diskImageDataExistsWithKey:sendInfo.targetUsers.firstObject.avatar]) {
                dispatch_group_enter(dispatchGroup);
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:sendInfo.targetUsers.firstObject.avatar] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:sendInfo.targetUsers.firstObject.avatar]];//downloadImageWithURL 这个没带缓存，自己缓存一次
                    dispatch_group_leave(dispatchGroup);
                }];
            }
        });
    }
    
    __block NSString *finalyString;
    dispatch_group_async(dispatchGroup, dispatchQueue, ^{
        NSString *md5String = [giftInfo.mp4Url MD5String];
        NSString *filePathString = [[CommonFileUtils documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",musicPath]];
        NSString *filePathUrl = [filePathString stringByAppendingPathComponent:md5String];
        BOOL isSameFile = [[CommonFileUtils readObjectFromUserDefaultWithKey:[NSString stringWithFormat:@"%ld",giftInfo.giftId]] integerValue] == giftInfo.giftMp4Key.fileSize.integerValue; // 当前已经有缓存了，并且缓存的和接口返回的一样
        if (!isSameFile) { // 接口返回的视频更改了。需要删除之前的
            [CommonFileUtils deleteFileWithFullPath:filePathUrl];
        }
        if (![CommonFileUtils isFileExists:filePathUrl]) {
            [CommonFileUtils createDirWithDirPath:filePathString];
            dispatch_group_enter(dispatchGroup);
            [HttpRequestHelper handelDownloadWithFileUrlPath:giftInfo.mp4Url saveFilePath:filePathUrl success:^(NSURLResponse *response, NSURL *filePath) {
                finalyString = filePathUrl;
                [CommonFileUtils writeObject:giftInfo.giftMp4Key.fileSize toUserDefaultWithKey:[NSString stringWithFormat:@"%ld",giftInfo.giftId]];
                dispatch_group_leave(dispatchGroup);
            } fail:^(NSInteger *resCode, NSString *message) {
                finalyString = nil;
                dispatch_group_leave(dispatchGroup);
            }];
        } else {
            finalyString = filePathUrl;
        }
    });
    
    dispatch_group_notify(dispatchGroup, mainQueue, ^{
        if (complete) {
            complete(finalyString);
        }
    });
}

#pragma mark -- 融合特效的接口 vapx
//provide the content for tags, maybe text or url string ...
- (NSString *)contentForVapTag:(NSString *)tag resource:(QGVAPSourceInfo *)info {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if (self.playInfo) {
        if (self.playInfo.gift.giftMp4Key.sendNick.length > 0) {
            if (self.playInfo.nick.length > 5) {
                self.playInfo.nick = [NSString stringWithFormat:@"%@...",[self.playInfo.nick substringToIndex:4]];
            }
            
            [dic safeSetObject:self.playInfo.nick forKey:self.playInfo.gift.giftMp4Key.sendNick];
        }
        
        if (self.playInfo.gift.giftMp4Key.receiveNick.length > 0) {
            if (self.playInfo.targetUsers.firstObject.nick.length > 5) {
                self.playInfo.targetUsers.firstObject.nick = [NSString stringWithFormat:@"%@...",[self.playInfo.targetUsers.firstObject.nick substringToIndex:4]];
            }
            [dic safeSetObject:self.playInfo.targetUsers.firstObject.nick forKey:self.playInfo.gift.giftMp4Key.receiveNick];
        }
        
        if (self.playInfo.msg.length > 0) {
            [dic safeSetObject:self.playInfo.msg forKey:@"z1"];
        }
    }
    return dic[tag];
}


//provide image for url from tag content
- (void)loadVapImageWithURL:(NSString *)urlStr context:(NSDictionary *)context completion:(VAPImageCompletionBlock)completionBlock {
    UIImage *image = nil;
    if ([urlStr isEqualToString: self.playInfo.gift.giftMp4Key.sendAvatar]) {
         image = [self getSdDiskCacheWithKey:self.playInfo.avatar];
    }else if ([urlStr isEqualToString: self.playInfo.gift.giftMp4Key.receiveAvatar]) {
        image = [self getSdDiskCacheWithKey:self.playInfo.targetUsers.firstObject.avatar];
   }
    //call completionBlock as you get the image, both sync or asyn are ok.
    //usually we'd like to make a net request
    dispatch_async(dispatch_get_main_queue(), ^{
        //let's say we've got result here
        completionBlock(image, nil, urlStr);
    });
}

- (UIImage *)getSdDiskCacheWithKey:(NSString *)key{
    if ([[SDImageCache sharedImageCache] diskImageDataExistsWithKey:key]) {
        //网络下载的资源文件
        return [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
    }
    return nil;
}

- (void)setInfo:(GiftInfo *)info {
    if (![self.dataArray containsObject:info]) {
        [self.dataArray addObject:info];
    }
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        if (!self.isDownMp4) {
            [self downMp4File];
        }
    }
}

/*------------       华丽的分割线     -----------------*/
- (void)stopMp4WithView:(UIView *)view {
    if (self.playView) {
        [self.playView stopHWDMP4];
    }
}

- (void)viewDidStopPlayMP4:(NSInteger)lastFrameIndex view:(UIView *)container {
    // 播放完成
    if (container == self.playView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playView removeFromSuperview];
            self.playView = nil;
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NotifyCoreClient(TTMp4PlayerClient, @selector(viewDidStopPlayWithView:), viewDidStopPlayWithView:container.superview);
            [container removeFromSuperview];
        });
    }
}

#pragma mark --- setter ---
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
