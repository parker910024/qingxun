//
//  TTUserCardBottomOpeButton.m
//  TuTu
//
//  Created by 卫明 on 2018/11/17.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTUserCardBottomOpeButton.h"
#import "UIButton+EnlargeTouchArea.h"

//mas
#import <Masonry/Masonry.h>

@interface TTUserCardBottomOpeButton ()

@property (strong, nonatomic) UIView *lineView;

@end

@implementation TTUserCardBottomOpeButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self initView];
        
        [self enlargeTouchArea:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self initConstraints];
}

#pragma mark - private

- (void)initView {
    [self addSubview:self.lineView];
}

- (void)initConstraints {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

@end
