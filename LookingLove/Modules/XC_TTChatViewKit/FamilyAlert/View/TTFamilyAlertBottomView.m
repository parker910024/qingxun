//
//  TTFamilyAlertBottomView.m
//  TuTu
//
//  Created by gzlx on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyAlertBottomView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"

@implementation TTFamilyAlertBottomView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.sureButton];
    [self addSubview:self.cancleButton];
}

- (void)initContrations{
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(38);
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self.sureButton.mas_left).offset(-18);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.mas_equalTo(self.cancleButton);
        make.right.mas_equalTo(self).offset(-20);
    }];
}

- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_cancleButton setBackgroundColor:UIColorFromRGB(0xFEF5ED)];
        _cancleButton.layer.masksToBounds = YES;
        _cancleButton.layer.cornerRadius = 38/2;
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cancleButton;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:[XCTheme getTTMainColor]];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureButton.layer.cornerRadius = 38/2;
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
