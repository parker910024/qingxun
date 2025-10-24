//
//  XCAniImageView.m
//  CeEr
//
//  Created by icholab on 2021/4/6.
//  Copyright © 2021 WUJIE INTERACTIVE. All rights reserved.
//

#import "XCAniImageView.h"
#import "SVGAImageView.h"
#import <Masonry/Masonry.h>
#import "SVGAParserManager.h"
#import "XCMacros.h"
#import <UIImageView+WebCache.h>
#import "NobleCore.h"
#import <YYWebImage/YYWebImageManager.h>
#import "XCTheme.h"
#import "SpriteSheetImageManager.h"
#import "UIImage+Resize.h"
#import <QGVAPlayer/QGVAPlayer.h>
#import <SDWebImage/SDImageCache.h>
#import "UIView+ZJFrame.h"
#import "UIView+NTES.h"
@interface XCAniImageView () <SVGAPlayerDelegate,HWDMP4PlayDelegate>
@property (nonatomic, strong) SVGAImageView *svgImageView;
@property (nonatomic, strong) SVGAParserManager *parserManager;
@property (nonatomic, strong) XCAniImageConfigurSvgaModel  *model;
@property (nonatomic, strong) YYAnimatedImageView  *gifImageView;
@property (nonatomic, strong) YYAnimatedImageView  *headerImageView;    //获取动态头饰第一针
@property (nonatomic, strong) SpriteSheetImageManager  *sheetManager;
@property (nonatomic, assign) XCAniImageType  type;

@end
@implementation XCAniImageView

#pragma mark - public
- (void)xc_setImageWithURL:(NSURL *)url withType:(XCAniImageType)type placeholder:(UIImage *)image{
    self.type = type;
    if (type == XCAniImageSVGA) {
        [self showSvgaIamage:YES];
        self.image = image;
        @KWeakify(self);
        [self.parserManager loadSvgaWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            selfWeak.svgImageView.loops = selfWeak.model.playCount;
            selfWeak.svgImageView.clearsAfterStop = NO;
            selfWeak.svgImageView.videoItem = videoItem;
            [selfWeak checkDownloadResource];
            if (selfWeak.model.replaceNickName.length > 0 && selfWeak.model.replaceNickKey.length > 0) {
                NSMutableAttributedString *nick = [[NSMutableAttributedString alloc] initWithString:selfWeak.model.replaceNickName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:UIColorFromRGB(0x271937)}];
                [selfWeak.svgImageView setAttributedText:nick forKey:selfWeak.model.replaceNickKey];
            }
            selfWeak.image = nil;
            [selfWeak.svgImageView startAnimation];
            
        } failureBlock:^(NSError * _Nullable error) {

        }];

        return;
    }else if (type == XCAniImageGif){
        [self showSvgaIamage:NO];
        [self.svgImageView clearsAfterStop];
        [self.gifImageView yy_setImageWithURL:url placeholder:image options:YYWebImageOptionShowNetworkActivity completion:nil];
        [self.gifImageView startAnimating];
        self.image = nil;
    }else if (type == XCAniMp4){
        [self showSvgaIamage:NO];
        [self.svgImageView clearsAfterStop];
        self.image = nil;
        [self checkDownloadResource];
       
    } else{
        self.svgImageView.hidden = YES;
        self.gifImageView.hidden = YES;
        [self sd_setImageWithURL:url placeholderImage:image];
    }


}

- (void)configureSvgaModel:(id)model{
    self.model = model;
}

- (void)xc_setImageWithURL:(NSURL *)url placeholder:(UIImage *)image{
    [self xc_setImageWithURL:url withType:XCAniImageNormal placeholder:image];
}

- (void)xc_setImageWithURL:(NSURL *)url withType:(XCAniImageType)type{
    [self xc_setImageWithURL:url withType:type placeholder:nil];
}

- (void)stopAnimating{
    [_svgImageView stopAnimation];
    [_svgImageView clear];
    [_gifImageView stopAnimating];
}

