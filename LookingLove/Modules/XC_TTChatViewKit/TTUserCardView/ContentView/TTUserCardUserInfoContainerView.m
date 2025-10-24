//
//  TTUserCardUserInfoContainerView.m
//  TuTu
//
//  Created by 卫明 on 2018/11/15.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTUserCardUserInfoContainerView.h"

//core
#import "UserCore.h"
#import "AuthCore.h"

//3rd parth
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>

//catrgory
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler+UserCard.h"
#import "UIImage+ImageEffects.h"

//tool
#import "TTNobleSourceHelper.h"
#import <YYImage/YYAnimatedImageView.h>
#import "SpriteSheetImageManager.h"
#import "XCCurrentVCStackManager.h"
#import "XCTheme.h"
#import "XCHtmlUrl.h"

//vc
#import "TTWKWebViewViewController.h"
#import "XCMediator+TTPersonalMoudleBridge.h"

#import "TTPopup.h"

@interface TTUserCardUserInfoContainerView ()

@property (nonatomic,assign) UserID infoUid;

@property (strong, nonatomic) UIImageView *avatarImageView;

@property (strong, nonatomic) YYLabel *identitySourceLabel;

@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) UIButton *reportButton;

@property (strong, nonatomic) UIImageView *backgroud;

@property (strong, nonatomic) UIVisualEffectView *effectView;

@property (strong, nonatomic) YYAnimatedImageView *headwear;

@property (strong, nonatomic) SpriteSheetImageManager *sheetImageManager;

@end

@implementation TTUserCardUserInfoContainerView

- (instancetype)initWithFrame:(CGRect)frame uid:(UserID)uid {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        self.infoUid = uid;
    }
    return self;
}

- (void)initView {
    [self addSubview:self.backgroud];
    [self addSubview:self.effectView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.headwear];
    [self addSubview:self.identitySourceLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.reportButton];
}

- (void)initConstrations {
    [self.backgroud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(self.backgroud);
    }];
    [self.headwear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.avatarImageView);
        make.width.height.mas_equalTo(73);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(55);
        make.leading.mas_equalTo(self.mas_leading).offset(20);
        make.top.mas_equalTo(self.mas_top).offset(20);
    }];
    [self.identitySourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarImageView.mas_trailing).offset(10);
        make.top.mas_equalTo(self.avatarImageView.mas_top);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
    }];
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.closeButton.mas_centerY);
        make.trailing.mas_equalTo(self.closeButton.mas_leading).offset(-15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(13);
    }];
}

#pragma mark - getter & setter

