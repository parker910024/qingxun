//
//  TTGameRoomViewController+Introduce.m
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+Introduce.h"
#import "TTPopup.h"

@implementation TTGameRoomViewController (Introduce)
- (void)showIntroduceAlertView {
    // 弹出房间介绍
    TTRoomIntroduceAlertView *introduceView = [[TTRoomIntroduceAlertView alloc] init];
    introduceView.roomInfo = self.roomInfo;
    introduceView.delegate = self;
    
    TTPopupConfig *config = [[TTPopupConfig alloc] init];
    config.contentView = introduceView;
    config.style = TTPopupStyleAlert;
    config.shouldDismissOnBackgroundTouch = NO;
    
    [TTPopup popupWithConfig:config];
}

#pragma mark - TTRoomIntroduceAlertViewDelegate
- (void)ttRoomIntroduceAlertView:(TTRoomIntroduceAlertView *)view didClickCloseButton:(UIButton *)button {
    
    [TTPopup dismiss];
}
@end
