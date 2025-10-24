//
//  TuTuOldUserRegressionView.m
//  XCErBan
//
//  Created by 卫明 on 2018/10/29.
//  Copyright © 2018 TuTu. All rights reserved.
//

#import "TTOldUserRegressionView.h"

//tool
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImage+Utils.h"
#import "XCCurrentVCStackManager.h"
#import "TTPopup.h"
#import "XCKeyWordTool.h"

//toast
#import "UIView+XCToast.h"

//core
#import "ActivityCore.h"
#import "ActivityCoreClient.h"
#import "UserCore.h"
#import "AuthCore.h"

NSString *const TTOldUserRegressionViewShowStatusStoreKey = @"TTOldUserRegressionViewShowStatusStoreKey";

@interface TTOldUserRegressionView ()
<
    ActivityCoreClient,
    UITextFieldDelegate
>
/**
 标题
 */
@property (strong, nonatomic) UILabel                   *titleLabel;

/**
 描述
 */
@property (strong, nonatomic) UILabel                   *desLabel;

/**
 邀请码输入框
 */
@property (strong, nonatomic) UITextField               *invitationTextFiled;

/**
 关闭按钮
 */
@property (strong, nonatomic) UIButton                  *closeButton;

/**
 邀请码输入框灰色背景
 */
@property (strong, nonatomic) UIView                     *textFiledBg;

/**
 注意
 */
@property (strong, nonatomic) UILabel                   *noticeLabel;

/**
 确定按钮
 */
@property (strong, nonatomic) UIButton                  *confirmButton;

@end

@implementation TTOldUserRegressionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}


#pragma mark - User Respone
- (void)onConfirmButtonClick:(UIButton *)sender {
    [GetCore(ActivityCore)getOldUserRegressionActivityGiftWithCode:self.invitationTextFiled.text];
}

- (void)onCloseButtonClick:(UIButton *)sender  {
    [TTPopup dismiss];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text.length > 6) {
        return NO;
    }
    return YES;
}

#pragma mark - life cycle
- (void)initView {
    AddCoreClient(ActivityCoreClient, self);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.f;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.desLabel];
    [self addSubview:self.textFiledBg];
    [self addSubview:self.closeButton];
    [self.textFiledBg addSubview:self.invitationTextFiled];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.confirmButton];
    
    _titleLabel.text = [NSString stringWithFormat:@"亲爱的%@:",[GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue].nick];

}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(18);
        make.top.mas_equalTo(self.mas_top).offset(30);
        make.height.mas_equalTo(17);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(20);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(13);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-20);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(self.mas_top).offset(4);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-4);
    }];
    [self.textFiledBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.desLabel.mas_leading);
        make.trailing.mas_equalTo(self.desLabel.mas_trailing);
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(26);
        make.height.mas_equalTo(35);
    }];
    [self.invitationTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.textFiledBg.mas_leading).offset(5);
        make.trailing.mas_equalTo(self.textFiledBg.mas_trailing);
        make.top.mas_equalTo(self.textFiledBg.mas_top);
        make.bottom.mas_equalTo(self.textFiledBg.mas_bottom);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.invitationTextFiled);
        make.top.mas_equalTo(self.invitationTextFiled.mas_bottom).offset(8);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(39);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.noticeLabel.mas_bottom).offset(29);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightBlack];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.font = [UIFont systemFontOfSize:14.f];
        _desLabel.numberOfLines = 0;
        _desLabel.textColor = UIColorFromRGB(0x333333);
        _desLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _desLabel.text = @"好久不见，翻起曾经一起度过的时光，期待你再次出现在身旁，谢谢你回来了！";
    }
    return _desLabel;
}

- (UITextField *)invitationTextFiled {
    if (!_invitationTextFiled) {
        _invitationTextFiled = [[UITextField alloc]init];
        _invitationTextFiled.placeholder = @"请输入邀请码（选填)";
        _invitationTextFiled.delegate = self;
        _invitationTextFiled.borderStyle = UITextBorderStyleNone;
        _invitationTextFiled.textColor = UIColorFromRGB(0x333333);
        _invitationTextFiled.font = [UIFont systemFontOfSize:14.f];
    }
    return _invitationTextFiled;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.font = [UIFont systemFontOfSize:11.f weight:UIFontWeightLight];
        _noticeLabel.textColor = UIColorFromRGB(0x999999);
        _noticeLabel.numberOfLines = 0;
        _noticeLabel.text = [NSString stringWithFormat: @"输入邀请码，邀请你加入的好友和你都可以获得%@回归计划的超级大礼哦！", [XCKeyWordTool sharedInstance].myAppName];
    }
    return _noticeLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setTitle:@"收下回归礼" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFF5C46),UIColorFromRGB(0xFFB15E)] gradientType:(GradientType)GradientTypeLeftToRight imgSize:CGSizeMake(165, 39)] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 20.f;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"goldegg_close"] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_closeButton addTarget:self action:@selector(onCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIView *)textFiledBg {
    if (!_textFiledBg) {
        _textFiledBg = [[UIView alloc]init];
        _textFiledBg.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _textFiledBg.layer.cornerRadius = 3.f;
    }
    return _textFiledBg;
}

#pragma mark - ActivityCoreClient
- (void)onGetTheOldUserRegressionGiftSuccess {
    [TTPopup dismiss];
    [UIView showSuccess:@"回归礼已发放至我的装扮"];
}

- (void)onGetTheOldUserRegressionGiftFailure {
    
}

#pragma mark - private method

+ (void)show {
    TTOldUserRegressionView *view = [[TTOldUserRegressionView alloc]initWithFrame:CGRectMake(0, 0, 295, 280)];

    TTPopupConfig *config = [[TTPopupConfig alloc] init];
    config.contentView = view;
    config.style = TTPopupStyleAlert;
    config.shouldDismissOnBackgroundTouch = NO;
    
    [TTPopup popupWithConfig:config];
}


@end
