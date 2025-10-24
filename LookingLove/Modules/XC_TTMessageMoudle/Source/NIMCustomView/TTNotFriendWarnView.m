//
//  TTNotFriendWarnView.m
//  TTPlay
//
//  Created by 卫明 on 2019/2/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTNotFriendWarnView.h"

//core
#import "ImFriendCore.h"

//theme
#import "XCTheme.h"

//tool
#import <Masonry/Masonry.h>

//auth
#import "AuthCore.h"

//category
#import "UIButton+EnlargeTouchArea.h"

@interface TTNotFriendWarnView ()

@property (strong, nonatomic) UILabel *warnTextLabel;

@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation TTNotFriendWarnView

- (instancetype)initWithUserId:(NSString *)userId frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _friendID = userId;
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = UIColorRGBAlpha(0xfee4e4, 1);
    
    [self addSubview:self.warnTextLabel];
    [self addSubview:self.closeButton];
}

- (void)initConstrations {
    [self.warnTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(8);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark - User Respone

- (void)closeWarnView {
    [GetCore(ImFriendCore).hadCloseNotFriendNoticeCache setObject:[GetCore(AuthCore)getUid] forKey:self.friendID];
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top - 30, 0, 0, 0);
    [self removeFromSuperview];
}

#pragma mark - Getter

- (UILabel *)warnTextLabel {
    if (!_warnTextLabel) {
        _warnTextLabel = [[UILabel alloc]init];
        _warnTextLabel.text = @"温馨提示：对方和您非好友关系，请注意隐私安全！";
        _warnTextLabel.textColor = UIColorFromRGB(0xFF5858);
        _warnTextLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _warnTextLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"message_warn_close"] forState:UIControlStateNormal];
        [_closeButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_closeButton addTarget:self action:@selector(closeWarnView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
