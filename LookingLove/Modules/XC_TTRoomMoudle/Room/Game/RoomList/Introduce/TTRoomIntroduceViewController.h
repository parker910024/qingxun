//
//  TTRoomIntroduceViewController.h
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RoomInfo;

@interface TTRoomIntroduceViewController : BaseUIViewController
/** info */
@property (nonatomic, strong) RoomInfo *ttRoomInfo;
@end

NS_ASSUME_NONNULL_END
