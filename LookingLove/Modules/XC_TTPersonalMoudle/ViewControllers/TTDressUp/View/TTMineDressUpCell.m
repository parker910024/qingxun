//
//  TTMineDressUpCell.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMineDressUpCell.h"

//model
#import "UserCar.h"
#import "UserHeadWear.h"
//t
#import <YYImage/YYAnimatedImageView.h>
#import "SpriteSheetImageManager.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "CoreManager.h"
#import "TTPersonModuleTools.h"
//cate
#import "UIImage+Utils.h"
#import "UIImage+_1x1Color.h"
#import "UIImageView+QiNiu.h"
//
#import "TTCarDressUpCell.h"

@interface TTMineDressUpCell()

@property (nonatomic, strong) UserHeadWear  *headwear;//
@property (nonatomic, strong) UserCar  *car;//

@property (nonatomic, strong) UIView  *contianView;//

@property (nonatomic, strong) UIImageView  *limicIconImageView;//类型
@property (nonatomic, strong) UIImageView  *giveIcon;//赠送

@property (nonatomic, strong) SpriteSheetImageManager  *managr;//
@property (nonatomic, strong) YYAnimatedImageView  *headwearImageView;//

@property (nonatomic, strong) UIImageView  *carImageView;//
@property(nonatomic, strong) UIView *carBgGaryView; // 座驾bgView
//price
@property (nonatomic, strong) UILabel  *dressUpNameLabel;//名字
@property (nonatomic, strong) UILabel  *priceOrRenewLabel;//价格
@property (nonatomic, strong) UIImageView  *timeIcon;//状态icon
@property (nonatomic, strong) UILabel  *timeLabel;//状态
//operation
@property (nonatomic, strong) UIButton  *renewBtn;//续费
@property (nonatomic, strong) UIButton  *buyBtn;//购买
@property (nonatomic, strong) UIButton  *cancelUseBtn;//取消使用
@property (nonatomic, strong) UIButton  *useBtn;//使用

@property (nonatomic, strong) UILabel *sellStatusLabel;//销售状态（暂不出售、已下架，正常不显示）

@end

@implementation TTMineDressUpCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.contianView];
    [self.contianView addSubview:self.headwearImageView];
    [self.contianView addSubview:self.carBgGaryView];
    [self.contianView addSubview:self.carImageView];
    [self.contianView addSubview:self.limicIconImageView];
    [self.contianView addSubview:self.giveIcon];
    [self.contianView addSubview:self.dressUpNameLabel];
    [self.contianView addSubview:self.priceOrRenewLabel];
    [self.contianView addSubview:self.timeIcon];
    [self.contianView addSubview:self.timeLabel];
    [self.contianView addSubview:self.renewBtn];
    [self.contianView addSubview:self.buyBtn];
    [self.contianView addSubview:self.cancelUseBtn];
    [self.contianView addSubview:self.useBtn];
    [self.contianView addSubview:self.sellStatusLabel];
    
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.contianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.headwearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(80);
        make.centerY.mas_equalTo(self.contianView);
        make.left.mas_equalTo(self.contianView).offset(20);
    }];
    [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(68);
        make.width.mas_equalTo(102);
        make.centerY.mas_equalTo(self.contianView);
        make.left.mas_equalTo(self.contianView).offset(20);
    }];
    
    [self.carBgGaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.carImageView).inset(-6);
    }];
    
    [self.limicIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contianView).offset(20);
        make.width.height.mas_equalTo(20);
    }];
    [self.giveIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headwearImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(self.dressUpNameLabel);
    }];
    [self.dressUpNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giveIcon);
        make.top.mas_equalTo(self.contianView).offset(21);
    }];
    [self.priceOrRenewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giveIcon);
        make.top.mas_equalTo(self.dressUpNameLabel.mas_bottom).offset(8);
    }];
    [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giveIcon);
        make.height.width.mas_equalTo(11);
        make.bottom.mas_equalTo(self.contianView).inset(20);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeIcon.mas_right).offset(2);
        make.centerY.mas_equalTo(self.timeIcon);
    }];
    [self.renewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contianView).offset(20);
        make.right.mas_equalTo(self.contianView).offset(-15);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(85);
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contianView).offset(20);
        make.right.mas_equalTo(self.contianView).offset(-15);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(85);
    }];
    [self.cancelUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contianView).offset(-20);
        make.right.mas_equalTo(self.contianView).offset(-15);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(85);
    }];
    [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contianView).offset(-20);
        make.right.mas_equalTo(self.contianView).offset(-15);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(85);
    }];
    
    [self.sellStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.renewBtn);
        make.centerY.mas_equalTo(0);
    }];
}

