//
//  TTMasterFourthTaskView.m
//  TTPlay
//
//  Created by Macx on 2019/1/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterFourthTaskView.h"
//category
#import "NSArray+Safe.h"
//tool
#import "XCTheme.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
#import "XCHtmlUrl.h"
#import "XCCurrentVCStackManager.h"
//core
#import "AuthCore.h"
#import "XCMentoringShipAttachment.h"

#import "TTWKWebViewViewController.h"

@interface TTMasterFourthTaskView ()
/** 背景的阴影图*/
@property (nonatomic, strong) UIImageView * backImageView;
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** tip */
@property (nonatomic, strong) UILabel *tipLabel;
/** 攻略*/
@property (nonatomic, strong) UIButton * strategyButton;
@end

@implementation TTMasterFourthTaskView

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
- (void)didClickInviteButton:(UIButton *)btn {
    if (self.inviteButtonDidClickBlcok) {
        self.inviteButtonDidClickBlcok();
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
    [self.contentView addSubview:self.strategyButton];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.inviteButton];
    
    [self.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.strategyButton addTarget:self action:@selector(didClickStrategyButton:) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.inviteButton.mas_top).offset(-35);
        make.width.mas_equalTo(184);
        make.height.mas_equalTo(25);
    }];
    
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-16);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(38);
    }];
}

#pragma mark - getters and setters

- (void)setMasterFourthTaskAttach:(XCMentoringShipAttachment *)masterFourthTaskAttach {
    _masterFourthTaskAttach = masterFourthTaskAttach;
    
    self.titleLabel.text = masterFourthTaskAttach.title;
    self.tipLabel.text = masterFourthTaskAttach.tips;
    for (int i = 0; i < masterFourthTaskAttach.content.count; i++) {
        NSString *text = masterFourthTaskAttach.content[i];
        if (i == 0) {
            self.tipLabel.text = text;
        }
    }
    // 按钮状态未设置
    self.inviteButton.enabled = !masterFourthTaskAttach.masterInvite;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.image = [UIImage imageNamed:@"message_master_backimage"];
    }
    return _backImageView;
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
        _tipLabel.textColor = [XCTheme getTTMainTextColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}


- (UIButton *)inviteButton {
    if (!_inviteButton) {
        _inviteButton = [[UIButton alloc] init];
        [_inviteButton setTitle:@"发送邀请" forState:UIControlStateNormal];
        [_inviteButton setTitle:@"已发送" forState:UIControlStateDisabled];
        [_inviteButton setBackgroundImage:[UIImage imageNamed:@"message_master_btn_bg_normal"] forState:UIControlStateNormal];
        [_inviteButton setBackgroundImage:[UIImage imageNamed:@"message_master_btn_bg_disable"] forState:UIControlStateDisabled];
        [_inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _inviteButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _inviteButton.layer.cornerRadius = 19;
        _inviteButton.layer.masksToBounds = YES;
    }
    return _inviteButton;
}

- (UIButton *)strategyButton {
    if (!_strategyButton) {
        _strategyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_strategyButton setTitle:@"攻略" forState:UIControlStateNormal];
        [_strategyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_strategyButton setBackgroundImage:[UIImage imageNamed:@"discover_master_strategy"] forState:UIControlStateNormal];
        [_strategyButton setBackgroundImage:[UIImage imageNamed:@"discover_master_strategy"] forState:UIControlStateSelected];
        _strategyButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _strategyButton;
}

@end