- (void)showSvgaIamage:(BOOL)isShow{
    self.svgImageView.hidden = !isShow;
    self.gifImageView.hidden = isShow;
}

- (void)playVAPViewWithPath:(NSString *)path{
//    CGFloat mp4Width = 75;
//    CGFloat mp4Height = 150;
    CGFloat playWidth = KScreenWidth;
    CGFloat playHeight = playWidth * self.model.rio;
    VAPView *mp4View = [[VAPView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, playHeight)];
    [self addSubview:mp4View];
    mp4View.center = self.center;
//    if (iPhoneXSeries) {
//        mp4View.zj_height = self.zj_height;
////        mp4View.zj_height = self.zj_height - kNavigationHeight -kSafeAreaBottomHeight - 50;
//        mp4View.zj_centerY = self.zj_height/2.0;
//    }else{
//
//        mp4View.zj_height = self.zj_height + 10;
////        mp4View.zj_height = self.zj_height + 50;
////        mp4View.zj_centerY = self.zj_centerY;
//    }
    NSInteger count = self.model.playCount;
    
    if (count == 1) {
        if ([mp4View respondsToSelector:@selector(playHWDMP4:delegate:)]) {
            [mp4View playHWDMP4:path delegate:self];

        }
    }else{
        if (count > 1) {
            count -= 1;
        }
        [mp4View playHWDMP4:path repeatCount:count delegate:self];

    }
}

- (void)reset{
    self.parserManager = nil;
    self.svgImageView = nil;
}

- (void)replay{
    [self.svgImageView startAnimation];
}
- (void)playSvgaViewAction{
    
    if (self.model.replaceUrl.length > 0 && self.model.replaceKey.length > 0) {
        UIImage *image = [self getSdDiskCacheWithKey:self.model.replaceUrl];
        [self.svgImageView setImage:image forKey:self.model.replaceKey];
    }
    NSString *replaceHeaderAroundUrl = [self getHeaderWearUrl];
   
    if (replaceHeaderAroundUrl.length > 0 && self.model.replaceHeaderAroundKey.length > 0) {
//        if (![replaceHeaderAroundUrl containsString:@"http"]) {
//            //读取本地文件
//            UIImage *image = [GetCore(NobleCore) findNobleSourceBySourceId:replaceHeaderAroundUrl];
//            [self.svgImageView setImage:image forKey:self.model.replaceHeaderAroundKey];
//        }else{
//            UIImage *image = [self getSdDiskCacheWithKey:self.model.replaceHeaderAroundUrl];
//            [self.svgImageView setImage:image forKey:self.model.replaceHeaderAroundKey];
//        }
     UIImage *image = [self getSdDiskCacheWithKey:replaceHeaderAroundUrl];
     [self.svgImageView setImage:image forKey:self.model.replaceHeaderAroundKey];
    }else if (self.model.replaceHeaderAroundKey.length > 0){
        //
        [self.svgImageView setImage:[UIImage imageNamed:@"room_hearwear"] forKey:self.model.replaceHeaderAroundKey];
    }
}
#pragma mark - svgaDelegate

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
    //svga播放完成
    if (self.model.finshCallBack) {
        self.model.finshCallBack(self);
    }
}


