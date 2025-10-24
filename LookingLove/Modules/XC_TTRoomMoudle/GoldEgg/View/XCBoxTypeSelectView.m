//
//  XCBoxTypeSelectView.m
//  XCRoomMoudle
//
//  Created by JarvisZeng on 2019/5/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCBoxTypeSelectView.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "XCAlertControllerCenter.h"
#import "XCMacros.h"

@interface XCBoxTypeSelectView ()
@property (nonatomic, strong) UIImageView *normalBoxbg; // 黄金宝箱 bg
@property (nonatomic, strong) UIButton *normalBoxBtn;  // 黄金宝箱 button

@property (nonatomic, strong) UIImageView *diamondBoxbg; // 钻石宝箱 bg
@property (nonatomic, strong) UIButton *diamondBoxBtn; // 钻石宝箱 button
@property (nonatomic, strong) UILabel *diamondBoxTipsLabel; // 钻石宝箱 tips

@property (nonatomic, strong) UIButton *cancelBtn; // dismiss button

@property (nonatomic, assign) BOOL isSelected;
@end

@implementation XCBoxTypeSelectView

#pragma mark - Life Style

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupConstraints];
}

- (void)dealloc {
    NSLog(@"XCBoxTypeSelectView dealloc");
}

#pragma mark - Event Response

- (void)normalBoxBtnClick {
    
    if (self.isSelected) {
        return;
    }
    self.isSelected = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.isSelected = NO;
    });
    
    [self.delegate onBoxTypeSelected:XCBoxSelectType_Normal];
    
}

- (void)diamondBoxBtnClick {
    
    if (self.isSelected) {
        return;
    }
    self.isSelected = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.isSelected = NO;
    });
    [self.delegate onBoxTypeSelected:XCBoxSelectType_Diamond];
}

- (void)cancelBtnClick {
    [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO];
}

#pragma mark - Public

- (void)updateBoxStatus:(BoxStatus *)status {
    [self.diamondBoxBtn setEnabled:status.opening];
    _diamondBoxTipsLabel.text = [NSString stringWithFormat:@"限时：%@ - %@", status.startTime, status.endTime];
}

#pragma mark - Private

- (void)setupSubviews {
    [self addSubview:self.normalBoxbg];
    [self addSubview:self.normalBoxBtn];
    [self addSubview:self.diamondBoxbg];
    [self addSubview:self.diamondBoxBtn];
    [self addSubview:self.diamondBoxTipsLabel];
    [self addSubview:self.cancelBtn];
}

#pragma mark - Layout

- (void)setupConstraints {
    [self.normalBoxbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@120);
        make.left.equalTo(@0);
        make.width.equalTo(@(KScreenWidth * 0.5));
        make.height.equalTo(@270);
    }];
    [self.diamondBoxbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@120);
        make.right.equalTo(@0);
        make.width.equalTo(@(KScreenWidth * 0.5));
        make.height.equalTo(@270);
    }];
    
    [self.normalBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.normalBoxbg.mas_bottom).offset(10);
        make.centerX.equalTo(self.normalBoxbg);
        make.height.equalTo(@38);
        make.width.equalTo(@153);
    }];
    [self.diamondBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.normalBoxbg.mas_bottom).offset(10);
        make.centerX.equalTo(self.diamondBoxbg);
        make.height.equalTo(@38);
        make.width.equalTo(@153);
    }];
    
    [self.diamondBoxTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.diamondBoxBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.diamondBoxbg);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.diamondBoxTipsLabel.mas_bottom).offset(45);
        make.centerX.equalTo(self);
        make.height.width.equalTo(@35);
    }];
}

#pragma mark - Getter
- (UIImageView *)normalBoxbg {
    if (!_normalBoxbg) {
        _normalBoxbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_gold"]];
        _normalBoxbg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _normalBoxbg;
}

- (UIImageView *)diamondBoxbg {
    if (!_diamondBoxbg) {
        _diamondBoxbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_diamond"]];
        _diamondBoxbg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _diamondBoxbg;
}

- (UIButton *)normalBoxBtn {
    if (!_normalBoxBtn) {
        _normalBoxBtn = [[UIButton alloc] init];
        [_normalBoxBtn setImage:[UIImage imageNamed:@"room_box_begain_enable"] forState:UIControlStateNormal];
        [_normalBoxBtn addTarget:self action:@selector(normalBoxBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _normalBoxBtn;
}
- (UIButton *)diamondBoxBtn {
    if (!_diamondBoxBtn) {
        _diamondBoxBtn = [[UIButton alloc] init];
        [_diamondBoxBtn setImage:[UIImage imageNamed:@"room_box_begain_enable"] forState:UIControlStateNormal];
        [_diamondBoxBtn setImage:[UIImage imageNamed:@"room_box_begain_disable"] forState:UIControlStateDisabled];
        [_diamondBoxBtn addTarget:self action:@selector(diamondBoxBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _diamondBoxBtn;
}

- (UILabel *)diamondBoxTipsLabel {
    if (!_diamondBoxTipsLabel) {
        _diamondBoxTipsLabel = [[UILabel alloc] init];
        _diamondBoxTipsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _diamondBoxTipsLabel.textColor = [UIColor whiteColor];
    }
    return _diamondBoxTipsLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"common_close_white_icon"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
