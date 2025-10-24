//
//  TTGameNavView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameNavView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIButton+EnlargeTouchArea.h"
#import "XCKeyWordTool.h"

///是否点击签到状态存储键
static NSString *const TTGameNavViewClickCheckinStatusStoreKey = @"TTGameNavViewClickCheckinStatusStoreKey";

@interface TTGameNavView ()
@property (nonatomic, strong) UIButton *roomButton;//我的房间
@property (nonatomic, strong) UIButton *searchButton; // 搜索
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UIButton *checkinButton;//签到
@property (nonatomic, strong) UIButton *drawIconButton;//瓜分百万
@end

@implementation TTGameNavView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
        [self initConstraints];
        
        //判断是否隐藏“瓜分百万”图标
        //此图标在第一次点击后就不显示
        BOOL isClickCheckin = [[NSUserDefaults standardUserDefaults] boolForKey:TTGameNavViewClickCheckinStatusStoreKey];
        if (isClickCheckin) {
            self.drawIconButton.hidden = YES;
        }
    }
    return self;
}

#pragma mark - event response
- (void)didClickMyRoomButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navViewDidClickCreateRoom:)]) {
        [self.delegate navViewDidClickCreateRoom:self];
    }
}

- (void)searchBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navViewDidClickSearch:)]) {
        [self.delegate navViewDidClickSearch:self];
    }
}

- (void)checkinButtonTapped:(UIButton *)button {
    
    //隐藏“瓜分百万”图标
    self.drawIconButton.hidden = YES;
    
    //存储点击状态
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TTGameNavViewClickCheckinStatusStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(navViewDidClickCheckin:)]) {
        [self.delegate navViewDidClickCheckin:self];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.roomButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.searchButton];
    [self addSubview:self.checkinButton];
    [self addSubview:self.drawIconButton];
}

- (void)initConstraints {
    [self.roomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.width.height.mas_equalTo(22);
        make.top.mas_equalTo(statusbarHeight + 10);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.roomButton.mas_left).offset(-11);
        make.top.mas_equalTo(statusbarHeight + 10);
        make.width.height.mas_equalTo(22);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(60);
        make.top.mas_equalTo(statusbarHeight + 10);
    }];
    
    [self.checkinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.width.height.mas_equalTo(28);
        make.centerY.mas_equalTo(self.roomButton.mas_centerY);
    }];
    
    [self.drawIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkinButton.mas_right);
        make.centerY.mas_equalTo(self.roomButton);
        make.width.mas_equalTo(57);
        make.height.mas_equalTo(21);
    }];
}

#pragma mark - getters and setters
- (UIButton *)roomButton {
    if (!_roomButton) {
        _roomButton = [[UIButton alloc] init];
        [_roomButton setImage:[UIImage imageNamed:@"home_room_add"] forState:UIControlStateNormal];
        [_roomButton addTarget:self action:@selector(didClickMyRoomButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_roomButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _roomButton;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = [XCKeyWordTool sharedInstance].myAppName;
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [XCTheme getMSMainTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIButton *)checkinButton {
    if (!_checkinButton) {
        _checkinButton = [[UIButton alloc] init];
        [_checkinButton setImage:[UIImage imageNamed:@"game_nav_checkin"] forState:UIControlStateNormal];
        [_checkinButton addTarget:self action:@selector(checkinButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_checkinButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _checkinButton;
}

- (UIButton *)drawIconButton {
    if (!_drawIconButton) {
        _drawIconButton = [[UIButton alloc] init];
        [_drawIconButton setImage:[UIImage imageNamed:@"game_nav_checkin_draw"] forState:UIControlStateNormal];
        [_drawIconButton addTarget:self action:@selector(checkinButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_drawIconButton setEnlargeEdgeWithTop:12 right:0 bottom:12 left:0];
    }
    return _drawIconButton;
}
@end

