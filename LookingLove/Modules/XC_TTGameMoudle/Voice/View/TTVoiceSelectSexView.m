//
//  TTVoiceSelectSexView.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceSelectSexView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "UIImage+_1x1Color.h"
#import <Masonry/Masonry.h>
#import "TTStatisticsService.h"

@interface TTVoiceSelectSexView ()
/** containView */
@property (nonatomic, strong) UIView *containView;
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** sure */
@property (nonatomic, strong) UIButton *sureButton;
/** 筛选性别 */
@property (nonatomic, strong) UILabel *selectSexLabel;
/** sexBGView */
@property (nonatomic, strong) UIView *sexBGView;
/** woman */
@property (nonatomic, strong) UIButton *womanButton;
/** man */
@property (nonatomic, strong) UIButton *manButton;
/** 不限 */
@property (nonatomic, strong) UIButton *unlimitedButton;
@end

@implementation TTVoiceSelectSexView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)setType:(NSInteger)type {
    _type = type;
    
    if (type == 1) {
        self.manButton.selected = YES;
        
        self.womanButton.selected = NO;
        self.unlimitedButton.selected = NO;
    } else if (type == 2) {
        self.womanButton.selected = YES;
        
        self.manButton.selected = NO;
        self.unlimitedButton.selected = NO;
    } else {
        self.unlimitedButton.selected = YES;
        
        self.manButton.selected = NO;
        self.womanButton.selected = NO;
    }
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickWomanButton:(UIButton *)button {
    self.womanButton.selected = YES;
    
    self.manButton.selected = NO;
    self.unlimitedButton.selected = NO;
}

- (void)didClickManButton:(UIButton *)button {
    self.manButton.selected = YES;
    
    self.womanButton.selected = NO;
    self.unlimitedButton.selected = NO;
}

- (void)didClickUnlimitedButton:(UIButton *)button {
    self.unlimitedButton.selected = YES;
    
    self.manButton.selected = NO;
    self.womanButton.selected = NO;
}

- (void)didClickSureButton:(UIButton *)button {
    if (self.manButton.isSelected) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kRequestVoiceBottleListTypeKey];
        [TTStatisticsService trackEvent:@"soundmatch_choiceSex" eventDescribe:@"选择性别-男"];
    } else if (self.womanButton.isSelected) {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:kRequestVoiceBottleListTypeKey];
        [TTStatisticsService trackEvent:@"soundmatch_choiceSex" eventDescribe:@"选择性别-女"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kRequestVoiceBottleListTypeKey];
        [TTStatisticsService trackEvent:@"soundmatch_choiceSex" eventDescribe:@"选择性别-不限"];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceSelectSexView:didClickSureButton:)]) {
        [self.delegate voiceSelectSexView:self didClickSureButton:button];
    }
}

- (void)closeSendGiftView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceSelectSexViewCloseAction:)]) {
        [self.delegate voiceSelectSexViewCloseAction:self];
    }
}

#pragma mark - private method

- (void)initView {
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSendGiftView)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.containView];
    [self.containView addSubview:self.contentView];
    [self.contentView addSubview:self.selectSexLabel];
    [self.contentView addSubview:self.sexBGView];
    [self.sexBGView addSubview:self.womanButton];
    [self.sexBGView addSubview:self.manButton];
    [self.sexBGView addSubview:self.unlimitedButton];
    
    [self.containView addSubview:self.sureButton];
}

- (void)initConstrations {
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(137 + 15 + 51 + 15 + kSafeAreaBottomHeight);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.containView);
        make.height.mas_equalTo(137);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(15);
        make.height.mas_equalTo(51);
    }];
    
    [self.selectSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(15);
    }];
    
    [self.sexBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(55);
        make.height.mas_equalTo(44);
    }];
    
    CGFloat width = (KScreenWidth - (15 * 4)) / 3;
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.sexBGView);
        make.width.mas_equalTo(width);
    }];
    
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.mas_equalTo(self.sexBGView);
        make.width.mas_equalTo(width);
    }];
    
    [self.unlimitedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.sexBGView);
        make.width.mas_equalTo(width);
    }];
}

#pragma mark - getters and setters

- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
    }
    return _containView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 14;
    }
    return _contentView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:RGBCOLOR(77, 77, 77) forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureButton.backgroundColor = [UIColor whiteColor];
        _sureButton.layer.cornerRadius = 14;
        [_sureButton addTarget:self action:@selector(didClickSureButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UILabel *)selectSexLabel {
    if (!_selectSexLabel) {
        _selectSexLabel = [[UILabel alloc] init];
        _selectSexLabel.text = @"筛选性别";
        _selectSexLabel.textColor = [XCTheme getTTMainTextColor];
        _selectSexLabel.font = [UIFont systemFontOfSize:16];
    }
    return _selectSexLabel;
}

- (UIView *)sexBGView {
    if (!_sexBGView) {
        _sexBGView = [[UIView alloc] init];
        _sexBGView.backgroundColor = [UIColor whiteColor];
        _sexBGView.layer.masksToBounds = YES;
        _sexBGView.layer.cornerRadius = 10;
    }
    return _sexBGView;
}

- (UIButton *)womanButton {
    if (!_womanButton) {
        _womanButton = [[UIButton alloc] init];
        [_womanButton setTitle:@"女生" forState:UIControlStateNormal];
        _womanButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_womanButton setTitleColor:RGBACOLOR(51, 51, 51, 0.3) forState:UIControlStateNormal];
        [_womanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_womanButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:[XCTheme getTTSimpleGrayColor]] forState:UIControlStateNormal];
        [_womanButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:RGBCOLOR(255, 96, 110)] forState:UIControlStateSelected];
        [_womanButton addTarget:self action:@selector(didClickWomanButton:) forControlEvents:UIControlEventTouchUpInside];
        _womanButton.adjustsImageWhenHighlighted = NO;
    }
    return _womanButton;
}

- (UIButton *)manButton {
    if (!_manButton) {
        _manButton = [[UIButton alloc] init];
        [_manButton setTitle:@"男生" forState:UIControlStateNormal];
        _manButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_manButton setTitleColor:RGBACOLOR(51, 51, 51, 0.3) forState:UIControlStateNormal];
        [_manButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_manButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:[XCTheme getTTSimpleGrayColor]] forState:UIControlStateNormal];
        [_manButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:RGBCOLOR(88, 200, 254)] forState:UIControlStateSelected];
        [_manButton addTarget:self action:@selector(didClickManButton:) forControlEvents:UIControlEventTouchUpInside];
        _manButton.adjustsImageWhenHighlighted = NO;
    }
    return _manButton;
}

- (UIButton *)unlimitedButton {
    if (!_unlimitedButton) {
        _unlimitedButton = [[UIButton alloc] init];
        [_unlimitedButton setTitle:@"不限" forState:UIControlStateNormal];
        _unlimitedButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_unlimitedButton setTitleColor:RGBACOLOR(51, 51, 51, 0.3) forState:UIControlStateNormal];
        [_unlimitedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_unlimitedButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:[XCTheme getTTSimpleGrayColor]] forState:UIControlStateNormal];
        [_unlimitedButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:RGBCOLOR(142, 122, 248)] forState:UIControlStateSelected];
        [_unlimitedButton addTarget:self action:@selector(didClickUnlimitedButton:) forControlEvents:UIControlEventTouchUpInside];
        _unlimitedButton.adjustsImageWhenHighlighted = NO;
    }
    return _unlimitedButton;
}

@end
