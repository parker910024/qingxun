//
//  LTOtherUserHeaderView.m
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTOtherUserHeaderView.h"

//core
#import "UserCore.h"
#import "UserInfo.h"

//tool
#import <SDWebImage/UIImageView+WebCache.h>


#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"

@interface LTOtherUserHeaderView ()
///用户头像
@property (nonatomic, strong) UIImageView *userIconImg;
///用户名称
@property (nonatomic, strong) UILabel *nameLab;
///用户国家
@property (nonatomic, strong) UILabel *countryLab;
///魅力值
@property (nonatomic, strong) UIButton *glamourBtn;
///用户信息 女/21/射手座ID:465657674
@property (nonatomic, strong) UILabel *userInfoLab;
///uid
@property (nonatomic, copy) NSString *uid;
///向下的箭头
@property (nonatomic, strong) UIImageView *arrowImg;

@end

@implementation LTOtherUserHeaderView


- (instancetype)initWithOtherUid:(NSString *)uid {
    self = [super init];
    if (self) {
        self.uid = uid;
        [self initView];
        [self initConstrations];
        [self getUserInfo];
    }
    return self;
}

#pragma mark - 私有方法
- (void)initView {
//    [self addSubview:self.videoPlayVc.view];
//    self.videoPlayVc.view.clipsToBounds = YES;
    [self addSubview:self.userIconImg];
    [self addSubview:self.nameLab];
    [self addSubview:self.countryLab];
    [self addSubview:self.glamourBtn];
    [self addSubview:self.userInfoLab];
    [self addSubview:self.arrowImg];
}

- (void)initConstrations {
    
//    [self.videoPlayVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self);
//        make.bottom.equalTo(self.mas_bottom).mas_offset(-146);
//    }];
//
//    [self.userIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.mas_right).mas_offset(-23);
//        make.centerY.mas_equalTo(self.videoPlayVc.view.mas_bottom).mas_offset(146/2.f);
//        make.width.height.mas_equalTo(80);
//    }];
//    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.videoPlayVc.view.mas_bottom).mas_offset(30);
//        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(self.userIconImg.mas_left).mas_offset(-5);
//    }];
//    [self.countryLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20);
//        make.top.mas_equalTo(self.nameLab.mas_bottom).mas_offset(7);
//    }];
//    [self.userInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20);
//        make.top.mas_equalTo(self.countryLab.mas_bottom).mas_offset(10);
//    }];
//    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.userInfoLab.mas_bottom);
//        make.centerX.mas_equalTo(self.mas_centerX);
//    }];
}

- (void)getUserInfo {
    @weakify(self);
    [[GetCore(UserCore) getUserInfoByRac:self.uid.userIDValue refresh:YES] subscribeNext:^(UserInfo *userInfo){
        @strongify(self);
        [self.userIconImg sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:default_bg]];
        self.nameLab.text = userInfo.nick;
//        NSString *country = userInfo.country.length ? userInfo.country : @"----";
//        self.countryLab.text = country;
//        NSString *ageStr = userInfo.age.integerValue > 0 ? [NSString stringWithFormat:@"%@/%@",userInfo.age,userInfo.constellation] : [@"未知" localString];
//        self.userInfoLab.text = [NSString stringWithFormat:@"%@/%@/ID:%@",userInfo.sex,ageStr,userInfo.erbanNo];
//        [self setGlamourButtonWith:userInfo.totalLike];
    }];
}

- (void)setGlamourButtonWith:(int )glamour {
    [self.glamourBtn setTitle:[NSString stringWithFormat:@"%d",glamour] forState:UIControlStateNormal];
    [self.glamourBtn sizeToFit];
    self.glamourBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.glamourBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [self.glamourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.countryLab.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(self.countryLab.mas_centerY);
        make.width.mas_equalTo(self.glamourBtn.width + 10 + 26);
        make.height.mas_equalTo(24);
        make.right.mas_lessThanOrEqualTo(self.userIconImg.mas_left).mas_offset(-5);
    }];
}

#pragma mark - set/get

//- (KEShortVideoPlayViewControler *)videoPlayVc {
//    if (!_videoPlayVc) {
//        _videoPlayVc = [[KEShortVideoPlayViewControler alloc] init];
//        _videoPlayVc.viewHeight = KScreenHeight - 146;
//        _videoPlayVc.uid = self.uid;
//        _videoPlayVc.isUserHomePage = YES;
//    }
//    return _videoPlayVc;
//}

- (UIImageView *)userIconImg {
    if (!_userIconImg) {
        _userIconImg = [[UIImageView alloc]init];
        _userIconImg.contentMode = UIViewContentModeScaleAspectFill;
        _userIconImg.layer.cornerRadius = 40;
        _userIconImg.layer.masksToBounds = YES;
//        _userIconImg.layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
//        _userIconImg.layer.borderWidth = 3;
    }
    return _userIconImg;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]init];
        _nameLab.textColor = UIColorRGBAlpha(0x222222, 1);
        _nameLab.font = [UIFont boldSystemFontOfSize:25];
    }
    return _nameLab;
}

- (UILabel *)countryLab {
    if (!_countryLab) {
        _countryLab = [[UILabel alloc]init];
        _countryLab.textColor = UIColorRGBAlpha(0x000000, 1);
        _countryLab.font = [UIFont boldSystemFontOfSize:18];
//        _countryLab.text = @"----";
    }
    return _countryLab;
}

- (UIButton *)glamourBtn {
    if (!_glamourBtn) {
        _glamourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _glamourBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_glamourBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_glamourBtn setImage:[UIImage imageNamed:@"Person_glamour_icon"] forState:UIControlStateNormal];
        //        _glamourBtn.frame = CGRectMake(0, 0, _glamourBtn.width + 10 + 26, 24);
        _glamourBtn.backgroundColor = UIColorFromRGB(0x000000);
        _glamourBtn.layer.cornerRadius = 12;
        _glamourBtn.layer.masksToBounds = YES;
    }
    return _glamourBtn;
}

- (UILabel *)userInfoLab {
    if (!_userInfoLab) {
        _userInfoLab = [[UILabel alloc]init];
        _userInfoLab.textColor = UIColorRGBAlpha(0x999999, 1);
        _userInfoLab.font = [UIFont systemFontOfSize:12];
    }
    return _userInfoLab;
}

- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person_arrow_down"]];
        [_arrowImg sizeToFit];
    }
    return _arrowImg;
}



@end
