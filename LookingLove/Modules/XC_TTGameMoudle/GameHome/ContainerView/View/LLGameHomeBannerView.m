//
//  LLGameHomeBannerView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGameHomeBannerView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "SDCycleScrollView.h"

#import "BannerInfo.h"

#import <Masonry/Masonry.h>

///banner 纵横比
CGFloat const LLGameHomeBannerViewBannerAspectRatio = 116/335.0f;

///顶部留白距离
CGFloat const LLGameHomeBannerViewTopMargin = 12.0f;

///底部留白距离
CGFloat const LLGameHomeBannerViewBottomMargin = 6.0f;

///水平留白距离
CGFloat const LLGameHomeBannerViewHoriMargin = 20.0f;

@interface LLGameHomeBannerView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation LLGameHomeBannerView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark - Public Methods
- (CGFloat)height {
    
    CGFloat cycleViewWidth = KScreenWidth - LLGameHomeBannerViewHoriMargin * 2;
    CGFloat cycleViewHeight = cycleViewWidth * LLGameHomeBannerViewBannerAspectRatio;
    CGFloat vertMargin = LLGameHomeBannerViewTopMargin + LLGameHomeBannerViewBottomMargin;
    
    return cycleViewHeight + vertMargin;
}

#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Core Protocols
#pragma mark - Event Responses
#pragma mark - Private Methods
- (void)initViews {
    [self addSubview:self.cycleScrollView];
}

- (void)initConstraints {
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(LLGameHomeBannerViewTopMargin);
        make.left.right.mas_equalTo(self).inset(LLGameHomeBannerViewHoriMargin);
        make.bottom.mas_equalTo(-LLGameHomeBannerViewBottomMargin);
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (self.bannerModelArray.count > index) {
        BannerInfo *data = self.bannerModelArray[index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBannerView:bannerData:)]) {
            [self.delegate didSelectBannerView:self bannerData:data];
        }
    }
}

#pragma mark - Getters and Setters
- (void)setBannerModelArray:(NSArray<BannerInfo *> *)bannerModelArray {
    _bannerModelArray = bannerModelArray;
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    for (BannerInfo *info in bannerModelArray) {
        [imageURLs addObject:info.bannerPic];
    }
    self.cycleScrollView.imageURLStringsGroup = imageURLs;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.backgroundColor = [XCTheme getDefaultBgColor];
        _cycleScrollView.layer.cornerRadius = 10;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        _cycleScrollView.autoScrollTimeInterval = 5.0;
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_select"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_normal"];
    }
    return _cycleScrollView;
}

@end
