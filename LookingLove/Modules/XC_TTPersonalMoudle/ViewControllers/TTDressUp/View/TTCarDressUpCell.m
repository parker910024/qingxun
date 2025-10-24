//
//  TTCarDressUpCell.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTCarDressUpCell.h"

//model
#import "UserCar.h"
//client
#import "TTDressUpUIClient.h"
//cate
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Utils.h"
#import "UIButton+EnlargeTouchArea.h"
//t
#import "CoreManager.h"
#import "TTPersonModuleTools.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTCarDressUpCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView  *limitIcon;//
@property (nonatomic, strong) UIImageView  *stateIcon;//

@property (nonatomic, strong) UIView  *topView;//
@property (nonatomic, strong) UIImageView  *carImageView;//

@property (nonatomic, strong) UIButton  *driveBtn;//

@property (nonatomic, strong) UILabel *carNameLabel;
@property (nonatomic, strong) UILabel *goldNumLabel;
@end

@implementation TTCarDressUpCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.topView];
    [self.topView addSubview:self.carImageView];
    [self.topView addSubview:self.driveBtn];
    [self.topView addSubview:self.stateIcon];
    [self.containerView addSubview:self.carNameLabel];
    [self.containerView addSubview:self.limitIcon];
    
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.limitIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.containerView).offset(6);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.containerView);
        make.height.mas_equalTo(self.containerView);
    }];
    
    [self.stateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.carImageView);
        make.top.mas_equalTo(self.carImageView).offset(15);
    }];
    
    [self.driveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(37);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-35);
    }];
    
    [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.topView).inset(8);
        make.bottom.mas_equalTo(-46);
    }];
    
    [self.carNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.width.lessThanOrEqualTo(self.containerView);
        make.bottom.mas_equalTo(self.containerView).inset(20);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 14;
}

#pragma mark - Event
- (void)onClickDriveBtnAction {
    NotifyCoreClient(TTDressUpUIClient, @selector(showCar:), showCar:self.car);
}


#pragma mark - Setter && Getter

- (void)setCar:(UserCar *)car {
    _car = car;
    NSString *imageName = [TTPersonModuleTools getNameFromDressUpLimitType:(DressUpModel *)car];
    self.limitIcon.image = [UIImage imageNamed:imageName];
    self.stateIcon.hidden = !self.isPerson;
    if (_car.status == Car_Status_down) {
        self.stateIcon.image = [UIImage imageNamed:@"dressUp_person_down"];
    }else if (_car.status == Car_Status_expire){
        self.stateIcon.image = [UIImage imageNamed:@"dressUp_person_outTime"];
    }else {
        self.stateIcon.image = nil;
    }
    
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:car.pic] placeholderImage:[UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square] options:SDWebImageRetryFailed];
    
    self.carNameLabel.text = _car.name;
    if (_car.labelType == DressUpLabelType_Limit || _car.labelType == DressUpLabelType_Exclusive) {
        self.goldNumLabel.attributedText = nil;
    }else {
        self.goldNumLabel.attributedText = [TTPersonModuleTools getPriceAttriButeStringWithPrice:_car.price];
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.topView.layer.borderWidth = _isSelected ? 2 : 0;
    self.topView.backgroundColor = _isSelected ? UIColor.whiteColor : UIColorFromRGB(0xFAFAFA);
    self.carNameLabel.textColor = _isSelected ? [XCTheme getTTMainColor] : [XCTheme getTTMainTextColor];
}

- (void)setIsPerson:(BOOL)isPerson {
    _isPerson = isPerson;
    
    self.stateIcon.hidden = NO;
    self.limitIcon.hidden = YES;
    self.driveBtn.hidden = YES;
    self.carNameLabel.hidden = YES;
    self.goldNumLabel.hidden = YES;
    
    if (isPerson) {
        [self.carImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
    } else {
        [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.topView).inset(8);
            make.bottom.mas_equalTo(-46);
        }];
    }
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
- (UIButton *)driveBtn {
    if (!_driveBtn) {
        _driveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_driveBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
        [_driveBtn addTarget:self action:@selector(onClickDriveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_driveBtn setTitle:@"试驾" forState:UIControlStateNormal];
        _driveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_driveBtn setBackgroundImage:[UIImage imageNamed:@"dressShop_driveBtn_bg"] forState:UIControlStateNormal];
        [_driveBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
    }
    return _driveBtn;
}

- (UIImageView *)limitIcon {
    if (!_limitIcon) {
        _limitIcon = [[UIImageView alloc] init];
    }
    return _limitIcon;
}
- (UIImageView *)stateIcon {
    if (!_stateIcon) {
        _stateIcon = [[UIImageView alloc] init];
    }
    return _stateIcon;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = UIColorFromRGB(0xF7F7F7);
        _topView.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _topView.layer.borderWidth = 0;
        _topView.layer.cornerRadius = 14;
        _topView.layer.masksToBounds = YES;
    }
    return _topView;
}

- (UIImageView *)carImageView {
    if (!_carImageView) {
        _carImageView = [[UIImageView alloc] init];
        _carImageView.contentMode = UIViewContentModeScaleAspectFill;
        _carImageView.layer.masksToBounds = YES;
    }
    return _carImageView;
}

- (UILabel *)carNameLabel {
    if (!_carNameLabel) {
        _carNameLabel = [[UILabel alloc] init];
        _carNameLabel.textColor = [XCTheme getTTMainTextColor];
        _carNameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _carNameLabel;
}

- (UILabel *)goldNumLabel {
    if (!_goldNumLabel) {
        _goldNumLabel = [[UILabel alloc] init];
        _goldNumLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _goldNumLabel.font = [UIFont systemFontOfSize:12];
        _goldNumLabel.text = @"暂不出售";
    }
    return _goldNumLabel;
}
@end
