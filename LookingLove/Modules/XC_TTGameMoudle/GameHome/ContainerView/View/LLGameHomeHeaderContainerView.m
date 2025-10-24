//
//  LLGameHomeHeaderContainerView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGameHomeHeaderContainerView.h"

#import "LLGameHomeHeader.h"

#import "XCMacros.h"
#import "XCTheme.h"

#import "HomeV5Category.h"

#import <Masonry/Masonry.h>

@interface LLGameHomeHeaderContainerView ()

/**
 当前容器高度，默认：kNavigationHeight
 */
@property (nonatomic, assign) CGFloat containerViewHeight;

/**
 stack 容器，包含导航栏，banner（如果有），入口（如果有）
 */
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation LLGameHomeHeaderContainerView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public Methods
- (void)configData:(HomeV5Category *)data {
    
    BOOL hasBanner = data.topBanners.count > 0;
    BOOL hasCard = data.firstPageBannerVos.count > 0;

    CGFloat navHeight = kNavigationHeight;
    CGFloat bannerHeight = hasBanner ? [self.bannerView height] : CGFLOAT_MIN;
    CGFloat cardHeight = hasCard ? 110 : CGFLOAT_MIN;
    self.containerViewHeight = navHeight + bannerHeight + cardHeight;
    
    self.bannerView.hidden = !hasBanner;
    self.cardEntranceView.hidden = !hasCard;
    
    self.frame = CGRectMake(0, 0, KScreenWidth, self.containerViewHeight);
    
    self.bannerView.bannerModelArray = [data.topBanners copy];
    self.cardEntranceView.bannerArray = [data.firstPageBannerVos copy];
}

- (CGFloat)height {
    return self.containerViewHeight;
}

#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Event Responses
#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    
    self.backgroundColor = LLGAMEHOME_BASE_COLOR;
    
    self.containerViewHeight = kNavigationHeight;

    self.cardEntranceView.hidden = YES;
    self.bannerView.hidden = YES;
    
    NSArray *subviews = @[self.navView, self.bannerView, self.cardEntranceView];
    
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:subviews];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.distribution = UIStackViewDistributionFill;
    [self addSubview:self.stackView];
}

- (void)initConstraints {
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavigationHeight);
    }];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self.bannerView height]);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Getters and Setters
- (LLGameHomeNavView *)navView {
    if (!_navView) {
        _navView = [[LLGameHomeNavView alloc] init];
    }
    return _navView;
}

- (LLGameHomeEntranceView *)cardEntranceView {
    if (!_cardEntranceView) {
        _cardEntranceView = [[LLGameHomeEntranceView alloc] init];
    }
    return _cardEntranceView;
}

- (LLGameHomeBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[LLGameHomeBannerView alloc] init];
    }
    return _bannerView;
}

@end
