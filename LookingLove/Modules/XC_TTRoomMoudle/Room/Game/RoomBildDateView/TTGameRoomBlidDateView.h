//
//  TTGameRoomBlidDateView.h
//  CeEr
//
//  Created by jiangfuyuan on 2020/12/18.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomBlidDateView : UIView

- (void)roomInfoUpdateAndUpdateLoveRoomStatus:(RoomInfo *)info;

- (void)updateStatusWithHost;

- (void)updateStatusWithOnMicUser;

- (void)updateStatusWithDownMicUser;

// 相亲房流程svga
- (void)procedureUpdateAndShowProcedureSvga:(BlindDateProcedure)procedure;
@end

NS_ASSUME_NONNULL_END