#pragma mark - private

- (void)priceToBuyOrRenew:(UserCar *)car headwear:(UserHeadWear *)headwear {
    
    DressUpModel *model = car ?: headwear;
    
    NSString *imageName = [TTPersonModuleTools getNameFromDressUpLimitType:model];
    self.limicIconImageView.image = [UIImage imageNamed:imageName];
    
    NSString *expireDays;// 距过期还有多少天（注意可能为负数）
    NSString *coinPrice = @"";    // 金币价格
    NSString *carrotPrice = @"";  // 萝卜价格
    
    BOOL isUse = NO;
    BOOL isGive = NO;
    
    if (car) {
        isUse = car.isUsed;
        isGive = car.isGive;
        expireDays = [NSString stringWithFormat:@"%ld", car.expireDate];
    } else {
        isUse = headwear.isUsed;
        isGive = headwear.comeFrom.intValue - 1;
        expireDays = headwear.expireDays;
    }
    
    if (car && car.status == Car_Status_ok) {
        
        if (model.goldSale) {
            coinPrice = [NSString stringWithFormat:@"%@金币", car.renewPrice];
        }
        if (model.radishSale) {
            carrotPrice = [NSString stringWithFormat:@"%@萝卜", car.radishRenewPrice];
        }
        
    } else if (headwear.status == Headwear_Status_ok) {
        
        if (model.goldSale) {
            coinPrice = [NSString stringWithFormat:@"%@金币", headwear.renewPrice];
        }
        if (model.radishSale) {
            carrotPrice = [NSString stringWithFormat:@"%@萝卜", headwear.radishRenewPrice];
        }
        
    } else {
        
        if (model.goldSale) {
            coinPrice = [NSString stringWithFormat:@"%@金币", model.price];
        }
        if (model.radishSale) {
            carrotPrice = [NSString stringWithFormat:@"%@萝卜", model.radishPrice];
        }
        
    }
    
    // 如果是单货币购买，就去掉 / 符号
    NSString *NeedPrice = [NSString stringWithFormat:@"%@/%@", coinPrice, carrotPrice];
    if (!model.goldSale || !model.radishSale) {
        NeedPrice = [NeedPrice stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    self.priceOrRenewLabel.text = NeedPrice;
    
    NSString *dressName = car ? car.name : headwear.headwearName;
    if (isGive) {
        dressName = [NSString stringWithFormat:@"    %@", dressName];
    }
    self.dressUpNameLabel.text = dressName;
    
    self.giveIcon.hidden = !isGive;
    
    //是否已下架
    BOOL isDown = (car.status == Car_Status_down) || (headwear.status == Headwear_Status_down);
    //是否已过期
    BOOL isExpired = (car.status == Car_Status_expire) || (headwear.status == Headwear_Status_expire) || expireDays.integerValue < 0;
    //是否为暂不出售
    BOOL notForSell = model.labelType == DressUpLabelType_Limit || model.labelType == DressUpLabelType_Exclusive;
    
    self.renewBtn.hidden = isDown || notForSell || isExpired;//下架|不出售|已过期 不显示续费
    self.buyBtn.hidden = isDown || notForSell || !isExpired;//下架|不出售|未过期 不显示购买
    self.useBtn.hidden = isExpired || isUse;//已过期|使用中 不显示使用
    self.cancelUseBtn.hidden = isExpired || !isUse;//已过期|未使用 不显示取消使用
    self.priceOrRenewLabel.hidden = notForSell; // 专属|限定 不显示价格
    
    self.timeLabel.text = isExpired ? @"已过期" : [NSString stringWithFormat:@"剩余%@", expireDays];
    
    ///布局思路：1.先判断下架情况；2.判断过期情况；3.判断使用情况
    if (notForSell || isDown) {
        [self remakeDownOrNotSellLayoutWithExpiredStatus:isExpired
                                             usingStatus:isUse
                                              downStatus:isDown];
    } else {
        [self remakeForSellLayoutWithExpiredStatus:isExpired
                                       usingStatus:isUse];
    }
}

/**
 重新约束可出售商品布局
 
 @param isExpired 是否已过期
 @param isUse 是否在使用中
 */
- (void)remakeForSellLayoutWithExpiredStatus:(BOOL)isExpired
                                 usingStatus:(BOOL)isUse {
    
    self.sellStatusLabel.hidden = YES;
    
    if (isExpired) {
        
        //已过期
        [self.buyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.renewBtn);
            make.centerY.mas_equalTo(0);
        }];
        
    } else if (isUse) {
        
        //使用中
        [self.cancelUseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.renewBtn.mas_bottom).offset(14);
            make.centerX.width.height.mas_equalTo(self.renewBtn);
        }];
        
    } else {
        
        //未使用
        [self.useBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.renewBtn.mas_bottom).offset(14);
            make.centerX.width.height.mas_equalTo(self.renewBtn);
        }];
    }
}

