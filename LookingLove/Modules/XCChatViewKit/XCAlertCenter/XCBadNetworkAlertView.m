//
//  XCBadNetworkAlertView.m
//  XCChatViewKit
//
//  Created by 卫明何 on 2018/9/11.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "XCBadNetworkAlertView.h"
//theme
#import "XCTheme.h"

//3rd part
#import <Masonry/Masonry.h>

typedef enum : NSUInteger {
    XCBadNetworkAlertViewClickType_Confirm = 1, //确定点击
    XCBadNetworkAlertViewClickType_Cancel = 2,  //取消点击
} XCBadNetworkAlertViewClickType;

@interface XCBadNetworkAlertView ()

/**
 弹框默认背景View
 */
@property (strong, nonatomic) UIView *mainView;

/**
 描述View
 */
@property (strong, nonatomic) UILabel *descLabel;

/**
 标题View
 */
@property (strong, nonatomic) UILabel *titleLabel;

/**
 取消按钮
 */
@property (strong, nonatomic) UIButton *cancelButton;

/**
 确定按钮
 */
@property (strong, nonatomic) UIButton *confirmButton;

/**
 按钮上面的一根线
 */
@property (strong, nonatomic) UIView *lineView;

/**
 按钮之间的一根线
 */
@property (strong, nonatomic) UIView *buttonLineView;

@end

@implementation XCBadNetworkAlertView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)desc cancel:(CancelClickBlock)cancel confirm:(ConfirmClickBlock)confirm {
    if (self = [super initWithFrame:frame]) {
        self.closeClickBlock = cancel;
        self.confirmClickBlock = confirm;
        self.descLabel.text = desc;
        self.titleLabel.text = title;
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

- (void)onAlertViewButtonClick:(UIButton *)sender {
    switch (sender.tag) {
        case XCBadNetworkAlertViewClickType_Confirm:
        {
            if (self.confirmClickBlock) {
                self.confirmClickBlock();
            }
        }
            break;
        case XCBadNetworkAlertViewClickType_Cancel:
        {
            if (self.closeClickBlock) {
                self.closeClickBlock();
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - private method

- (void)initView {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.7, 95);
    self.backgroundColor = UIColorRGBAlpha(0x000000, 0.3);
    self.mainView.layer.cornerRadius = 8.f;
    self.mainView.layer.masksToBounds = YES;
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.descLabel];
    [self.mainView addSubview:self.titleLabel];
    [self.mainView addSubview:self.lineView];
    [self.mainView addSubview:self.cancelButton];
    [self.mainView addSubview:self.buttonLineView];
    [self.mainView addSubview:self.confirmButton];
}

- (void)initConstrations {
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.7);
        make.top.mas_equalTo(self.titleLabel.mas_top).offset(-20);
        make.bottom.mas_equalTo(self.cancelButton.mas_bottom);
        make.centerX.mas_equalTo(self.descLabel);
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(self.mainView.mas_width).offset(-40);
        make.bottom.mas_equalTo(self.descLabel.mas_top).offset(-10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.mainView.mas_width).offset(-40);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mainView.mas_leading);
        make.trailing.mas_equalTo(self.mainView.mas_trailing);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.cancelButton.mas_top);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mainView.mas_leading);
        make.height.mas_equalTo(44);
        make.trailing.mas_equalTo(self.buttonLineView.mas_leading);
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(15);
    }];
    [self.buttonLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.centerX.mas_equalTo(self.mainView.mas_centerX);
        make.bottom.mas_equalTo(self.mainView.mas_bottom);
        make.top.mas_equalTo(self.lineView.mas_bottom);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.buttonLineView.mas_trailing);
        make.trailing.mas_equalTo(self.mainView.mas_trailing);
        make.bottom.mas_equalTo(self.mainView.mas_bottom);
        make.height.width.mas_equalTo(self.cancelButton);
    }];
}

#pragma mark - getters and setters

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc]init];
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightRegular];
        _descLabel.textColor = UIColorFromRGB(0x000000);
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:17.f weight:UIFontWeightMedium];
        _titleLabel.textColor = UIColorFromRGB(0x000000);
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = UIColorRGBAlpha(0x1a1a1a, 0.1);
    }
    return _lineView;
}

- (UIView *)buttonLineView {
    if (!_buttonLineView) {
        _buttonLineView = [[UIView alloc]init];
        _buttonLineView.backgroundColor = UIColorRGBAlpha(0x1a1a1a, 0.1);
    }
    return _buttonLineView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        _cancelButton.tag = XCBadNetworkAlertViewClickType_Cancel;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onAlertViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        _confirmButton.tag = XCBadNetworkAlertViewClickType_Confirm;
        [_confirmButton setTitle:@"设置" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColorFromRGB(0x4579FB) forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onAlertViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
