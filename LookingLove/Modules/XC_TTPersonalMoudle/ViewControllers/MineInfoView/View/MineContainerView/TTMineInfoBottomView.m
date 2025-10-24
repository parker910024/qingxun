//
//  TTMineInfoBottomView.m
//  TuTu
//
//  Created by lee on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoBottomView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImage+Utils.h"
#import "XCMacros.h"

@interface TTMineInfoBottomView ()

@property (nonatomic, strong) UIButton *followBtn; // 关注
@property (nonatomic, strong) UIButton *sendMsgBtn; // 私信
@property (nonatomic, strong) UIImageView *followShadowImgView;
@property (nonatomic, strong) UIImageView *sendMsgShadowImgView;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation TTMineInfoBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.sendMsgShadowImgView];
    [self addSubview:self.followShadowImgView];
    [self.followShadowImgView addSubview:self.followBtn];
    [self.sendMsgShadowImgView addSubview:self.sendMsgBtn];
}

- (void)initConstraints {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.followShadowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(164.f, 74.f));
        make.bottom.top.mas_equalTo(self);
        make.left.equalTo(self).offset(21);
    }];
    
    [self.sendMsgShadowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.bottom.top.equalTo(self.followShadowImgView);
        make.right.equalTo(self).inset(21);
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(129.f, 39.f));
        make.center.mas_equalTo(self.followShadowImgView);
    }];
    
    [self.sendMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.followBtn);
        make.center.mas_equalTo(self.sendMsgShadowImgView);
    }];
}

#pragma mark -
#pragma mark btn custom Events
- (void)followBtnClickAction:(UIButton *)btn {
    // 关注 or 取消关注
    !_btnClickHandler ? : _btnClickHandler(btn);
}

- (void)sendMsgBtnClickAction:(UIButton *)btn {
    //  发送私信
    !_btnClickHandler ? : _btnClickHandler(btn);
}

#pragma mark -
#pragma mark getter & setter
- (void)setAttentioned:(BOOL)attentioned {
    _attentioned = attentioned;
//    self.followBtn.selected = attentioned;
    if (attentioned) {
        [self.followBtn setImage:[UIImage imageNamed:@"mineInfo_follow_icon"] forState:UIControlStateNormal];
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        [self.followBtn setImage:[UIImage imageNamed:@"mineInfo_unfollow_icon"] forState:UIControlStateNormal];
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_followBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
        _followBtn.layer.masksToBounds = YES;
        _followBtn.layer.cornerRadius = 20;
        _followBtn.tag = 1001;
        
        [_followBtn addTarget:self action:@selector(followBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_followBtn setBackgroundColor:[XCTheme getTTMainColor]];
        _followBtn.layer.borderWidth = 2;
        _followBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        [_followBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        
    }
    return _followBtn;
}


- (UIButton *)sendMsgBtn {
    if (!_sendMsgBtn) {
        _sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendMsgBtn setTitle:@"私信" forState:UIControlStateNormal];
        [_sendMsgBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_sendMsgBtn setImage:[UIImage imageNamed:@"mineInfo_sendMsg"] forState:UIControlStateNormal];
        [_sendMsgBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
        _sendMsgBtn.layer.masksToBounds = YES;
        _sendMsgBtn.layer.cornerRadius = 20;
        _sendMsgBtn.tag = 1002;
        _sendMsgBtn.backgroundColor = UIColor.whiteColor;
        
        _sendMsgBtn.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        _sendMsgBtn.layer.borderWidth = 2;
        
        [_sendMsgBtn addTarget:self action:@selector(sendMsgBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendMsgBtn;
}

- (UIImageView *)followShadowImgView {
    if (!_followShadowImgView) {
        _followShadowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineInfo_bottomShadow"]];
        _followShadowImgView.userInteractionEnabled = YES;
    }
    return _followShadowImgView;
}

- (UIImageView *)sendMsgShadowImgView {
    if (!_sendMsgShadowImgView) {
        _sendMsgShadowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineInfo_bottomShadow"]];
        _sendMsgShadowImgView.userInteractionEnabled = YES;
    }
    return _sendMsgShadowImgView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        if (iPhoneXSeries) {
            _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineinfo_bottom_BG_xx"]];
        } else {
            _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineinfo_bottom_BG"]];
        }
    }
    return _bgImageView;
}
@end
