//
//  TTPositionGiftValueDetailView.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/21.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionGiftValueDetailView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"

@interface TTPositionGiftValueDetailView ()
// 礼物值
@property(nonatomic, strong) UILabel *giftVauleLabel;
// 容器view
@property(nonatomic, strong) UIView *containView;
// 向下的箭头图片
@property(nonatomic, strong) UIImageView *downArrowImage;
@end

@implementation TTPositionGiftValueDetailView

#pragma mark - lifeCycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
        [self initConstraints];
        [self addColseGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        [self addColseGesture];
    }
    return self;
}

- (void)initViews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self addSubview:self.containView];
    [self.containView addSubview:self.downArrowImage];
    [self.containView addSubview:self.giftVauleLabel];
}

- (void)initConstraints {
    [self.giftVauleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.containView).inset(12);
        make.center.mas_equalTo(self.containView);
    }];
}

#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response

#pragma mark -
#pragma mark Public Methods
- (void)updateGiftValue:(long long)giftValue {
    NSString *value;
    if (giftValue >= 100000000) {
        value = @"99999999+";
    } else {
        value = [NSString stringWithFormat:@"%lld", giftValue];
    }
    self.giftVauleLabel.text = value;
}
#pragma mark -
#pragma mark Private Methods
- (void)addColseGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
    [self addGestureRecognizer:tap];
}

- (void)dismissAction {
    [UIView animateWithDuration:0.2 animations:^{
        self.containView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.containView.zj_y += 40;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark -
#pragma mark Getters and Setters
- (UILabel *)giftVauleLabel {
    if (!_giftVauleLabel) {
        _giftVauleLabel = [[UILabel alloc] init];
        _giftVauleLabel.text = @"99999999";
        _giftVauleLabel.font = [UIFont systemFontOfSize:13];
        _giftVauleLabel.textColor = UIColorFromRGB(0xFD5766);
        _giftVauleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _giftVauleLabel;
}

- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = UIColor.whiteColor;
        _containView.layer.cornerRadius = 17;
        //        _containView.layer.masksToBounds = YES;
    }
    return _containView;
}

- (UIImageView *)downArrowImage {
    if (!_downArrowImage) {
        _downArrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roomPostion_GiftValue_downArrow"]];
    }
    return _downArrowImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
