//
//  TTDressUpBuyOrPresentView.m
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDressUpBuyOrPresentView.h"
#import "UIImage+Utils.h"
#import "UIView+NTES.h"
//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTDressUpBuyOrPresentView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton  *cancelBtn;//
@property (nonatomic, strong) UIButton  *ensureBtn;//
@property (nonatomic, strong) UIButton  *closeBtn;//
@property (nonatomic, strong) UILabel  *titleLabel;//
@property (nonatomic, strong) UILabel  *messageLabel;//
@property (nonatomic, strong) UILabel  *priceLabel;//
@property (nonatomic, strong) UIView  *VLineView;//
@property (nonatomic, strong) UIView  *HLineView;//
@property (nonatomic, strong) UIButton *coinBtn; // 选择金币
@property (nonatomic, strong) UIButton *carrotBtn;  // 选择萝卜
@property (nonatomic, strong) UILabel *notMoneryTipsLabel; // 萝卜不足 tips
@property (nonatomic, assign) TTDressUpBuyType type; // 使用货币购买方式 0 金币，1 是萝卜
@end
@implementation TTDressUpBuyOrPresentView

- (instancetype)initWithStyle:(TTDressUpViewStyle)style title:(NSString *)title message:(NSString *)message attriMessageString:(NSAttributedString *)attriMessageString priceString:(NSString *)priceString carrotString:(NSString *)carrotString {
    if (self = [super init]) {
        // 设置一个默认宽度，因为是使用 layout 自动适应高度布局，所以要放在所有布局之前
        self.width = 295;
        // 赋值
        _style = style;
        _type = TTDressUpBuyTypeCarrot;
        
        [self initSubViews];
        
        self.titleLabel.text = title;
        
        // 判断是使用普通文本 还是使用富文本内容
        if (message) {
            self.messageLabel.text = message;
        } else if (attriMessageString) {
            self.messageLabel.attributedText = attriMessageString;
        }
            // 双按钮样式
        if (_style == TTDressUpViewStyleBoth) {
            [self setupBothStylePrice:priceString carrotString:carrotString];
        } else {
            // 单价格显示样式
        self.priceLabel.text = [self configPriceString:priceString];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 14;
    self.layer.masksToBounds = YES;
}


- (void)initSubViews {
    // 默认属性
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.ensureBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.cancelBtn];
    
    if (self.style == TTDressUpViewStyleBoth) { //
        [self.contentView addSubview:self.coinBtn];
        [self.contentView addSubview:self.carrotBtn];
    } else if (self.style == TTDressUpViewStyleNotMoney) {
        [self.contentView addSubview:self.notMoneryTipsLabel];
    } else {
        [self.contentView addSubview:self.priceLabel];
    }
    [self makeConstraints];
}

- (void)makeConstraints {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(25);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(26);
        make.left.right.mas_equalTo(self.contentView);
    }];
    
    if (self.style == TTDressUpViewStyleBoth) { // 如果商品两种货币都可以购买
        [self.carrotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(29);
            make.centerX.mas_equalTo(self.contentView);
            make.height.mas_equalTo(22);
        }];
        
        [self.coinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.carrotBtn.mas_bottom).offset(20);
            make.left.mas_equalTo(self.carrotBtn);
            make.height.mas_equalTo(22);
        }];
    } else { // 只支持单种货币，或者货币不足时显示
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(6);
            make.centerX.mas_equalTo(self.contentView);
        }];
    }
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.style == TTDressUpViewStyleBoth) { // 根据风格样式使用不同的布局
            make.top.mas_equalTo(self.coinBtn.mas_bottom).offset(29);
        } else {
            make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(53);
        }
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(120);
        make.right.mas_equalTo(self.contentView.mas_centerX).offset(-8.5);
    }];
    
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).offset(8.5);
        make.width.height.mas_equalTo(self.cancelBtn);
        make.centerY.mas_equalTo(self.cancelBtn);
    }];
}

#pragma mark -
#pragma mark private methods

/**
 设置价格显示样式

 @param priceString 价格
 @return 带单位的价格
 */
- (NSString *)configPriceString:(NSString *)priceString {
    
    NSString *text;
    if (self.style == TTDressUpViewStyleCoin) {
        text = @"金币";
    } else if (self.style == TTDressUpViewStyleCarrot) {
        text = @"萝卜";
    } else if (self.style == TTDressUpViewStyleNotMoney) {
        text = @"";
    }
    NSString *string = [NSString stringWithFormat:@"%@%@", priceString, text];
    
    return string;
}


