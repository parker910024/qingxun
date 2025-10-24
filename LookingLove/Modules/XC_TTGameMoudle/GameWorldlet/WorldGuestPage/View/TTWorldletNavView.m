//
//  TTWorldletNavView.m
//  XC_TTGameMoudle
//
//  Created by apple on 2019/6/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldletNavView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

@interface TTWorldletNavView ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *menuBtn;
@property (nonatomic, strong) UIButton *helpBtn;

@end

@implementation TTWorldletNavView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        
        [self initConstraint];
        
    }
    return self;
}

- (void)initView {
    [self addSubview:self.backBtn];
    [self addSubview:self.menuBtn];
    [self addSubview:self.helpBtn];
}

- (void)initConstraint {
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(statusbarHeight + (kNavigationHeight - statusbarHeight - 20) / 2);
    }];
    
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.backBtn);
    }];
    
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.menuBtn.mas_left).offset(-16);
        make.centerY.mas_equalTo(self.backBtn);
    }];
}

- (void)didClickbackBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBackBtnAction:)]) {
        [self.delegate didClickBackBtnAction:self];
    }
}

- (void)didClickMenuBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMenuBtnAction:)]) {
        [self.delegate didClickMenuBtnAction:self];
    }
}

- (void)didClickHelpBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHelpBtnAction:)]) {
        [self.delegate didClickHelpBtnAction:self];
    }
}

#pragma mark --- setter ---
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(didClickbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)menuBtn {
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setImage:[UIImage imageNamed:@"worldletMoreMenu"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(didClickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}

- (UIButton *)helpBtn {
    if (!_helpBtn) {
        _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpBtn setImage:[UIImage imageNamed:@"worldletHelp"] forState:UIControlStateNormal];
        [_helpBtn addTarget:self action:@selector(didClickHelpBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
