//
//  TTSendRedBagView.m
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/11.
//

#import "TTSendRedBagView.h"
#import "TTSendRedBagTextField.h"
#import "TTRedbagConditionListView.h"

#import "XCTheme.h"
#import "UIImage+XCCorner.h"
#import <Masonry/Masonry.h>
#import "XCHUDTool.h"
#import <YYLabel.h>
#import "TTPopup.h"
#import "TTStatisticsService.h"

#import "RoomCoreV2.h"
#import "ImRoomCoreV2.h"


@interface TTSendRedBagView() <UITextFieldDelegate>
@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) UIImageView *underBgView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) TTSendRedBagTextField *countTextView;
@property (nonatomic, strong) TTSendRedBagTextField *coinTextView;
@property (nonatomic, strong) TTSendRedBagTextField *conditionTextView;
@property (nonatomic, strong) TTSendRedBagTextField *messageTextView;
@property (nonatomic, strong) TTRedbagConditionListView *listView;
@property (nonatomic, strong) YYLabel *totalPriceLabel;//(总价)
@property (nonatomic, strong) UILabel *poundageLabel;//手续费

@property (nonatomic, assign) int selectConditionValue;//选中的条件ID
@end

@implementation TTSendRedBagView

- (instancetype)init  {
    if (self = [super init]) {
        [self initView];
        [self initConstrations];
        [self showAnmation];
    }
    return self;
}

- (void)showAnmation {
    /* 创建转场动画 */
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3; // 动画时间
    transition.type = kCATransitionReveal; // 动画样式
    transition.subtype = kCATransitionFromTop; // 动画方向
    [self.layer addAnimation:transition forKey:kCATransition];
}

#pragma mark - Private Method
- (void)initView {
    [self addSubview:self.bgView];
    [self addSubview:self.whiteBgView];
    [self addSubview:self.underBgView];
    [self addSubview:self.sendButton];
    [self addSubview:self.countTextView];
    [self addSubview:self.coinTextView];
    [self addSubview:self.conditionTextView];
    [self addSubview:self.messageTextView];
    [self addSubview:self.totalPriceLabel];
    [self addSubview:self.poundageLabel];
    [self addSubview:self.listView];
}

- (void)initConstrations {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.equalTo(@295);
        make.height.equalTo(@385);
    }];
    
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(15);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
    }];
    
    [self.underBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.bgView);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.underBgView.mas_centerX);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-13);
    }];
    
    [self.countTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.whiteBgView).inset(12);
        make.top.equalTo(self.whiteBgView.mas_top).offset(10);
        make.height.equalTo(@45);
    }];
    
    [self.coinTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.whiteBgView).inset(12);
        make.top.equalTo(self.countTextView.mas_bottom).offset(10);
        make.height.equalTo(@45);
    }];
    
    [self.conditionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.whiteBgView).inset(12);
        make.top.equalTo(self.coinTextView.mas_bottom).offset(10);
        make.height.equalTo(@45);
    }];
    
    [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.whiteBgView).inset(12);
        make.top.equalTo(self.conditionTextView.mas_bottom).offset(10);
        make.height.equalTo(@45);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.underBgView.mas_top).offset(26);
    }];
    
    [self.poundageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.totalPriceLabel.mas_bottom).offset(4);
    }];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.conditionTextView);
        make.top.equalTo(self.conditionTextView.mas_bottom).offset(1);
        make.height.equalTo(@136);
    }];
}

