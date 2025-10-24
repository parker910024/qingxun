//
//  TTUserCardDelegate.m
//  TuTu
//
//  Created by KevinWang on 2018/11/25.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTUserCardDelegate.h"
//t
#import "XCCurrentVCStackManager.h"

//vc
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTWKWebViewViewController.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
//view
#import "TTOpenNobleTipCardView.h"

#import "XCHtmlUrl.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "TTPopup.h"
#import "XCTheme.h"
#import "TTStatisticsService.h"

@interface TTUserCardDelegate()<TTOpenNobleTipCardViewDelegate>

@end

@implementation TTUserCardDelegate

+ (instancetype)defaultDelegate{
    
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

#pragma mark - TTSendGiftViewDelegate
//关闭
- (void)sendGiftViewDidClose:(TTSendGiftView *)sendGiftView{
    [TTPopup dismiss];
}

//充值
- (void)sendGiftViewDidClickRecharge:(TTSendGiftView *)sendGiftView type:(GiftConsumeType)type {
    
    [TTPopup dismiss];
    
    if (type == GiftConsumeTypeCarrot) {
        // 跳转去做任务。
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        return;
    }
    
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    [TTStatisticsService trackEvent:TTStatisticsServiceEventGiftViewToRecharge eventDescribe:@"用户卡片-礼物面板充值"];
}

//开通贵族
- (void)sendGiftViewDidClickBecomeNobe:(TTSendGiftView *)sendGiftView{
    
    [TTPopup dismiss];
    
    TTWKWebViewViewController *webVc = [[TTWKWebViewViewController alloc] init];
    webVc.urlString = HtmlUrlKey(kNobilityIntroURL);
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:webVc animated:YES];
}

//开通贵族提示
- (void)sendGiftView:(TTSendGiftView *)sendGiftView currentNobleLevel:(int)currentLevel needNobelLevel:(int)needLevel{
    
    [TTPopup dismiss];
    
    TTOpenNobleTipCardView *cardView = [[TTOpenNobleTipCardView alloc] initWithCurrentLevel:[self nobleNameByNobleLevel:currentLevel] doAction:@"" needLevel:[self nobleNameByNobleLevel:needLevel]];
    cardView.delegate = self;
    [TTPopup popupView:cardView style:TTPopupStyleAlert];
}

// 萝卜不足，去做任务
- (void)sendGiftView:(TTSendGiftView *)sendGiftView notEnoughtCarrot:(NSString *)errorMsg {
    // 跳转去任务
    [self ttShowCarrotBalanceNotEnougth];
}

/** 萝卜钱包余额不足 */
- (void)ttShowCarrotBalanceNotEnougth {
    
    [TTPopup dismiss];
    
    //防止多次萝卜不足弹窗
    static BOOL hasShowRadishAlert = NO;
    if (hasShowRadishAlert) {
        return;
    }
    
    hasShowRadishAlert = YES;
    
    TTAlertMessageAttributedConfig *moreAttrConf = [[TTAlertMessageAttributedConfig alloc] init];
    moreAttrConf.text = @"完成任务获取更多的萝卜";
    moreAttrConf.color = [XCTheme getTTMainColor];
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"您的萝卜不足,请前往任务中心\n完成任务获取更多的萝卜";
    config.messageAttributedConfig = @[moreAttrConf];
    config.confirmButtonConfig.title = @"前往";
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        // 前往任务中心
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        
        hasShowRadishAlert = NO;
        
    } cancelHandler:^{
        hasShowRadishAlert = NO;
    }];
}


#pragma mark - TTOpenNobleTipCardViewDelegate
- (void)openNobleTipCardViewDidClose:(TTOpenNobleTipCardView *)cardView{
    [TTPopup dismiss];
    
}

- (void)openNobleTipCardViewDidGotoOpenNoble:(TTOpenNobleTipCardView *)cardView{
    
    [TTPopup dismiss];
    
    TTWKWebViewViewController *webVc = [[TTWKWebViewViewController alloc] init];
    webVc.urlString = HtmlUrlKey(kNobilityIntroURL);
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:webVc animated:YES];
}

#pragma mark - private method
- (NSString *)nobleNameByNobleLevel:(int)nobleLevel{
    NSString *nobleLevelString = [NSString stringWithFormat:@"%d",nobleLevel];
    NSDictionary *matchNobleName = @{@"0":@"平民",
                                     @"1":@"男爵",
                                     @"2":@"子爵",
                                     @"3":@"伯爵",
                                     @"4":@"侯爵",
                                     @"5":@"公爵",
                                     @"6":@"国王",
                                     @"7":@"皇帝"};
    return matchNobleName[nobleLevelString];
}

@end