/**
 设置全价格显示样式

 @param priceString 连个价格显示
 */
- (void)setupBothStylePrice:(NSString *)priceString carrotString:(NSString *)carrotString {
    NSString *coinPrice = [NSString stringWithFormat:@"%@金币", priceString];
    NSString *carrotPrice = [NSString stringWithFormat:@"%@萝卜", carrotString];

    [self.coinBtn setTitle:coinPrice forState:UIControlStateNormal];
    [self.carrotBtn setTitle:carrotPrice forState:UIControlStateNormal];
}
#pragma mark - action

- (void)cancelBtnAction {
    !_cancelBlock ? : _cancelBlock();
}

- (void)ensureBtnAction {
    !_ensureBlock ? : _ensureBlock(_style, _type);
}

// 选择金币
- (void)onClickCoinBtnAction:(UIButton *)coinBtn {
    _type = TTDressUpBuyTypeCoin;
    coinBtn.selected = YES;
    self.carrotBtn.selected = !coinBtn.selected;
    
    [coinBtn setImage:[UIImage imageNamed:@"rabish_icon_hook_selected"] forState:UIControlStateNormal];
    [self.carrotBtn setImage:[UIImage imageNamed:@"rabish_icon_hook_normal"] forState:UIControlStateNormal];
}

// 选择萝卜
- (void)onClickCarrotBtnAction:(UIButton *)carrotBtn {
    _type = TTDressUpBuyTypeCarrot;
    carrotBtn.selected = YES;
    self.coinBtn.selected = !carrotBtn.selected;
    
    [carrotBtn setImage:[UIImage imageNamed:@"rabish_icon_hook_selected"] forState:UIControlStateNormal];
    [self.coinBtn setImage:[UIImage imageNamed:@"rabish_icon_hook_normal"] forState:UIControlStateNormal];
}

#pragma mark - Getter && Setter

- (void)setEnsureBtnTitle:(NSString *)ensureBtnTitle {
    _ensureBtnTitle = ensureBtnTitle;
    [self.ensureBtn setTitle:ensureBtnTitle forState:UIControlStateNormal];
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close_card_logo"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}


- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setBackgroundColor:UIColorFromRGB(0xFEF5ED)];
        _cancelBtn.layer.cornerRadius = 19;
        _cancelBtn.layer.masksToBounds = YES;
        
        [_cancelBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setBackgroundColor:UIColor.whiteColor];
        _cancelBtn.layer.borderWidth = 2;
        _cancelBtn.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(ensureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_ensureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_ensureBtn setBackgroundColor:[XCTheme getTTMainColor]];
        _ensureBtn.layer.cornerRadius = 19;
        _ensureBtn.layer.masksToBounds = YES;
        [_ensureBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_ensureBtn setBackgroundColor:[XCTheme getTTMainColor]];
        _ensureBtn.layer.borderWidth = 2;
        _ensureBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
    }
    return _ensureBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.text = @"购买提示";
        
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textColor = UIColorFromRGB(0x333333);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.textColor = [XCTheme getTTMainColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (UIView *)VLineView {
    if (!_VLineView) {
        _VLineView = [UIView new];
//        _VLineView.backgroundColor = UIColorFromRGB(0xececec);
    }
    return _VLineView;
}
- (UIView *)HLineView {
    if (!_HLineView) {
        _HLineView = [UIView new];
//        _HLineView.backgroundColor = UIColorFromRGB(0xececec);
    }
    return _HLineView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIButton *)coinBtn {
    if (!_coinBtn) {
        _coinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coinBtn setImage:[UIImage imageNamed:@"rabish_icon_hook_normal"] forState:UIControlStateNormal];
        [_coinBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_coinBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        [_coinBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        _coinBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_coinBtn addTarget:self action:@selector(onClickCoinBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_coinBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateSelected];
    }
    return _coinBtn;
}

- (UIButton *)carrotBtn {
    if (!_carrotBtn) {
        _carrotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carrotBtn setImage:[UIImage imageNamed:@"rabish_icon_hook_selected"] forState:UIControlStateNormal];
        [_carrotBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_carrotBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        [_carrotBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        _carrotBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _carrotBtn.selected = YES;
        [_carrotBtn addTarget:self action:@selector(onClickCarrotBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_carrotBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateSelected];
    }
    return _carrotBtn;
}



@end
