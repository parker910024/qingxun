//
//  LLPostDynamicLittleWorldAlertView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/1/9.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  选择小世界弹窗

#import <UIKit/UIKit.h>

#import "LittleWorldDynamicPostWorld.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLPostDynamicLittleWorldAlertView : UIView
@property (nonatomic, assign) DynamicPostWorldRequestType currentSelectType;//当前查看类型
@property (nonatomic, copy) void (^selectWorldHandler)(LittleWorldDynamicPostWorld *model);

#pragma mark - Public
- (void)show;

@end

NS_ASSUME_NONNULL_END