- (NSMutableAttributedString *)setTotalPriceAttrStr:(NSString *)string {
    NSString *totalStr = [NSString stringWithFormat:@"需支付%@金币",string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorRGBAlpha(0xFFFFFF, 0.8) range:NSMakeRange(0,totalStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorRGBAlpha(0xFFFFFF, 1) range:NSMakeRange(3, string.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightBold] range:NSMakeRange(0,totalStr.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17 weight:UIFontWeightBold] range:NSMakeRange(3, string.length)];
    return str;
}

/// 通过时间戳返回分秒
- (NSString *)timeWithStamp:(NSString *)timeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue/1000];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.coinTextView.textField) {
        NSInteger price = self.coinTextView.textField.text.integerValue;
        if (price >= self.config.maxAmount && ![string isEqualToString:@""]) {
            return NO;
        }
    } else if (textField == self.countTextView.textField) {
        NSInteger count = self.countTextView.textField.text.integerValue;
        if (count >= self.config.maxNum && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldChanged:(UITextField*)textField {
    if (textField == self.coinTextView.textField) {
        if (self.config.feeSwitch) {
            NSInteger price = self.coinTextView.textField.text.integerValue;
            NSInteger poundage = round(price * (self.config.feeRate));
            NSInteger totalPrice = price + poundage;
            self.totalPriceLabel.attributedText = [self setTotalPriceAttrStr:[NSString stringWithFormat:@"%ld", totalPrice]];
            self.poundageLabel.text = [NSString stringWithFormat:@"包含手续费%ld金币", poundage];
        } else {
            self.totalPriceLabel.attributedText = [self setTotalPriceAttrStr:textField.text];
        }
    }
    if (textField == self.messageTextView.textField) {
        self.messageTextView.unitLabel.text = [NSString stringWithFormat:@"%ld/20",textField.text.length];
        if (textField.text.length == 0) {
            self.messageTextView.unitLabel.text = [NSString stringWithFormat:@"%d/20",9];
        }
    }
    if (self.coinTextView.textField.text.length > 0 && self.countTextView.textField.text.length > 0 && self.conditionTextView.textField.text.length > 0) {
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"redbag_send_botton_on"] forState:normal];
        self.sendButton.userInteractionEnabled = YES;
    } else {
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"redbag_send_botton_off"] forState:normal];
        self.sendButton.userInteractionEnabled = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.countTextView.textField && ![self.countTextView.textField.text isEqualToString:@""]) {
        if ([textField.text integerValue] < self.config.minNum || [textField.text integerValue] > self.config.maxNum) {
            [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"范围在%d~%d之间",self.config.minNum,self.config.maxNum]];
            textField.text = @"";
            self.totalPriceLabel.attributedText = [self setTotalPriceAttrStr:@"0"];
            return;
        }
        
        textField.text = @(textField.text.integerValue).stringValue;
        
    } else if (textField == self.coinTextView.textField && ![self.coinTextView.textField.text isEqualToString:@""]) {
        if ([textField.text integerValue] < self.config.minAmount || [textField.text integerValue] > self.config.maxAmount) {
            [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"范围在%d~%d之间",self.config.minAmount,self.config.maxAmount]];
            textField.text = @"";
            self.totalPriceLabel.attributedText = [self setTotalPriceAttrStr:@"0"];
            return;
        }
        
        textField.text = @(textField.text.integerValue).stringValue;
        
    } else if (textField == self.messageTextView.textField) {
        if (self.messageTextView.textField.text.length > 20) {
            [XCHUDTool showErrorWithMessage:@"超出20个字符"];
            self.messageTextView.textField.text = [self.messageTextView.textField.text substringToIndex:20];
            self.messageTextView.unitLabel.text = [NSString stringWithFormat:@"%ld/20",textField.text.length];
            if (textField.text.length == 0) {
                self.messageTextView.unitLabel.text = [NSString stringWithFormat:@"%d/20",9];
            }
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.listView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action
- (void)conditionClick {
    [self endEditing:YES];
    self.listView.hidden = !self.listView.hidden;
}

- (void)sendButtonClick {
    [self endEditing:YES];
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"提示";
    
    NSInteger price = self.coinTextView.textField.text.integerValue;
    NSInteger count = self.countTextView.textField.text.integerValue;
    
    if (self.config.feeSwitch) {
        NSInteger poundage = round(price * (self.config.feeRate));
        NSInteger total = price + poundage;
        config.message = [NSString stringWithFormat:@"即将支付%ld金币发%ld个红包，包含手续费%ld金币，请老板确认~", total, count, poundage];
    } else {
        config.message = [NSString stringWithFormat:@"即将支付%ld金币发%ld个红包，请老板确认~", price, count];
    }
    
    config.confirmButtonConfig.title = @"确定";
    config.cancelButtonConfig.title = @"取消";
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        [TTStatisticsService trackEvent:@"room_give_red_paper_ensure" eventDescribe:@"确定"];
        
        RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
        NSString *msg = self.messageTextView.textField.text.length>0 ? self.messageTextView.textField.text : @"大家快来抢红包啊~";
        
        [GetCore(RoomCoreV2) requestRoomSendRedByRoomUid:info.uid amount:price num:count requirementType:self.selectConditionValue notifyText:msg completion:^(NSDictionary * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
            if (data) {
                
                [TTStatisticsService trackEvent:@"room_give_red_paper_success" eventDescribe:self.conditionTextView.textField.text];
                
                if (self.sendRedBagSuccessBlock) {
                    self.sendRedBagSuccessBlock();
                }
                NSString *time = [data[@"startTime"] stringValue];
                NSString *message = [NSString stringWithFormat:@"操作成功，红包将于%@开启",[self timeWithStamp:time]];
                [XCHUDTool showSuccessWithMessage:message];
                [self removeFromSuperview];
            }
        }];
    } cancelHandler:^{
        [TTStatisticsService trackEvent:@"room_give_red_paper_ensure" eventDescribe:@"取消"];
    }];
    
}

