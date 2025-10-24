//
//  TTRoomIntroduceAlertView.m
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomIntroduceAlertView.h"

#import "RoomInfo.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTRoomIntroduceAlertView()
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** closeButton */
@property (nonatomic, strong) UIButton *closeButton;
/** textView */
@property (nonatomic, strong) UITextView *textView;
@end

@implementation TTRoomIntroduceAlertView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.textView.contentSize.height > self.textView.frame.size.height) {
        self.textView.scrollEnabled = YES;
    } else {
        self.textView.scrollEnabled = NO;
    }
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)ttDidClickCloseButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttRoomIntroduceAlertView:didClickCloseButton:)]) {
        [self.delegate ttRoomIntroduceAlertView:self didClickCloseButton:button];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.closeButton];
}

- (void)initConstrations {
    
    CGFloat scale = KScreenWidth / 375;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32 * scale);
        make.right.mas_equalTo(-32 * scale);
        make.top.mas_equalTo(136 * scale + statusbarHeight);
        make.height.mas_equalTo(170 * scale);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(22 * scale);
        make.left.mas_equalTo(26 * scale);
        make.right.mas_equalTo(-26 * scale);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15 * scale);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(140 * scale);
        make.height.mas_equalTo(38 * scale);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26 * scale);
        make.right.mas_equalTo(-26 * scale);
        make.top.mas_equalTo(60 * scale);
        make.bottom.mas_equalTo(-85 * scale);
    }];
}

#pragma mark - getters and setters

- (void)setRoomInfo:(RoomInfo *)roomInfo {
    _roomInfo = roomInfo;
    
    NSString *intro = roomInfo.introduction;
    NSString *theme = roomInfo.roomDesc;
    if (intro.length == 0) {
        intro = @"这个房主很懒哟...";
    } else {
        intro = roomInfo.introduction;
    }
    
    if (theme.length == 0) {
        theme = @"房间公告";
    } else {
        theme = roomInfo.roomDesc;
    }
    
    CGFloat scale = KScreenWidth / 375;
    
    // 计算文本高度
    UITextView *textV = [[UITextView alloc] init];
    textV.font = [UIFont systemFontOfSize:14];
    textV.text = intro;
    CGSize textVSize = [textV sizeThatFits:CGSizeMake(KScreenWidth - 32 * scale * 2 - 26 * scale * 2, CGFLOAT_MAX)];
    
    // 主 + 55 + 65
    // 客 + 55 + 45
    // 最大 280
    // 默认 主170 客 150
    CGFloat height;
    height = textVSize.height + 60 * scale + 85 * scale;
    
    if (height > 355 * scale) {
        height = 355 * scale;
    }
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32 * scale);
        make.right.mas_equalTo(-32 * scale);
        make.top.mas_equalTo(136 * scale + statusbarHeight);
        make.height.mas_equalTo(height);
    }];
    
    self.textView.text = intro;
    self.titleLabel.text = theme;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _closeButton.backgroundColor = RGBCOLOR(240, 240, 240);
        _closeButton.layer.cornerRadius = 19;
        _closeButton.layer.masksToBounds = YES;
        [_closeButton addTarget:self action:@selector(ttDidClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = RGBCOLOR(66, 66, 66);
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.editable = NO;
        _textView.selectable = NO;
    }
    return _textView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.text = @"公告标题";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
