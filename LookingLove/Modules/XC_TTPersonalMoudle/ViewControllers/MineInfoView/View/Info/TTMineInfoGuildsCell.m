//
//  TTMineInfoGuildsCell.m
//  TuTu
//
//  Created by lee on 2019/1/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMineInfoGuildsCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
//#import "UIButton+EventInterval.h"

// Model
#import "GuildOwnerHallInfo.h"

@interface TTMineInfoGuildsCell ()
@property (nonatomic, strong) UIButton *hallBtn;
@property (nonatomic, strong) UIButton *joinBtn;
@property (nonatomic, strong) UILabel *publicGroupChatLabel;
@property (nonatomic, strong) UIButton *joinChatBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) GuildOwnerHallGroupChat *groupChat;
@property (nonatomic, copy) NSString *publicChatID;

@end

@implementation TTMineInfoGuildsCell

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self initConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.hallBtn];
    [self.contentView addSubview:self.joinBtn];
    [self.contentView addSubview:self.publicGroupChatLabel];
    [self.contentView addSubview:self.joinChatBtn];
}

- (void)initConstraints {
    [self.hallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.hallBtn);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(26);
    }];
    
    [self.publicGroupChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hallBtn.mas_bottom).offset(8);
        make.left.mas_equalTo(15);
    }];
    
    [self.joinChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.publicGroupChatLabel);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(26);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events

- (void)onJoinBtnClickHandler:(UIButton *)joinBtn {
    // btn.tga = 1001;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBtnAction:groupChat:)]) {
        [self.delegate onClickBtnAction:joinBtn groupChat:self.groupChat];
    }
}

- (void)onJoinChatBtnClickHandler:(UIButton *)joinChatBtn {
    // btn.tga = 1002;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBtnAction:groupChat:)]) {
        [self.delegate onClickBtnAction:joinChatBtn groupChat:self.groupChat];
    }
}

#pragma mark -
#pragma mark getter & setter
- (void)setInfoModel:(GuildOwnerHallInfo *)infoModel {
    _infoModel = infoModel;
    [self.hallBtn setTitle:infoModel.hallName forState:UIControlStateNormal];
    [self.infoModel.groupChats enumerateObjectsUsingBlock:^(GuildOwnerHallGroupChat * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        群聊类型：1:公开群，2：内部群
        if (obj.type == 1) {
            self.groupChat = obj;
            self.joinChatBtn.hidden = NO;
            self.publicGroupChatLabel.hidden = NO;
            self.publicGroupChatLabel.text = obj.name;
        }
        self.joinChatBtn.hidden = obj.inChat;
        
        if (obj.inChat) { // 如果有公开群
            self.publicChatID = @(obj.tid).stringValue;
        }
    }];
    self.joinBtn.hidden = infoModel.inHall; // 已经加入模厅不显示
}

- (UIButton *)hallBtn {
    if (!_hallBtn) {
        _hallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hallBtn setTitle:@"模厅名字" forState:UIControlStateNormal];
        [_hallBtn setImage:[UIImage imageNamed:@"person_guild_puding"] forState:UIControlStateNormal];
        [_hallBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_hallBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        _hallBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8);
    }
    return _hallBtn;
}

- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinBtn setTitle:@"申请入厅" forState:UIControlStateNormal];
        [_joinBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_joinBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        [_joinBtn setBackgroundColor:[XCTheme getTTMainColor]];
        _joinBtn.layer.masksToBounds = YES;
        _joinBtn.layer.cornerRadius = 13;
        _joinBtn.tag = 1001;
        [_joinBtn addTarget:self action:@selector(onJoinBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinBtn;
}

- (UIButton *)joinChatBtn {
    if (!_joinChatBtn) {
        _joinChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinChatBtn setTitle:@"加入群" forState:UIControlStateNormal];
        [_joinChatBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_joinChatBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        _joinChatBtn.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _joinChatBtn.layer.borderWidth = 1.f;
        _joinChatBtn.layer.masksToBounds = YES;
        _joinChatBtn.layer.cornerRadius = 13;
        _joinChatBtn.tag = 1002;
        _joinChatBtn.hidden = YES;
//        _joinBtn.eventInterval = 2;
        [_joinChatBtn addTarget:self action:@selector(onJoinChatBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinChatBtn;
}

- (UILabel *)publicGroupChatLabel
{
    if (!_publicGroupChatLabel) {
        _publicGroupChatLabel = [[UILabel alloc] init];
        _publicGroupChatLabel.textColor = [XCTheme getMSMainTextColor];
        _publicGroupChatLabel.font = [UIFont systemFontOfSize:16.f];
        _publicGroupChatLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _publicGroupChatLabel;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _topView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _bottomView;
}

@end
