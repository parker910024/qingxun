//
//  TTInviteRewardsNavigationView.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/21.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTInviteRewardsNavigationView.h"
#import "XCKeyWordTool.h"

#import <Masonry/Masonry.h>

@interface TTInviteRewardsNavigationView ()
@property (nonatomic, strong) UIButton  *leftButton;
@property (nonatomic, strong) UIButton  *rightButton;
@property (nonatomic, strong) UILabel  *titleLabel;
@end

@implementation TTInviteRewardsNavigationView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
        [self makeConstriants];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.titleLabel];
}

- (void)makeConstriants {
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15-(44-18)/2);//15:原margin，18：原width
        make.width.mas_equalTo(44);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.leftButton);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftButton);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark - Event

- (void)onClickLeftButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationViewClickLeftAction)]) {
        [self.delegate navigationViewClickLeftAction];
    }
}

- (void)onClickRightButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationViewClickRightAction)]) {
        [self.delegate navigationViewClickRightAction];
    }
}

#pragma mark - Getter && Setter
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(onClickLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString *title = [NSString stringWithFormat:@"%@记录", [XCKeyWordTool sharedInstance].xcRedColor];
        [_rightButton setTitle:title forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(onClickRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = [NSString stringWithFormat:@"我的%@奖励", [XCKeyWordTool sharedInstance].xcRedColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}

@end
