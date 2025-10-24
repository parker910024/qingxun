//
//  TTDressUpContainHeadView.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDressUpContainHeadView.h"

//model
#import "UserInfo.h"
#import "UserHeadWear.h"

//cate
#import "UIImageView+QiNiu.h"
//core client
#import "TTDressUpUIClient.h"
#import "CoreManager.h"
//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "SpriteSheetImageManager.h"
#import <YYImage/YYAnimatedImageView.h>

@interface TTDressUpContainHeadView()<TTDressUpUIClient>
@property (nonatomic, strong) UIView  *navView;//
@property (nonatomic, strong) UIButton  *leftButton;//
@property (nonatomic, strong) UIButton  *rightButton;//
@property (nonatomic, strong) UILabel  *titleLabel;//
@property (nonatomic, strong) UIView *redBageView;

@property (nonatomic, strong) UIImageView  *bgImageView;//
@property (nonatomic, strong) UIImageView  *avatar;//头像

@property (nonatomic, strong) SpriteSheetImageManager  *manager;//
@property (nonatomic, strong) YYAnimatedImageView  *hearwearImageView;//头饰

@property (nonatomic, strong) UserHeadWear  *selectHeadwear;//
@property (nonatomic, strong) UserHeadWear  *lastHeadwear;//上次选择的头饰

@end

@implementation TTDressUpContainHeadView

- (void)dealloc {
    RemoveCoreClient(TTDressUpUIClient, self);
}

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.navView];
    [self.navView addSubview:self.leftButton];
    [self.navView addSubview:self.rightButton];
    [self.navView addSubview:self.titleLabel];
    [self.navView addSubview:self.redBageView];
    
    [self addSubview:self.avatar];
    [self addSubview:self.hearwearImageView];
    
    [self makeConstriants];
    AddCoreClient(TTDressUpUIClient, self);
}

- (void)makeConstriants {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self).offset(statusbarHeight);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.navView).offset(8);
        make.centerY.mas_equalTo(self.navView);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(20);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navView).offset(-15);
        make.centerY.mas_equalTo(self.navView);
    }];
    
    [self.redBageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightButton.mas_left).offset(-8);
        make.height.width.mas_equalTo(6);
        make.centerY.mas_equalTo(self.rightButton);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.navView);
    }];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.width.mas_equalTo(67);
        make.bottom.mas_equalTo(self).offset(-50);
    }];
    [self.hearwearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.avatar);
        make.height.width.mas_equalTo(self.avatar).multipliedBy(1.31);
    }];
}

#pragma mark - core client
- (void)shopSelectHeadwear:(UserHeadWear *)headwear {
    self.selectHeadwear = headwear;
}
#pragma mark - Event

- (void)onClickLeftButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBackAction)]) {
        [self.delegate onClickBackAction];
    }
}

- (void)onClickRightButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickMineDressupAction)]) {
        [self.delegate onClickMineDressupAction];
    }
}

#pragma mark - Getter && Setter
- (void)setIsShowBage:(BOOL)isShowBage {
    _isShowBage = isShowBage;
    self.redBageView.hidden = !isShowBage;
}

- (void)setInfo:(UserInfo *)info {
    _info = info;
    [self.avatar qn_setImageImageWithUrl:_info.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
}

- (void)setSelectHeadwear:(UserHeadWear *)selectHeadwear {
    _selectHeadwear = selectHeadwear;
    
    if (self.lastHeadwear) {
        if ([self.lastHeadwear.effect isEqualToString:_selectHeadwear.effect]) {
            return;
        }
    }
    
    self.lastHeadwear = _selectHeadwear;
    
    [self.manager loadSpriteSheetImageWithURL:[NSURL URLWithString:_selectHeadwear.effect] completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
        self.hearwearImageView.image = sprit;
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}


- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] init];
    }
    return _navView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_DressUp_headBG"]];
    }
    return _bgImageView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(onClickLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@"我的装扮" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(onClickRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"装扮商城";
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}


- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 67/2;
    }
    return _avatar;
}

- (YYAnimatedImageView *)hearwearImageView {
    if (!_hearwearImageView) {
        _hearwearImageView = [[YYAnimatedImageView alloc] init];
    }
    return _hearwearImageView;
}
- (SpriteSheetImageManager *)manager {
    if (!_manager) {
        _manager = [[SpriteSheetImageManager alloc] init];
    }
    return _manager;
}

- (UIView *)redBageView
{
    if (!_redBageView) {
        _redBageView = [[UIView alloc] init];
        _redBageView.backgroundColor = [UIColor redColor];
        _redBageView.layer.cornerRadius = 3;
        _redBageView.layer.masksToBounds = YES;
        _redBageView.hidden = YES;
    }
    return _redBageView;
}


@end
