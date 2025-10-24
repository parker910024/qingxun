//
//  XCGameVoiceGreetView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/12.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCGameVoiceGreetView.h"
#import <YYText/YYLabel.h>
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "BaseAttrbutedStringHandler.h"

@interface XCGameVoiceGreetView ()

/** 显示内容*/
@property (nonatomic,strong) YYLabel *titleLabel;

/** 打个招呼*/
@property (nonatomic,strong) UIButton *greetButton;

@end

@implementation XCGameVoiceGreetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)greetButtonClick:(UIButton *)sender {
    if (self.clickGreet) {
        self.clickGreet(sender);
    }
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.greetButton];
    self.titleLabel.attributedText = [self creatGameVoiceAttribut];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.greetButton addTarget:self action:@selector(greetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initContrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(18);
    }];
    
    [self.greetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(75, 28));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(24);
    }];
}


- (NSMutableAttributedString *)creatGameVoiceAttribut {
    NSMutableAttributedString * attributeing = [[NSMutableAttributedString alloc] init];
    [attributeing appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"👋快向对方打个招呼吧" attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[XCTheme getTTDeepGrayTextColor]}]];
    return attributeing;
}

#pragma mark - setters and getters
- (void)setVoiceAttach:(XCGameVoiceBottleAttachment *)voiceAttach {
    _voiceAttach = voiceAttach;
    if (_voiceAttach.isGreet) {
        _greetButton.backgroundColor = UIColorFromRGB(0xf0f0f2);
        [_greetButton setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
        _greetButton.userInteractionEnabled = NO;
    }else{
        _greetButton.backgroundColor = [UIColor whiteColor];
        [_greetButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _greetButton.userInteractionEnabled = YES;
    }
}


- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
    }
    return _titleLabel;
}

- (UIButton *)greetButton {
    if (!_greetButton) {
        _greetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_greetButton setTitle:@"打个招呼" forState:UIControlStateNormal];
        [_greetButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _greetButton.backgroundColor = [UIColor whiteColor];
        [_greetButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _greetButton.layer.masksToBounds = YES;
        _greetButton.layer.cornerRadius = 14;
    }
    return _greetButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
