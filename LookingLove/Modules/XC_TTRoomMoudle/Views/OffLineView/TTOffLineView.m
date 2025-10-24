//
//  TTOffLineView.m
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTOffLineView.h"
//core
#import "UserCore.h"
//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import <YYLabel.h>

//category
#import "UIImageView+QiNiu.h"
#import "UIImage+ImageEffects.h"

//bridge
#import "XCMediator+TTPersonalMoudleBridge.h"

//center
#import "TTRoomModuleCenter.h"
#import "XCCurrentVCStackManager.h"

@interface TTOffLineView()
@property (nonatomic, strong) UIImageView *avatarBgImageView;//头像背景
@property (strong, nonatomic) UIVisualEffectView *effectView;//模糊

@property (nonatomic, strong) UIImageView *avatarImgView;//头像
@property (nonatomic, strong) YYLabel *nickLabel;//昵称+性别

@property (nonatomic, strong) UIView *lineLeft;
@property (nonatomic, strong) UILabel *tipLabel;//提示
@property (nonatomic, strong) UIView *lineRight;

@property (strong, nonatomic) UIButton *homePageButton;//主页按钮
@property (strong, nonatomic) UIButton *exitButton;//退出按钮

@property (nonatomic, assign) UserID uid;
@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation TTOffLineView

#pragma mark - Life Style
- (instancetype)initWithUserId:(UserID)userId {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.uid = userId;
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}


#pragma mark - event response

- (void)onHomePageClicked:(id) tap {
    
    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES animation:YES completion:^{
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:self.uid];
        [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)onExitClicked:(id)tap {
    
    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
}



#pragma mark - puble method
- (void)setUid:(UserID)uid {
    _uid = uid;
    @weakify(self);
    [GetCore(UserCore) getUserInfo:self.uid refresh:YES success:^(UserInfo *info) {
        @strongify(self);
        self.userInfo = info;
        self.nickLabel.attributedText = [[NSAttributedString alloc] initWithString:self.userInfo.nick.length > 0 ? self.userInfo.nick : @" "
            attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xffffff),
                         NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f]}];
        self.nickLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.avatarImgView qn_setImageImageWithUrl:self.userInfo.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:(ImageType)ImageTypeUserIcon];
        [self.avatarBgImageView qn_setImageImageWithUrl:self.userInfo.avatar placeholderImage:nil type:(ImageType)ImageTypeUserIcon success:^(UIImage *image) {
            if (image != nil) {
                self.avatarBgImageView.image = [image applyBlurWithRadius:2 tintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] saturationDeltaFactor:1.8 maskImage:nil];
            }
        }];
    }failure:^(NSError *error) {
        
    }];
}


#pragma mark - Private
- (void)setupSubviews{
    
    NSAssert(self.uid > 0, @"can not init %@ without uid",NSStringFromClass([self class]));
    self.bounds = [UIScreen mainScreen].bounds;
    
    [self addSubview:self.avatarBgImageView];
    [self addSubview:self.effectView];
    
    [self addSubview:self.avatarImgView];
    [self addSubview:self.nickLabel];
    
    [self addSubview:self.lineLeft];
    [self addSubview:self.tipLabel];
    [self addSubview:self.lineRight];
    
    [self addSubview:self.homePageButton];
    [self addSubview:self.exitButton];
    
}
- (void)setupSubviewsConstraints{
    [self.avatarBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(102);
        make.width.height.equalTo(@120);
        make.centerX.equalTo(self);
    }];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImgView.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.width.equalTo(self.avatarImgView);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.exitButton.mas_top).offset(-90);
        make.centerX.equalTo(self);
    }];
    [self.lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tipLabel);
        make.height.equalTo(@0.5);
        make.width.equalTo(@84);
        make.right.equalTo(self.tipLabel.mas_left).offset(-8);
    }];
    [self.lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.lineLeft);
        make.left.equalTo(self.tipLabel.mas_right).offset(8);
    }];
    
    [self.homePageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(self.exitButton);
        make.bottom.equalTo(self.exitButton.mas_top).offset(-15);
    }];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-80);
        make.width.equalTo(@274);
        make.height.equalTo(@44);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - Getter
- (UIImageView *)avatarBgImageView {
    if (!_avatarBgImageView) {
        _avatarBgImageView = [[UIImageView alloc]init];
        _avatarBgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarBgImageView;
}
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    }
    return _effectView;
}

- (UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc]init];
        _avatarImgView.layer.masksToBounds = YES;
        _avatarImgView.layer.cornerRadius = 60.0;
    }
    return _avatarImgView;
}
- (YYLabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[YYLabel alloc]init];
    }
    return _nickLabel;
}

- (UIView *)lineLeft{
    if (!_lineLeft) {
        _lineLeft = [[UIView alloc] init];
        _lineLeft.backgroundColor = [XCTheme getTTMainColor];
    }
    return _lineLeft;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"房主已经下线";
        _tipLabel.textColor = [XCTheme getTTMainColor];
        _tipLabel.font = [UIFont boldSystemFontOfSize:18.0];
    }
    return _tipLabel;
}

- (UIView *)lineRight{
    if (!_lineRight) {
        _lineRight = [[UIView alloc] init];
        _lineRight.backgroundColor = [XCTheme getTTMainColor];
    }
    return _lineRight;
}


- (UIButton *)homePageButton {
    if (!_homePageButton) {
        _homePageButton = [[UIButton alloc]init];
        [_homePageButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _homePageButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _homePageButton.layer.cornerRadius = 22.f;
        _homePageButton.layer.masksToBounds = YES;
        _homePageButton.layer.borderWidth = 1;
        _homePageButton.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        [_homePageButton setTitle:@"返回主页" forState:UIControlStateNormal];
        [_homePageButton addTarget:self action:@selector(onHomePageClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homePageButton;
}

- (UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [[UIButton alloc]init];
        [_exitButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _exitButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _exitButton.layer.cornerRadius = 22.f;
        _exitButton.layer.masksToBounds = YES;
        _exitButton.layer.borderWidth = 1;
        _exitButton.layer.borderColor = UIColorRGBAlpha(0xffffff, 1).CGColor;
        [_exitButton setTitle:@"退出" forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(onExitClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}



@end
