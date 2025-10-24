//
//  AnchorOrderPickerFooterView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "AnchorOrderPickerFooterView.h"

#import "AnchorOrderStatus.h"

#import "XCTheme.h"

#include <Masonry/Masonry.h>

@interface AnchorOrderPickerFooterView ()
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UIButton *saveButton;//请选择
@end

@implementation AnchorOrderPickerFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化按钮状态
        AnchorOrderInfo *order;
        [self updateButtonStatusWithOrder:order];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.saveButton];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.right.mas_equalTo(self).inset(20);
        }];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(66);
            make.left.right.mas_equalTo(self).inset(27);
            make.height.mas_equalTo(45);
        }];
    }
    return self;
}

#pragma mark - Public
- (void)updateButtonStatusWithOrder:(AnchorOrderInfo *)order {
    
    BOOL valid = order.orderPrice.length
    && order.orderDuration > 0
    && order.orderType.length
    && order.orderValidTime.length;
    
    self.saveButton.userInteractionEnabled = valid;
    self.saveButton.backgroundColor = [[XCTheme getMainDefaultColor] colorWithAlphaComponent:valid ? 1 : 0.5];
}

#pragma mark - Action
- (void)onClickSaveButton:(UIButton *)sender {
    !self.doneHandler ?: self.doneHandler();
}

#pragma mark - Lazy Load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0xFF4A6F);
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"若恶意发布虚假订单，平台将撤销认证主播身份并进行封号处理";
    }
    return _titleLabel;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(onClickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
                
        button.layer.cornerRadius = 22.5;
        button.layer.masksToBounds = YES;
        
//        button.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//        button.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//        button.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
                
        _saveButton = button;
    }
    return _saveButton;
}

@end
