//
//  TTLittleWorldNavView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/1.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldNavView.h"
#import "UIButton+EnlargeTouchArea.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTLittleWorldNavView ()
/** 显示标题*/
@property (nonatomic,strong) UILabel *titleLabel;
/** 显示返回按钮*/
@property (nonatomic,strong) UIButton *backButton;
/** 显示分割Ian*/
@property (nonatomic,strong) UIView *sepLineView;

@end

@implementation TTLittleWorldNavView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - response
- (void)backButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goBackDidClick)]) {
        [self.delegate goBackDidClick];
    }
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.backButton];
    [self addSubview:self.sepLineView];
    
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
}

- (void)initContrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self.backButton);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self).offset(-15);
    }];
    
    [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
}

#pragma mark - setters and getters
- (void)setTitle:(NSString *)title {
    _title = title;
    if (_title) {
        self.titleLabel.text = _title;
    }
}

- (void)setIsShowBack:(BOOL)isShowBack {
    _isShowBack = isShowBack;
    self.backButton.hidden = !_isShowBack;
}

- (void)setIsShowLine:(BOOL)isShowLine {
    _isShowLine = isShowLine;
    self.sepLineView.hidden = !_isShowLine;
}

- (UIView *)sepLineView {
    if (!_sepLineView) {
        _sepLineView = [[UIView alloc] init];
        _sepLineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _sepLineView.hidden = YES;
    }
    return _sepLineView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
         [_backButton setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateSelected];
        _backButton.hidden = NO;
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
