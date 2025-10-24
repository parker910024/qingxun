//
//  LLPostDynamicSucceccAlert.m
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/12/1.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLPostDynamicSucceccAlert.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"

@interface LLPostDynamicSucceccAlert ()

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation LLPostDynamicSucceccAlert

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
    
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.iconImg];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tipsLabel];
}

- (void)initConstraints {
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(self);
        make.height.width.mas_equalTo(76);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(-3);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
}

- (void)dealloc {

}
#pragma mark -
#pragma mark setter && getter
- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamic_post_success_icon"]];
    }
    return _iconImg;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"审核中";
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"咻，收到小可爱的动态了呢~\n审核通过后小秘书会帮你发送并通知你哦~";
        _tipsLabel.font = [UIFont systemFontOfSize:13];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textColor = UIColorFromRGB(0x999999);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

@end
