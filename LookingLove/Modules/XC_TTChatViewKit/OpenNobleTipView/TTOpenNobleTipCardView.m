//
//  TTOpenNobleTipCardView.m
//  TuTu
//
//  Created by KevinWang on 2018/11/19.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTOpenNobleTipCardView.h"
#import "TTOpenNobleTipCardView+Private.h"
//t
#import <YYLabel.h>
#import <YYText.h>
#import <Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"


@interface TTOpenNobleTipCardView()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) YYLabel *needNobleLabel;
@property (nonatomic, strong) YYLabel *currentNobleLabel;
@property (nonatomic, strong) UIImageView *nobleImageView;
@property (nonatomic, strong) UIImageView *openNobleImageView;
@property (nonatomic, strong) UIImageView *closeImageView;


@end

@implementation TTOpenNobleTipCardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
        
    }
    return self;
}

#pragma mark - puble method
- (instancetype)initWithCurrentLevel:(NSString *)currentLevel doAction:(NSString *)action needLevel:(NSString *)needLevel{
    
    TTOpenNobleTipCardView *tipCard = [[TTOpenNobleTipCardView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    tipCard.needNobleLabel.attributedText = [self creatOpenNobleTipCardNeedLevelString:needLevel];
    tipCard.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    tipCard.currentNobleLabel.attributedText = [self creatOpenNobleTipCardCurrentLevelString:currentLevel];
    return tipCard;
}


#pragma mark - Event
- (void)gotoOpenNoble:(UIGestureRecognizer *)recognizer{
    if ([self.delegate respondsToSelector:@selector(openNobleTipCardViewDidGotoOpenNoble:)]) {
        [self.delegate openNobleTipCardViewDidGotoOpenNoble:self];
    }
}
- (void)close:(UIGestureRecognizer *)recognizer{
    if ([self.delegate respondsToSelector:@selector(openNobleTipCardViewDidClose:)]) {
        [self.delegate openNobleTipCardViewDidClose:self];
    }
}

#pragma mark - private method
- (void)setupSubViews{
    [self addSubview:self.bgImageView];
    [self addSubview:self.needNobleLabel];
    [self addSubview:self.currentNobleLabel];
    [self addSubview:self.nobleImageView];
    [self addSubview:self.openNobleImageView];
    [self addSubview:self.closeImageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@322);
        make.width.equalTo(@355);
    }];
    
    [self.needNobleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(55);
        make.left.equalTo(self);
        make.width.equalTo(self);
    }];
    
    [self.currentNobleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.width.equalTo(self);
        make.bottom.equalTo(self.nobleImageView.mas_top);
    }];
    
    [self.nobleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.width.equalTo(@80);
        make.bottom.equalTo(self.openNobleImageView.mas_top).offset(-15);
    }];
    
    [self.openNobleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.width.equalTo(@168);
        make.height.equalTo(@38);
        make.bottom.equalTo(self.bgImageView).offset(-58);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.centerX.equalTo(self.bgImageView);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(-25);
    }];

}

#pragma mark - Getter
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = [UIImage imageNamed:@"room_noble_bg"];//295  274
    }
    return _bgImageView;
}
- (YYLabel *)needNobleLabel{
    if (!_needNobleLabel) {
        _needNobleLabel = [[YYLabel alloc] init];
        _needNobleLabel.textAlignment = NSTextAlignmentCenter;
        _needNobleLabel.numberOfLines = 0;
    }
    return _needNobleLabel;
}
- (YYLabel *)currentNobleLabel{
    if (!_currentNobleLabel) {
        _currentNobleLabel = [[YYLabel alloc] init];
        _currentNobleLabel.textAlignment = NSTextAlignmentCenter;
        _currentNobleLabel.numberOfLines = 1;
    }
    return _currentNobleLabel;
}

- (UIImageView *)nobleImageView{
    if (!_nobleImageView) {
        _nobleImageView = [[UIImageView alloc] init];
        _nobleImageView.userInteractionEnabled = YES;
        _nobleImageView.image = [UIImage imageNamed:@"room_noble_noble"];//218*49
    }
    return _nobleImageView;
}

- (UIImageView *)openNobleImageView{
    if (!_openNobleImageView) {
        _openNobleImageView = [[UIImageView alloc] init];
        _openNobleImageView.userInteractionEnabled = YES;
        _openNobleImageView.image = [UIImage imageNamed:@"room_noble_open"];//218*49
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoOpenNoble:)];
        [_openNobleImageView addGestureRecognizer:tap];
    }
    return _openNobleImageView;
}

- (UIImageView *)closeImageView{
    if (!_closeImageView) {
        _closeImageView = [[UIImageView alloc] init];
        _closeImageView.userInteractionEnabled = YES;
        _closeImageView.image = [UIImage imageNamed:@"room_noble_close"];//15
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        [_closeImageView addGestureRecognizer:tap];
    }
    return _closeImageView;
}

@end
