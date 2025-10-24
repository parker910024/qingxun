//
//  TTFamilyBottomView.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyBottomView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTFamilyBottomView ()

@end

@implementation TTFamilyBottomView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sureButton];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)sureButtonAction:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureButtonActionWith:)]) {
        [self.delegate sureButtonActionWith:sender];
    }
}

#pragma mark - private method
- (void)initContrations{
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self).offset(10);
    }];
}

- (UIButton*)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitle:@"确认" forState:UIControlStateSelected];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton setBackgroundColor:[XCTheme getTTMainColor]];
        _sureButton.layer.cornerRadius = 20;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
