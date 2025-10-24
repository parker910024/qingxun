//
//  XCGuildMessageContentControlView.h
//  TuTu
//
//  Created by lvjunhang on 2019/1/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  公会管理 自定义云信消息内容 控制视图（拒绝、同意、状态显示）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XCGuildAttachment;

@interface XCGuildMessageContentControlView : UIView
@property (strong, nonatomic) XCGuildAttachment *attachment;

@property (strong, nonatomic) UIButton *rejectButton;
@property (strong, nonatomic) UIButton *agreeButton;

@end

NS_ASSUME_NONNULL_END
