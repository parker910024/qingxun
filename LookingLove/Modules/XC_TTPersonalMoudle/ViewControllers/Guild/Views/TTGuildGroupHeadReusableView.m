//
//  TTGuildGroupHeadReusableView.m
//  TuTu
//
//  Created by lee on 2019/1/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildGroupHeadReusableView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

@interface TTGuildGroupHeadReusableView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *creatGroupChatBtn;
@property (nonatomic, strong) UIView *underLineView;

@end

@implementation TTGuildGroupHeadReusableView

#pragma mark -
#pragma mark lifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}
- (void)initViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.creatGroupChatBtn];
    [self addSubview:self.underLineView];
}

- (void)initConstraints {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(18);
    }];
    
    [self.creatGroupChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.titleLabel);
    }];

    [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
- (void)onClickCreatGroupChatBtnAction:(UIButton *)creatGroupChatBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickCreatGroupChatBtnHandler:)]) {
        [self.delegate onClickCreatGroupChatBtnHandler:creatGroupChatBtn];
    }
}

#pragma mark -
#pragma mark getter & setter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    }
    return _lineView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"厅群聊";
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIButton *)creatGroupChatBtn {
    if (!_creatGroupChatBtn) {
        _creatGroupChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_creatGroupChatBtn setTitle:@"＋ 创建群聊" forState:UIControlStateNormal];
        [_creatGroupChatBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_creatGroupChatBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_creatGroupChatBtn addTarget:self action:@selector(onClickCreatGroupChatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _creatGroupChatBtn.hidden = YES;
    }
    return _creatGroupChatBtn;
}

- (UIView *)underLineView {
    if (!_underLineView) {
        _underLineView = [[UIView alloc] init];
        _underLineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _underLineView;
}

@end
