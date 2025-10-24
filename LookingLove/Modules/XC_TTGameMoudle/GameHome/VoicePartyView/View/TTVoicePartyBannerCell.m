//
//  TTVoicePartyBannerCell.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/5.
//

#import "TTVoicePartyBannerCell.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "SDCycleScrollView.h"

#import "BannerInfo.h"

#import <Masonry/Masonry.h>

///banner 纵横比
CGFloat const TTVoicePartyBannerCellBannerAspectRatio = 80/345.0f;

///底部留白距离
CGFloat const TTVoicePartyBannerCellBottomMargin = 26.0f;

@interface TTVoicePartyBannerCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation TTVoicePartyBannerCell

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
        make.top.mas_equalTo(self.contentView);
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-TTVoicePartyBannerCellBottomMargin);
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
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.backgroundColor = [XCTheme getDefaultBgColor];
        _cycleScrollView.layer.cornerRadius = 12;
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

