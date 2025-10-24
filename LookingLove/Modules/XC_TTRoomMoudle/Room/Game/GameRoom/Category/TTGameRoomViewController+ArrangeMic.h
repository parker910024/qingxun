//
//  TTGameRoomViewController+ArrangeMic.h
//  TuTu
//
//  Created by gzlx on 2018/12/18.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (ArrangeMic)
/** 排麦列表 */
- (void)ttShowArrangeMicVc;
/** 从无到有，改变排麦显示状态 */
- (void)updateQueueMicStatus:(BOOL)status;

@end

NS_ASSUME_NONNULL_END
