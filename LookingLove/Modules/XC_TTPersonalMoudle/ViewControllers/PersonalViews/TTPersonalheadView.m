
//
//  TTPersonalheadView.m
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonalheadView.h"
#import "UserInfo.h"
#import <YYImage/YYAnimatedImageView.h>
#import <YYText/YYLabel.h>
#import "UIImageView+QiNiu.h"
#import "NSString+SpecialClean.h"
#import "BaseAttrbutedStringHandler+TTMineInfo.h"
#import "TTNobleSourceHelper.h"
#import "SpriteSheetImageManager.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "UIImage+Utils.h"
#import "XCMacros.h"

@interface TTPersonalheadView()
@property (nonatomic, strong) UIImageView  *avatarImageView;
@property (nonatomic, strong) YYAnimatedImageView *headwearImageView;
@property (nonatomic, strong) SpriteSheetImageManager  *manger;
@property (nonatomic, strong) YYLabel  *nameLabel;
@property (nonatomic, strong) UIImageView  *sexIcon;
@property (nonatomic, strong) YYLabel  *tutuIdLabel;
@property (nonatomic, strong) UIImageView  *arrowImageView;
@property (nonatomic, strong) UIImageView *iconBgImageView;
@property (nonatomic, strong) UIVisualEffectView *iconEffectView;
//@property (nonatomic, strong) UIView *maskView;
@end

@implementation TTPersonalheadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayoutViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.width / 2;
}

- (void)initLayoutViews {
    [self addSubview:self.iconBgImageView];
    [self addSubview:self.iconEffectView];
//    [self addSubview:self.maskView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.headwearImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.sexIcon];
    [self addSubview:self.tutuIdLabel];
    [self initLayoutConstriants];
}

- (void)initLayoutConstriants {
    [self.iconBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
//    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self);
//    }];
    [self.iconEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-36);
        make.top.mas_equalTo(kNavigationHeight + 20);
        make.height.width.mas_equalTo(80);
    }];
    [self.headwearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(self.avatarImageView).multipliedBy(1.31);
        make.center.mas_equalTo(self.avatarImageView);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.avatarImageView);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(7);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(self.avatarImageView.mas_left).offset(-30);
        make.top.mas_equalTo(self.avatarImageView);
    }];
    [self.sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    [self.tutuIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(20);
    }];
}

#pragma mark - Event

- (void)gotoPersonDescribeVC {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onGotoPersonView)]) {
        [self.delegate onGotoPersonView];
    }
}

- (void)gotoEditVC {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onGotoPersonEditing)]) {
        [self.delegate onGotoPersonEditing];
    }
}

#pragma mark - Getter && Setter

- (void)setInfo:(UserInfo *)info {
    _info = info;
    [self.avatarImageView qn_setImageImageWithUrl:_info.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeRoomFace];
    [self.iconBgImageView qn_setImageImageWithUrl:_info.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeRoomFace];

    if (self.info.userHeadwear.status == Headwear_Status_ok) {
        NSURL *url = [NSURL URLWithString:self.info.userHeadwear.effect];
        [self.manger loadSpriteSheetImageWithURL:url completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
            self.headwearImageView.image = sprit;
        } failureBlock:^(NSError * _Nullable error) {}];
    } else if(self.info.nobleUsers) {
        [TTNobleSourceHelper disposeImageView:self.headwearImageView withSource:self.info.nobleUsers.headwear imageType:ImageTypeRoomMagic];
    } else {
        self.headwearImageView.image = nil;
    }
    self.nameLabel.text = _info.nick;
    if (_info.gender == UserInfo_Male) {
        self.sexIcon.image = [UIImage imageNamed:[XCTheme defaultTheme].common_sex_male];
    } else {
        self.sexIcon.image = [UIImage imageNamed:[XCTheme defaultTheme].common_sex_female];
    }
    self.tutuIdLabel.attributedText = [BaseAttrbutedStringHandler creatTitle_Beauty_Constellation_IDByUserInfo:_info];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPersonDescribeVC)];
        [_avatarImageView addGestureRecognizer:tap];
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (SpriteSheetImageManager *)manger {
    if (!_manger) {
        _manger = [[SpriteSheetImageManager alloc] init];
    }
    return _manger;
}

- (YYAnimatedImageView *)headwearImageView {
    if (!_headwearImageView) {
        _headwearImageView = [[YYAnimatedImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPersonDescribeVC)];
        [_headwearImageView addGestureRecognizer:tap];
        _headwearImageView.userInteractionEnabled = YES;
    }
    return _headwearImageView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        _nameLabel.textColor = [XCTheme getTTMainTextColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoEditVC)];
        [_nameLabel addGestureRecognizer:tap];
        _nameLabel.userInteractionEnabled = YES;
    }
    return _nameLabel;
}

- (UIImageView *)sexIcon {
    if (!_sexIcon) {
        _sexIcon = [[UIImageView alloc] init];
    }
    return _sexIcon;
}

- (YYLabel *)tutuIdLabel {
    if(!_tutuIdLabel) {
        _tutuIdLabel = [[YYLabel alloc] init];
        _tutuIdLabel.font = [UIFont systemFontOfSize:13];
        _tutuIdLabel.numberOfLines = 0;
    }
    return _tutuIdLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_arrow_puding"]];
    }
    return _arrowImageView;
}

- (UIImageView *)iconBgImageView {
    if (!_iconBgImageView) {
        _iconBgImageView = [[UIImageView alloc] init];
    }
    return _iconBgImageView;
}

- (UIVisualEffectView *)iconEffectView {
    if (!_iconEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _iconEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    return _iconEffectView;
}

//- (UIView *)maskView {
//    if (!_maskView) {
//        _maskView = [[UIView alloc] init];
//        _maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
//    }
//    return _maskView;
//}
@end