#pragma mark -- down resource
- (void)checkDownloadResource{
    dispatch_queue_t dispatchQueue = dispatch_queue_create("downImage.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_group_t dispatchGroup = dispatch_group_create();
    @KWeakify(self)
    dispatch_group_async(dispatchGroup, dispatchQueue, ^{
        
        if (self.model.replaceUrl.length > 0 && ![[SDImageCache sharedImageCache] diskImageDataExistsWithKey:selfWeak.model.replaceUrl]) {
            dispatch_group_enter(dispatchGroup);
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.model.replaceUrl] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:selfWeak.model.replaceUrl]];//downloadImageWithURL 这个没带缓存，自己缓存一次
                dispatch_group_leave(dispatchGroup);
            }];
        }
    });
    
    dispatch_group_async(dispatchGroup, dispatchQueue, ^{
        if (self.model.staticPic.length > 0 && ![[SDImageCache sharedImageCache] diskImageDataExistsWithKey:selfWeak.model.staticPic]) {
            dispatch_group_enter(dispatchGroup);
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.model.staticPic] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:selfWeak.model.staticPic]];//downloadImageWithURL 这个本事没带缓存，自己缓存一次
                dispatch_group_leave(dispatchGroup);
            }];
        }
    });
    
    dispatch_group_async(dispatchGroup, dispatchQueue, ^{
        NSString *replaceHeaderAroundUrl = self.model.replaceHeaderAroundUrl;
        if ([[SDImageCache sharedImageCache] diskImageDataExistsWithKey:replaceHeaderAroundUrl]) {
//            return;
        }
        dispatch_group_enter(dispatchGroup);

        if (replaceHeaderAroundUrl.length > 0 && self.model.replaceHeaderAroundKey.length > 0) {
            if (![replaceHeaderAroundUrl containsString:@"http"]) {
                //读取本地文件
//                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL fileURLWithPath:replaceHeaderAroundUrl]];
                dispatch_group_leave(dispatchGroup);
            }else{
                NSURL *url = [NSURL URLWithString:replaceHeaderAroundUrl];
                __block BOOL isReturn = NO;
                [selfWeak.sheetManager loadSpriteSheetImageWithURL:url completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
                    if (isReturn) {
                        return; //这个block会被回调2次
                    }
                    isReturn = YES;
//                    if (sprit.contentRects.count > 1) {
                        //动态图片
                        selfWeak.headerImageView.image = sprit;
                    NSValue *rame = [sprit.contentRects firstObject];
                    CGRect value =  [rame CGRectValue];
                    BOOL isSave = YES;
                    if (value.size.width < 10 ) {
                        //截取有问题
                        value = CGRectMake(0, 0, 384, 384);
                        isSave = NO;
                    }
                        UIImage *image = (UIImage *)sprit;
                        image = [image getSubImage:value];
                    if (isSave) {
                        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:url];
                    }
                        dispatch_group_leave(dispatchGroup);

//                        [selfWeak.svgImageView setImage:image forKey:selfWeak.model.replaceHeaderAroundKey];

//                    }else{
//                        //静态图片
////                        [selfWeak.svgImageView setImage:sprit forKey:selfWeak.model.replaceHeaderAroundKey];
//                        [[SDWebImageManager sharedManager] saveImageToCache:sprit forURL:url];
//                        dispatch_group_leave(dispatchGroup);
//                    }
                    
                } failureBlock:^(NSError * _Nullable error) {
                    dispatch_group_leave(dispatchGroup);
                }];
            }
            
        }else{
            dispatch_group_leave(dispatchGroup);
        }
    });
    NSString *fileNewPath = [[SDImageCache sharedImageCache] defaultCachePathForKey:selfWeak.model.mp4Url];
//    fileNewPath = [fileNewPath stringByAppendingFormat:@".mp4"];
    if (self.type == XCAniMp4 && ![[SDImageCache sharedImageCache] diskImageDataExistsWithKey:selfWeak.model.mp4Url]) {
        dispatch_group_async(dispatchGroup, dispatchQueue, ^{
            dispatch_group_enter(dispatchGroup);
            [HttpRequestHelper handelDownloadWithFileUrlPath:self.model.mp4Url saveFilePath:fileNewPath success:^(NSURLResponse *response, NSURL *filePath) {
                dispatch_group_leave(dispatchGroup);
            } fail:^(NSInteger *resCode, NSString *message) {
                [[SDImageCache sharedImageCache] removeImageForKey:selfWeak.model.mp4Url withCompletion:nil];
                dispatch_group_leave(dispatchGroup);
            }];
        });
    }
    
    dispatch_group_notify(dispatchGroup, mainQueue, ^{
        if (self.type == XCAniImageSVGA) {
            [self playSvgaViewAction];
        }else if (self.type == XCAniMp4){
            [self playVAPViewWithPath:fileNewPath];
        }
    });
   
}
#pragma mark -- 融合特效的接口 vapx

