//
//  TTUserProtocolView.m
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTUserProtocolView.h"

#import <Masonry/Masonry.h>
#import "NSString+Utils.h"
#import "XCWKWebViewController.h"
#import "XCTheme.h"
#import <YYLabel.h>
@interface TTUserProtocolView ()
/** 选择框 */
@property (nonatomic, strong) UIButton *checkButton;
/** 同意即可登录 */
@property (nonatomic, strong) YYLabel *agreeLabel;
/** 协议 */
@property (nonatomic, strong) UIButton *protocolButton;
@property (nonatomic, assign) BOOL select;
@end

@implementation TTUserProtocolView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)checkButtonClick:(UIButton *)sender
{
    if (self.isHiddenCheck) {
        return;
    }
    if (_select) {
        _select = NO;
        self.checkButton.selected = NO;
    } else {
        _select = YES;
        self.checkButton.selected = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectBtnClicked:)]) {
        [self.delegate onSelectBtnClicked:_select];
    }
}

- (void)onUserProtocolLabelClicked:(UIButton *)sender {
    if (self.nav != nil) {
        XCWKWebViewController *vc = [[XCWKWebViewController alloc]init];
        vc.urlString = self.protocolUrl;
        [self.nav pushViewController:vc animated:YES];
    }
}

- (BOOL)isSelect
{
    return _select;
}

- (CGFloat)getViewWidth
{
    CGFloat width = 0;
    if(_isHiddenCheck)  {
        width = 15 + 7;
    }
    if (_agreementString) {
        CGSize agreeWidth = [NSString sizeWithText:_agreementString font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(200,CGFLOAT_MAX)];
        width = width + agreeWidth.width + 7;
    }
    
    if (_agreementAttString) {
        NSString *agreeString = [_agreementAttString string];
        CGSize agreeWidth = [NSString sizeWithText:agreeString font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(200,CGFLOAT_MAX)];
        width = width + agreeWidth.width + 7;
    }
    
    if (_protocolString) {
        CGSize protocolWidth = [NSString sizeWithText:_protocolString font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(300,CGFLOAT_MAX)];
        width = width + protocolWidth.width + 10;
    }
    return width;
}

#pragma mark - private method

- (void)initView {
    _select = YES;
    [self addSubview:self.checkButton];
    [self addSubview:self.agreeLabel];
    [self addSubview:self.protocolButton];
}

- (void)initConstrations {
    if (!_isHiddenCheck) {
        [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(15);
        }];
        
        [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.checkButton.mas_right).offset(5);
            make.centerY.mas_equalTo(self);
        }];
        
        [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.agreeLabel.mas_right).offset(2);
            make.centerY.mas_equalTo(self);
        }];
    }else{
        [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(22);
            make.centerY.mas_equalTo(self);
        }];
        
        [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.agreeLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self);
        }];
    }
}

#pragma mark - getters and setters

- (void)setIsHiddenCheck:(BOOL)isHiddenCheck {
    _isHiddenCheck =isHiddenCheck;
    self.checkButton.hidden = _isHiddenCheck;
    [self initConstrations];
}

- (void)setAgreementString:(NSString *)agreementString {
    _agreementString = agreementString;
    _agreementString = _agreementString.length > 0 ? _agreementString : @"勾选代表已同意";
    self.agreeLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:_agreementString];
}

- (void)setAgreementAttString:(NSMutableAttributedString *)agreementAttString {
    _agreementAttString = agreementAttString;
    self.agreeLabel.attributedText = _agreementAttString;
}

- (void)setProtocolString:(NSString *)protocolString {
    _protocolString = protocolString;
    [self.protocolButton setTitle:_protocolString forState:UIControlStateNormal];
}

- (void)setProtocolColor:(UIColor *)protocolColor {
    _protocolColor = protocolColor;
    if (_protocolColor) {
        [self.protocolButton setTitleColor:_protocolColor forState:UIControlStateNormal];
    }
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setImage:[UIImage imageNamed:@"auth_login_protocol_unselect"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"auth_login_protocol_select"] forState:UIControlStateSelected];
        _checkButton.selected =YES;
        [_checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

- (YYLabel *)agreeLabel {
    if (!_agreeLabel) {
        _agreeLabel = [[YYLabel alloc] init];
        _agreeLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _agreeLabel.font = [UIFont systemFontOfSize:12];
        _agreeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _agreeLabel;
}

- (UIButton *)protocolButton {
    if (!_protocolButton) {
        _protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _protocolButton.titleLabel.font =[UIFont systemFontOfSize:13];
        _protocolButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_protocolButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_protocolButton addTarget:self action:@selector(onUserProtocolLabelClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolButton;
}

@end
