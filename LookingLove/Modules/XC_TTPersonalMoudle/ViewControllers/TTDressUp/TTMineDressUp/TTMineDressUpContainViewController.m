//
//  TTMineDressUpContainViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMineDressUpContainViewController.h"
//vc
#import "TTMineHeadwearDressUpViewController.h"
#import "TTMineCarDressUpViewController.h"
#import "WBNameplateViewController.h"
#import "TTPopup.h"

#import "TTRechargeViewController.h"
#import "LLRechargeViewController.h"

#import "XCMediator+TTDiscoverModuleBridge.h"
//view
#import "TTDressUpBuyOrPresentSuccessView.h"
#import "TTDressUpBuyOrPresentView.h"
#import "TTDressUpSelectTabView.h"
#import "ZJScrollPageView.h"
#import "ZJScrollPageViewDelegate.h"
#import "TTPopup.h"
#import "TTFamilyBaseAlertController.h"
#import "UIView+XCToast.h"
//core
#import "TTDressUpUIClient.h"
#import "BalanceErrorClient.h"
#import "CarCore.h"
#import "HeadWearCore.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "UserCoreClient.h"
//cate
#import "XCHUDTool.h"
//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "TTStatisticsService.h"

@interface TTMineDressUpContainViewController ()<ZJScrollPageViewDelegate,UserCoreClient,TTDressUpUIClient>
@property (nonatomic, strong) TTDressUpSelectTabView  *segmentView;//

@property(strong, nonatomic) ZJScrollPageView *scrollPageView;
@property(strong, nonatomic) NSArray<NSString *> *titles;

@property (weak , nonatomic) TTMineHeadwearDressUpViewController *headVC;
@property (weak , nonatomic) TTMineCarDressUpViewController *carVC;
@property (weak , nonatomic) WBNameplateViewController *nameplateVC;

@property (nonatomic, assign) TTDressUpPlaceType type;

@end

@implementation TTMineDressUpContainViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的装扮";
    [self initSubViews];
}

- (void)initSubViews {
    [self.view addSubview:self.scrollPageView];
    [self.view addSubview:self.segmentView];
    [self makeConstriants];
    
    AddCoreClient(UserCoreClient, self);
    AddCoreClient(BalanceErrorClient, self);
}

- (void)makeConstriants {
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.height.mas_equalTo(50);
    }];
    [self.scrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.segmentView.mas_bottom).offset(5);
    }];
    
    [self addCore];
}

- (void)addCore {
    AddCoreClient(TTDressUpUIClient, self);
    AddCoreClient(BalanceErrorClient, self);
}

#pragma mark - BalanceErrorClient
- (void)onBalanceNotEnough {
    if(self.presentVC)return;
    [XCHUDTool hideHUDInView:self.view];
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"温馨提示";
    config.message = @"账户余额不足，前往充值?";
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        UIViewController *vc;
        vc = [[LLRechargeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        // 统计钱包不足的行为是什么导致
        [TTStatisticsService trackEvent:TTStatisticsServiceEventNotEnoughToRecharge eventDescribe:[self trackEvent]];
    } cancelHandler:^{
    }];
}

/// 统计字段
- (NSString *)trackEvent {
    NSString *str;
    if (self.type == TTDressUpPlaceType_CarShop) {
        str = @"买座驾";
    } else if (self.type == TTDressUpPlaceType_HeadwearShop) {
        str = @"买头饰";
    }
    return @"";
}

#pragma mark - TTDressUpUiClient
//购买 座驾
- (void)shopBuyCar:(UserCar *)userCar place:(TTDressUpPlaceType)type {
    if (type != TTDressUpPlaceType_CarGarage) {
        return;
    }
    self.type == type;
    [self buyCar:userCar headwear:nil];
}

//购买 头饰
- (void)shopBuyHeadwear:(UserHeadWear *)headwear place:(TTDressUpPlaceType)type {
    if (type != TTDressUpPlaceType_HeadwearGarage) {
        return;
    }
    self.type == type;
    [self buyCar:nil headwear:headwear];
}

