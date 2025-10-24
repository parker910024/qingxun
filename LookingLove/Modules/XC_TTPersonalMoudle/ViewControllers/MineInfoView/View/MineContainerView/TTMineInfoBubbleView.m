//
//  TTMineInfoBubbleView.m
//  TuTu
//
//  Created by lee on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoBubbleView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface TTMineInfoBubbleView ()

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *iconBtn;

@end

@implementation TTMineInfoBubbleView

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        
        [self initViews];
        [self initConstraints];
        [self addTapGesture];
        if (text.length == 0) {
            NSAssert(NO, @"text can not be nil!");
        }
        _textLabel.text = text;
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.numLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.iconBtn];
//    self.backgroundColor = UIColorFromRGB(0xE7D5BB);
}

- (void)initConstraints {
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(10);
    }];
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(10);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)addTapGesture {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGesture)];
    [self addGestureRecognizer:tap];
}

- (void)viewTapGesture {
    !_bubbleClickHandler ? : _bubbleClickHandler();
}
#pragma mark -
#pragma mark getter & setter

- (void)setLineHidden:(BOOL)lineHidden {
    _lineHidden = lineHidden;
    
    if (lineHidden) {
        _lineView.backgroundColor = [UIColor clearColor];
    } else {
        _lineView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setCountNum:(NSString *)countNum {
    _countNum = countNum;

    _numLabel.text = countNum;
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    if (iconName.length == 0) {
        NSAssert(NO, @"iconName can not be nil");
    }
    [_iconBtn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:19.f];
        _numLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _numLabel;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [XCTheme getMSSimpleGrayColor];
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.f];
        _textLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _textLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UIButton *)iconBtn
{
    if (!_iconBtn) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBtn.userInteractionEnabled = NO;
    }
    return _iconBtn;
}
@end