#pragma mark - Setter && Getter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"room_red_list_bg"];
    }
    return _bgView;
}

- (UIView *)whiteBgView {
    if (!_whiteBgView) {
        _whiteBgView = [UIView new];
        _whiteBgView.layer.cornerRadius = 10;
        _whiteBgView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView;
}

- (UIImageView *)underBgView {
    if (!_underBgView) {
        _underBgView = [UIImageView new];
        _underBgView.image =  [UIImage imageNamed:@"redbag_send_bottom"];
    }
    return _underBgView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton new];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"redbag_send_botton_off"] forState:normal];
        _sendButton.userInteractionEnabled = NO;
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (TTSendRedBagTextField *)countTextView {
    if (!_countTextView) {
        _countTextView = [[TTSendRedBagTextField alloc] initWithType:TTSendRedBagTextFieldTypeCount];
        _countTextView.textField.delegate = self;
        _countTextView.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_countTextView.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _countTextView;
}

- (TTSendRedBagTextField *)coinTextView {
    if (!_coinTextView) {
        _coinTextView = [[TTSendRedBagTextField alloc] initWithType:TTSendRedBagTextFieldTypeCoin];
        _coinTextView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _coinTextView.textField.delegate = self;
        [_coinTextView.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _coinTextView;
}

- (TTSendRedBagTextField *)conditionTextView {
    if (!_conditionTextView) {
        _conditionTextView =  [[TTSendRedBagTextField alloc] initWithType:TTSendRedBagTextFieldTypeCondition];
        _conditionTextView.textField.delegate = self;
        [_conditionTextView.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(conditionClick)];
        [_conditionTextView addGestureRecognizer:ges];
    }
    return _conditionTextView;
}

- (TTSendRedBagTextField *)messageTextView {
    if (!_messageTextView) {
        _messageTextView =  [[TTSendRedBagTextField alloc] initWithType:TTSendRedBagTextFieldTypeMessage];
        _messageTextView.textField.delegate = self;
        [_messageTextView.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _messageTextView.textField.returnKeyType = UIReturnKeyDone;
    }
    return _messageTextView;
}

- (TTRedbagConditionListView *)listView {
    if (!_listView) {
        _listView = [TTRedbagConditionListView new];
        _listView.hidden = YES;
        @weakify(self);
        _listView.conditionListSelectBlock = ^(NSDictionary * _Nonnull dict) {
            @strongify(self);
            self.selectConditionValue = [dict[@"value"] intValue];
            self.conditionTextView.textField.text = dict[@"desc"];
            self.listView.hidden = YES;
            if (self.coinTextView.textField.text.length > 0 && self.countTextView.textField.text.length > 0 && self.conditionTextView.textField.text.length > 0) {
                [self.sendButton setBackgroundImage:[UIImage imageNamed:@"redbag_send_botton_on"] forState:normal];
                self.sendButton.userInteractionEnabled = YES;
            } else {
                [self.sendButton setBackgroundImage:[UIImage imageNamed:@"redbag_send_botton_off"] forState:normal];
                self.sendButton.userInteractionEnabled = NO;
            }
        };
    }
    return _listView;
}

- (YYLabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [YYLabel new];
        _totalPriceLabel.attributedText = [self setTotalPriceAttrStr:@"0"];
    }
    return _totalPriceLabel;
}

- (UILabel *)poundageLabel {
    if (!_poundageLabel) {
        _poundageLabel = [UILabel new];
        _poundageLabel.textColor = UIColorRGBAlpha(0xFFFFFFF, 0.5);
        _poundageLabel.text = @"包含手续费0金币";
        _poundageLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    }
    return _poundageLabel;
}

- (void)setConfig:(RoomRedConfig *)config {
    _config = config;
    
    NSString *maxCoin = [NSString stringWithFormat:@"(最多%d）",config.maxNum];
    self.countTextView.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:maxCoin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorRGBAlpha(0x2C2C2E, 0.3)}];
    
    NSString *minAmount = [NSString stringWithFormat:@"(不低于%d）",config.minAmount];
    self.coinTextView.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:minAmount attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorRGBAlpha(0x2C2C2E, 0.3)}];
    
    self.messageTextView.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:config.defaultNotifyText attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorRGBAlpha(0x2C2C2E, 0.3)}];
    
    self.listView.requireTypeList = config.requireTypeList;
    self.poundageLabel.hidden = !config.feeSwitch;
    if (!config.feeSwitch) {
        [self.sendButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.underBgView.mas_centerX);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-18);
        }];
        [self.totalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.centerX.equalTo(self.mas_centerX);
               make.top.equalTo(self.underBgView.mas_top).offset(31);
           }];
    }
}

@end