#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers
{
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        if (index == 0) {
            TTMineHeadwearDressUpViewController *hearwearShop = [[TTMineHeadwearDressUpViewController alloc]init];
            hearwearShop.type = TTDressUpPlaceType_HeadwearGarage;
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)hearwearShop;
            self.headVC = hearwearShop;
        }else if (index == 1) {
            TTMineCarDressUpViewController *carShopVc = [[TTMineCarDressUpViewController alloc]init];
            carShopVc.type = TTDressUpPlaceType_CarGarage;
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)carShopVc;
            self.carVC = carShopVc;
        } else if (index == 2) {
            WBNameplateViewController *nameplateVC = [[WBNameplateViewController alloc]init];
            
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)nameplateVC;
            self.nameplateVC = nameplateVC;
        }
    }
    
    return childVc;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    self.segmentView.index = index;
}

#pragma mark - private
- (void)buyCar:(UserCar *)car headwear:(UserHeadWear *)headwear {
    NSString *days; // 天数
    NSString *shopName;
    NSString *coinSring;
    NSString *carrotString = @"";
    NSString *buyOrRebuy = @"购买";
    BOOL isRenew = NO;
    TTDressUpViewStyle style = TTDressUpViewStyleCoin;   // 显示的样式
    if(car) {
        shopName = car.name;
        days = car.days;
        //        coinSring = car.renewPrice;
        if (car.status == Car_Status_ok && car.expireDate >=0 ) {
            buyOrRebuy = @"续费";
            isRenew = YES;
        }
        
        // 如果当前商品同时支持金币和萝卜购买
        if (car.radishSale && car.goldSale) {
            style = TTDressUpViewStyleBoth;
            coinSring = isRenew ? car.renewPrice : car.price;
            carrotString = isRenew ? car.radishRenewPrice : car.radishPrice;
        } else if (car.radishSale) { // 只支持萝卜购买
            style = TTDressUpViewStyleCarrot;
            coinSring = isRenew ? car.radishRenewPrice : car.radishPrice;
        } else if (car.goldSale) { // 只支持金币购买
            style = TTDressUpViewStyleCoin;
            coinSring = isRenew ? car.renewPrice : car.price;
        }
        
    } else if(headwear) {
        if(headwear.name.length) {
            shopName = headwear.name;
        }else {
            //如果是头饰库
            shopName = headwear.headwearName;
        }
        
        if(headwear.status == Headwear_Status_ok && [headwear.expireDays integerValue] >=0 ) {
            buyOrRebuy = @"续费";
            isRenew = YES;
        }
        days = headwear.days;
        //        coinSring = headwear.renewPrice;
        
        // 如果当前商品同时支持金币和萝卜购买
        if (headwear.radishSale && headwear.goldSale) {
            style = TTDressUpViewStyleBoth;
            coinSring = isRenew ? headwear.renewPrice : headwear.price;
            carrotString = isRenew ? headwear.radishRenewPrice : headwear.radishPrice;
        } else if (headwear.radishSale) { // 只支持萝卜购买
            style = TTDressUpViewStyleCarrot;
            coinSring = isRenew ? headwear.radishRenewPrice : headwear.radishPrice;
        } else if (headwear.goldSale) { // 只支持金币购买
            style = TTDressUpViewStyleCoin;
            coinSring = isRenew ? headwear.renewPrice : headwear.price;
        }
    }
    
    NSString *string;
    NSMutableAttributedString *mAttributedString;
    string = [NSString stringWithFormat:@"您将要%@“%@(%@)”",buyOrRebuy,shopName, days];
    
    mAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [mAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, mAttributedString.length)];
    [mAttributedString addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMainTextColor] range:NSMakeRange(0, mAttributedString.length)];
    
    
    [mAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(6, shopName.length)];
    
    TTDressUpBuyOrPresentView *prenstEnsureView = [[TTDressUpBuyOrPresentView alloc] initWithStyle:style title:@"购买提示" message:nil attriMessageString:mAttributedString priceString:coinSring carrotString:carrotString];
    
    @weakify(self)
    prenstEnsureView.ensureBlock = ^(TTDressUpViewStyle style, TTDressUpBuyType type) {
        BuyGoodsType currencyType = Coin; // 金币
        
        if (style == TTDressUpViewStyleBoth) {
            // 如果购买方式是金币和萝卜都可以，那么就看选择使用什么购买，默认是金币
            currencyType = (BuyGoodsType)type;
        } else {
            // 如果是单货币购买。根据商品所支持的货币来购买
            currencyType = (BuyGoodsType)style;
        }
        
        [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO];
        @strongify(self)
        [self ensureBuycar:car headwear:headwear currencyType:currencyType];
    };
    prenstEnsureView.cancelBlock = ^{
        [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO];
    };
    
    [XCAlertControllerCenter defaultCenter].alertViewOriginY = 0;
    [[XCAlertControllerCenter defaultCenter]presentAlertWith:self view:prenstEnsureView preferredStyle:(TYAlertControllerStyle)TYAlertControllerStyleAlert dismissBlock:nil completionBlock:nil];
}
//购买
- (void)ensureBuycar:(UserCar *)car headwear:(UserHeadWear *)headwear currencyType:(BuyGoodsType)currencyType {
    
    [XCHUDTool showGIFLoadingInView:self.view];
    @weakify(self);
    if(car) {
        //  购买
        [[GetCore(CarCore) buyCarByCarId:car.carID currencyType:currencyType] subscribeError:^(NSError *error) {
            @strongify(self);
            [XCHUDTool hideHUDInView:self.view];
            [UIView showToastInKeyWindow:error.domain duration:2 position:YYToastPositionCenter];
            if (error.code == kNotCarrotCode) {
                //TODO
                @strongify(self);
                [self showNotCarrot];
            }
            NotifyCoreClient(TTDressUpUIClient, @selector(buyCarFailth:error:), buyCarFailth:car error:error);
            
        } completed:^{
            @strongify(self);
            [XCHUDTool hideHUDInView:self.view];
            [self showBuyOrPresentSuccess:@"恭喜您！购买成功"];
            [self.carVC reloadData];
        }];
    }else if(headwear){
        //头饰
        //  购买
        [[GetCore(HeadWearCore) buyHeadwearByHeadwearId:headwear.headwearId currencyType:currencyType] subscribeError:^(NSError *error) {
            @strongify(self);
            [XCHUDTool hideHUDInView:self.view];
            [UIView showToastInKeyWindow:error.domain duration:2 position:YYToastPositionCenter];
            if (error.code == kNotCarrotCode) {
                // show 萝卜不足，去做任务的弹窗
                @strongify(self);
                [self showNotCarrot];
                
            }
            NotifyCoreClient(TTDressUpUIClient, @selector(buyHeadwearFailth:error:), buyHeadwearFailth:headwear error:error);
        } completed:^{
            @strongify(self);
            [XCHUDTool hideHUDInView:self.view];
            [self showBuyOrPresentSuccess:@"恭喜您！购买成功"];
            [self.headVC reloadData];
        }];
    }
}

