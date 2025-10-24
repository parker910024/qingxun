//
//  TTWorldletContainerViewController.h
//  XC_TTGameMoudle
//
//  Created by apple on 2019/6/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletContainerViewController : BaseUIViewController

@property (nonatomic, strong) NSString *worldId;

/** 是不是从房间进入的*/
@property (nonatomic,assign) BOOL isFromRoom;

@end

NS_ASSUME_NONNULL_END
