//
//  TTWKGameCloseView.m
//  TTPlay
//
//  Created by new on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWKGameCloseView.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"

@interface TTWKGameCloseView ()
@property (nonatomic, strong) UIButton *closeH5Button; // 关闭
@property (nonatomic, strong) UIButton *voiceH5Button;
@property (nonatomic, strong) UIButton *helpH5Button;
@end

@implementation TTWKGameCloseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initConstraint];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.closeH5Button];
    [self addSubview:self.voiceH5Button];
    [self addSubview:self.helpH5Button];
}

- (void)initConstraint{
    [self.closeH5Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(39, 39));
    }];
    
    [self.voiceH5Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.closeH5Button.mas_right).offset(10);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(39, 39));
    }];
    
    [self.helpH5Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.voiceH5Button.mas_right).offset(10);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(39, 39));
    }];
}

- (void)closeH5Action:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeCurrentPage)]) {
        [self.delegate closeCurrentPage];
    }   
}

- (void)voiceH5Action:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeVoiceCurrentPage)]) {
        [self.delegate changeVoiceCurrentPage];
    }
}

- (void)helpH5Action:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(helpWithCurrentPage)]) {
        [self.delegate helpWithCurrentPage];
    }
}


- (UIButton *)closeH5Button{
    if (!_closeH5Button) {
        _closeH5Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeH5Button setBackgroundImage:[UIImage imageNamed:@"game_h5_close"] forState:UIControlStateNormal];
        [_closeH5Button addTarget:self action:@selector(closeH5Action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeH5Button;
}

- (UIButton *)voiceH5Button{
    if (!_voiceH5Button) {
        _voiceH5Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceH5Button setImage:[UIImage imageNamed:@"game_h5_voice_on"] forState:UIControlStateNormal];
        [_voiceH5Button setImage:[UIImage imageNamed:@"game_h5_voice_off"] forState:UIControlStateSelected];
        [_voiceH5Button addTarget:self action:@selector(voiceH5Action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceH5Button;
}

- (UIButton *)helpH5Button{
    if (!_helpH5Button) {
        _helpH5Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpH5Button setImage:[UIImage imageNamed:@"game_h5_explain"] forState:UIControlStateNormal];
        [_helpH5Button addTarget:self action:@selector(helpH5Action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpH5Button;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
