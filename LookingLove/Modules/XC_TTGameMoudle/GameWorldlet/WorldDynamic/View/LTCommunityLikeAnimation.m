//
//  LTCommunityLikeAnimation.m
//  LTChat
//
//  Created by apple on 2019/9/30.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTCommunityLikeAnimation.h"
#import "SVGA.h"
#import "XCCurrentVCStackManager.h"
#import "UIView+NTES.h"
#import "XCMacros.h"

@interface LTCommunityLikeAnimation ()<
SVGAPlayerDelegate
>

///点赞动画
@property (nonatomic, strong) SVGAPlayer *likeSvga;

@end

@implementation LTCommunityLikeAnimation


+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static LTCommunityLikeAnimation *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[LTCommunityLikeAnimation alloc]init];
    });
    return sharedInstance;
}

- (void)showGiveLikeAnimation {
    SVGAParser * parser = [[SVGAParser alloc] init];
    [parser parseWithNamed:@"community_like" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            self.likeSvga.videoItem = videoItem;
            [self.likeSvga startAnimation];
        }
    } failureBlock:nil];
    self.likeSvga.centerY = [XCCurrentVCStackManager shareManager].getCurrentVC.view.height/2.f;
    [[XCCurrentVCStackManager shareManager].getCurrentVC.view addSubview:self.likeSvga];
    [self.likeSvga startAnimation];
}


#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage {
    if (percentage >= 0.99) {
        [self.likeSvga stopAnimation];
        [self.likeSvga removeFromSuperview];
    }
}

- (SVGAPlayer *)likeSvga {
    if (!_likeSvga) {
        SVGAPlayer *svgView = [[SVGAPlayer alloc]initWithFrame:CGRectMake(0, 0, 200,200)];
        svgView.centerX = KScreenWidth/2.f;
        svgView.delegate = self;
        _likeSvga = svgView;
    }
    return _likeSvga;
}

@end
