//
//  TTDressUpContainViewController+BuyOrPresentAction.m
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDressUpContainViewController+BuyOrPresentAction.h"
#import "TTDressUpBuyOrPresentView.h"
#import "TTDressUpBuyOrPresentSuccessView.h"
#import "TTDressupPresentViewController.h"
//t
#import "XCAlertControllerCenter.h"
#import "TTPopup.h"
#import "XCTheme.h"
#import "UIView+XCToast.h"
//cate
#import "XCHUDTool.h"
//core
#import "CarCore.h"
#import "HeadWearCore.h"
#import "TTDressUpUIClient.h"
#import "AuthCore.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "TTMineGameTagCore.h"

@implementation TTDressUpContainViewController (BuyOrPresentAction)

//赠送
- (void)presenterActionWithUserInfo:(UserInfo *)userinfo car:(UserCar *)car headwear:(UserHeadWear *)headwear isPresent:(BOOL)isPresent {
    NSString *days; // 天数
    NSString *shopName;     // 商品名字
    NSString *priceString;   // 商品有效期文案
    NSString *carrotString = @"";   // 显示萝卜数
    NSString *buyOrRebuy = @"购买";
    BOOL isRenew = NO;
    
    NSLog(@"萝卜：%d,金币 ：%d", headwear.radishSale, headwear.goldSale);
    TTDressUpViewStyle style = TTDressUpViewStyleCoin;   // 显示的样式
    if(car) {
        shopName = car.name;
        days = car.days;
        if (car.status == Car_Status_ok && car.expireDate >=0 ) {
            buyOrRebuy = @"续费";
            isRenew = YES; // 续费
        }
        // 如果当前商品同时支持金币和萝卜购买
        if (car.radishSale && car.goldSale) {
            style = TTDressUpViewStyleBoth;
            // 金币价格
            priceString = isRenew ? car.renewPrice : car.price;
            // 萝卜价格
            carrotString = isRenew ? car.radishRenewPrice : car.radishPrice;
        } else if (car.radishSale) { // 只支持萝卜购买
            style = TTDressUpViewStyleCarrot;
            priceString = isRenew ? car.radishRenewPrice : car.radishPrice;
        } else if (car.goldSale) { // 只支持金币购买
            style = TTDressUpViewStyleCoin;
            priceString = isRenew ? car.renewPrice : car.price;
        }
        
    }else if(headwear) {
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
        
        // 如果当前商品同时支持金币和萝卜购买
        if (headwear.radishSale && headwear.goldSale) {
            style = TTDressUpViewStyleBoth;
            // 金币价格
            priceString = isRenew ? headwear.renewPrice : headwear.price;
            // 萝卜价格
            carrotString = isRenew ? headwear.radishRenewPrice : headwear.radishPrice;
            
        } else if (headwear.radishSale) { // 只支持萝卜购买
            style = TTDressUpViewStyleCarrot;
            priceString = isRenew ? headwear.radishRenewPrice : headwear.radishPrice;
        } else if (headwear.goldSale) { // 只支持金币购买
            style = TTDressUpViewStyleCoin;
            priceString = isRenew ? headwear.renewPrice : headwear.price;
        }
        
    }
    NSString *string;
    NSMutableAttributedString *mAttributedString;
    if (isPresent) {
        string = [NSString stringWithFormat:@"您将赠送给%@“%@(%@)”",userinfo.nick,shopName, days];
    }else {
        string = [NSString stringWithFormat:@"您将要%@“%@(%@)”",buyOrRebuy,shopName, days];
    }
    
    // 文案里描述加粗字段长度
    NSRange boldRange = [string rangeOfString:shopName];
    
    mAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [mAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, mAttributedString.length)];
    [mAttributedString addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMainTextColor] range:NSMakeRange(0, mAttributedString.length)];
    
    if (isPresent) {
        [mAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(5, userinfo.nick.length)];
        [mAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(6, shopName.length)];
    }else {
        [mAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(6, shopName.length)];
    }
    
    TTDressUpBuyOrPresentView *prenstEnsureView = [[TTDressUpBuyOrPresentView alloc] initWithStyle:style title:@"购买提示" message:nil attriMessageString:mAttributedString priceString:priceString carrotString:carrotString];
    
    @weakify(self)
    prenstEnsureView.ensureBlock = ^(TTDressUpViewStyle style, TTDressUpBuyType type) {
        [[XCAlertControllerCenter defaultCenter]dismissAlertNeedBlock:NO];
        @strongify(self)
        // 默认为金币购买
        BuyGoodsType currencyType = Coin;
        if (style == TTDressUpViewStyleBoth) {
            currencyType = (BuyGoodsType)type;
        } else {
            currencyType = (BuyGoodsType)style;
        }
        
        [self ensurePresenter:userinfo isPresent:isPresent car:car headwear:headwear currencyType:currencyType];
    };
    prenstEnsureView.cancelBlock = ^{
        [[XCAlertControllerCenter defaultCenter]dismissAlertNeedBlock:NO];
    };
    
    [XCAlertControllerCenter defaultCenter].alertViewOriginY = 0;
    [[XCAlertControllerCenter defaultCenter]presentAlertWith:self view:prenstEnsureView preferredStyle:(TYAlertControllerStyle)TYAlertControllerStyleAlert dismissBlock:nil completionBlock:nil];
}
//购买或是 赠送
- (void)ensurePresenter:(UserInfo *)info isPresent:(BOOL)isPresent car:(UserCar *)car headwear:(UserHeadWear *)headwear currencyType:(BuyGoodsType)currencyType {
    
    [XCHUDTool showGIFLoadingInView:self.view];
    
    if(car) {
        //座驾
        if (isPresent) {
            // 赠送
            @weakify(self);
            [[GetCore(CarCore) presentCarByCarId:car.carID targetUid:info.uid currencyType:currencyType] subscribeError:^(NSError *error) {
                @strongify(self);
                [XCHUDTool hideHUDInView:self.view];
                [UIView showToastInKeyWindow:error.domain duration:2 position:YYToastPositionCenter];
                if (error.code == kNotCarrotCode) {
                    // show 萝卜不足，去做任务的弹窗
                    //TODO
                    [self showNotCarrot];
                }
                NotifyCoreClient(TTDressUpUIClient, @selector(buyCarFailth:error:), buyCarFailth:car error:error);
            } completed:^{
                //赠送成功
                @strongify(self);
                [XCHUDTool hideHUDInView:self.view];
                [self showBuyOrPresentSuccess:@"赠送成功"];
                
            }];;
            
        }else {
            //  购买
            @weakify(self);
            [[GetCore(CarCore) buyCarByCarId:car.carID currencyType:currencyType] subscribeError:^(NSError *error) {
                @strongify(self);
                [XCHUDTool hideHUDInView:self.view];
                [UIView showToastInKeyWindow:error.domain duration:2 position:YYToastPositionCenter];
                if (error.code == kNotCarrotCode) {
                    // show 萝卜不足，去做任务的弹窗
                    //TODO
                    [self showNotCarrot];
                }
                NotifyCoreClient(TTDressUpUIClient, @selector(buyCarFailth:error:), buyCarFailth:car error:error);
            } completed:^{
                @strongify(self);
                [XCHUDTool hideHUDInView:self.view];
                [self showBuyOrPresentSuccess:@"恭喜您！购买成功"];
            }];
            
        }
        
        
    } else if(headwear){
        //头饰
        if (isPresent) {
            // 赠送
            @weakify(self);
            [[GetCore(HeadWearCore) presentHeadwearByHeadwearId:headwear.headwearId toTargetUid:info.uid currencyType:currencyType] subscribeError:^(NSError *error) {
                @strongify(self);
                [XCHUDTool hideHUDInView:self.view];
                [UIView showToastInKeyWindow:error.domain duration:2 position:YYToastPositionCenter];
                if (error.code == kNotCarrotCode) {
                    // show 萝卜不足，去做任务的弹窗
                    //TODO
                    [self showNotCarrot];
                }
                NotifyCoreClient(TTDressUpUIClient, @selector(buyHeadwearFailth:error:), buyHeadwearFailth:headwear error:error);
            } completed:^{
                @strongify(self);
                [XCHUDTool hideHUDInView:self.view];
                [self showBuyOrPresentSuccess:@"赠送成功"];
            }];
        } else {
            //  购买     1.购买 2.续费
            int type = 1;
            if (headwear.status == Headwear_Status_ok) {
                type = 2;
            }
            @weakify(self);
            [[GetCore(HeadWearCore) buyHeadwearByHeadwearId:headwear.headwearId currencyType:currencyType] subscribeError:^(NSError *error) {
                @strongify(self);
                [XCHUDTool hideHUDInView:self.view];
                [UIView showToastInKeyWindow:error.domain duration:2 position:YYToastPositionCenter];
                if (error.code == kNotCarrotCode) {
                    // show 萝卜不足，去做任务的弹窗
                    //TODO
                    [self showNotCarrot];
                }
                NotifyCoreClient(TTDressUpUIClient, @selector(buyHeadwearFailth:error:), buyHeadwearFailth:headwear error:error);
            } completed:^{
                @strongify(self);
                [XCHUDTool hideHUDInView:self.view];
                [self showBuyOrPresentSuccess:@"恭喜您！购买成功"];
                
                // 更新头饰
                [GetCore(TTMineGameTagCore) userUpdateHeadWear];

                [[NSNotificationCenter defaultCenter] postNotificationName:kNeedRefreshUserInfoNotification object:nil];
            }];
        }
        
    }
}
//选择赠送
- (void)selectPresenterPersonWithCar:(UserCar *)car Headwear:(UserHeadWear *)hearwear {
    if (self.userInfo.uid == [GetCore(AuthCore).getUid userIDValue]) {
        @weakify(self)
        TTDressupPresentViewController *controller = [[TTDressupPresentViewController alloc]
                                                      init];
        controller.presentUserInfoBlock = ^(UserInfo *info) {
            @strongify(self)
            [self presenterActionWithUserInfo:info car:car headwear:hearwear isPresent:YES];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        //当前页面是其他人 就是赠送给他
        [self presenterActionWithUserInfo:self.userInfo car:car headwear:hearwear isPresent:YES];
    }
}

//购买或者赠送成功
- (void)showBuyOrPresentSuccess:(NSString *)title {
    [XCHUDTool hideHUDInView:self.view];
    TTDressUpBuyOrPresentSuccessView *buySuccessView = [[TTDressUpBuyOrPresentSuccessView alloc] init];
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = buySuccessView;
    
    
    buySuccessView.ensureBlock = ^{
        [TTPopup dismiss];
    };
    
    if(title){
        buySuccessView.titleLabel.text = title;
    }
    
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

@end
