//
//  TTWorldletJoinSuccessAlertView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/11/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  成功加入小世界弹窗

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletJoinSuccessAlertView : UIView

/// 小世界名称
@property (nonatomic, copy) NSString *name;

/// 进入
@property (nonatomic, copy) void (^enterActionBlock)(void);
/// 继续逛逛
@property (nonatomic, copy) void (^browseActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
