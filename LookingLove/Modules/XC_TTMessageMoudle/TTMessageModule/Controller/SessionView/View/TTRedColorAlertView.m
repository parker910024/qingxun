//
//  RedAlertView.m
//  XChat
//
//  Created by 卫明何 on 2018/5/30.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TTRedColorAlertView.h"
#import "RedPacketCore.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "FamilyCore.h"

#import <Masonry/Masonry.h>

#import "XCHUDTool.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "XCKeyWordTool.h"
#import "TTPopup.h"

@interface TTRedColorAlertView ()

@property (strong, nonatomic) UIImageView *redOpenView;
@property (strong, nonatomic) UIImageView *redWaitOpenView;
@property (strong, nonatomic) UIImageView *redOutDateView;
@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UILabel *nickLabel;
@property (strong, nonatomic) UILabel *coinLabel;
@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) UILabel *noticeLabel;
@property (strong, nonatomic) UILabel *outBounLabel;
@property (strong, nonatomic) UIButton *checkDetailButton;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *openButton;
@property (strong, nonatomic) UserInfo *myUserInfo;
@end

@implementation TTRedColorAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    self.myUserInfo = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue];
    [self addSubview:self.redOpenView];
    [self addSubview:self.redWaitOpenView];
    [self addSubview:self.redOutDateView];
    [self addSubview:self.avatar];
    [self addSubview:self.nickLabel];
    [self addSubview:self.coinLabel];
    [self addSubview:self.outBounLabel];
    [self addSubview:self.checkDetailButton];
    [self addSubview:self.openButton];
    [self addSubview:self.closeButton];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.tipsLabel];
}

- (void)initConstrations {
    [self.redOpenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.redWaitOpenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.redOutDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(64);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(95);
        make.width.mas_equalTo(95);
    }];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatar.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(42);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.checkDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(120);
        make.top.mas_equalTo(self.mas_bottom).offset(-25);
    }];
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(28);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

#pragma mark - setter

- (void)setInfo:(RedPacketDetailInfo *)info {
    _info = info;
    switch (info.status) {
        case RedPacketStatus_DidOpen:
        {
            [self showRedPacketDidOpen];
        }
        break;
        case RedPacketStatus_NotOpen:
        {
            [self showRedPacketNotOpen];
        }
        break;
        case RedPacketStatus_OutDate:
        {
            [self showRedPacketOutDate];
        }
        break;
        case RedPacketStatus_OutBouns:
        {
            [self showRedPacketBounsOut];
        }
        break;
        default:
            break;
    }
    self.nickLabel.text = info.nick;
    [self.avatar qn_setImageImageWithUrl:info.avatar placeholderImage:@"default_avatar" type:ImageTypeRoomMagic];
    NSString *amount = [NSString stringWithFormat:@"%.2f%@",info.amount,GetCore(FamilyCore).getFamilyModel.moneyName];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:amount];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35.f] range:NSMakeRange(0, amount.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:NSMakeRange(amount.length-1,info.coinName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffdf02) range:NSMakeRange(0, amount.length)];
    self.coinLabel.attributedText = attrStr;
}


- (void)showRedPacketDidOpen {
    self.closeButton.hidden = NO;
    self.redOpenView.hidden = NO;
    self.redWaitOpenView.hidden = YES;
    self.redWaitOpenView.userInteractionEnabled = NO;
    self.redOutDateView.hidden = YES;
    
    self.openButton.hidden = YES;
    self.avatar.hidden = NO;
    self.nickLabel.hidden = NO;
    self.coinLabel.hidden = NO;
    self.checkDetailButton.hidden = NO;
    self.tipsLabel.hidden = YES;
    self.noticeLabel.hidden = YES;
    self.outBounLabel.hidden = YES;
    
//    [_checkDetailButton setTitle:[NSString stringWithFormat:@"查看%@领取详情", [XCKeyWordTool sharedInstance].xcRedColor] forState:UIControlStateNormal];
//    [_checkDetailButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];

}

- (void)showRedPacketNotOpen {
    self.closeButton.hidden = NO;
    
    self.redOpenView.hidden = YES;
    self.redWaitOpenView.hidden = NO;
    self.redWaitOpenView.userInteractionEnabled = YES;
    self.redOutDateView.hidden = YES;
    
    self.openButton.hidden = NO;
    self.avatar.hidden = YES;
    self.nickLabel.hidden = YES;
    self.coinLabel.hidden = YES;
    self.checkDetailButton.hidden = YES;
    self.tipsLabel.hidden = YES;
    self.noticeLabel.hidden = YES;
    self.outBounLabel.hidden = YES;
}

