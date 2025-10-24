//
//  LLStatusToolView.m
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/7.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import "LLStatusToolView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "LLDynamicLayoutModel.h"
#import "CTDynamicModel.h"

@interface LLStatusToolView ()

@property (nonatomic, strong) UIButton *littleWorldBtn;
@property (nonatomic, strong) UIView *worldBgView;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation LLStatusToolView

#pragma mark - lifeCyle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.worldBgView];
    [self addSubview:self.littleWorldBtn];
    [self addSubview:self.confirmBtn];
}

- (void)initConstraints {
    [self.littleWorldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.height.mas_equalTo(25);
    }];
    
    [self.worldBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.edges.mas_equalTo(self.littleWorldBtn).insets(UIEdgeInsetsMake(0, -11, 0, -11));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.littleWorldBtn);
        make.height.mas_equalTo(25);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectActionAtToolView:)]) {
        [self.delegate didSelectActionAtToolView:self];
    }
}

- (void)setLayout:(LLDynamicLayoutModel *)layout {
    _layout = layout;
    
    self.frame = layout.worldTagViewF;
    [self.littleWorldBtn setTitle:layout.dynamicModel.worldName forState:UIControlStateNormal];
    self.confirmBtn.hidden = layout.dynamicModel.inWorld;
    // 如果不是小世界动态就隐藏
    self.hidden = layout.dynamicModel.worldId.integerValue <= 0 ? YES : NO;
}

- (UIButton *)littleWorldBtn {
    if (!_littleWorldBtn) {
        _littleWorldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_littleWorldBtn setImage:[UIImage imageNamed:@"littleWorld_Dynamic_typeIcon"] forState:UIControlStateNormal];
        [_littleWorldBtn setTitleColor:UIColorFromRGB(0xFF838D) forState:UIControlStateNormal];
        [_littleWorldBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _littleWorldBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
        _littleWorldBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        _littleWorldBtn.layer.cornerRadius = 12.5;
        _littleWorldBtn.userInteractionEnabled = NO;
    }
    return _littleWorldBtn;
}

- (UIView *)worldBgView {
    if (!_worldBgView) {
        _worldBgView = [[UIView alloc] init];
        [_worldBgView setBackgroundColor:UIColorRGBAlpha(0xFF838D, 0.1)];
        _worldBgView.layer.cornerRadius = 12.5;
        _worldBgView.layer.masksToBounds = YES;
    }
    return _worldBgView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"去看看" forState:UIControlStateNormal];
        [_confirmBtn setImage:[UIImage imageNamed:@"dynamic_rightArrow_icon"] forState:UIControlStateNormal];
        _confirmBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _confirmBtn.transform = CGAffineTransformMakeScale(-1, 1);// 翻转
        _confirmBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _confirmBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        [_confirmBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _confirmBtn.userInteractionEnabled = NO;
    }
    return _confirmBtn;
}
@end
