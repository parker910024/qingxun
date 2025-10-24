//
//  NIMKitPhotoFetcher.m
//  NIMKit
//
//  Created by chris on 2016/11/12.
//  Copyright © 2016年 NetEase. All rights reserved.
//


#import "XCMediaFetcher.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "XCFileLocationHelper.h"
#import "TZImageManager.h"
#import "XCCurrentVCStackManager.h"
#import "UIView+XCToast.h"

#import "TZImagePickerController.h"
#import "GCDHelper.h"

@interface XCMediaPickerController : TZImagePickerController

@end

@interface XCMediaFetcher()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,copy)   XCLibraryFetchResult libraryResultHandler;

@property (nonatomic,copy)   XCCameraFetchResult  cameraResultHandler;

@property (nonatomic,strong) UIImagePickerController  *imagePicker;

@property (nonatomic,strong) XCMediaPickerController  *assetsPicker;

@property (nonatomic, strong) UIImage *coverImage;

@end

@implementation XCMediaFetcher

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mediaTypes = @[(NSString *)kUTTypeImage];
        _limit = 9;
    }
    return self;
}

- (void)fetchPhotoFromLibrary:(XCLibraryFetchResult)result
{
    __weak typeof(self) weakSelf = self;
    [self setUpPhotoLibrary:^(XCMediaPickerController * _Nullable picker) {
        if (picker && weakSelf) {
            weakSelf.assetsPicker = picker;
            weakSelf.libraryResultHandler = result;
            picker.sortAscendingByModificationDate = NO;
            picker.allowPickingVideo = [weakSelf.mediaTypes containsObject:(NSString *)kUTTypeMovie];;
            picker.allowPickingImage = [weakSelf.mediaTypes containsObject:(NSString *)kUTTypeImage];
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            if ([[XCCurrentVCStackManager shareManager]getCurrentVC]) {
                [[[XCCurrentVCStackManager shareManager] getCurrentVC] presentViewController:picker animated:YES completion:nil];
            }else {
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
            }
        }else{
            result(nil,nil,nil,PHAssetMediaTypeUnknown);
        }
    }];
}

- (void)fetchMediaFromCamera:(XCCameraFetchResult)result
{
    if ([self initCamera]) {
        self.cameraResultHandler = result;
#if TARGET_IPHONE_SIMULATOR
        NSAssert(0, @"not supported");
#elif TARGET_OS_IPHONE
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        if (![[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UIImagePickerController class]]) {
//            if ([GetCore(ImRoomCoreV2)isInRoom]) {
//                [[[XCCurrentVCStackManager shareManager] getCurrentVC] presentViewController:self.imagePicker animated:YES completion:nil];
//            }else {
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.imagePicker animated:YES completion:nil];
//            }
//
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.imagePicker animated:YES completion:nil];
        }
#endif
    }
}


- (void)setUpPhotoLibrary:(void(^)(XCMediaPickerController * _Nullable picker)) handler
{
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"请开启相册访问权限"
                                           delegate:nil
                                  cancelButtonTitle:@"开启"
                                  otherButtonTitles:nil] show];
                if(handler) handler(nil);
            }
            if (status == PHAuthorizationStatusAuthorized) {
                XCMediaPickerController *vc = [[XCMediaPickerController alloc] initWithMaxImagesCount:self.limit delegate:weakSelf];
                vc.allowPickingOriginalPhoto = !self.notAllowPickingOriginalPhoto;
                vc.naviBgColor = [UIColor blackColor];
                vc.naviTitleColor = [UIColor whiteColor];
                vc.barItemTextColor = [UIColor whiteColor];
                vc.navigationBar.barStyle = UIBarStyleDefault;
                vc.sortAscendingByModificationDate = NO;
                vc.allowPickingVideo = [_mediaTypes containsObject:(NSString *)kUTTypeMovie];
                vc.allowPickingImage = [_mediaTypes containsObject:(NSString *)kUTTypeImage];
                vc.selectedAssets = weakSelf.selectedAssets;
                if(handler) handler(vc);
            }
        });
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *inputURL  = [info objectForKey:UIImagePickerControllerMediaURL];
            NSString *outputFileName = [XCFileLocationHelper genFilenameWithExt:@"mp4"];
            NSString *outputPath = [XCFileLocationHelper filepathForVideo:outputFileName];
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
            AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                             presetName:AVAssetExportPresetMediumQuality];
            session.outputURL = [NSURL fileURLWithPath:outputPath];
            session.outputFileType = AVFileTypeMPEG4;   // 支持安卓某些机器的视频播放
            session.shouldOptimizeForNetworkUse = YES;
            session.videoComposition = [self getVideoComposition:asset];  //修正某些播放器不识别视频Rotation的问题
            [session exportAsynchronouslyWithCompletionHandler:^(void)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (session.status == AVAssetExportSessionStatusCompleted)
                     {
                         self.cameraResultHandler(outputPath,nil);
                     }
                     else
                     {
                         self.cameraResultHandler(nil,nil);
                     }
                     self.cameraResultHandler = nil;
                 });
             }];
            
        });
        
    }else{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.cameraResultHandler(nil,image);
        self.cameraResultHandler = nil;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 相册回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    if (isSelectOriginalPhoto)
    {
        [self requestAssets:[assets mutableCopy]];
    }
    else
    {
        if (self.libraryResultHandler) {
            NSMutableArray *selAssts = [NSMutableArray arrayWithArray:assets];
            self.libraryResultHandler(photos,selAssts,nil,PHAssetMediaTypeImage);
        }
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
    self.coverImage = coverImage;
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:@[asset]];
    [self requestAssets:items];
}

