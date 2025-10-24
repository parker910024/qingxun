//
//  AppDelegate+Config.h
//  TuTu
//
//  Created by 卫明 on 2018/11/8.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "AppDelegate.h"
#import "ImMessageCoreClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Config)
<
    ImMessageCoreClient
>

- (void)configPublicChatroom;
@end

NS_ASSUME_NONNULL_END
