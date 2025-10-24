//
//  TTGuildGroupChatCell.m
//  TuTu
//
//  Created by lee on 2019/1/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildGroupChatCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
// model
#import "GuildHallGroupListItem.h"
// tool
#import "UIImageView+QiNiu.h"

@interface TTGuildGroupChatCell ()

@property (nonatomic, strong) UIImageView *chatIcon;
@property (nonatomic, strong) UILabel *chatNameLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *joinBtn;
@end

@implementation TTGuildGroupChatCell

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.chatIcon];
    [self addSubview:self.chatNameLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.joinBtn];
}

- (void)initConstraints {
    [self.chatIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.height.width.mas_equalTo(50);
    }];
    
    [self.chatNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chatIcon.mas_right).offset(13);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.chatIcon);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(1);
    }];
    
    [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(53);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.chatNameLabel);
    }];
}

#pragma mark -
#pragma mark clients
- (void)onJoinBtnClickHandler:(UIButton *)btn {
    // 进入群
    if (self.delegate && [self.delegate respondsToSelector:@selector(onJoinGroupChatClickHandler:groupChatItem:)]) {
        [self.delegate onJoinGroupChatClickHandler:btn groupChatItem:self.listItem];
    }
}
#pragma mark -
#pragma mark private methods
- (void)setListItem:(GuildHallGroupListItem *)listItem {
    _listItem = listItem;
    [self.chatIcon qn_setImageImageWithUrl:listItem.icon placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    self.chatNameLabel.text = listItem.name;
    self.joinBtn.hidden = listItem.inChat;
}

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UIImageView *)chatIcon
{
    if (!_chatIcon) {
        _chatIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[XCTheme defaultTheme].default_avatar]];
        _chatIcon.layer.cornerRadius = 5;
        _chatIcon.layer.masksToBounds = YES;
    }
    return _chatIcon;
}

- (UILabel *)chatNameLabel
{
    if (!_chatNameLabel) {
        _chatNameLabel = [[UILabel alloc] init];
        _chatNameLabel.text = @"靓丽女神厅";
        _chatNameLabel.textColor = [XCTheme getMSMainTextColor];
        _chatNameLabel.font = [UIFont systemFontOfSize:15.f];
        _chatNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _chatNameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _lineView;
}

- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinBtn setTitle:@"加入" forState:UIControlStateNormal];
        [_joinBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_joinBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        _joinBtn.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _joinBtn.layer.borderWidth = 1;
        _joinBtn.layer.masksToBounds = YES;
        _joinBtn.layer.cornerRadius = 25/2;
        [_joinBtn addTarget:self action:@selector(onJoinBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinBtn;
}

@end
