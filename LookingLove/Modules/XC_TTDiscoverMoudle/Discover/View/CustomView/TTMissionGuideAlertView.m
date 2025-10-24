//
//  TTMissionGuideAlertView.m
//  AFNetworking
//
//  Created by lee on 2019/4/18.
//

#import "TTMissionGuideAlertView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+QiNiu.h"

@interface TTMissionGuideAlertView ()
@property (nonatomic, strong) UIImageView *guideImageView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation TTMissionGuideAlertView

#pragma mark -
#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame withStepPic:(nonnull NSString *)stepPic{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        self.backgroundColor = UIColor.whiteColor;
        
        [self.guideImageView qn_setImageImageWithUrl:stepPic placeholderImage:[XCTheme defaultTheme].default_empty type:ImageTypeUserLibaryDetail];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.guideImageView];
    [self addSubview:self.closeBtn];
}

- (void)initConstraints {
    [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.right.left.mas_equalTo(self).inset(10);
        make.height.mas_equalTo(201);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.guideImageView.mas_bottom).offset(27);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(38);
        make.centerX.mas_equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 14;
    self.layer.masksToBounds = YES;
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
- (void)onCloseBtnClickAction:(UIButton *)closeBtn {
    !_dismissHandler ?: _dismissHandler();
}
#pragma mark -
#pragma mark getter & setter
- (UIImageView *)guideImageView {
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] init];
    }
    return _guideImageView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_closeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_closeBtn addTarget:self action:@selector(onCloseBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.layer.cornerRadius = 19;
        _closeBtn.layer.masksToBounds = YES;
        _closeBtn.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        _closeBtn.layer.borderWidth = 2.f;
    }
    return _closeBtn;
}
@end
