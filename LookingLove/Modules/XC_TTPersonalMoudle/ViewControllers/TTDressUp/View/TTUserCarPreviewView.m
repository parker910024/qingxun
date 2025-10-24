//
//  TTUserCarPreviewView.m
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTUserCarPreviewView.h"

#import "TTDressUpUIClient.h"


#import "SVGAParser.h"
#import "SVGAImageView.h"

#import <YYText/YYLabel.h>

#import "UIImage+Utils.h"
//core
#import "AuthCore.h"
#import "CarCore.h"


//model
#import "UserCar.h"
//cate
#import "XCHUDTool.h"
#import "UIImage+Utils.h"
//t
#import "TTPersonModuleTools.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "UIView+XCToast.h"

@interface TTUserCarPreviewView()<SVGAPlayerDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SVGAImageView *svgaImageView;
@property (nonatomic, strong) UILabel *carNameLabel;
@property (nonatomic, strong) YYLabel *priceOrDaysLabel;
@property (nonatomic, strong) UIButton *orderBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) SVGAParser *svgaParser;
@property (nonatomic, strong) UIImageView  *picImageView;//静态
@end

@implementation TTUserCarPreviewView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorRGBAlpha(0x000000, 0.8);
        self.userInteractionEnabled = YES;
        [self setup];
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)setup {
//    [self addSubview:self.titleLabel];
    [self addSubview:self.svgaImageView];
//    [self addSubview:self.picImageView];
//    [self addSubview:self.carNameLabel];
//    [self addSubview:self.priceOrDaysLabel];
//    [self addSubview:self.orderBtn];
    [self addSubview:self.cancelBtn];
    
    self.titleLabel.hidden = YES;
    
    [self initConstraints];
}

- (void)initConstraints {
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (iPhone5s) {
//            make.top.mas_equalTo(self.mas_top).offset(20);
//        }else {
//            make.top.mas_equalTo(self.mas_top).offset(60);
//        }
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.width.mas_lessThanOrEqualTo(self.mas_width).offset(-30);
//    }];
    [self.svgaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        
    }];
//    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self);
//    }];
//    [self.carNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.priceOrDaysLabel.mas_top).offset(-10);
//        make.centerX.mas_equalTo(self);
//        make.width.mas_lessThanOrEqualTo(self.mas_width).offset(-30);
//    }];
//    [self.priceOrDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.cancelBtn.mas_top).offset(-24);
//        make.centerX.mas_equalTo(self);
//    }];
//    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_centerX).offset(15);
//        make.width.mas_equalTo(122);
//        make.height.mas_equalTo(40);
//        make.top.mas_equalTo(self.cancelBtn);
//    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-55-kSafeAreaBottomHeight);
    }];
    
}

#pragma mark - Setter && Getter

- (void)setCar:(UserCar *)car {
    _car = car;
//    if (car.expireDate >= 0) {
//        if (car.status == Car_Status_expire) {
//            [self configBuy];
//        }else if (car.status == Car_Status_ok){
//            [self configRenew];
//        }
//    }else if (car.expireDate == -1) {
//        [self configBuy];
//    }
//    BOOL isDown = self.car.status == Car_Status_down;
//
//    if (car.labelType == DressUpLabelType_Limit || car.labelType == DressUpLabelType_Exclusive || isDown) {
//        self.priceOrDaysLabel.hidden = YES;
//        self.orderBtn.hidden = YES;
//        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(122);
//            make.height.mas_equalTo(40);
//            make.centerX.mas_equalTo(self);
//            make.bottom.mas_equalTo(self).offset(-40-kSafeAreaBottomHeight);
//
//        }];
//    }else {
//        self.priceOrDaysLabel.hidden = NO;
//        self.orderBtn.hidden = NO;
//        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(122);
//            make.height.mas_equalTo(40);
//            make.right.mas_equalTo(self.mas_centerX).offset(-15);
//            make.bottom.mas_equalTo(self).offset(-40-kSafeAreaBottomHeight);
//        }];
//    }
//
//    self.carNameLabel.text = car.name;
//    self.priceOrDaysLabel.attributedText = [TTPersonModuleTools getPriceAttriButeStringWithPrice:car.price];
    [self playSvga:_car.effect];
}

#pragma mark - Private


