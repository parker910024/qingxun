//
//  AnchorOrderPickerCell.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "AnchorOrderPickerCell.h"

#import "XCTheme.h"
#import "XCHUDTool.h"
#import "UIButton+EnlargeTouchArea.h"

#import "AnchorOrderStatus.h"

#include <Masonry/Masonry.h>

@interface AnchorOrderPickerCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *unitLabel;//单位
@property (nonatomic, strong) UIButton *selectButton;//请选择
@property (nonatomic, strong) UITextField *inputTextField;//输入框
@property (nonatomic, strong) UIView *sepatateLine;//分割线
@end

@implementation AnchorOrderPickerCell

#pragma Mark- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.unitLabel];
    [self.contentView addSubview:self.inputTextField];
    [self.contentView addSubview:self.sepatateLine];
}

- (void)initContrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(20);
        make.right.mas_equalTo(self.unitLabel.mas_left).offset(-6);
        make.top.bottom.mas_equalTo(self.contentView).inset(6);
    }];
    
    [self.sepatateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(20);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
}

- (NSString *)titleFromStyle:(AnchorOrderPickerStyle)style {
    switch (style) {
        case AnchorOrderPickerStylePrice:
            return @"价格";
        case AnchorOrderPickerStylePlayTime:
            return @"陪玩时长";
        case AnchorOrderPickerStyleType:
            return @"类型";
        case AnchorOrderPickerStyleEffectTime:
            return @"订单有效时长";
        default:
            return @"";
    }
}

- (void)componentDisplayConfigWithStyle:(AnchorOrderPickerStyle)style {
    switch (style) {
        case AnchorOrderPickerStylePrice:
        {
            self.inputTextField.hidden = NO;
            self.unitLabel.hidden = NO;
            self.selectButton.hidden = YES;
            self.unitLabel.text = @"金币";
        }
            break;
        case AnchorOrderPickerStylePlayTime:
        {
            self.inputTextField.hidden = NO;
            self.unitLabel.hidden = NO;
            self.selectButton.hidden = YES;
            self.unitLabel.text = @"min";
        }
            break;
        case AnchorOrderPickerStyleType:
        {
            self.inputTextField.hidden = YES;
            self.unitLabel.hidden = YES;
            self.selectButton.hidden = NO;
        }
            break;
        case AnchorOrderPickerStyleEffectTime:
        {
            self.inputTextField.hidden = YES;
            self.unitLabel.hidden = YES;
            self.selectButton.hidden = NO;
        }
            break;
        default:
        {
            self.inputTextField.hidden = YES;
            self.unitLabel.hidden = YES;
            self.selectButton.hidden = YES;
        }
            break;
    }
}

- (void)onClickSelectButton:(UIButton *)sender {
    !self.buttonActionHandler ?: self.buttonActionHandler();
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        NSInteger toIntValue = [textField.text integerValue];
        textField.text = @(toIntValue).stringValue;

        if (self.style == AnchorOrderPickerStylePlayTime) {
            if (toIntValue == 0) {
                [XCHUDTool showErrorWithMessage:@"陪玩时长不能小于1分钟哦"];
            }
        }
    }
    
    !self.completeInputHandler ?: self.completeInputHandler(textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.style == AnchorOrderPickerStylePrice) {
        //价格可填写0~99999，最大五位数，超过则限制输入，服务端可配置填写限制
        if (textField.text.length >= 5 && string.length > 0) {
            return NO;
        }
    } else if (self.style == AnchorOrderPickerStylePlayTime) {
        //时长可填写1~999，最大三位数，超过则限制输入，填写0时toast提示【陪玩时长不能小于1分钟哦】，服务端可配置填写限制
        if (textField.text.length >= 3 && string.length > 0) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Lazy Load
- (void)setStyle:(AnchorOrderPickerStyle)style {
    _style = style;
    
    self.titleLabel.text = [self titleFromStyle:style];
    
    [self componentDisplayConfigWithStyle:style];
}

- (void)setOrderInfo:(AnchorOrderInfo *)orderInfo {
    _orderInfo = orderInfo;
    
    switch (self.style) {
        case AnchorOrderPickerStylePrice:
        {
            self.inputTextField.text = self.orderInfo.orderPrice ?: @"";
        }
            break;
        case AnchorOrderPickerStylePlayTime:
        {
            self.inputTextField.text = self.orderInfo.orderDuration>0?@(self.orderInfo.orderDuration).stringValue:@"";
        }
            break;
        case AnchorOrderPickerStyleType:
        {
            [self.selectButton setTitle:self.orderInfo.orderType ?: @"请选择" forState:UIControlStateNormal];
            [self.selectButton setTitleColor:UIColorFromRGB((self.orderInfo.orderType ? 0x2C2C2E : 0xbbbbbb)) forState:UIControlStateNormal];
        }
            break;
        case AnchorOrderPickerStyleEffectTime:
        {
            [self.selectButton setTitle:self.orderInfo.orderValidTime ?: @"请选择" forState:UIControlStateNormal];
            [self.selectButton setTitleColor:UIColorFromRGB((self.orderInfo.orderType ? 0x2C2C2E : 0xbbbbbb)) forState:UIControlStateNormal];
        }
            break;
        default:
        {
        }
            break;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = XCThemeMainTextColor;
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = [UIFont systemFontOfSize:15];
        _unitLabel.textColor = XCThemeMainTextColor;
        [_unitLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        _unitLabel.hidden = YES;
    }
    return _unitLabel;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"home_list_icon_down_noselect"] forState:UIControlStateNormal];
        [button setTitle:@"请选择" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xbbbbbb) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(onClickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
                        
        button.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        button.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        button.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        
        button.hidden = YES;
        
        [button enlargeTouchArea:UIEdgeInsetsMake(6, 20, 6, 10)];

        _selectButton = button;
    }
    return _selectButton;
}

- (UITextField *)inputTextField {
    if (_inputTextField == nil) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.delegate = self;
        _inputTextField.font = [UIFont systemFontOfSize:15];
        _inputTextField.textColor = XCThemeMainTextColor;
        _inputTextField.returnKeyType = UIReturnKeyDone;
        _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        _inputTextField.textAlignment = NSTextAlignmentRight;
        
        _inputTextField.hidden = YES;
    }
    return _inputTextField;
}

- (UIView *)sepatateLine {
    if (!_sepatateLine) {
        _sepatateLine = [[UIView alloc] init];
        _sepatateLine.backgroundColor = UIColorFromRGB(0xf4f4f4);
    }
    return _sepatateLine;
}

@end
