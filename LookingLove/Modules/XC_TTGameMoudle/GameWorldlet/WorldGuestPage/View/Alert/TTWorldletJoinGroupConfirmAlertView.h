//
//  TTWorldletJoinGroupConfirmAlertView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/11/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  加入群聊确认弹窗（加入群聊后可以和小世界的朋友们 谈天说地，确认加入群聊吗？）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletJoinGroupConfirmAlertView : UIView

/// 名称
@property (nonatomic, copy) NSString *name;

/// 进入
@property (nonatomic, copy) void (^enterActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