/**
 重新约束暂不出售和已下架商品布局
 
 @discussion “暂不出售”和“已下架”现在是当做相同的布局处理，就文案不同
 
 @param isExpired 是否已过期
 @param isUse 是否在使用中
 @param isDown 是否已下架
 */
- (void)remakeDownOrNotSellLayoutWithExpiredStatus:(BOOL)isExpired
                                       usingStatus:(BOOL)isUse
                                        downStatus:(BOOL)isDown {
    
    self.sellStatusLabel.hidden = NO;
    self.sellStatusLabel.text = isDown ? @"已下架" : @"暂不出售";
    
    if (isExpired) {
        
        //已过期
        [self.sellStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.renewBtn);
            make.centerY.mas_equalTo(0);
        }];
        
    } else if (isUse) {
        
        //使用中
        [self.sellStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.renewBtn);
            make.top.mas_equalTo(self.renewBtn.mas_bottom).offset(24);
        }];
        [self.cancelUseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.width.height.mas_equalTo(self.renewBtn);
        }];
        
    } else {
        
        //未使用
        [self.sellStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.renewBtn);
            make.top.mas_equalTo(self.renewBtn.mas_bottom).offset(24);
        }];
        [self.useBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.width.height.mas_equalTo(self.renewBtn);
        }];
    }
}

#pragma mark - Event

- (void)setModel:(DressUpModel *)model {
    _model = model;
    if ([_model isKindOfClass:[UserHeadWear class]]) {
        self.headwear = (UserHeadWear *)model;
    }else  {
        self.car = (UserCar *)model;
    }
}

- (void)setHeadwear:(UserHeadWear *)headwear {
    _headwear = headwear;
    self.carImageView.hidden = YES;
    self.carBgGaryView.hidden = YES;
    [self priceToBuyOrRenew:nil headwear:_headwear];
    @weakify(self)
    [self.managr loadSpriteSheetImageWithURL:[NSURL URLWithString:_headwear.effect] completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
        @strongify(self)
        self.headwearImageView.image = sprit;
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)setCar:(UserCar *)car {
    _car = car;
    [self.giveIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.carImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(self.dressUpNameLabel);
    }];
    self.headwearImageView.hidden = YES;
    [self priceToBuyOrRenew:_car headwear:nil];
    [self.carImageView qn_setImageImageWithUrl:_car.pic placeholderImage:@"dress_headwear_placehoder" type:ImageTypeRoomFace];
}

