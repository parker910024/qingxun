//
//  TTSendRedBagTextField.m
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/11.
//

#import "TTSendRedBagTextField.h"

#import "XCTheme.h"
#import <Masonry.h>

@interface TTSendRedBagTextField() 
@property(nonatomic, assign) TTSendRedBagTextFieldType type;
@property(nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTSendRedBagTextField

- (instancetype)initWithType:(TTSendRedBagTextFieldType)type {
    if (self == [super init]) {
        _type = type;
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - Private Method
- (void)initView {
    self.backgroundColor = UIColorFromRGB(0xF9F9F9);
    self.layer.cornerRadius = 10;
}

- (void)initConstrations {
    if (self.type == TTSendRedBagTextFieldTypeCount || self.type == TTSendRedBagTextFieldTypeCoin) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.unitLabel];
        [self addSubview:self.textField];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10.5);
            make.width.equalTo(@60);
        }];
        
        [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-12);
            make.width.equalTo(self.type == TTSendRedBagTextFieldTypeCount ? @(15):@(30));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.right.equalTo(self.unitLabel.mas_left).offset(-1);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(30);
        }];
    } else if (self.type == TTSendRedBagTextFieldTypeCondition) {
        [self addSubview:self.rightImageView];
        [self addSubview:self.textField];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-12);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10.5);
        }];
    } else if (self.type == TTSendRedBagTextFieldTypeMessage) {
        [self addSubview:self.unitLabel];
        [self addSubview:self.textField];
        
        [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-12);
            make.width.equalTo(@40);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10.5);
            make.right.equalTo(self.unitLabel.mas_left).offset(-5);
        }];
    }
}

#pragma mark - Setter && Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _titleLabel.textColor = UIColorFromRGB(0x222222);
        switch (_type) {
            case TTSendRedBagTextFieldTypeCoin:
                _titleLabel.text = @"总金币数";
                break;
                
            case TTSendRedBagTextFieldTypeCount:
                _titleLabel.text = @"红包个数";
                break;
                
            case TTSendRedBagTextFieldTypeMessage:
                _titleLabel.text = @"";
                break;
                
            case TTSendRedBagTextFieldTypeCondition:
                _titleLabel.text = @"";
                break;
                
            default:
                break;
        }
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        switch (_type) {
            case TTSendRedBagTextFieldTypeCoin:
                _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(不低于100）" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorRGBAlpha(0x2C2C2E, 0.3)}];
                _textField.textAlignment = NSTextAlignmentRight;
                break;
                
            case TTSendRedBagTextFieldTypeCount:
                _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(最多100）" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorRGBAlpha(0x2C2C2E, 0.3)}];
                _textField.textAlignment = NSTextAlignmentRight;
                break;
                
            case TTSendRedBagTextFieldTypeMessage:
                _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"大家快来抢红包啊~" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorRGBAlpha(0x2C2C2E, 0.3)}];
                _textField.textAlignment = NSTextAlignmentLeft;
                
                break;
                
            case TTSendRedBagTextFieldTypeCondition:
                _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"设置抢红包条件" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorRGBAlpha(0x2C2C2E, 0.3)}];
                _textField.textAlignment = NSTextAlignmentLeft;
                _textField.userInteractionEnabled = NO;
                break;
                
            default:
                break;
        }
    }
    return _textField;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [UILabel new];
        _unitLabel.textAlignment = NSTextAlignmentRight;
        _unitLabel.textColor = UIColorRGBAlpha(0x2C2C2E, 1);
        _unitLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        switch (_type) {
            case TTSendRedBagTextFieldTypeCoin:
                _unitLabel.text = @"金币";
                break;
                
            case TTSendRedBagTextFieldTypeCount:
                _unitLabel.text = @"个";
                break;
                
            case TTSendRedBagTextFieldTypeMessage:
                _unitLabel.text = @"9/20";
                _unitLabel.textColor = UIColorRGBAlpha(0x2C2C2E, 0.3);
                _unitLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
                break;
                
            case TTSendRedBagTextFieldTypeCondition:
                _unitLabel.text = @"";
                break;
                
            default:
                break;
        }
    }
    return _unitLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.image = [UIImage imageNamed:@"redbag_down_icon"];
    }
    return _rightImageView;
}

@end
