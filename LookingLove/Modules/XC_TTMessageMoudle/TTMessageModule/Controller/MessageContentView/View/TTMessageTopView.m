//
//  TTMessageTopView.m
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageTopView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"

@interface TTMessageTopView ()
/** 好友*/
@property (nonatomic, strong) UIButton * friendButton;
/** 关注*/
@property (nonatomic, strong) UIButton * focusButton;
/** 粉丝*/
@property (nonatomic, strong) UIButton * fansButton;
/** bgView */
@property (nonatomic, strong) UIView *whiteBGView;
@end

@implementation TTMessageTopView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
        
        // 默认选中第一个
        [self updateButtonWithIndex:0];
    }
    return self;
}

#pragma mark - response
- (void)chooseButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButtonToReloadData:)]) {
        [self.delegate didClickButtonToReloadData:sender];
    }
    
    [self updateSelectButton:sender];
}

#pragma mark - private method
- (void)initView{
    self.layer.cornerRadius = 37/2;
    self.layer.masksToBounds = YES;
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:self.whiteBGView];
    [self addSubview:self.friendButton];
    [self addSubview:self.focusButton];
    [self addSubview:self.fansButton];
}

- (void)initContrations{
    CGFloat width = (KScreenWidth - 46)/ 3;
    [self.friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(width);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.centerY.mas_equalTo(self.friendButton);
        make.left.mas_equalTo(self.friendButton.mas_right);
    }];
    
    [self.fansButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.centerY.mas_equalTo(self.focusButton);
        make.left.mas_equalTo(self.focusButton.mas_right);
    }];
    
    [self.whiteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self.friendButton);
        make.width.mas_equalTo(width - 10);
        make.height.mas_equalTo(30);
    }];
}

- (void)updateSelectButton:(UIButton *)selectButton {
    [self layoutIfNeeded];
    self.friendButton.selected = NO;
    self.focusButton.selected = NO;
    self.fansButton.selected = NO;
    CGFloat width = (KScreenWidth - 46)/ 3;
    [self.whiteBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(selectButton);
        make.width.mas_equalTo(width - 10);
        make.height.mas_equalTo(30);
    }];
    
    [UIView animateWithDuration:0.15 animations:^{
        [self layoutIfNeeded];
        selectButton.selected = YES;
    }];
}

#pragma mark - setters and getters
- (void)updateButtonWithIndex:(NSInteger)index {
    UIButton * button;
    if (index == 0) {
        button = self.friendButton;
    } else if (index == 1) {
        button = self.focusButton;
    } else {
        button = self.fansButton;
    }
    [self updateSelectButton:button];
}

- (UIButton *)friendButton{
    if (!_friendButton) {
        _friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_friendButton setTitle:@"好友" forState:UIControlStateNormal];
        [_friendButton setTitle:@"好友" forState:UIControlStateSelected];
        _friendButton.tag = 1000;
        [_friendButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_friendButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        _friendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_friendButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _friendButton.backgroundColor = [UIColor clearColor];
    }
    return _friendButton;
}

- (UIButton *)focusButton{
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [_focusButton setTitle:@"关注" forState:UIControlStateSelected];
        _focusButton.tag = 1001;
        [_focusButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_focusButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        _focusButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_focusButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _focusButton.backgroundColor = [UIColor clearColor];
    }
    return _focusButton;
}

- (UIButton *)fansButton{
    if (!_fansButton) {
        _fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fansButton setTitle:@"粉丝" forState:UIControlStateNormal];
        [_fansButton setTitle:@"粉丝" forState:UIControlStateSelected];
        _fansButton.tag = 1002;
        [_fansButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_fansButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        _fansButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_fansButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _fansButton.backgroundColor = [UIColor clearColor];
    }
    return _fansButton;
}

- (UIView *)whiteBGView {
    if (!_whiteBGView) {
        _whiteBGView = [[UIView alloc] init];
        _whiteBGView.backgroundColor = [UIColor whiteColor];
        _whiteBGView.layer.cornerRadius = 15;
        _whiteBGView.layer.masksToBounds = YES;
    }
    return _whiteBGView;
}

@end
