//
//  TTApprenticeAcceptView.m
//  TTPlay
//
//  Created by Macx on 2019/1/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTApprenticeAcceptView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>
#import "XCMentoringShipAttachment.h"

@interface TTApprenticeAcceptView ()
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;

/** lineView */
@property (nonatomic, strong) UIView *lineView;
/** resultLabel */
@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation TTApprenticeAcceptView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
- (void)didClickAgreeButton:(UIButton *)btn {
    if (self.agreeButtonDidClickBlcok) {
        self.agreeButtonDidClickBlcok();
    }
}

- (void)didClickRejectButton:(UIButton *)btn {
    if (self.rejectButtonDidClickBlcok) {
        self.rejectButtonDidClickBlcok();
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.rejectButton];
    [self.contentView addSubview:self.agreeButton];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.resultLabel];
    
    [self.agreeButton addTarget:self action:@selector(didClickAgreeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rejectButton addTarget:self action:@selector(didClickRejectButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(9);
        make.right.mas_equalTo(self).offset(-9);
        make.top.mas_equalTo(self).offset(20);
        make.bottom.mas_equalTo(self).offset(-60);
    }];
    
    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(50);
        make.bottom.mas_equalTo(self).offset(-15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(26);
    }];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-50);
        make.bottom.mas_equalTo(self).offset(-15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(26);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.bottom.mas_equalTo(self).offset(-40);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-13);
    }];
}

#pragma mark - getters and setters

- (void)setAppenticeAcceptAttach:(XCMentoringShipAttachment *)appenticeAcceptAttach {
    _appenticeAcceptAttach = appenticeAcceptAttach;
    for (int i =0 ; i < appenticeAcceptAttach.content.count; i++) {
        if (i == 0) {
            self.titleLabel.text = appenticeAcceptAttach.content[i];
        }
    }
    if (appenticeAcceptAttach.apprenticeAgree) {
        self.resultLabel.text = @"已同意";
        self.resultLabel.textColor = UIColorFromRGB(0x09BB07);
        self.agreeButton.hidden = YES;
        self.rejectButton.hidden = YES;
        self.resultLabel.hidden = NO;
        self.lineView.hidden = NO;
    }else if (appenticeAcceptAttach.apprenticeReject){
        self.resultLabel.text = @"已拒绝";
        self.resultLabel.textColor = UIColorFromRGB(0xFF3852);
        self.agreeButton.hidden = YES;
        self.rejectButton.hidden = YES;
        self.resultLabel.hidden = NO;
        self.lineView.hidden = NO;
    }else{
        self.agreeButton.hidden = NO;
        self.rejectButton.hidden = NO;
        self.resultLabel.hidden = YES;
        self.lineView.hidden = YES;
    }
    //如果是徒弟在拒绝师傅的时候已经同意了另一个师傅的邀请 那么就拒绝失败
    if (appenticeAcceptAttach.apprenticeAgreeFail) {
        self.rejectButton.enabled = !appenticeAcceptAttach.apprenticeAgreeFail;
        self.agreeButton.enabled = !appenticeAcceptAttach.apprenticeAgreeFail;
         self.rejectButton.layer.borderColor = [UIColorFromRGB(0xdbdbdb) CGColor];
         self.rejectButton.layer.borderColor = [UIColorFromRGB(0xdbdbdb) CGColor];
        [self.agreeButton setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
         [self.agreeButton setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
    }
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(26, 26, 26);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIButton *)rejectButton {
    if (!_rejectButton) {
        _rejectButton = [[UIButton alloc] init];
        [_rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_rejectButton setTitle:@"拒绝" forState:UIControlStateDisabled];
        [_rejectButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_rejectButton setTitleColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        _rejectButton.layer.cornerRadius = 13;
        _rejectButton.layer.masksToBounds = YES;
        _rejectButton.layer.borderWidth = 1;
        _rejectButton.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _rejectButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rejectButton;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc] init];
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setTitle:@"同意" forState:UIControlStateDisabled];
        [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        _agreeButton.layer.cornerRadius = 13;
        _agreeButton.layer.masksToBounds = YES;
        _agreeButton.backgroundColor = [XCTheme getTTMainColor];
        _agreeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _agreeButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    return _lineView;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.font = [UIFont systemFontOfSize:12];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resultLabel;
}

@end
