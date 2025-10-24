//
//  TTSessionViewController+MentoringShip.m
//  TTPlay
//
//  Created by gzlx on 2019/1/24.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTSessionViewController+MentoringShip.h"
#import <BaiduMobStat.h>
#import <Masonry/Masonry.h>

#import "XCMediator+TTRoomMoudleBridge.h"
#import "TTPopup.h"

@implementation TTSessionViewController (MentoringShip)

- (void)addMeesageToChatUIWith:(NSArray *)messages{
    if (messages.count > 0) {
        NIMMessage * message = (NIMMessage *)[messages firstObject];
        if ([self.session.sessionId isEqualToString:message.session.sessionId]) {
             [self uiAddMessages:messages];
        }
    }
}

- (void)setupMentoringShipSucess{
    TTMasterTaskSuccessView *successView = [[TTMasterTaskSuccessView alloc] init];
    successView.delegate =self;
    [TTPopup popupView:successView style:TTPopupStyleAlert];
}


/** 点击了灰色背景 - 消失close */
- (void)masterTaskSuccessView:(TTMasterTaskSuccessView *)view didClickCloseButton:(UIView *)closeView{
    [TTPopup dismiss];
}



@end
