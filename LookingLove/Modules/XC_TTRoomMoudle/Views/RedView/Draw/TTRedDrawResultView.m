//
//  TTRedDrawResultView.m
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/19.
//

#import "TTRedDrawResultView.h"

#import <Masonry.h>
#import <UICountingLabel.h>
#import "XCTheme.h"

@interface TTRedDrawResultView()
@property (nonatomic, strong) UIImageView *colorBgView;


@property (nonatomic, strong) UIImageView *underBgView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UICountingLabel *priceView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel*supplementLabel;
@property (nonatomic, strong) UILabel*unitLabel;

@property (nonatomic, assign) TTRedDrawResultViewType type;
@property (nonatomic, strong) NSString * _Nullable  data;
@end


@implementation TTRedDrawResultView

- (instancetype)initWithType:(TTRedDrawResultViewType)type data:(NSString * _Nullable) data {
    if (self == [super init]) {
        self.type = type;
        self.data = data;
        [self initViews];
        [self initConstrations];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //延迟响应发红包，解决抢红包误操作
            self.sendButton.userInteractionEnabled = YES;
        });
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.colorBgView];
    [self.bgView addSubview:self.underBgView];
    [self.bgView addSubview:self.sendButton];
    [self.bgView addSubview:self.recordButton];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.supplementLabel];
}

- (void)initConstrations {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.equalTo(@295);
        make.height.equalTo(@385);
    }];
    
    [self.colorBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView.mas_top).offset(15);
    }];
    
    [self.underBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.bgView);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.underBgView.mas_centerX);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-51);
    }];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.underBgView.mas_centerX);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        if (self.type == TTRedDrawResultViewTypeOver) {
            make.top.equalTo(self.colorBgView.mas_top).offset(89.5);
        } else if (self.type == TTRedDrawResultViewTypeSnow) {
            make.top.equalTo(self.colorBgView.mas_top).offset(80);
        } else if (self.type == TTRedDrawResultViewTypeSuccess) {
            make.top.equalTo(self.colorBgView.mas_top).offset(45);
        }
    }];
    
    [self.supplementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        if (self.type == TTRedDrawResultViewTypeOver) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(23.5);
        } else if (self.type == TTRedDrawResultViewTypeSnow) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(21.5);
        } else if (self.type == TTRedDrawResultViewTypeSuccess) {
            make.bottom.equalTo(self.underBgView.mas_top).offset(-20);
        }
    }];
    
    if (self.type == TTRedDrawResultViewTypeSuccess) {
        [self.bgView addSubview:self.priceView];
        [self.bgView addSubview:self.unitLabel];
        [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.bgView.mas_top).offset(119);
            make.width.equalTo(self.bgView);
            make.height.equalTo(@50);
        }];
        
        [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.priceView.mas_bottom).offset(4);
        }];
        
    }
}

#pragma mark - Public
/// 金额增加动画
- (void)countAnimation {
    if (self.type == TTRedDrawResultViewTypeSuccess) {
        [self.priceView countFromZeroTo:[self.data floatValue]];
    }
}

#pragma mark - Action
- (void)sendButtonClick {
    self.resultViewBlock(TTRedDrawResultViewActionSend);
}

- (void)recordButtonClick {
    self.resultViewBlock(TTRedDrawResultViewActionRecord);
}


#pragma mark - Setter && Getter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"room_red_list_bg"];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
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
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"redbag_resend_btn"] forState:normal];
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.userInteractionEnabled = NO;
    }
    return _sendButton;
}
//
- (UICountingLabel *)priceView {
    if (!_priceView) {
        _priceView = [[UICountingLabel alloc] init];
        _priceView.format = @"%d";
        _priceView.animationDuration = 0.5;
        _priceView.textAlignment = NSTextAlignmentCenter;
        _priceView.textColor = UIColorFromRGB(0xFB5049);
        _priceView.font = [UIFont systemFontOfSize:50];
            }
    return _priceView;
}

- (UIImageView *)colorBgView {
    if (!_colorBgView) {
        _colorBgView = [UIImageView new];
        if (self.type == TTRedDrawResultViewTypeOver) {
            _colorBgView.image = [UIImage imageNamed:@"redbag_white_bg"];
        } else {
            _colorBgView.image = [UIImage imageNamed:@"redbag_glod_bg"];
        }
    }
    return _colorBgView;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton new];
        [_recordButton setTitle:@"红包记录>" forState:normal];
        [_recordButton addTarget:self action:@selector(recordButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton setTitleColor:UIColorFromRGB(0xFFFBF48) forState:normal];
        _recordButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    }
    return _recordButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:22];
        if (self.type == TTRedDrawResultViewTypeSuccess) {
            _titleLabel.text = @"哇！抢到了";
            _titleLabel.textColor = UIColorFromRGB(0xFFB5049);
        } else if (self.type == TTRedDrawResultViewTypeSnow) {
            _titleLabel.text = @"哎呀，手慢了";
            _titleLabel.textColor = UIColorFromRGB(0xFFB5049);
        } else if (self.type == TTRedDrawResultViewTypeOver) {
            _titleLabel.text = @"红包已过期";
            _titleLabel.textColor = UIColorFromRGB(0x666666);
        }
    }
    return _titleLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [UILabel new];
        _unitLabel.text = @"金币";
        _unitLabel.textColor = UIColorFromRGB(0xFB5049);
        _unitLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _unitLabel;
}

- (UILabel *)supplementLabel {
    if (!_supplementLabel) {
        _supplementLabel = [UILabel new];
        _supplementLabel.numberOfLines = 0;
        _supplementLabel.textColor = UIColorRGBAlpha(0x666666, 0.5);
        _supplementLabel.textAlignment = NSTextAlignmentCenter;
        if (self.type == TTRedDrawResultViewTypeSuccess) {
            _supplementLabel.text = @"红包已放入你的金币余额咯";
            _supplementLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        } else if (self.type == TTRedDrawResultViewTypeSnow || self.type == TTRedDrawResultViewTypeOver) {
            _supplementLabel.text = @"没关系啊\n下次再努力嘛";
            _supplementLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        }
    }
    return _supplementLabel;
}

@end
