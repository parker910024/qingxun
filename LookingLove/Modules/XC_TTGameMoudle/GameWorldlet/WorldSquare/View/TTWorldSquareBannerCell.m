//
//  TTWorldSquareBannerCell.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldSquareBannerCell.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "SDCycleScrollView.h"

#import "BannerInfo.h"

#import <Masonry/Masonry.h>

///banner 纵横比
CGFloat const TTWorldSquareBannerCellBannerAspectRatio = 80/345.0f;

///顶部留白距离
CGFloat const TTWorldSquareBannerCellTopMargin = 10.0f;

///底部留白距离
CGFloat const TTWorldSquareBannerCellBottomMargin = 0.0f;

@interface TTWorldSquareBannerCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation TTWorldSquareBannerCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Core Protocols
#pragma mark - Event Responses
#pragma mark - Private Methods
- (void)initViews {
    self.contentView.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.cycleScrollView];
}

- (void)initConstraints {
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TTWorldSquareBannerCellTopMargin);
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-TTWorldSquareBannerCellBottomMargin);
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (self.bannerModelArray.count > index) {
        BannerInfo *data = self.bannerModelArray[index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBannerCell:bannerData:)]) {
            [self.delegate didSelectBannerCell:self bannerData:data];
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
    self.cycleScrollView.autoScroll = [imageURLs count] > 1;//大于一张开始轮播
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.backgroundColor = [XCTheme getDefaultBgColor];
        _cycleScrollView.layer.cornerRadius = 12;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 5.0;
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_select"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_normal"];
    }
    return _cycleScrollView;
}

@end

