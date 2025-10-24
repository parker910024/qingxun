//
//  TTWorldletGroupFullAlertView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/11/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  加入群聊满员弹窗（哎呀，群聊人满暂时加不进来啦~）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletGroupFullAlertView : UIView

/// 名称
@property (nonatomic, copy) NSString *name;

/// 进入
@property (nonatomic, copy) void (^enterActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