//购买或者赠送成功
- (void)showBuyOrPresentSuccess:(NSString *)title {
    [XCHUDTool hideHUDInView:self.view];
    TTDressUpBuyOrPresentSuccessView *buySuccessView = [[TTDressUpBuyOrPresentSuccessView alloc] init];

    buySuccessView.ensureBlock = ^{
        [TTPopup dismiss];
    };
    if(title){
        buySuccessView.titleLabel.text = title;
    }
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = buySuccessView;
    
    [TTPopup popupWithConfig:service];
}

/** 萝卜不足，前往任务页 */
- (void)showNotCarrot {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"您的萝卜不足,请前往任务中心\n完成任务获取更多的萝卜";
    
    TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
    attConfig.text = @"完成任务获取更多的萝卜";

    config.confirmButtonConfig.title = @"前往";
    config.messageAttributedConfig = @[attConfig];
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [self.navigationController pushViewController:vc animated:YES];
    } cancelHandler:^{
    }];
}

#pragma mark - Getter && Setter

- (void)setPlace:(int)place {
    _place = place;
    self.segmentView.index = place;
    [self.scrollPageView setSelectedIndex:place animated:YES];
}

- (TTDressUpSelectTabView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[TTDressUpSelectTabView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50) titles:self.titles];
        @weakify(self)
        _segmentView.selectBlock = ^(int selectIndex) {
            @strongify(self)
            [self.scrollPageView setSelectedIndex:selectIndex animated:YES];
        };
    }
    return _segmentView;
}

- (ZJScrollPageView *)scrollPageView {
    if (!_scrollPageView) {
        _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, (55+statusbarHeight), KScreenWidth, KScreenHeight-(55+statusbarHeight+44)-kSafeAreaBottomHeight) segmentStyle:nil titles:self.titles parentViewController:self delegate:self];
        _scrollPageView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    }
    return _scrollPageView;
}

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"头饰",@"座驾",@"铭牌"];
    }
    return _titles;
}

@end