- (void)setInfoUid:(UserID)infoUid {
    _infoUid = infoUid;
    UserExtensionRequest *request = [[UserExtensionRequest alloc]init];
    request.type = QueryUserInfoExtension_Full;
    request.needRefresh = YES;
    
    @weakify(self);
    [[GetCore(UserCore)queryExtensionUserInfoByWithUserID:_infoUid requests:@[request]]subscribeNext:^(id x) {
        UserInfo *info = (UserInfo *)x;
        @strongify(self);
        
        if ([self.delegate respondsToSelector:@selector(onUserContentView:updateWithUserInfo:)]) {
            [self.delegate onUserContentView:self updateWithUserInfo:info];
        }
        
        if (info.nobleUsers.level > 0 && info.nobleUsers.cardbg) {
            [TTNobleSourceHelper disposeImageView:self.backgroud withSource:info.nobleUsers.cardbg imageType:ImageTypeUserLibaryDetail];
            self.effectView.hidden = YES;
        }else {
            [self.backgroud qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserCardBg];
            self.effectView.hidden = NO;
        }
        if (self.type == ShowUserCardType_Online) {
            if (info.nobleUsers.enterHide) {
                [self.avatarImageView qn_setImageImageWithUrl:RankHideAvatarUrl placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:(ImageType)ImageTypeCornerAvatar cornerRadious:1000 success:nil];
            }else{
                [self.avatarImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:(ImageType)ImageTypeCornerAvatar cornerRadious:1000 success:nil];
            }
        }else if (self.type == ShowUserCardType_Rank){
            if (info.nobleUsers.rankHide) {
                [self.avatarImageView qn_setImageImageWithUrl:RankHideAvatarUrl placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:(ImageType)ImageTypeCornerAvatar cornerRadious:1000 success:nil];
            }else{
                [self.avatarImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:(ImageType)ImageTypeCornerAvatar cornerRadious:1000 success:nil];
            }
        }else{
            [self.avatarImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:(ImageType)ImageTypeCornerAvatar cornerRadious:1000 success:nil];
        }
        
        //id=0就是不使用头饰，如果不使用头饰，但是又是贵族，就显示贵族头饰
        if ([info.userHeadwear.headwearId integerValue] == 0) {
            if (info.nobleUsers.level > 0 && info.nobleUsers.headwear) {
                [TTNobleSourceHelper disposeImageView:self.headwear withSource:info.nobleUsers.headwear imageType:ImageTypeUserLibaryDetail];
            }
        }else {
            if (info.userHeadwear.effect.length > 0) {
                [self.sheetImageManager loadSpriteSheetImageWithURL:[NSURL URLWithString:info.userHeadwear.effect] completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
                    self.headwear.image = sprit;
                } failureBlock:^(NSError * _Nullable error) {
                    
                }];
            }else if (info.userHeadwear.effect.length <=0 && info.userHeadwear.pic.length > 0) {
                [self.sheetImageManager loadSpriteSheetImageWithURL:[NSURL URLWithString:info.userHeadwear.pic] completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
                    self.headwear.image = sprit;
                } failureBlock:^(NSError * _Nullable error) {
                    
                }];
            }
        }
        
        self.identitySourceLabel.attributedText = [BaseAttrbutedStringHandler makeUserCardInfoByUserInfo:info type:self.type];
        
    }];
    
    if (infoUid == GetCore(AuthCore).getUid.userIDValue) {
        self.reportButton.hidden = YES;
    } else {
        self.reportButton.hidden = NO;
    }
}

#pragma mark - user respone

- (void)onCloseButtonClick:(UIButton *)sender {
    [TTPopup dismiss];
}

- (void)onReportButtonClick:(UIButton *)sender {
    
    [[BaiduMobStat defaultStat]logEvent:@"data_dard_report" eventLabel:@"资料卡片-举报"];
    
    [TTPopup dismiss];
    
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%lld&source=USERCARD",HtmlUrlKey(kReportURL),self.infoUid];
    vc.urlString = urlstr;
    [[[XCCurrentVCStackManager shareManager]currentNavigationController]pushViewController:vc animated:YES];
}

- (void)didTapAvatarImageView:(UITapGestureRecognizer *)tap {
    
    [TTPopup dismiss];
    
    [[BaiduMobStat defaultStat]logEvent:@"data_dard_homepage" eventLabel:@"资料卡片-主页"];
    UIViewController *personalVC = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:self.infoUid];
    [[[XCCurrentVCStackManager shareManager] currentNavigationController] pushViewController:personalVC animated:YES];
}

#pragma mark - setter & getter

- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [[UIButton alloc]init];
        _reportButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
        [_reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(onReportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"common_close_cycle_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(onCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.contentMode = UIViewContentModeScaleToFill;
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvatarImageView:)]];
    }
    return _avatarImageView;
}

- (YYLabel *)identitySourceLabel {
    if (!_identitySourceLabel) {
        _identitySourceLabel = [[YYLabel alloc]init];
        _identitySourceLabel.numberOfLines = 0;
        _identitySourceLabel.preferredMaxLayoutWidth = 200;
        _identitySourceLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _identitySourceLabel.backgroundColor = [UIColor clearColor];
    }
    return _identitySourceLabel;
}

- (UIImageView *)backgroud {
    if (!_backgroud) {
        _backgroud = [[UIImageView alloc]init];
        _backgroud.contentMode = UIViewContentModeScaleToFill;
    }
    return _backgroud;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    }
    return _effectView;
}

- (YYAnimatedImageView *)headwear {
    if (!_headwear) {
        _headwear = [[YYAnimatedImageView alloc]init];
        _headwear.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headwear;
}

- (SpriteSheetImageManager *)sheetImageManager {
    if (!_sheetImageManager) {
        _sheetImageManager = [[SpriteSheetImageManager alloc]init];
    }
    return _sheetImageManager;
}

@end
