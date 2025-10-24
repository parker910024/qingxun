//
//  TTMasterFirstTaskView.m
//  TTPlay
//
//  Created by Macx on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterFirstTaskView.h"

#import "XCTheme.h"
#import "XCMacros.h"

#import <Masonry/Masonry.h>
#import "XCMentoringShipAttachment.h"
#import "AuthCore.h"
#import "UserCore.h"
//category
#import "UIImageView+QiNiu.h"
#import "NSArray+Safe.h"
#import "BaseAttrbutedStringHandler+Message.h"

#import "XCHtmlUrl.h"
#import "XCCurrentVCStackManager.h"
#import <YYText/YYLabel.h>
#import "XCCurrentVCStackManager.h"
#import "TTWKWebViewViewController.h"

@interface TTMasterFirstTaskView ()
/** 背景图*/
@property (nonatomic, strong) UIImageView * backImageView;
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** report */
@property (nonatomic, strong) UIButton *reportButton;
/** tip */
@property (nonatomic, strong) UILabel *tipLabel;
/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** name + sex */
@property (nonatomic, strong) YYLabel *nameLabel;
/** dot */
@property (nonatomic, strong) UIView *dot1View;
/** dot */
@property (nonatomic, strong) UIView *dot2View;
/** 互相发3条信息 */
@property (nonatomic, strong) UILabel *sendMessageLabel;
/** 相互关注 */
@property (nonatomic, strong) UILabel *followLabel;
/** 攻略*/
@property (nonatomic, strong) UIButton * strategyButton;
@end

@implementation TTMasterFirstTaskView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickFollowButton:(UIButton *)btn {
    if (self.followButtonDidClickBlcok) {
        self.followButtonDidClickBlcok();
    }
}

- (void)didClickReportButton:(UIButton *)btn {
    if (self.reportButtonDidClickBlcok) {
        self.reportButtonDidClickBlcok();
    }
}

- (void)avatarImageViewRecognizer:(UITapGestureRecognizer *)tap{
    if (self.avatarImageTapBlock) {
        self.avatarImageTapBlock();
    }
}

- (void)didClickStrategyButton:(UIButton *)sender{
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.urlString = [NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kMasterStrategyURL),[GetCore(AuthCore) getUid]];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
}


#pragma mark - private method

- (void)initView {
    [self addSubview:self.backImageView];
    
    [self.backImageView addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.strategyButton];
    [self.contentView addSubview:self.reportButton];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dot1View];
    [self.contentView addSubview:self.dot2View];
    [self.contentView addSubview:self.sendMessageLabel];
    [self.contentView addSubview:self.followLabel];
    [self.contentView addSubview:self.followButton];
    
    [self.followButton addTarget:self action:@selector(didClickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.reportButton addTarget:self action:@selector(didClickReportButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.strategyButton addTarget:self action:@selector(didClickStrategyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewRecognizer:)];
    [self.avatarImageView addGestureRecognizer:tap];
}

- (void)initConstrations {
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView).offset(14);
        make.left.mas_equalTo(self.backImageView).offset(11);
        make.right.mas_equalTo(self.backImageView).offset(-11);
        make.bottom.mas_equalTo(self.backImageView).offset(-14);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(18);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [self.strategyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(19);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(16);
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.bottom.mas_equalTo(self.contentView).offset(-16);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(21);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(50);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(25);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(62);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.avatarImageView);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(11);
    }];
    
    [self.dot1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(144);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(26);
        make.width.height.mas_equalTo(4);
    }];
    
    [self.sendMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dot1View.mas_right).offset(4);
        make.centerY.mas_equalTo(self.dot1View);
    }];
    
    [self.dot2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dot1View);
        make.top.mas_equalTo(self.dot1View.mas_bottom).offset(20);
        make.width.height.mas_equalTo(4);
    }];
    
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dot2View.mas_right).offset(4);
        make.centerY.mas_equalTo(self.dot2View);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-16);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(38);
    }];
}

#pragma mark - getters and setters