//购买
- (void)onClickBuyBtn {
    if (self.headwear) {
        NotifyCoreClient(TTDressUpUIClient, @selector(shopBuyHeadwear:place:), shopBuyHeadwear:self.headwear place:TTDressUpPlaceType_HeadwearGarage);
        
    }else if (self.car) {
        NotifyCoreClient(TTDressUpUIClient, @selector(shopBuyCar:place:), shopBuyCar:self.car place:TTDressUpPlaceType_CarGarage);
    }
}

//取消使用
- (void)onClickCancelUseBtn {
    if (self.headwear) {
        NotifyCoreClient(TTDressUpUIClient, @selector(mineCancelUseHeadwear), mineCancelUseHeadwear);
    }else if (self.car) {
        NotifyCoreClient(TTDressUpUIClient, @selector(mineCancelCar), mineCancelCar);
    }
}
//使用
- (void)onClickUseBtn {
    if (self.headwear) {
        NotifyCoreClient(TTDressUpUIClient, @selector(mineUseHeadwear:), mineUseHeadwear:self.headwear );
    }else if (self.car) {
        NotifyCoreClient(TTDressUpUIClient, @selector(mineUseCar:), mineUseCar:self.car);
    }
}

#pragma mark - Getter && Setter

- (UIView *)contianView {
    if (!_contianView) {
        _contianView = [[UIView alloc] init];
        _contianView.backgroundColor = [UIColor whiteColor];
        _contianView.layer.masksToBounds = YES;
        _contianView.layer.cornerRadius = 10;
    }
    return _contianView;
}

- (UIImageView *)limicIconImageView {
    if (!_limicIconImageView) {
        _limicIconImageView = [[UIImageView alloc] init];
    }
    return _limicIconImageView;
}

- (SpriteSheetImageManager *)managr {
    if (!_managr) {
        _managr = [[SpriteSheetImageManager alloc] init];
    }
    return _managr;
}

- (YYAnimatedImageView *)headwearImageView {
    if (!_headwearImageView) {
        _headwearImageView = [[YYAnimatedImageView alloc] init];
        _headwearImageView.backgroundColor = UIColorFromRGB(0xF7F7F7);
        _headwearImageView.layer.masksToBounds = YES;
        _headwearImageView.layer.cornerRadius = 10;
    }
    return _headwearImageView;
}


- (UIImageView *)carImageView {
    if (!_carImageView) {
        _carImageView = [[UIImageView alloc] init];
        _carImageView.backgroundColor = UIColorFromRGB(0xF7F7F7);
        _carImageView.layer.masksToBounds = YES;
        _carImageView.layer.cornerRadius = 10;
    }
    return _carImageView;
}

- (UIView *)carBgGaryView {
    if (!_carBgGaryView) {
        _carBgGaryView = [[UIView alloc] init];
        _carBgGaryView.backgroundColor = UIColorFromRGB(0xF7F7F7);
        _carBgGaryView.layer.cornerRadius = 10;
        _carBgGaryView.layer.masksToBounds = YES;
    }
    return _carBgGaryView;
}

