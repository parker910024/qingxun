//
//  LTDynamicPlayVideoVC.m
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTDynamicPlayVideoVC.h"
//#import "LTChooseSampleView.h"
//#import "KELoadingTool.h"

@interface LTDynamicPlayVideoVC ()


@property (strong, nonatomic) UIImageView *coverImageView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
//模板
//@property(nonatomic, strong)  LTChooseSampleView * sampleView;
@end

@implementation LTDynamicPlayVideoVC

- (BOOL)isHiddenNavBar{
    return YES;
}
- (void)dealloc
{
//    NSLog(@"释放 了LTDynamicPlayVideoVC");
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = UIColorFromRGB(0x000000);
    //创建播放器对象，可以创建多个示例
//    AliyunVodPlayer *aliPlayer = [[AliyunVodPlayer alloc] init];
//    //设置播放器代理
//    aliPlayer.delegate = self;
//
//    self.aliPlayer = aliPlayer;
    
    //获取播放器视图
//    UIView *playerView = aliPlayer.playerView;
//    playerView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
//    //添加播放器视图到需要展示的界面上
//    [self.view addSubview:playerView];
//
//    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //        NSString *docDir = [pathArray objectAtIndex:0];
//    NSString *docDir = [[NSString alloc]initWithFormat:@"%@/%@",[pathArray objectAtIndex:0],KShortVideoDecument]; //在创建播放器类,并在调用prepare方法之前设置。比如：maxSize设置500M时缓存文件超过500M后会优先覆盖最早缓存的文件。maxDuration设置为300秒时表示超过300秒的视频不会启用缓存功能。
//    [self.aliPlayer setPlayingCache:YES saveDir:docDir maxSize:500 maxDuration:300];
//    self.aliPlayer.circlePlay = YES;
//
//    @weakify(self);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        @strongify(self);
//        if (self.videoUrl) {
//            NSURL *url = [NSURL URLWithString:self.videoUrl];
//            [self.aliPlayer prepareWithURL:url];
//        }
//    });
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackAction)];
//    self.view.userInteractionEnabled = YES;
//    [self.view addGestureRecognizer:tap];
//
//    [self.view addSubview:self.coverImageView];
//    self.coverImageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//
//    if (self.coverImage) {
//        CGFloat videoRatio = self.coverImage.size.width * 1.0f / self.coverImage.size.height * 1.0f;
//        CGFloat screenRatio = _aliPlayer.playerView.frame.size.width / _aliPlayer.playerView.frame.size.height;
//        if (videoRatio > screenRatio) {
//            _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
//        }else{
//            _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
//        }
//    }
//    _coverImageView.image = self.coverImage;
//
//    if (self.dynamicModel.tempType>0 && self.dynamicModel.videoContent.length>0) {
//        CGRect ff = CGRectMake(0, kNavigationHeight, KScreenWidth, KScreenHeight-kNavigationHeight - 100);
//        self.sampleView = [[LTChooseSampleView alloc] initWithFrame:ff];
//        [self.view addSubview:self.sampleView];
//        self.sampleView.hidden = NO;
//        [self.sampleView showSampleWithSampleType:self.dynamicModel.tempType content:self.dynamicModel.videoContent];
//
//    }else{
//        self.sampleView.hidden = YES;
//    }
//
////    [self.view addSubview:self.activityView];
////    self.activityView.center = self.view.center;
////    [self.activityView startAnimating];
//    [KELoadingTool showRefreshing];
}

//- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
//    //这里监控播放事件回调
//    //主要事件如下：
//    switch (event) {
//        case AliyunVodPlayerEventPrepareDone:
//            //播放准备完成时触发
//        {
//            if (self.view.window) {
//                [self.aliPlayer start];
////                [self.activityView stopAnimating];
//                [UIView hideHUD];
//            }
//
//        }
//            break;
//        case AliyunVodPlayerEventPlay:
//            //暂停后恢复播放时触发
//            break;
//        case AliyunVodPlayerEventFirstFrame:
//            //播放视频首帧显示出来时触发
//            _coverImageView.hidden = YES;
////            [self.activityView stopAnimating];
//            [UIView hideHUD];
//            break;
//        case AliyunVodPlayerEventPause:
//            //视频暂停时触发
//            break;
//        case AliyunVodPlayerEventStop:
//            //主动使用stop接口时触发
//            break;
//        case AliyunVodPlayerEventFinish:
//            //视频正常播放完成时触发
//            break;
//        case AliyunVodPlayerEventBeginLoading:
//            //视频开始载入时触发
//            break;
//        case AliyunVodPlayerEventEndLoading:
//            //视频加载完成时触发
//            break;
//        case AliyunVodPlayerEventSeekDone:
//            //视频Seek完成时触发
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if (self.aliPlayer.isPlaying) {
//        [self.aliPlayer pause];
//    }
//    [UIView hideHUD];
//}
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    if (self.aliPlayer.isPlaying) {
//        [self.aliPlayer pause];
//    }
//}

- (void)onBackAction{
//    [self.aliPlayer reset];
//    [self.aliPlayer stop];
    [self.navigationController popViewControllerAnimated:NO];
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = [UIColor clearColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.4, 1.4);    // 变大变小调这里即可
        _activityView.transform = transform;
    }
    return _activityView;
}
@end
