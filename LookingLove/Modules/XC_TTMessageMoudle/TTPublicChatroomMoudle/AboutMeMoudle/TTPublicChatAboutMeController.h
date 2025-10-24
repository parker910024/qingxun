//
//  TTPublicChatAboutMeController.h
//  TuTu
//
//  Created by 卫明 on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import "NIMSessionViewController.h"

#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicChatAboutMeController : NIMSessionViewController
<
    ZJScrollPageViewChildVcDelegate
>

@end

NS_ASSUME_NONNULL_END
