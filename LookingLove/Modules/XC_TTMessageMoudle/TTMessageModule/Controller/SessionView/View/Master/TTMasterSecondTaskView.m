//
//  TTMasterSecondTaskView.m
//  TTPlay
//
//  Created by Macx on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterSecondTaskView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>
#import "XCMentoringShipAttachment.h"
#import "MentoringGiftModel.h"
#import "UIImageView+QiNiu.h"
#import "XCHtmlUrl.h"
//core
#import "AuthCore.h"

#import "TTWKWebViewViewController.h"
#import "XCCurrentVCStackManager.h"

@interface TTMasterSecondTaskView ()
@property (nonatomic, strong) UIImageView * backImageView;
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** tip */
@property (nonatomic, strong) UILabel *tipLabel;
/** 头像 */
@property (nonatomic, strong) UIImageView *flowerImageView;
/** 新人小花 */
@property (nonatomic, strong) UILabel *flowerLabel;
/** dot */
@property (nonatomic, strong) UIView *dot1View;
/** 送Ta一束花花\n当见面礼吧！ */
@property (nonatomic, strong) UILabel *sendMessageLabel;
/** 立即赠送 */
@property (nonatomic, strong) UIButton *sendButton;
/** 攻略*/
@property (nonatomic, strong) UIButton * strategyButton;
@end

@implementation TTMasterSecondTaskView

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
    if (self.sendButtonDidClickBlcok) {
        self.sendButtonDidClickBlcok();
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
    [self.contentView addSubview:self.flowerImageView];
    [self.contentView addSubview:self.flowerLabel];
    [self.contentView addSubview:self.dot1View];
    [self.contentView addSubview:self.sendMessageLabel];
    [self.contentView addSubview:self.sendButton];
    
    [self.sendButton addTarget:self action:@selector(didClickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
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
        make.top.mas_equalTo(self.contentView).offset(50);
        make.width.mas_equalTo(230);
        make.height.mas_equalTo(25);
    }];
    
    [self.flowerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(64);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(14);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.flowerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.flowerImageView);
        make.top.mas_equalTo(self.flowerImageView.mas_bottom).offset(4);
    }];
    
    [self.dot1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(144);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(26);
        make.width.height.mas_equalTo(4);
    }];
    
    [self.sendMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dot1View.mas_right).offset(4);
        make.top.mas_equalTo(self.dot1View).offset(-2);
        make.right.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(38);
    }];
}

#pragma mark - getters and setters
- (void)setMasterSecondTaskAttach:(XCMentoringShipAttachment *)masterSecondTaskAttach {
    _masterSecondTaskAttach = masterSecondTaskAttach;
    
    self.titleLabel.text = masterSecondTaskAttach.title;
    self.tipLabel.text = masterSecondTaskAttach.tips;
    for (int i = 0 ; i < masterSecondTaskAttach.content.count; i++) {
        if (i == 0) {
            self.sendMessageLabel.text = masterSecondTaskAttach.content[i];
        }
    }
    MentoringGiftModel * giftInfor = [MentoringGiftModel yy_modelWithJSON:masterSecondTaskAttach.extendData];
    self.flowerLabel.text = giftInfor.giftName.length > 0 ? giftInfor.giftName : @"";
    [self.flowerImageView qn_setImageImageWithUrl:giftInfor.picUrl placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    // 按钮状态, 花图, 和 文本
    self.sendButton.enabled = !masterSecondTaskAttach.masterSendGift;
}

//拜师任务
- (void)setApprenticeSendAttachment:(XCMentoringShipAttachment *)apprenticeSendAttachment {
    _apprenticeSendAttachment = apprenticeSendAttachment;
    
    self.titleLabel.text = apprenticeSendAttachment.title;
    self.tipLabel.text = apprenticeSendAttachment.tips;
    
    for (int i = 0 ; i < apprenticeSendAttachment.content.count; i++) {
        if (i == 0) {
            self.sendMessageLabel.text = apprenticeSendAttachment.content[i];
        }
    }
    
    // 按钮状态, 花图, 和 文本
    MentoringGiftModel * giftInfor = [MentoringGiftModel yy_modelWithJSON:apprenticeSendAttachment.extendData];
    self.flowerLabel.text = giftInfor.giftName.length > 0 ? giftInfor.giftName : @"";
    [self.flowerImageView qn_setImageImageWithUrl:giftInfor.picUrl placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    // 按钮状态, 花图, 和 文本
    self.sendButton.enabled = !apprenticeSendAttachment.apprenticeSendGift;
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
        _tipLabel.textColor = [XCTheme getTTMainColor];
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.layer.cornerRadius = 12.5;
        _tipLabel.backgroundColor = [XCTheme getTTSimpleGrayColor];
        _tipLabel.layer.masksToBounds = YES;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIImageView *)flowerImageView {
    if (!_flowerImageView) {
        _flowerImageView = [[UIImageView alloc] init];
    }
    return _flowerImageView;
}

- (UILabel *)flowerLabel {
    if (!_flowerLabel) {
        _flowerLabel = [[UILabel alloc] init];
        _flowerLabel.textColor = RGBCOLOR(255, 56, 82);
        _flowerLabel.font = [UIFont systemFontOfSize:11];
    }
    return _flowerLabel;
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

- (UILabel *)sendMessageLabel {
    if (!_sendMessageLabel) {
        _sendMessageLabel = [[UILabel alloc] init];
        _sendMessageLabel.textColor = [XCTheme getTTMainTextColor];
        _sendMessageLabel.font = [UIFont systemFontOfSize:14];
        _sendMessageLabel.numberOfLines = 2;
    }
    return _sendMessageLabel;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"立即赠送" forState:UIControlStateNormal];
        [_sendButton setTitle:@"已赠送" forState:UIControlStateDisabled];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"message_master_btn_bg_normal"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"message_master_btn_bg_disable"] forState:UIControlStateDisabled];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendButton.layer.cornerRadius = 19;
        _sendButton.layer.masksToBounds = YES;
    }
    return _sendButton;
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
