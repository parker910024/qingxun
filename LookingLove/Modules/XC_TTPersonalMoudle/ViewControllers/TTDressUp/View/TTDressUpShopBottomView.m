//
//  TTDressUpShopBottomView.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDressUpShopBottomView.h"

//core client
#import "TTDressUpUIClient.h"

//model
#import "UserCar.h"
#import "UserHeadWear.h"

//cate
#import "UIImage+Utils.h"
//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "CoreManager.h"
#import "TTWKWebViewViewController.h"
#import "XCCurrentVCStackManager.h"

@interface TTDressUpShopBottomView()<TTDressUpUIClient>
@property (nonatomic, strong) UserCar *userCar;//
@property (nonatomic, strong) UserHeadWear *userHeadwear;//

@property (nonatomic, strong) UIView  *contianView;//
/***--  正常 新 折扣 显示 ---*****/
@property (nonatomic, strong) UIView  *nomalOperationView;// 正常 新 折扣 显示
@property (nonatomic, strong) UIView  *operationbtnView;//
@property (nonatomic, strong) UIButton  *presentBtn;// 赠送
@property (nonatomic, strong) UIButton  *buyOrRenewBtn;// 购买/续费
@property (nonatomic, strong) UILabel  *currentPriceLabel;// 现价
@property (nonatomic, strong) UILabel  *originPriceLabel;//原价
@property (nonatomic, strong) UIView  *cutLineView;//
@property (nonatomic, strong) UIButton  *onlyPresentBtn;//赠送
/***--  限定 专属 显示 ---*****/
@property (nonatomic, strong) UIView  *conditionView;//限定 专属 显示
@property (nonatomic, strong) UILabel  *conditionLabel;//
@property (nonatomic, strong) UIButton  *conditionBtn;//

@property (nonatomic, strong) UIView *lineView;//
@end

