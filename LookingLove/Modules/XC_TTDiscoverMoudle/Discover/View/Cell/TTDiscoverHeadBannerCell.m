//
//  TTDiscoverHeadBannerCell.m
//  TTPlay
//
//  Created by lee on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDiscoverHeadBannerCell.h"


#import <Masonry/Masonry.h>

#import "SDCycleScrollView.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "TTHomeV4DetailData.h"
#import "BannerInfo.h"
#import "DiscoveryBannerInfo.h"

///banner 纵横比
CGFloat const TTDiscoverHeadBannerCellBannerAspectRatio = 120/345.0f;

@interface TTDiscoverHeadBannerCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation TTDiscoverHeadBannerCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    [self.contentView addSubview:self.cycleScrollView];
}

- (void)initConstraints {
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.right.mas_equalTo(self.contentView).inset(0);
        }];
    }else {
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.right.mas_equalTo(self.contentView).inset(15);
        }];
    }
   
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBannerCellClickHandler:)]) {
        [self.delegate onBannerCellClickHandler:self.headBannerArray[index]];
    }
}

#pragma mark - Getters and Setters
- (void)setHeadBannerArray:(NSArray<DiscoveryBannerInfo *> *)headBannerArray {
    _headBannerArray = headBannerArray;
    NSMutableArray *imageURLs = [NSMutableArray array];
    [headBannerArray enumerateObjectsUsingBlock:^(DiscoveryBannerInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageURLs addObject:obj.bannerPic];
    }];
    self.cycleScrollView.imageURLStringsGroup = imageURLs;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.backgroundColor = [XCTheme getDefaultBgColor];
        _cycleScrollView.layer.cornerRadius = 8;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        _cycleScrollView.autoScrollTimeInterval = 5.0;
//        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill; 那个坑爹的设置的
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_select"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_normal"];
    }
    return _cycleScrollView;
}
@end