- (void)setMasterFirstTaskAttach:(XCMentoringShipAttachment *)masterFirstTaskAttach {
    _masterFirstTaskAttach = masterFirstTaskAttach;
    
    self.titleLabel.text = masterFirstTaskAttach.title;
    self.tipLabel.text = masterFirstTaskAttach.tips;
    
    for (int i = 0; i < masterFirstTaskAttach.content.count; i++) {
        NSString *text = masterFirstTaskAttach.content[i];
        if (i == 0) {
            self.sendMessageLabel.text = text;
        } else if (i == 1) {
            self.followLabel.text = text;
        }
    }
    
    if (masterFirstTaskAttach.content.count == 1) {
        self.dot2View.hidden = YES;
        self.followLabel.hidden = YES;
    }
    
    @KWeakify(self);
    UserInfo * info = [UserInfo yy_modelWithJSON:masterFirstTaskAttach.extendData];
    if (info) {
        [self.avatarImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
        // 昵称(最多四个字, 多的...) + 性别
        self.nameLabel.attributedText = [BaseAttrbutedStringHandler creatNick_SexLimitByUserInfo:info textColor:RGBCOLOR(26, 26, 26) font:[UIFont systemFontOfSize:11]];
    }else{
        @KWeakify(self);
        [GetCore(UserCore) getUserInfo:masterFirstTaskAttach.masterUid refresh:YES success:^(UserInfo *info) { @KStrongify(self);
            [self.avatarImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
            // 昵称(最多四个字, 多的...) + 性别
            self.nameLabel.attributedText = [BaseAttrbutedStringHandler creatNick_SexLimitByUserInfo:info textColor:RGBCOLOR(26, 26, 26) font:[UIFont systemFontOfSize:11]];
        } failure:^(NSError *error) {
            
        }];
    }
    
    // 关注按钮是否已状态待字段确定后设置
    self.followButton.enabled = !masterFirstTaskAttach.masterFocus;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.image = [UIImage imageNamed:@"message_master_backimage"];
    }
    return _backImageView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [XCTheme getTTMainColor];
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.layer.cornerRadius = 12.5;
        _tipLabel.backgroundColor = [XCTheme getMSSimpleGrayColor];
        _tipLabel.layer.masksToBounds = YES;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
        [_reportButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _reportButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _reportButton;
}

- (UIButton *)strategyButton {
    if (!_strategyButton) {
        _strategyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_strategyButton setBackgroundImage:[UIImage imageNamed:@"discover_master_strategy"] forState:UIControlStateNormal];
        [_strategyButton setBackgroundImage:[UIImage imageNamed:@"discover_master_strategy"] forState:UIControlStateSelected];
        [_strategyButton setTitle:@"攻略" forState:UIControlStateNormal];
        [_strategyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _strategyButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _strategyButton;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 20.0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.textColor = RGBCOLOR(26, 26, 26);
        _nameLabel.font = [UIFont systemFontOfSize:11];
    }
    return _nameLabel;
}

- (UIView *)dot1View {
    if (!_dot1View) {
        _dot1View = [[UIView alloc] init];
        _dot1View.layer.masksToBounds = YES;
        _dot1View.backgroundColor = [XCTheme getTTMainColor];
        _dot1View.layer.cornerRadius = 2;
    }
    return _dot1View;
}

- (UIView *)dot2View {
    if (!_dot2View) {
        _dot2View = [[UIView alloc] init];
        _dot2View.layer.masksToBounds = YES;
        _dot2View.backgroundColor = [XCTheme getTTMainColor];
        _dot2View.layer.cornerRadius = 2;
    }
    return _dot2View;
}

- (UILabel *)sendMessageLabel {
    if (!_sendMessageLabel) {
        _sendMessageLabel = [[UILabel alloc] init];
        _sendMessageLabel.textColor = [XCTheme getTTMainTextColor];
        _sendMessageLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sendMessageLabel;
}

- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [[UILabel alloc] init];
        _followLabel.textColor = [XCTheme getTTMainTextColor];
        _followLabel.font = [UIFont systemFontOfSize:14];
    }
    return _followLabel;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followButton setTitle:@"打招呼" forState:UIControlStateNormal];
        [_followButton setTitle:@"打招呼" forState:UIControlStateDisabled];
        [_followButton setBackgroundImage:[UIImage imageNamed:@"message_master_btn_bg_normal"] forState:UIControlStateNormal];
        [_followButton setBackgroundImage:[UIImage imageNamed:@"message_master_btn_bg_disable"] forState:UIControlStateDisabled];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _followButton.layer.cornerRadius = 19;
        _followButton.layer.masksToBounds = YES;
    }
    return _followButton;
}

@end
