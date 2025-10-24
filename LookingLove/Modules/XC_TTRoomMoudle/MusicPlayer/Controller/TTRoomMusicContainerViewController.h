//
//  TTRoomMusicContainerViewController.h
//  TTPlay
//
//  Created by Macx on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TTMusicListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTRoomMusicContainerViewController : BaseUIViewController
@property (strong, nonatomic, readonly) TTMusicListController *musicListVC;
@end

NS_ASSUME_NONNULL_END
