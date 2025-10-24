//
//  TTSendGiftTipsView.m
//  LookingLove
//
//  Created by Lee on 2020/11/12.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTSendGiftTipsView.h"
#import "XCMacros.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "UIFont+FontCollection.h"
#import "GiftInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XCCurrentVCStackManager.h"
#import "TTWKWebViewViewController.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"

@interface TTSendGiftTipsView ()

@property (nonatomic, strong) UIImageView *bgImageView; // 背景图
@property (nonatomic, strong) UIButton *introductionBtn; // 介绍
@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UILabel *tipsLabel; // 描述

@end

@implementation TTSendGiftTipsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.introductionBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tipsLabel];
}

- (void)initConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self);
        make.width.mas_equalTo(334.75);
        make.height.mas_equalTo(60);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgImageView).offset(15);
        make.top.mas_equalTo(10);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgImageView).offset(-10);
        make.left.mas_equalTo(self.titleLabel);
    }];
    
    [self.introductionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgImageView);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.bgImageView).offset(-15);
    }];
}

- (void)onClickBtnAction:(UIButton *)btn {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
    vc.url = [NSURL URLWithString:self.giftInfo.tips.skipUrl];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    [TTPopup dismiss];
    
    [TTStatisticsService trackEvent:@"room_blind_box_prompt_box" eventDescribe:@"点击盲盒礼物提示框"];
}

- (void)setGiftInfo:(GiftInfo *)giftInfo {
    _giftInfo = giftInfo;
    
    self.titleLabel.text = giftInfo.tips.title;
    self.tipsLabel.text = giftInfo.tips.content;
    self.introductionBtn.hidden = !giftInfo.tips.skipUrl.length;
    if (giftInfo.tips.picUrl.length) {
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:giftInfo.tips.picUrl]];
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"sendGift_tips_bg"];
    }
}

// MARK: - getter && setter
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.layer.cornerRadius = 8;
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont PingFangSC_Semibold_WithFontSize:16];
        _titleLabel.text = @"盲盒随机送";
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = UIColor.whiteColor;
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.text = @"赠送盲盒，随机开出超值礼物";
    }
    return _tipsLabel;
}

- (UIButton *)introductionBtn {
    if (!_introductionBtn) {
        _introductionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_introductionBtn setTitle:@"玩法介绍 " forState:UIControlStateNormal];
        [_introductionBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_introductionBtn setBackgroundColor:UIColorRGBAlpha(0xffffff, 0.2)];
        _introductionBtn.layer.cornerRadius = 30/2;
        _introductionBtn.layer.masksToBounds = YES;
        [_introductionBtn setImage:[UIImage imageNamed:@"community_box_direct"] forState:normal];
        _introductionBtn.hidden = YES;
        [_introductionBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_introductionBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _introductionBtn;
}


@end
