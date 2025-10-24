//
//  TTGameRoomViewController+RoomActivity.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+RoomActivity.h"
#import "TTGameRoomViewController+Private.h"

#import "TTHalfWebAlertView.h"

#import "ActivityInfo.h"
#import "TTWKWebViewViewController.h"
#import "TTStatisticsService.h"
#import "P2PInteractiveAttachment.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "TTPopup.h"

@implementation TTGameRoomViewController (RoomActivity)

//房间活动跳转
- (void)roomActivityView:(XCRoomActivityView *)activityView jumbByActivityInfo:(ActivityInfo *)activityInfo {
     [self jumpUrlWithInfo:activityInfo];
}

// 活动入口  banner
- (void)roomActivityListView:(TTRoomActivityCycleView *)activityView jumbByActivityInfo:(ActivityInfo *)activityInfo {
    
    //此 ID 由后端查询给出
    NSUInteger goRecommendActId = 19;
    if (activityInfo.actId == goRecommendActId) {
        [TTStatisticsService trackEvent:TTStatisticsServiceRoomGoRecommendClick
                          eventDescribe:@"我要上推荐"];
    }
    
    NSString *event = [self roomFullTrackName:@"room_activity"];
    NSString *des = self.roomInfo.type==RoomType_Game ? @"多人房活动入口" : @"陪伴房活动入口";
    [TTStatisticsService trackEvent:event eventDescribe:des];
    
    if (activityInfo.skipType == P2PInteractive_SkipType_Room) {
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:activityInfo.skipUrl.userIDValue];
    } else if (activityInfo.skipType == P2PInteractive_SkipType_H5) {
        [self jumpUrlWithInfo:activityInfo];
    }
}

- (void)jumpUrlWithInfo:(ActivityInfo *)activityInfo {
    
    if (activityInfo.showType == 2) {
        //半屏webview
        TTHalfWebAlertView *alert = [[TTHalfWebAlertView alloc] init];
        alert.url = [NSURL URLWithString:activityInfo.skipUrl];
        @weakify(alert)
        alert.dismissRequestHandler = ^() {
            @strongify(alert)
            [alert removeFromSuperview];
        };
        [self.view addSubview:alert];
        return;
    }
    
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
    vc.url = [NSURL URLWithString:activityInfo.skipUrl];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
