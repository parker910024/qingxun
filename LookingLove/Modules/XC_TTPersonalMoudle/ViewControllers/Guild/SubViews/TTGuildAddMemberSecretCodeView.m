//
//  TTGuildAddMemberSecretCodeView.m
//  TTPlay
//
//  Created by lee on 2019/2/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildAddMemberSecretCodeView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
// tools
#import "GuildEmojiCode.h"
#import "NSDate+TimeCategory.h"

#pragma mark -
#pragma mark SecretCodeViw
@interface TTGuildAddMemberSecretCodeView ()

@property (nonatomic, strong) UIView *contentView; // 容器view
@property (nonatomic, strong) UILabel *textLabel;   // 标题
@property (nonatomic, strong) UILabel *tipsLabel;   // 过期提示语
@property (nonatomic, strong) UIButton *cancelBtn;  // 取消按钮
@property (nonatomic, strong) UIView *lineView;     // 分割线
@property (nonatomic, strong) UIButton *goCopyCodeBtn; // 复制并分享按钮
@property (nonatomic, strong) UILabel *secretCodeLabel;   // 暗号
@end

@implementation TTGuildAddMemberSecretCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.contentView];
    [self addSubview:self.cancelBtn];
    
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.goCopyCodeBtn];
    [self.contentView addSubview:self.secretCodeLabel];
    [self.contentView addSubview:self.tipsLabel];
}

- (void)initConstraints {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(299);
        make.left.right.mas_equalTo(self).inset(15);
        make.top.mas_equalTo(self);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(15);
        make.left.right.mas_equalTo(self).inset(15);
        make.height.mas_equalTo(51);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(34);
    }];
    
    [self.goCopyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(51);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.goCopyCodeBtn.mas_top);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.lineView.mas_top).offset(-22);
        make.left.right.mas_equalTo(self.contentView).inset(56);
    }];
    
    [self.secretCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(35);
        make.centerX.mas_equalTo(self.contentView);
    }];
}

#pragma mark -
#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
-(void)onCancelBtnClickAction:(UIButton *)cancelBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickCancelBtnAction)]) {
        [self.delegate onClickCancelBtnAction];
    }
}

- (void)onGoCopyCodeBtnClickAction:(UIButton *)goCopyCodeBtn {
    if (_emojiCode.shareContent) {
        [[UIPasteboard generalPasteboard] setString:_emojiCode.shareContent];
    }
     // 跳转wx 或者 qq
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickShareBtnWithType:)]) {
        [self.delegate onClickShareBtnWithType:self.shareType];
    }
    
    [self onCancelBtnClickAction:self.cancelBtn];
}

#pragma mark -
#pragma mark getter & setter

- (void)setEmojiCode:(GuildEmojiCode *)emojiCode {
    _emojiCode = emojiCode;
    _secretCodeLabel.text = emojiCode.emojiCode;
    _tipsLabel.text = emojiCode.expireDateStr;
    _tipsLabel.text = [NSString stringWithFormat:@"7天内(%@前)有效，过期后需重新获取", [NSDate dateStrFromCstampTime:emojiCode.expireDate.integerValue / 1000 withDateFormat:@"MM月dd日"]];
}

- (void)setShareType:(TTGuildMemberCodeShareType)shareType {
    _shareType = shareType;
    switch (shareType) {
        case TTGuildMemberCodeShareTypeWX:
            {
                [self.goCopyCodeBtn setTitle:@"复制并跳转微信" forState:UIControlStateNormal];
                [self.goCopyCodeBtn setImage:[UIImage imageNamed:@"guild_shareCode_wx"] forState:UIControlStateNormal];
                [self.goCopyCodeBtn setTitleColor:UIColorFromRGB(0x3ED172) forState:UIControlStateNormal];
            }
            break;
        case TTGuildMemberCodeShareTypeQQ:
            {
                [self.goCopyCodeBtn setTitle:@"复制并跳转 QQ" forState:UIControlStateNormal];
                [self.goCopyCodeBtn setImage:[UIImage imageNamed:@"guild_shareCode_QQ"] forState:UIControlStateNormal];
                [self.goCopyCodeBtn setTitleColor:UIColorFromRGB(0x13B7F5) forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x4D4D4D) forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 14;
        [_cancelBtn addTarget:self action:@selector(onCancelBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)goCopyCodeBtn {
    if (!_goCopyCodeBtn) {
        _goCopyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goCopyCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        _goCopyCodeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_goCopyCodeBtn addTarget:self action:@selector(onGoCopyCodeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goCopyCodeBtn;
}


- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"这是你的邀请暗号\n好友可以通过暗号直接加入你的厅";
        _textLabel.textColor = [XCTheme getMSMainTextColor];
        _textLabel.font = [UIFont systemFontOfSize:16.f];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        _textLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _textLabel;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"7天内(2月18日前)有效，过期后需重新获取";
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipsLabel.font = [UIFont systemFontOfSize:12.f];
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UILabel *)secretCodeLabel
{
    if (!_secretCodeLabel) {
        _secretCodeLabel = [[UILabel alloc] init];
        _secretCodeLabel.text = @"🐵 🙈 🙉 🙊 🙊\n🙉 🙈 🐵 🙉 🙊";
        _secretCodeLabel.textColor = [XCTheme getMSMainTextColor];
        _secretCodeLabel.font = [UIFont systemFontOfSize:30.f];
        _secretCodeLabel.adjustsFontSizeToFitWidth = YES;
        _secretCodeLabel.textAlignment = NSTextAlignmentCenter;
        _secretCodeLabel.numberOfLines = 0;
        
    }
    return _secretCodeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    }
    return _lineView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 14;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}
@end
