//
//  XCBoxBuykeyView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCBoxBuykeyView.h"
#import <Masonry.h>
#import "XCTheme.h"

NSInteger keyNumberOperationMinNumber = 10;

@interface XCBoxBuykeyView()

@property (nonatomic, strong) UIView  *contianterView;//内容view

@property (nonatomic, strong) UIView  *buyKeyContentView;//

@property (nonatomic, strong) UIImageView  *keyIcon;//钥匙图标
@property (nonatomic, strong) UILabel  *titleLabel;//购钥匙 标题

//数量
@property (nonatomic, strong) UIView  *keyNumbContianterView;// 数量容器View
@property (nonatomic, strong) UILabel  *numTip;//数量
@property (nonatomic, strong) UIButton  *reduceBtn;//减少按钮
@property (nonatomic, strong) UIButton  *moreBtn;//增加按钮
@property (nonatomic, strong) UIView  *keytextFieldMaskView;//
@property (nonatomic, strong) UITextField  *keyNumberTextField;//钥匙的数量


//消耗的金币
@property (nonatomic, strong) UIView  *priceContianterView;//
@property (nonatomic, strong) UILabel  *priceTip;//价格
@property (nonatomic, strong) UILabel  *pirceLabel;//金币

//操作

@property (nonatomic, strong) UIView  *operationViewContianterView;//操作View
@property (nonatomic, strong) UIButton  *closeBtn;//关闭按钮
@property (nonatomic, strong) UIButton  *buyBtn;//购买按钮


//差多少钥匙
@property (nonatomic, strong) UILabel  *needKeyTitle;//
@property (nonatomic, strong) UILabel  *needKeyDesLabel;//


@end

@implementation XCBoxBuykeyView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithNeedKey {
    if (self = [super init]) {
        _needKeyNumber = 1;
        [self initSubViews];
    }
    return self;
}
#pragma mark - puble method
- (void)setKeyPrice:(NSInteger)keyPrice{
    if (keyPrice==0) {
        keyPrice = 20;
    }
    _keyPrice = keyPrice;
    [self keyNumberChange:self.keyNumberTextField];
}


#pragma makr - Event
- (void)setNeedKeyNumber:(NSInteger)needKeyNumber {
    _needKeyNumber = needKeyNumber;
    [self makeNeedKeyDesLabelText];
}

- (void)setIsDiamondBox:(BOOL)isDiamondBox {
    _isDiamondBox = isDiamondBox;
    
    if (isDiamondBox) { // 至尊蛋
        self.keyIcon.image = [UIImage imageNamed:@"room_box__buy_gold_key"];
        self.titleLabel.text = @"至尊锤子";
    } else {
        self.keyIcon.image = [UIImage imageNamed:@"room_box_normal_key"];
        self.titleLabel.text = @"金蛋锤子";
    }
}

- (void)keyNumberChange:(UITextField *)textField {
    if (textField.text.length > 8) {
        textField.text = [textField.text substringToIndex:8];
    }
    NSInteger keyNum = self.keyNumberTextField.text.integerValue;
    self.pirceLabel.text = [NSString stringWithFormat:@"%ld金币",keyNum*self.keyPrice];
}

//添加钥匙
- (void)moreKeyNumber {
    NSInteger keyNum = self.keyNumberTextField.text.integerValue;
    self.keyNumberTextField.text = [NSString stringWithFormat:@"%ld",keyNum+keyNumberOperationMinNumber];
    self.pirceLabel.text = [NSString stringWithFormat:@"%ld金币",(keyNum + keyNumberOperationMinNumber)*self.keyPrice];
}

//减少钥匙
- (void)reduceKeyNumber {
    NSInteger keyNum = self.keyNumberTextField.text.integerValue;
    //至少一把钥匙
    if (keyNum <= keyNumberOperationMinNumber) {
        self.keyNumberTextField.text = @"1";
        self.pirceLabel.text = [NSString stringWithFormat:@"%ld金币",(long)self.keyPrice];

        return;
    }
    self.keyNumberTextField.text = [NSString stringWithFormat:@"%ld",keyNum - keyNumberOperationMinNumber];
    self.pirceLabel.text = [NSString stringWithFormat:@"%ld金币",(keyNum - keyNumberOperationMinNumber)*self.keyPrice];
}

//关闭
- (void)closeBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelBuyKey)]) {
        [self.delegate cancelBuyKey];
    }
    
    if (self.cancelBuyKeyBlock) {
        self.cancelBuyKeyBlock();
    }
    [self removeFromSuperview];
}