@implementation TTDressUpShopBottomView

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
    
    AddCoreClient(TTDressUpUIClient, self);
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contianView];
    [self.contianView addSubview:self.nomalOperationView];
    [self.contianView addSubview:self.conditionView];
    
    [self.nomalOperationView addSubview:self.currentPriceLabel];
    [self.nomalOperationView addSubview:self.originPriceLabel];
    [self.nomalOperationView addSubview:self.operationbtnView];
    [self.nomalOperationView addSubview:self.onlyPresentBtn];
    
    [self.originPriceLabel addSubview:self.cutLineView];
    [self.operationbtnView addSubview:self.presentBtn];
    [self.operationbtnView addSubview:self.buyOrRenewBtn];
    
    [self.conditionView addSubview:self.conditionLabel];
    [self.conditionView addSubview:self.conditionBtn];
    
    [self addSubview:self.lineView];
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.contianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-kSafeAreaBottomHeight);
    }];
    [self.nomalOperationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contianView);
    }];
    [self.conditionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contianView);
    }];
    
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nomalOperationView).offset(15);
        make.top.mas_equalTo(self.nomalOperationView).offset(13);
    }];
    [self.originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nomalOperationView).offset(15);
        make.top.mas_equalTo(self.currentPriceLabel.mas_bottom).offset(9);
    }];
    [self.cutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.mas_equalTo(self.originPriceLabel);
        make.height.mas_equalTo(1);
    }];
    
    [self.onlyPresentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contianView);
        make.right.mas_equalTo(self.conditionView).offset(-15);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(83);
    }];
    [self.operationbtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contianView);
        make.right.mas_equalTo(self.contianView).offset(-15);
        make.height.mas_equalTo(33);
    }];
    
    [self.presentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(71);
        make.left.top.bottom.mas_equalTo(self.operationbtnView);
    }];
    
    [self.buyOrRenewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.presentBtn);
        make.left.mas_equalTo(self.presentBtn.mas_right);
        make.top.bottom.right.mas_equalTo(self.operationbtnView);
    }];
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.conditionView).offset(15);
        make.centerY.mas_equalTo(self.conditionView);
        make.right.mas_equalTo(self.conditionBtn.mas_left).offset(-30);
    }];
    [self.conditionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.conditionView).offset(-15);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(83);
        make.centerY.mas_equalTo(self.conditionView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - TTDressUpUIClient

- (void)shopSelectCar:(UserCar *)userCar {
    [self dealDressUpDataWithCar:userCar headwear:nil];
}

- (void)shopSelectHeadwear:(UserHeadWear *)headwear {
    [self dealDressUpDataWithCar:nil headwear:headwear];
}


/** 大佬们，不知道为啥其他控制器里不走这个方法，所以写这里 */
- (void)shopTogetLimitDressUpAdress:(NSString *)adress {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
    vc.urlString = adress;
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
}


#pragma mark - Event
- (void)onClickPresentBtnActin {
    NotifyCoreClient(TTDressUpUIClient, @selector(shopBottomPresentCar:headwear:), shopBottomPresentCar:self.userCar headwear:self.userHeadwear);
}

- (void)onClickBuyOrRenewBtnAction {
    if (self.userHeadwear) {
        NotifyCoreClient(TTDressUpUIClient, @selector(shopBuyHeadwear:place:), shopBuyHeadwear:self.userHeadwear place:TTDressUpPlaceType_HeadwearShop);
    }else if (self.userCar) {
        NotifyCoreClient(TTDressUpUIClient, @selector(shopBuyCar:place:), shopBuyCar:self.userCar place:TTDressUpPlaceType_CarShop);
    }
    
}

- (void)onClickConditionBtnAction {
    NSString *adress;
    if (self.userHeadwear) {
        adress = self.userHeadwear.redirectLink;
    }else if (self.userCar) {
        adress = self.userCar.redirectLink;
    }
    if (adress.length) {
        NotifyCoreClient(TTDressUpUIClient, @selector(shopTogetLimitDressUpAdress:), shopTogetLimitDressUpAdress:adress);
    }
}

#pragma mark - priavte
- (void)dealDressUpDataWithCar:(UserCar *)car headwear:(UserHeadWear *)headwear {
    self.userCar = car;
    self.userHeadwear = headwear;
    BOOL isLimit = NO;
    NSString *needPrice;
    NSString *days;
    DressUpModel *model;
    
    if (car) {
        model = car;
    }else {
        model = headwear;
    }
    
    if (model.labelType == DressUpLabelType_Limit || model.labelType == DressUpLabelType_Exclusive) {
        //限定专属
        isLimit = YES;
        self.conditionLabel.text = model.limitDesc;
        self.conditionBtn.hidden = !model.redirectLink.length;
        
        [self.conditionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.conditionBtn.hidden) {
                make.right.mas_equalTo(-15);
            } else {
                make.right.mas_equalTo(self.conditionBtn.mas_left).offset(-30);
            }
        }];
    }else {
        //正常
        BOOL isRenew = NO;
        if (car) {
            if (car.status == Car_Status_ok) {
                //续费
                needPrice = [self configPriceCar:car headwear:nil];
                isRenew = YES;
            }else {
                needPrice = [self configPriceCar:car headwear:nil];
            }
            days = car.days;
        }else {
            if (headwear.status == Headwear_Status_ok) {
                //续费
                needPrice = [self configPriceCar:nil headwear:headwear];
                isRenew = YES;
            }else {
                needPrice = [self configPriceCar:nil headwear:headwear];
                
            }
            days = headwear.days;
        }
        UIColor *presentColor = isRenew?UIColorFromRGB(0xFC6E6D):[XCTheme getTTMainColor];
        presentColor = [XCTheme getTTMainTextColor];
        NSString *presentImage = isRenew?@"person_DressUp_renewPresentBtn":@"person_DressUp_buyPresentBtn";
        NSString *buyImage = isRenew?@"person_DressUp_RenewBtn":@"person_DressUp_buyBtn";
        NSString *buyTitle = isRenew?@"续费":@"购买";
        [self.presentBtn setTitleColor:presentColor forState:UIControlStateNormal];
        [self.presentBtn setBackgroundImage:[UIImage imageNamed:presentImage] forState:UIControlStateNormal];
        [self.buyOrRenewBtn setBackgroundImage:[UIImage imageNamed:buyImage] forState:UIControlStateNormal];
        [self.buyOrRenewBtn setTitle:buyTitle forState:UIControlStateNormal];
    }
    
    self.onlyPresentBtn.hidden = !self.isOnlyPresent;
    self.operationbtnView.hidden = self.isOnlyPresent;
    
    self.conditionView.hidden = !isLimit;
    self.nomalOperationView.hidden = isLimit;
    self.currentPriceLabel.attributedText = [self getPriceAStringWithPrice:needPrice days:days];
    if (model.labelType == DressUpLabelType_Discount) {
        self.originPriceLabel.text = [self configOriginalPrice:model.price model:model];
    } else {
        self.originPriceLabel.text = @"";
    }
}

