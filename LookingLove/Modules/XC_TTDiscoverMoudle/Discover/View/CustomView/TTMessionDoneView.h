//
// Created by lee on 2019-03-21.
// Copyright (c) 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MissionInfo;

typedef void(^TTMessionDoneViewDismissHandler)(void);

@interface TTMessionDoneView : UIView
@property (nonatomic, strong, readonly) UIImageView *effectImageView;     // 带动效的图
@property (nonatomic, strong) MissionInfo *info; // 任务列表
@property (nonatomic, copy) TTMessionDoneViewDismissHandler dismissHandler;
- (void)startAnimation;
@end