- (void)showRedPacketOutDate {
    self.closeButton.hidden = NO;
    
    self.redOpenView.hidden = YES;
    self.redWaitOpenView.hidden = YES;
    self.redWaitOpenView.userInteractionEnabled = NO;
    self.redOutDateView.hidden = NO;
    
    
    self.openButton.hidden = YES;
    self.avatar.hidden = NO;
    self.nickLabel.hidden = NO;
    self.coinLabel.hidden = YES;
    self.checkDetailButton.hidden = YES;
    self.tipsLabel.hidden = NO;
    self.noticeLabel.hidden = NO;
    self.outBounLabel.hidden = YES;
    
    [self.avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(42);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(85);
        make.width.mas_equalTo(85);
    }];
    [self.nickLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatar.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

- (void)showRedPacketBounsOut {
    self.closeButton.hidden = NO;
    
    self.redOpenView.hidden = YES;
    self.redWaitOpenView.hidden = YES;
    self.redWaitOpenView.userInteractionEnabled = NO;
    self.redOutDateView.hidden = NO;
    
    
    self.openButton.hidden = YES;
    self.avatar.hidden = NO;
    self.nickLabel.hidden = NO;
    self.coinLabel.hidden = YES;
    self.checkDetailButton.hidden = NO;
    self.tipsLabel.hidden = YES;
    self.noticeLabel.hidden = YES;
    self.outBounLabel.hidden = NO;
    
    [self.avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(42);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(85);
        make.width.mas_equalTo(85);
    }];
    [self.nickLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatar.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.outBounLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(50);
    }];
    [self.checkDetailButton setTitle:@"查看大家的手气>" forState:UIControlStateNormal];
    [self.checkDetailButton setTitleColor:UIColorRGBAlpha(0xffc515, 0.8) forState:UIControlStateNormal];
    
}

#pragma mark - user Respone

- (void)openButtonClick:(UIButton *)sender {
    [XCHUDTool showGIFLoading];
    
    @weakify(self);
    [GetCore(RedPacketCore)getRedByRedPacketId:self.info.id teamId:self.info.tid message:self.message success:^(RedPacketDetailInfo *info) {
        @strongify(self);
        [XCHUDTool hideHUD];
        self.info = info;
        
    } failure:^(NSNumber *resCode, NSString *message) {
        [XCHUDTool hideHUD];
        [XCHUDTool showErrorWithMessage:message];
    }];
}

- (void)closeButtonClick:(UIButton *)sender {
    [TTPopup dismiss];
}

- (void)checkDetailButtonClick:(UIButton *)sender {
    [TTPopup dismiss];
//        NSAssert(NO, @"wait XCMediator handle");
//        @strongify(self);
//        UIViewController *redDetail = [[XCMediator sharedInstance] msDiscoverMoudle_XCRedColorDetailControllerForTeamId:self.info.tid redPacketId:self.info.id];
//        [self.navigationController pushViewController:redDetail animated:YES];
}

//- (void)openRed {
//    @weakify(self);
////    [self showToast:@"请稍后" position:YYToastPositionCenter];
//    [GetCore(RedPacketCore)getRedByRedPacketId:self.info.id teamId:self.info.tid message:self.message success:^(RedPacketDetailInfo *info) {
//        @strongify(self);
////        [self hideToastView];
//        [self setInfo:info];
//    } failure:^(NSNumber *resCode, NSString *message) {
//
//    }];
//}

#pragma mark - Getter

- (UIImageView *)redOutDateView {
    if (!_redOutDateView) {
        _redOutDateView = [[UIImageView alloc]init];
        _redOutDateView.image = [UIImage imageNamed:@"red_outdate_bg"];
    }
    return _redOutDateView;
}

- (UIImageView *)redOpenView {
    if (!_redOpenView) {
        _redOpenView = [[UIImageView alloc]init];
        _redOpenView.image = [UIImage imageNamed:@"red_open_bg"];
    }
    return _redOpenView;
}

- (UIImageView *)redWaitOpenView {
    if (!_redWaitOpenView) {
        _redWaitOpenView = [[UIImageView alloc]init];
        _redWaitOpenView.image = [UIImage imageNamed:@"red_close_bg"];
//        _redWaitOpenView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openRed)];
//        [_redWaitOpenView addGestureRecognizer:tapGesture];
    }
    return _redWaitOpenView;
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc]init];
        _avatar.layer.cornerRadius = 95/2;
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
}

- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]init];
        _nickLabel.font = [UIFont systemFontOfSize:15.f];
        _nickLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _nickLabel;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc]init];
    }
    return _coinLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.text = [NSString stringWithFormat:@"给您发了一个%@", [XCKeyWordTool sharedInstance].xcRedColor];
        _tipsLabel.font = [UIFont systemFontOfSize:13.f];
        _tipsLabel.textColor = UIColorFromRGB(0xFFDF02);
    }
    return _tipsLabel;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.text = [NSString stringWithFormat:@"该%@已超过24小时。如已经领取\n可在“我的家族币”里查看", [XCKeyWordTool sharedInstance].xcRedColor];
        _noticeLabel.numberOfLines = 0;
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.font = [UIFont systemFontOfSize:14.f];
        _noticeLabel.textColor = UIColorFromRGB(0xFFDF02);
    }
    return _noticeLabel;
}

- (UILabel *)outBounLabel {
    if (!_outBounLabel) {
        _outBounLabel = [[UILabel alloc]init];
        _outBounLabel.text = [NSString stringWithFormat:@"手慢了，%@派完了", [XCKeyWordTool sharedInstance].xcRedColor];
        _outBounLabel.textColor = UIColorRGBAlpha(0xffdf02, 0.8);
        _outBounLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _outBounLabel;
}

-  (UIButton *)checkDetailButton {
    if (!_checkDetailButton) {
        _checkDetailButton = [[UIButton alloc]init];
        [_checkDetailButton addTarget:self action:@selector(checkDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _checkDetailButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _checkDetailButton;
}

- (UIButton *)openButton {
    if (!_openButton) {
        _openButton = [[UIButton alloc]init];
        [_openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"message_red_btn_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


@end