/**
 组合需要显示的价格文本
 
 @param car 座驾模型
 @param headwear 头饰模型
 @return 组合后的价格文本
 */
- (NSString *)configPriceCar:(UserCar *)car headwear:(UserHeadWear *)headwear  {
    NSString *NeedPrice = @"";
    NSString *coinPrice = @"";
    NSString *carrotPrice = @"";
    BOOL isRenew = NO;
    BOOL goldSale = NO;
    BOOL carrotSale = NO;
    if (car) {
        if (car.expireDate >= 0 && car.status == Car_Status_ok) {
            isRenew = YES;
        }
        
        // 价格
        if (car.goldSale) {
            NSString *price = isRenew ? car.renewPrice : car.price;
            coinPrice = [NSString stringWithFormat:@"%@金币", price];
            goldSale = car.goldSale;
        }
        if (car.radishSale) {
            NSString *price = isRenew ? car.radishRenewPrice : car.radishPrice;
            carrotPrice = [NSString stringWithFormat:@"%@萝卜", price];
            carrotSale = car.radishSale;
        }
    }
    
    if (headwear) {
        if (headwear.expireDays.integerValue >= 0 && headwear.status == Headwear_Status_ok) {
            isRenew = YES;
        }
        // 价格
        if (headwear.goldSale) {
            NSString *price = isRenew ? headwear.renewPrice : headwear.price;
            coinPrice = [NSString stringWithFormat:@"%@金币", price];
            goldSale = headwear.goldSale;
            
        }
        if (headwear.radishSale) {
            NSString *price = isRenew ? headwear.radishRenewPrice : headwear.radishPrice;
            carrotPrice = [NSString stringWithFormat:@"%@萝卜", price];
            carrotSale = headwear.radishSale;
            
        }
    }
    
    // 如果是单货币购买，就去掉 / 符号
    NeedPrice = [NSString stringWithFormat:@"%@/%@", coinPrice, carrotPrice];
    if (!goldSale || !carrotSale) {
        NeedPrice = [NeedPrice stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    return NeedPrice;
}


/**
 组合需要显示的原价文本
 
 @param string 价格
 @param model 模型
 @return 组合好的原价显示文本
 */
- (NSString *)configOriginalPrice:(NSString *)string model:(DressUpModel *)model {
    NSString *NeedPrice = @"";
    NSString *coinPrice = @"";
    NSString *carrotPrice = @"";
    // 价格
    if (model.goldSale) {
        coinPrice = [NSString stringWithFormat:@"%@金币", model.originalPrice];
    }
    if (model.radishSale) {
        carrotPrice = [NSString stringWithFormat:@"%@萝卜", model.radishOriginalPrice];
    }
    
    // 如果是单货币购买，就去掉 / 符号
    NeedPrice = [NSString stringWithFormat:@"%@/%@", coinPrice, carrotPrice];
    if (!model.goldSale || !model.radishSale) {
        NeedPrice = [NeedPrice stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    return NeedPrice;
}


- (NSAttributedString *)getPriceAStringWithPrice:(NSString *)price days:(NSString *)days {
    NSString *string = [NSString stringWithFormat:@"%@(%@)",price,days];
    NSMutableAttributedString *astring = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[XCTheme getTTDeepGrayTextColor]}];
    [astring addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMainColor] range:NSMakeRange(0, price.length)];
    return astring.copy;
}



#pragma mark - Getter && Setter


- (UIView *)contianView {
    if (!_contianView) {
        _contianView = [[UIView alloc] init];
    }
    return _contianView;
}

- (UIView *)nomalOperationView {
    if (!_nomalOperationView) {
        _nomalOperationView = [[UIView alloc] init];
    }
    return _nomalOperationView;
}

- (UIView *)operationbtnView {
    if (!_operationbtnView) {
        _operationbtnView = [[UIView alloc] init];
    }
    return _operationbtnView;
}

- (UIButton *)onlyPresentBtn {
    if (!_onlyPresentBtn) {
        UIImage *image = [UIImage gradientColorImageFromColors:@[[XCTheme getTTGradualStartColor],[XCTheme getTTGradualEndColor]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(83, 33)];
        _onlyPresentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _onlyPresentBtn.layer.masksToBounds = YES;
        _onlyPresentBtn.layer.cornerRadius = 33/2;
        [_onlyPresentBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_onlyPresentBtn setTitle:@"赠送" forState:UIControlStateNormal];
        [_onlyPresentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _onlyPresentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_onlyPresentBtn addTarget:self action:@selector(onClickPresentBtnActin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onlyPresentBtn;
}

- (UIButton *)presentBtn {
    if (!_presentBtn) {
        _presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_presentBtn addTarget:self action:@selector(onClickPresentBtnActin) forControlEvents:UIControlEventTouchUpInside];
        _presentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_presentBtn setTitle:@"赠送" forState:UIControlStateNormal];
    }
    return _presentBtn;
}

- (UIButton *)buyOrRenewBtn {
    if (!_buyOrRenewBtn) {
        _buyOrRenewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyOrRenewBtn addTarget:self action:@selector(onClickBuyOrRenewBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _buyOrRenewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_buyOrRenewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyOrRenewBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
    }
    return _buyOrRenewBtn;
}

- (UILabel *)currentPriceLabel {
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc] init];
    }
    return _currentPriceLabel;
}

- (UILabel *)originPriceLabel {
    if (!_originPriceLabel) {
        _originPriceLabel = [[UILabel alloc] init];
        _originPriceLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _originPriceLabel.font = [UIFont systemFontOfSize:12];
    }
    return _originPriceLabel;
}


- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [[UIView alloc] init];
        _cutLineView.backgroundColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _cutLineView;
}


- (UIView *)conditionView {
    if (!_conditionView) {
        _conditionView = [[UIView alloc] init];
    }
    return _conditionView;
}

- (UILabel *)conditionLabel {
    if (!_conditionLabel) {
        _conditionLabel = [[UILabel alloc] init];
        _conditionLabel.textColor = [XCTheme getTTMainTextColor];
        _conditionLabel.font = [UIFont systemFontOfSize:15];
        _conditionLabel.numberOfLines = 0;
    }
    return _conditionLabel;
}

- (UIButton *)conditionBtn {
    if (!_conditionBtn) {
        
        _conditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_conditionBtn addTarget:self action:@selector(onClickConditionBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_conditionBtn setTitle:@"获取方式" forState:UIControlStateNormal];
        _conditionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _conditionBtn.layer.masksToBounds = YES;
        _conditionBtn.layer.cornerRadius = 33/2;
        
        [_conditionBtn setBackgroundColor:UIColor.whiteColor];
        _conditionBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _conditionBtn.layer.borderWidth = 2;
        [_conditionBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
    
    }
    return _conditionBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    return _lineView;
}
@end
