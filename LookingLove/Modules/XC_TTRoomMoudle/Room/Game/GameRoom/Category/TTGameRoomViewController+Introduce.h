//
//  TTGameRoomViewController+Introduce.h
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"

#import "TTRoomIntroduceAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (Introduce)<TTRoomIntroduceAlertViewDelegate>
- (void)showIntroduceAlertView;
@end

NS_ASSUME_NONNULL_END