- (void)configBuy {
    self.titleLabel.text = @"确认购买此座驾？";
    [self.orderBtn setTitle:@"购买" forState:UIControlStateNormal];
    [self.orderBtn setTitle:@"购买" forState:UIControlStateHighlighted];
    UIImage *image = [UIImage gradientColorImageFromColors:@[[XCTheme getTTGradualStartColor],[XCTheme getTTGradualEndColor]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(83, 33)];
    
    [self.orderBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)configRenew {
    self.titleLabel.text = @"确认续费此座驾？";
    [self.orderBtn setTitle:@"续费" forState:UIControlStateNormal];
    [self.orderBtn setTitle:@"续费" forState:UIControlStateHighlighted];
    UIImage *image = [UIImage gradientColorImageFromColors:@[[XCTheme getTTGradualEndColor],[XCTheme getTTMainColor]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(83, 33)];
    [self.orderBtn setBackgroundImage:image forState:UIControlStateNormal];
    
}

- (void)playSvga:(NSString *)url {
    [self.svgaParser parseWithURL:[NSURL URLWithString:url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        self.svgaImageView.videoItem = videoItem;
        self.svgaImageView.clearsAfterStop = YES;
        self.svgaImageView.loops = INT_MAX;
        [self.svgaImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XCHUDTool showErrorWithMessage:@"加载资源失败"];
        });
    }];
}

#pragma mark - SVGAPlayerDelegate

#pragma mark - User Respone

- (void)buy {
    @weakify(self);
    
    [XCHUDTool showGIFLoading];
    [[GetCore(CarCore)buyCarByCarId:self.car.carID]subscribeError:^(NSError *error) {
        @strongify(self);
        [XCHUDTool hideHUD];
    } completed:^{
        @strongify(self);
        [XCHUDTool hideHUD];
        NotifyCoreClient(TTDressUpUIClient, @selector(buyCarSuccess:uid:), buyCarSuccess:self.car uid:[GetCore(AuthCore) getUid].userIDValue);
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(carOrderViewDidDismiss)]) {
            [self.delegate carOrderViewDidDismiss];
        }
    }];
}

- (void)cancel {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(carOrderViewDidDismiss)]) {
        [self.delegate carOrderViewDidDismiss];
    }
}

#pragma mark - BalanceErrorClient

- (void)onBalanceNotEnough {
    [self removeFromSuperview];
}


#pragma mark - Getter
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:20.f];
        _titleLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _titleLabel;
}

- (SVGAImageView *)svgaImageView {
    if (_svgaImageView == nil) {
        _svgaImageView = [[SVGAImageView alloc]init];
        _svgaImageView.backgroundColor = [UIColor clearColor];
        _svgaImageView.layer.masksToBounds = YES;
        _svgaImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _svgaImageView;
}

- (UILabel *)carNameLabel {
    if (_carNameLabel == nil) {
        _carNameLabel = [[UILabel alloc]init];
        _carNameLabel.font = [UIFont systemFontOfSize:16];
        _carNameLabel.textColor = [UIColor whiteColor];
    }
    return _carNameLabel;
}

- (YYLabel *)priceOrDaysLabel {
    if (_priceOrDaysLabel == nil) {
        _priceOrDaysLabel = [[YYLabel alloc]init];
    }
    return _priceOrDaysLabel;
}

- (UIButton *)orderBtn {
    if (_orderBtn == nil) {
        _orderBtn = [[UIButton alloc]init];
        [_orderBtn setTitle:@"购买" forState:UIControlStateNormal];
        [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _orderBtn.layer.masksToBounds = YES;
        _orderBtn.layer.cornerRadius = 20;
        [_orderBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderBtn;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setImage:[UIImage imageNamed:@"person_dressup_cancel"] forState:UIControlStateNormal];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//        _cancelBtn.backgroundColor = UIColorFromRGB(0xE5E5E5);
//        _cancelBtn.layer.masksToBounds = YES;
//        _cancelBtn.layer.cornerRadius = 20;
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (SVGAParser *)svgaParser {
    if (_svgaParser == nil) {
        _svgaParser = [[SVGAParser alloc]init];
    }
    return _svgaParser;
}

- (UIImageView *)picImageView {
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _picImageView;
}


@end
