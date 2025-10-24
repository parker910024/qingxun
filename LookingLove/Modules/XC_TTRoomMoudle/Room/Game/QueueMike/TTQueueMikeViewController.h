//
//  TTQueueMikeViewController.h
//  TuTu
//
//  Created by lee on 2018/12/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RoomInfo;
typedef void(^TTQueueMikeBtnClickHandler)(UIButton *btn);

@interface TTQueueMikeViewController : BaseUIViewController
@property (nonatomic, assign) BOOL isMyRoom; // 如果是自己房间
@property (nonatomic, copy) TTQueueMikeBtnClickHandler btnClickHander;
@property (nonatomic, strong) RoomInfo *roomInfo;

@end

NS_ASSUME_NONNULL_END
