//
//  TTMasterRelieveView.m
//  TTPlay
//
//  Created by Macx on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterRelieveView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>

@interface TTMasterRelieveView ()
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** icon */
@property (nonatomic, strong) UIImageView *iconImageView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** close */
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation TTMasterRelieveView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickCloseButton:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterRelieveView:didClickCloseButton:)]) {
        [self.delegate masterRelieveView:self didClickCloseButton:btn];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.closeButton];
    
    [self.closeButton addTarget:self action:@selector(didClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(295);
        make.height.mas_equalTo(195);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(18);
        make.width.height.mas_equalTo(76);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(100);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-19);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(39);
    }];
}

#pragma mark - getters and setters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"discover_master_delete_success"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"解除成功！";
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _closeButton.backgroundColor = RGBCOLOR(240, 240, 240);
        _closeButton.layer.cornerRadius = 19;
        _closeButton.layer.masksToBounds = YES;
    }
    return _closeButton;
}

@end