- (void)buyBtnAction {
    
    NSInteger keyNum;
    XCBoxBuyKeyType type = XCBoxBuyKeyType_Buy;
    if (self.needKeyNumber) {
        keyNum = self.needKeyNumber;
        type = XCBoxBuyKeyType_Need;
    }else {
        keyNum = self.keyNumberTextField.text.integerValue;
    }

    if (keyNum < 1) {
        return;
    }

   
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ensureBuyKeyWithKeyNumber:type:)]) {
        [self.delegate ensureBuyKeyWithKeyNumber:keyNum type:type];
    }
    if (self.ensureBuyKeyBlock) {
        self.ensureBuyKeyBlock(keyNum,type);
    }
    
}


#pragma mark - private

- (void)hiddenKeyborad {
    [self endEditing:YES];
}

- (void)makeNeedKeyDesLabelText {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"剩余锤子不足是否另外购买并砸蛋" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x333333),
                                                                                                                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    NSAttributedString *insertString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld把锤子",(long)self.needKeyNumber] attributes:@{NSForegroundColorAttributeName:[XCTheme getTTMainTextColor],
                                                                                                                                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
    [string insertAttributedString:insertString atIndex:12];
    
    self.needKeyDesLabel.attributedText = string;
}



- (void)initSubViews {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyborad)];
    [self addGestureRecognizer:tap];
    [self addSubview:self.contianterView];
    if (self.needKeyNumber) {
        [self.contianterView addSubview:self.needKeyTitle];
        [self.contianterView addSubview:self.needKeyDesLabel];
    }else {
        
        [self.contianterView addSubview:self.buyKeyContentView];
        [self.buyKeyContentView addSubview:self.keyIcon];
        [self.buyKeyContentView addSubview:self.titleLabel];
        //钥匙
        [self.buyKeyContentView addSubview:self.keyNumbContianterView];
        [self.keyNumbContianterView addSubview:self.keytextFieldMaskView];
        [self.keytextFieldMaskView addSubview:self.keyNumberTextField];
        
        [self.keyNumbContianterView addSubview:self.numTip];
        [self.keyNumbContianterView addSubview:self.reduceBtn];
        [self.keyNumbContianterView addSubview:self.moreBtn];
        //价格
        [self.buyKeyContentView addSubview:self.priceContianterView];
        [self.priceContianterView addSubview:self.priceTip];
        [self.priceContianterView addSubview:self.pirceLabel];
    }
    
    //操作
    [self.contianterView addSubview:self.operationViewContianterView];
    [self.operationViewContianterView addSubview:self.closeBtn];
    [self.operationViewContianterView addSubview:self.buyBtn];
    
    [self makeConstarints];
}



- (void)makeConstarints {
    [self.contianterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(100);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(260);
    }];
    
    if(self.needKeyNumber) {
        [self.needKeyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contianterView).offset(38);
            make.centerX.mas_equalTo(self.contianterView);
            make.height.mas_equalTo(17);
        }];
        [self.needKeyDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.needKeyTitle.mas_bottom).offset(20);
            make.left.mas_equalTo(self.contianterView).offset(40);
            make.right.mas_equalTo(self.contianterView).offset(-40);
        }];
    }else {
        
        [self.buyKeyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.contianterView);
            make.bottom.mas_equalTo(self.operationViewContianterView.mas_top);
        }];
        
        [self.keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(60);
            make.top.mas_equalTo(24);
            make.height.width.mas_equalTo(60);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.keyIcon.mas_right).offset(11);
            make.centerY.mas_equalTo(self.keyIcon);
        }];
        
        [self.keyNumbContianterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.keyIcon.mas_bottom).offset(20);
        }];
        
        [self.numTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.keyNumbContianterView);
            make.centerY.mas_equalTo(self.reduceBtn);
        }];
        [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.numTip.mas_right).offset(8);
            make.top.bottom.mas_equalTo(self.keyNumbContianterView);
            make.height.width.mas_equalTo(25);
        }];
        [self.keytextFieldMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.reduceBtn.mas_right).offset(5);
            make.centerY.mas_equalTo(self.reduceBtn);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(75);
        }];
        [self.keyNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.keytextFieldMaskView);
            make.right.mas_equalTo(self.keytextFieldMaskView).offset(-2);
            make.centerY.height.mas_equalTo(self.keytextFieldMaskView);
        }];
        
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.keyNumberTextField.mas_right).offset(5);
            make.right.mas_equalTo(self.keyNumbContianterView);
            make.height.width.mas_equalTo(25);
            make.centerY.mas_equalTo(self.reduceBtn);
        }];
        
        [self.priceContianterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.keyNumbContianterView.mas_bottom).offset(20);
            make.left.width.height.mas_equalTo(self.keyNumbContianterView);
        }];
        
        [self.priceTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(self.priceContianterView);
        }];
        [self.pirceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.mas_equalTo(self.priceContianterView);
            make.left.mas_equalTo(self.reduceBtn);
        }];
    }
    
    
    [self.operationViewContianterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contianterView).offset(-30);
        make.centerX.mas_equalTo(self.contianterView);
        make.height.mas_equalTo(38);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(self.operationViewContianterView);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(105);
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.height.mas_equalTo(self.closeBtn);
        make.left.mas_equalTo(self.closeBtn.mas_right).offset(18);
        make.right.mas_equalTo(self.operationViewContianterView);
    }];
    
}


