//
//  XCBoxSelecteView.m
///  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCBoxSelecteView.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface XCBoxSelecteView()

@property (nonatomic, strong) UIButton *oneButton;//一次
@property (nonatomic, strong) UIButton *tenButton;//10次
@property (nonatomic, strong) UIButton *hundredButton;//100次
@property (nonatomic, strong) UIButton *autoButton;//自动

@end

@implementation XCBoxSelecteView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        [self buttonDidClick:self.oneButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}
#pragma mark - event response
- (void)buttonDidClick:(UIButton *)button{
    self.oneButton.selected = self.tenButton.selected = self.hundredButton.selected = self.autoButton.selected = NO;
//    self.oneButton.backgroundColor = self.tenButton.backgroundColor = self.hundredButton.backgroundColor = self.autoButton.backgroundColor = UIColorFromRGB(0x081E4A);
    button.selected = YES;
//    button.backgroundColor = UIColorFromRGB(0xAE58F0);
    if (self.BoxSelecteViewBlock) {
        self.BoxSelecteViewBlock(button.tag);
    }
}

#pragma mark - Private
- (void)setupSubviews{
    [self addSubview:self.oneButton];
    [self addSubview:self.tenButton];
    [self addSubview:self.hundredButton];
    [self addSubview:self.autoButton];
}

- (void)setupSubviewsConstraints{
    [self.oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        if (KScreenWidth > 320) {
            make.left.equalTo(self).offset(40);
        } else {
            make.left.equalTo(self).offset(20);
        }
        make.height.equalTo(@(25));
        make.centerY.equalTo(self);
    }];
    [self.tenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.oneButton);
        make.left.equalTo(self.oneButton.mas_right).offset(15);
        make.height.top.equalTo(self.oneButton);
    }];
    [self.hundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.oneButton);
        make.left.equalTo(self.tenButton.mas_right).offset(15);
        make.height.top.equalTo(self.oneButton);
    }];
    [self.autoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.oneButton);
        make.left.equalTo(self.hundredButton.mas_right).offset(15);
        make.height.top.equalTo(self.oneButton);
    }];
}

- (UIButton *)buttonWithTitle:(NSString *)title tag:(int)tag{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"eggCountBtnBg_selected"] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"eggCountBtnBg_unSelected"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    return button;
}

- (void)setIsDiamonBox:(BOOL)isDiamonBox {
    _isDiamonBox = isDiamonBox;
    
    if (isDiamonBox) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                
                [btn setBackgroundImage:[UIImage imageNamed:@"eggCountBtnBg_gold_selected"] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"eggCountBtnBg_gold_unSelected"] forState:UIControlStateNormal];
                
                [btn setTitleColor:UIColorFromRGB(0xC93E0E) forState:UIControlStateSelected];
            }
        }];
    }
}

#pragma mark - Getter
- (UIButton *)oneButton{
    if (!_oneButton) {
        _oneButton = [self buttonWithTitle:@"1次" tag:XCBoxSelectOpenCountTypeOne];
    }
    return _oneButton;
}
- (UIButton *)tenButton{
    if (!_tenButton) {
        _tenButton = [self buttonWithTitle:@"10次" tag:XCBoxSelectOpenCountTypeTen];
    }
    return _tenButton;
}
- (UIButton *)hundredButton{
    if (!_hundredButton) {
        _hundredButton = [self buttonWithTitle:@"100次" tag:XCBoxSelectOpenCountTypeHundred];
    }
    return _hundredButton;
}
- (UIButton *)autoButton{
    if (!_autoButton) {
        _autoButton = [self buttonWithTitle:@"自动砸" tag:XCBoxSelectOpenCountTypeAuto];
    }
    return _autoButton;
}
@end