//provide the content for tags, maybe text or url string ...
- (NSString *)contentForVapTag:(NSString *)tag resource:(QGVAPSourceInfo *)info {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    [dic safeSetObject:self.model.replaceNickName forKey:self.model.replaceNickKey];

    return dic[tag];
}


//provide image for url from tag content
- (void)loadVapImageWithURL:(NSString *)urlStr context:(NSDictionary *)context completion:(VAPImageCompletionBlock)completionBlock {
    UIImage *image = nil;
    if ([urlStr isEqualToString: self.model.replaceKey]) {
         image = [self getSdDiskCacheWithKey:self.model.replaceUrl];
    }else if ([urlStr isEqualToString: self.model.replaceHeaderAroundKey]){ //urlStr 和资源文件的key一致
        NSString *headerWearKey = [self getHeaderWearUrl];

         image = [self getSdDiskCacheWithKey:headerWearKey];  //以url地址为key
    }
    //call completionBlock as you get the image, both sync or asyn are ok.
    //usually we'd like to make a net request
    dispatch_async(dispatch_get_main_queue(), ^{
        //let's say we've got result here
        completionBlock(image, nil, urlStr);
    });
}


- (void)viewDidStopPlayMP4:(NSInteger)lastFrameIndex view:(VAPView *)container {
    if (self.model.finshCallBack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hidden = YES;  //因为这里老是引起崩溃，所以不在block回调处理
            self.model.finshCallBack(nil);
        });
    }
}

- (BOOL)isPlaySvga{
    if (self.svgImageView.videoItem == nil) {
        return NO;
    }
    return YES;
}

- (void)clearVideoItem{
    [self.svgImageView clear];
}


- (XCAniImageConfigurSvgaModel *)svgaModel{
    return self.model;
}

- (SVGAImageView *)svgImageView {
    if (_svgImageView == nil) {
        _svgImageView = [[SVGAImageView alloc] init];
        _svgImageView.autoPlay = YES;
        _svgImageView.delegate = self;
        [self insertSubview:_svgImageView atIndex:0];
        [_svgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(self);
        }];
    }
    return _svgImageView;
}

- (YYAnimatedImageView *)gifImageView{
    if (!_gifImageView) {
        _gifImageView = [[YYAnimatedImageView alloc] init];
        [self insertSubview:_gifImageView atIndex:0];
        [_gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(self);
        }];
    }
    return _gifImageView;
}

- (YYAnimatedImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[YYAnimatedImageView alloc] init];

    }
    return _headerImageView;
}

- (SVGAParserManager *)parserManager {
    if (_parserManager == nil) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}

- (SpriteSheetImageManager *)sheetManager{
    if (!_sheetManager) {
        _sheetManager = [[SpriteSheetImageManager alloc] init];
    }
    return _sheetManager;
}

- (NSString *)getHeaderWearUrl{
    NSString *replaceHeaderAroundUrl = nil;
    if (self.model.staticPic.length > 0) {
        replaceHeaderAroundUrl = self.model.staticPic;
    }else{
        replaceHeaderAroundUrl = self.model.replaceHeaderAroundUrl;
    }
    return replaceHeaderAroundUrl;
}

- (UIImage *)getSdDiskCacheWithKey:(NSString *)key{
    if ([[SDImageCache sharedImageCache] diskImageDataExistsWithKey:key]) {
        //网络下载的资源文件
        return [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
    }else if (![key containsString:@"http"]){
        //本地资源文件 贵族头饰
        UIImage *image = [GetCore(NobleCore) findNobleSourceBySourceId:key];
        return image;
    }
    return nil;
}
@end


@implementation XCAniImageConfigurSvgaModel

- (int)playCount{
    if (_playCount == 0) {
        _playCount = INT_MAX;
    }
    return _playCount;
}

@end