- (UILabel *)dressUpNameLabel {
    if (!_dressUpNameLabel) {
        _dressUpNameLabel = [[UILabel alloc] init];
        _dressUpNameLabel.font = [UIFont systemFontOfSize:15];
        _dressUpNameLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _dressUpNameLabel;
}


- (UILabel *)priceOrRenewLabel {
    if (!_priceOrRenewLabel) {
        _priceOrRenewLabel = [[UILabel alloc] init];
        _priceOrRenewLabel.textColor = [XCTheme getTTMainColor];
        _priceOrRenewLabel.font = [UIFont systemFontOfSize:13];
    }
    return _priceOrRenewLabel;
}

- (UIButton *)renewBtn {
    if (!_renewBtn) {
        _renewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFE7763),UIColorFromRGB(0xFD5766)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(85, 33)];
        [_renewBtn setBackgroundImage:[UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0x999999)] forState:UIControlStateDisabled];
        [_renewBtn setTitle:@"续费" forState:UIControlStateNormal];
        [_renewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_renewBtn addTarget:self action:@selector(onClickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
        _renewBtn.layer.masksToBounds = YES;
        _renewBtn.layer.cornerRadius = 33/2;
        image = [UIImage imageWithColor:UIColorFromRGB(0xFF8484)];
        [_renewBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _renewBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _renewBtn.layer.borderWidth = 2;
        [_renewBtn setBackgroundImage:image forState:UIControlStateNormal];
        _renewBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _renewBtn;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFFC807), UIColorFromRGB(0xFEAD30)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(85, 33)];
        [_buyBtn setBackgroundImage:[UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0x999999)] forState:UIControlStateDisabled];
        [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyBtn addTarget:self action:@selector(onClickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.cornerRadius = 33/2;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        image = [UIImage imageWithColor:UIColorFromRGB(0x34EBDE) size:CGSizeMake(85, 33)];
        [_buyBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _buyBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _buyBtn.layer.borderWidth = 2;
        [_buyBtn setBackgroundImage:image forState:UIControlStateNormal];

    }
    return _buyBtn;
}

- (UIButton *)cancelUseBtn {
    if (!_cancelUseBtn) {
        _cancelUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelUseBtn.backgroundColor = UIColorFromRGB(0xFEF5ED);
        [_cancelUseBtn setTitle:@"取消使用" forState:UIControlStateNormal];
        [_cancelUseBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_cancelUseBtn addTarget:self action:@selector(onClickCancelUseBtn) forControlEvents:UIControlEventTouchUpInside];
        _cancelUseBtn.layer.masksToBounds = YES;
        _cancelUseBtn.layer.cornerRadius = 33/2;
        _cancelUseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelUseBtn.layer.borderWidth = 2;
        _cancelUseBtn.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        _cancelUseBtn.backgroundColor = UIColor.whiteColor;
        [_cancelUseBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
    }
    return _cancelUseBtn;
}

- (UIButton *)useBtn {
    if (!_useBtn) {
        _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFFC807), UIColorFromRGB(0xFEAD30)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(85, 33)];
        [_useBtn setTitle:@"使用" forState:UIControlStateNormal];
        [_useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_useBtn addTarget:self action:@selector(onClickUseBtn) forControlEvents:UIControlEventTouchUpInside];
        _useBtn.layer.masksToBounds = YES;
        _useBtn.layer.cornerRadius = 33/2;
        _useBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        image = [UIImage imageWithColor:UIColorFromRGB(0x34EBDE)];
        [_useBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _useBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _useBtn.layer.borderWidth = 2;
        [_useBtn setBackgroundImage:image forState:UIControlStateNormal];

    }
    return _useBtn;
}

- (UIImageView *)giveIcon {
    if (!_giveIcon) {
        _giveIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_Dressup_give"]];
    }
    return _giveIcon;
}

- (UIImageView *)timeIcon {
    if (!_timeIcon) {
        _timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_Dressup_time"]];
    }
    return _timeIcon;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _timeLabel;
}

- (UILabel *)sellStatusLabel {
    if (!_sellStatusLabel) {
        _sellStatusLabel = [[UILabel alloc] init];
        _sellStatusLabel.font = [UIFont systemFontOfSize:13];
        _sellStatusLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _sellStatusLabel.hidden = YES;
    }
    return _sellStatusLabel;
}

@end