- (void)requestAssets:(NSMutableArray *)assets
{
    if (!assets.count) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    //    [UIView showMessage:@""];
    [self requestAsset:assets.firstObject handler:^(NSString *path, PHAssetMediaType type) {
        //        [UIView hideHUD];
        if (weakSelf.libraryResultHandler)
        {
            if (weakSelf.coverImage) {
                weakSelf.libraryResultHandler(@[weakSelf.coverImage],nil,path,type);
                weakSelf.coverImage = nil;
            }else{
                weakSelf.libraryResultHandler(nil,nil,path,type);
                
            }
        }
        dispatch_main_sync_safe(^{
            [assets removeObjectAtIndex:0];
            [weakSelf requestAssets:assets];
        });
    }];
}

- (void)requestAsset:(PHAsset *)asset handler:(void(^)(NSString *,PHAssetMediaType)) handler
{
    //视频目前传入回来的时候r路径
    if ([asset isKindOfClass:[AVURLAsset class]]) {
        AVURLAsset * avUrl = (AVURLAsset *)asset;
        handler([[avUrl URL] absoluteString], PHAssetMediaTypeVideo);
        return;
    }
    
    if (asset.mediaType == PHAssetMediaTypeImage)
    {
        [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
            NSString *path = contentEditingInput.fullSizeImageURL.relativePath;
            handler(path,contentEditingInput.mediaType);
        }];
    }
}

#pragma mark - Private

- (void)setMediaTypes:(NSArray *)mediaTypes
{
    _mediaTypes = mediaTypes;
    _imagePicker.mediaTypes = mediaTypes;
    _assetsPicker.allowPickingVideo = [mediaTypes containsObject:(NSString *)kUTTypeMovie];
    _assetsPicker.allowPickingImage = [mediaTypes containsObject:(NSString *)kUTTypeImage];
}

- (AVMutableVideoComposition *)getVideoComposition:(AVAsset *)asset
{
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    CGSize videoSize = videoTrack.naturalSize;
    BOOL isPortrait_ = [self isVideoPortrait:asset];
    if(isPortrait_) {
        videoSize = CGSizeMake(videoSize.height, videoSize.width);
    }
    composition.naturalSize     = videoSize;
    videoComposition.renderSize = videoSize;
    
    videoComposition.frameDuration = CMTimeMakeWithSeconds( 1 / videoTrack.nominalFrameRate, 600);
    AVMutableCompositionTrack *compositionVideoTrack;
    compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    AVMutableVideoCompositionLayerInstruction *layerInst;
    layerInst = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInst setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];
    AVMutableVideoCompositionInstruction *inst = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    inst.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    inst.layerInstructions = [NSArray arrayWithObject:layerInst];
    videoComposition.instructions = [NSArray arrayWithObject:inst];
    return videoComposition;
}

- (BOOL) isVideoPortrait:(AVAsset *)asset
{
    BOOL isPortrait = NO;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks    count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        CGAffineTransform t = videoTrack.preferredTransform;
        // Portrait
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)
        {
            isPortrait = YES;
        }
        // PortraitUpsideDown
        if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)  {
            
            isPortrait = YES;
        }
        // LandscapeRight
        if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0)
        {
            isPortrait = NO;
        }
        // LandscapeLeft
        if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0)
        {
            isPortrait = NO;
        }
    }
    return isPortrait;
}

- (BOOL)initCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"检测不到相机设备"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return NO;
    }
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"请开启相册访问权限"
                                   delegate:nil
                          cancelButtonTitle:@"开启"
                          otherButtonTitles:nil] show];
        return NO;
        
    }
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = self.mediaTypes;
    return YES;
}

- (void)originalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    option.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [self fixOrientation:result];
            BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (completion) completion(result,info,isDegraded);
        }
    }];
}


/// 修正图片转向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
#pragma clang diagnostic pop



@end


@implementation XCMediaPickerController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
@end
