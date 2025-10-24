//
//  TTQueueMikeCell.m
//  TuTu
//
//  Created by lee on 2018/12/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTQueueMikeCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIImage+Utils.h"
#import "UserInfo.h"
#import "UIImageView+QiNiu.h"
#import "ImRoomCoreV2.h"

@interface TTQueueMikeCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UIButton *nickNameBtn;
@property (nonatomic, strong) UIButton *mikeBtn;

@end

@implementation TTQueueMikeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [XCTheme getTTSimpleGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.contentView addSubview:self.containerView];
    
    [self.containerView addSubview:self.countLabel];
    [self.containerView addSubview:self.iconImg];
    [self.containerView addSubview:self.nickNameBtn];
    [self.containerView addSubview:self.mikeBtn];
}

- (void)initConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 0, 10));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(17);
    }];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(self.countLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.nickNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImg.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(-100);
    }];
    
    [self.mikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(65);
        make.centerY.mas_equalTo(0);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
- (void)onMikeBtnClickAction:(UIButton *)btn {
    btn.userInteractionEnabled = NO;
    [self.delegate onQueueMicBtnClick:btn userID:self.userInfo.uid gender:self.userInfo.gender];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
}

#pragma mark -
#pragma mark getter & setter
- (void)setIsMyRoom:(BOOL)isMyRoom {
    _isMyRoom = isMyRoom;
    self.mikeBtn.selected = isMyRoom;
}

- (void)setUserInfo:(UserInfo *)userInfo {
    if (![userInfo isKindOfClass:[UserInfo class]]) {
        return;
    }
    _userInfo = userInfo;
    
    [self.nickNameBtn setTitle:userInfo.nick forState:UIControlStateNormal];
    [self.iconImg qn_setImageImageWithUrl:userInfo.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    NSString *imageName;
    switch (userInfo.gender) {
        case UserInfo_Male:
            imageName = [XCTheme defaultTheme].common_sex_male;
            break;
        case UserInfo_Female:
            imageName = [XCTheme defaultTheme].common_sex_female;
            break;
        default:
            break;
    }
    
    [self.nickNameBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
        UIImage *selectedImg;
        switch (userInfo.gender) {
            case UserInfo_Male:
                selectedImg = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0x8AE8FF), UIColorFromRGB(0x4ECBFB)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(70, 29)];
                break;
            case UserInfo_Female:
                selectedImg = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFF71EA), UIColorFromRGB(0xFF4B90)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(70, 29)];
                break;
            default:
                break;
        }
        [self.mikeBtn setBackgroundImage:selectedImg forState:UIControlStateSelected];
    }
}

// getter
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5;
    }
    return _containerView;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.backgroundColor = [XCTheme getTTMainColor];
        _countLabel.font = [UIFont systemFontOfSize:13.f];
        _countLabel.adjustsFontSizeToFitWidth = YES;
        _countLabel.layer.cornerRadius = 17 * 0.5;
        _countLabel.layer.masksToBounds = YES;
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

- (UIButton *)nickNameBtn {
    if (!_nickNameBtn) {
        _nickNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_nickNameBtn setTitle:@"从web(排行榜、年度盛典)上点击跳转至房间，进入后，一直loadin" forState:UIControlStateNormal];
        _nickNameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        [_nickNameBtn setImage:[UIImage imageNamed:[XCTheme defaultTheme].common_sex_male] forState:UIControlStateNormal];
        [_nickNameBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_nickNameBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        _nickNameBtn.userInteractionEnabled = NO;
        [_nickNameBtn setTransform:CGAffineTransformMakeScale(-1, 1)]; // 翻转
        _nickNameBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _nickNameBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);

    }
    return _nickNameBtn;
}

- (UIButton *)mikeBtn {
    if (!_mikeBtn) {
        _mikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mikeBtn setTitle:@"排麦中" forState:UIControlStateNormal];
        [_mikeBtn setTitle:@"抱上麦" forState:UIControlStateSelected];
        [_mikeBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_mikeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_mikeBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        UIImage *normalImg = [UIImage imageWithColor:[XCTheme getTTSimpleGrayColor]];
        UIImage *selectedImg = [UIImage imageWithColor:[XCTheme getTTMainColor]];
        [_mikeBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
        [_mikeBtn setBackgroundImage:selectedImg forState:UIControlStateSelected];
        _mikeBtn.layer.masksToBounds = YES;
        _mikeBtn.layer.cornerRadius = 15;
        [_mikeBtn addTarget:self action:@selector(onMikeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mikeBtn;
}

- (UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[XCTheme defaultTheme].default_avatar]];
        _iconImg.layer.cornerRadius = 20;
        _iconImg.layer.masksToBounds = YES;
    }
    return _iconImg;
}


@end