#pragma mark - Getter && Setter

- (UIView *)contianterView {
    if (!_contianterView) {
        _contianterView = [[UIView alloc] init];
        _contianterView.backgroundColor = [UIColor whiteColor];
        _contianterView.layer.masksToBounds = YES;
        _contianterView.layer.cornerRadius = 5;
    }
    return _contianterView;
}

- (UIView *)buyKeyContentView {
    if (!_buyKeyContentView) {
        _buyKeyContentView = [[UIView alloc] init];

    }
    return _buyKeyContentView;
}

- (UIImageView *)keyIcon {
    if (!_keyIcon) {
        _keyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_small_key"]];
    }
    return _keyIcon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"金蛋锤子";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}

- (UIView *)keyNumbContianterView {
    if (!_keyNumbContianterView) {
        _keyNumbContianterView = [[UIView alloc] init];
    }
    return _keyNumbContianterView;
}

- (UILabel *)numTip {
    if (!_numTip) {
        _numTip = [[UILabel alloc] init];
        _numTip.textColor = UIColorFromRGB(0x666666);
        _numTip.font = [UIFont systemFontOfSize:15];
        _numTip.text = @"数量";
    }
    return _numTip;
}

- (UIButton *)reduceBtn {
    if (!_reduceBtn) {
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceBtn setImage:[UIImage imageNamed:@"reduceKey_icon"] forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(reduceKeyNumber) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"moreKey_icon"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreKeyNumber) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIView *)keytextFieldMaskView {
    if (!_keytextFieldMaskView) {
        _keytextFieldMaskView = [[UIView alloc] init];
    }
    return _keytextFieldMaskView;
}

- (UITextField *)keyNumberTextField {
    if (!_keyNumberTextField) {
        _keyNumberTextField = [[UITextField alloc] init];
        _keyNumberTextField.text = @"10";
        _keyNumberTextField.layer.cornerRadius = 25/2;
        _keyNumberTextField.layer.masksToBounds = YES;
        _keyNumberTextField.textColor = UIColorFromRGB(0x666666);
        _keyNumberTextField.font = [UIFont boldSystemFontOfSize:14];
        _keyNumberTextField.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _keyNumberTextField.keyboardType = UIKeyboardTypePhonePad;
        _keyNumberTextField.textAlignment = NSTextAlignmentCenter;
        [_keyNumberTextField addTarget:self action:@selector(keyNumberChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _keyNumberTextField;
}


- (UIView *)priceContianterView {
    if (!_priceContianterView) {
        _priceContianterView = [[UIView alloc] init];
    }
    return _priceContianterView;
}

- (UILabel *)priceTip {
    if (!_priceTip) {
        _priceTip = [[UILabel alloc] init];
        _priceTip.text = @"价格";
        _priceTip.textColor = UIColorFromRGB(0x666666);
        _priceTip.font = [UIFont systemFontOfSize:15];
        
    }
    return _priceTip;
}

- (UILabel *)pirceLabel {
    if (!_pirceLabel) {
        _pirceLabel = [[UILabel alloc] init];
        _pirceLabel.text = @"200金币";
        _pirceLabel.font = [UIFont boldSystemFontOfSize:15];
        _pirceLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _pirceLabel;
}

- (UIView *)operationViewContianterView {
    if (!_operationViewContianterView) {
        _operationViewContianterView = [[UIView alloc] init];
    }
    return _operationViewContianterView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _closeBtn.layer.masksToBounds = YES;
        _closeBtn.layer.cornerRadius = 19;
        _closeBtn.layer.borderWidth = 2;
        _closeBtn.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        _buyBtn.backgroundColor = [XCTheme getTTMainColor];
        [_buyBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _buyBtn.layer.cornerRadius = 19;
        _buyBtn.layer.borderWidth = 2;
        _buyBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        [_buyBtn addTarget:self action:@selector(buyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

- (UILabel *)needKeyTitle {
    if (!_needKeyTitle) {
        _needKeyTitle = [[UILabel alloc] init];
        _needKeyTitle.text = @"提示";
        _needKeyTitle.font = [UIFont boldSystemFontOfSize:18];
        _needKeyTitle.textColor = UIColorFromRGB(0x333333);
    }
    return _needKeyTitle;
}

- (UILabel *)needKeyDesLabel {
    if (!_needKeyDesLabel) {
        _needKeyDesLabel = [[UILabel alloc] init];
        _needKeyDesLabel.numberOfLines = 0;
    }
    return _needKeyDesLabel;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
