//
//  TTGameRoomViewController+RoomGift.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+RoomGift.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCCurrentVCStackManager.h"
#import "TTWKWebViewViewController.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "TTGameRoomViewController+Private.h"
#import "XCHtmlUrl.h"
#import "TTPopup.h"
#import "TTNewbieGuideView.h"
#import "TTStatisticsService.h"

// 礼物新手引导状态保存
static NSString *const kGiftGuideStatusStoreKey = @"TTGiftViewGiftGuideStatus";


@implementation TTGameRoomViewController (RoomGift)

//展示礼物面板
- (void)ttShowSendGiftViewType:(SelectGiftType)type targetUid:(UserID)targetUid{
    
    TTSendGiftView *giftView = [[TTSendGiftView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) usingPlace:XCSendGiftViewUsingPlace_Room roomUid:(NSInteger)self.roomInfo.uid];
    giftView.delegate = self;
    giftView.targetInfo = [GetCore(UserCore) getUserInfoInDB:targetUid];
    
    TTPopupConfig *config = [[TTPopupConfig alloc] init];
    config.contentView = giftView;
    config.style = TTPopupStyleActionSheet;
    config.didFinishDismissHandler = ^(BOOL isDismissOnBackgroundTouch) {
        [IQKeyboardManager sharedManager].enable = NO;
    };
    config.didFinishShowingHandler = ^{
        
        [IQKeyboardManager sharedManager].enable = YES;
        if (iPhoneX) {
            [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 40;
        }
    };
    
    [TTPopup popupWithConfig:config];
    
    // 轻寻不展示新手引导
    if (self.roomInfo.type != RoomType_CP && projectType() != ProjectType_LookingLove) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        BOOL hadGuide = [ud boolForKey:kGiftGuideStatusStoreKey];
        if (!hadGuide) {
            [ud setBool:YES forKey:kGiftGuideStatusStoreKey];
            [ud synchronize];
            if (![self.view viewWithTag:2000]) {
                TTNewbieGuideView *guideView = [[TTNewbieGuideView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) withArcWithFrame:CGRectMake(10, KScreenHeight - (55.0 + 36.0 + 218.0 + 44.0 + kSafeAreaBottomHeight), KScreenWidth - 20, 55) withSpace:YES withCorner:14 withPage:TTGuideViewPage_Gift];
                guideView.tag = 2000;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [giftView addSubview:guideView];
                });
            }
        }
    }

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
        [[TTRoomModuleCenter defaultCenter].currentNav pushViewController:vc animated:YES];
        return;
    }
    // 之前的是跳去充值
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
    [[TTRoomModuleCenter defaultCenter].currentNav pushViewController:vc animated:YES];
    [TTStatisticsService trackEvent:TTStatisticsServiceEventGiftViewToRecharge eventDescribe:@"房间-礼物面板充值"];
    // 首次充值资格
    if (sendGiftView.isFirstRecharge) {
        [TTStatisticsService trackEvent:@"room_gift_oneyuan_entrance" eventDescribe:@"房间"];
    }
}
//开通贵族
- (void)sendGiftViewDidClickBecomeNobe:(TTSendGiftView *)sendGiftView{
    [TTPopup dismiss];
    
    TTWKWebViewViewController *webVc = [[TTWKWebViewViewController alloc] init];
    webVc.urlString = HtmlUrlKey(kNobilityIntroURL);
    [self.navigationController pushViewController:webVc animated:YES];
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

#pragma mark - TTOpenNobleTipCardViewDelegate
- (void)openNobleTipCardViewDidGotoOpenNoble:(TTOpenNobleTipCardView *)cardView {
    [TTPopup dismiss];
    
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
    vc.urlString = HtmlUrlKey(kNobilityIntroURL);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openNobleTipCardViewDidClose:(TTOpenNobleTipCardView *)cardView {
    [TTPopup dismiss];
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
