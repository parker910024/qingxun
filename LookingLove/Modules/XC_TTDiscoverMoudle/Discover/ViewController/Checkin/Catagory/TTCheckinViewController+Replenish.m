//
//  TTCheckinViewController+Replenish.m
//  XC_TTDiscoverMoudle
//
//  Created by lvjunhang on 2019/5/9.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTCheckinViewController+Replenish.h"
#import "CheckinCore.h"
#import "XCHUDTool.h"
#import "TTPopup.h"
#import "XCTheme.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMacros.h"
#import "XCKeyWordTool.h"
#import "XCCurrentVCStackManager.h"

#import "TTCheckinReplenishSuccessAlertView.h"

@implementation TTCheckinViewController (Replenish)

/**
 补签:获取补签信息
 
 @param signDay 第几天补签
 */
- (void)replenishWithSignDay:(NSUInteger)signDay {
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(CheckinCore) requestCheckinReplenishInfoWithSignDay:signDay];
}

//显示分享获取补签弹窗
- (void)showShareGetReplenishChanceAlert {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"补签";
    config.message = [NSString stringWithFormat:@"分享好友 即可获得补签机会\n分享后返回%@才有效哦~",[XCKeyWordTool sharedInstance].myAppName] ;
    config.messageLineSpacing = 4;
    config.confirmButtonConfig.title = @"分享好友";
    
    TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
    attConfig.text = @"分享好友";
    
    TTAlertMessageAttributedConfig *moreaAttConfig = [[TTAlertMessageAttributedConfig alloc] init];
    moreaAttConfig.text = [NSString stringWithFormat:@"分享后返回%@才有效哦~", [XCKeyWordTool sharedInstance].myAppName];
    moreaAttConfig.color = [XCTheme getTTDeepGrayTextColor];
    
    config.messageAttributedConfig = @[attConfig, moreaAttConfig];
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        self.isReplenishShare = YES;
        [self shareButtonTapped];
    } cancelHandler:^{
    }];
}

/**
 显示支付萝卜获取补签弹窗
 
 @param radishNum 萝卜数量
 */
- (void)showPayRadishGetReplenishChanceAlertWithRadish:(NSInteger)radishNum {
    
    NSString *radish = [NSString stringWithFormat:@"%ld萝卜", (long)radishNum];
    NSString *content = [NSString stringWithFormat:@"本次补签需要消耗 %@", radish];

    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"补签";
    config.message = content;
    config.messageLineSpacing = 4;
    
    TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
    attConfig.text = radish;
    
    config.messageAttributedConfig = @[attConfig];
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        [GetCore(CheckinCore) requestCheckinReplenishWithSignDay:self.replenishSignDay];
    } cancelHandler:^{
    }];
}

/**
 显示萝卜余额不足弹窗
 */
- (void)showNoEnoughRadishBalanceAlert {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"补签提示";
    config.message = @"您的萝卜金额不足，请前往任务中心\n完成任务获取更多的萝卜";
    config.messageLineSpacing = 4;
    config.confirmButtonConfig.title = @"前往";
    
    TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
    attConfig.text = @"完成任务获取更多的萝卜";

    config.messageAttributedConfig = @[attConfig];
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [[[XCCurrentVCStackManager shareManager] currentNavigationController] pushViewController:vc animated:YES];
    } cancelHandler:^{
    }];
}

/**
 显示补签成功弹窗
 
 @param rewardName 补签获得奖励
 */
- (void)showReplenishSuccessAlertWithReward:(NSString *)rewardName {
    TTCheckinReplenishSuccessAlertView *alert = [[TTCheckinReplenishSuccessAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [alert configRerard:rewardName];
    @KWeakify(self)
    [UIView animateWithDuration:0.5 animations:^{
        @KStrongify(self)
        [self.navigationController.view addSubview:alert];
    } completion:^(BOOL finished) {
    }];
}

@end
