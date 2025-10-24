//
//  TTHomeRecommendBannerCell.m
//  TTPlay
//
//  Created by lvjunhang on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTHomeRecommendBannerCell.h"
#import "TTHomeRecommendViewProtocol.h"

#import <Masonry/Masonry.h>

#import "SDCycleScrollView.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "TTHomeV4DetailData.h"
#import "BannerInfo.h"

///banner 纵横比
CGFloat const TTHomeRecommendBannerCellBannerAspectRatio = 120/345.0f;

@interface TTHomeRecommendBannerCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation TTHomeRecommendBannerCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.cycleScrollView];
}

- (void)initConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).inset(8);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(self.contentView).inset(15);
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (self.dataModelArray.count > index) {
        TTHomeV4DetailData *data = self.dataModelArray[index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBannerCell:detailData:)]) {
            [self.delegate didSelectBannerCell:self detailData:data];
        }
        
    } else if (self.bannerModelArray.count > index) {
        BannerInfo *data = self.bannerModelArray[index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBannerCell:bannerData:)]) {
            [self.delegate didSelectBannerCell:self bannerData:data];
        }
    }
}

#pragma mark - Getters and Setters
- (void)setDataModelArray:(NSArray<TTHomeV4DetailData *> *)dataModelArray {
    _dataModelArray = dataModelArray;
    
    self.bgImageView.hidden = YES;
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    for (TTHomeV4DetailData *info in dataModelArray) {
        [imageURLs addObject:info.bannerPic];
    }
    self.cycleScrollView.imageURLStringsGroup = imageURLs;
}

- (void)setBannerModelArray:(NSArray<BannerInfo *> *)bannerModelArray {
    _bannerModelArray = bannerModelArray;
    
    self.bgImageView.hidden = YES;
    
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
        _cycleScrollView.layer.cornerRadius = 21;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        _cycleScrollView.autoScrollTimeInterval = 5.0;
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_select"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_normal"];
    }
    return _cycleScrollView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:iPhoneXSeries ? @"home_nav_bg_footer_iPhoneX" : @"home_nav_bg_footer"];
    }
    return _bgImageView;
}

@end
