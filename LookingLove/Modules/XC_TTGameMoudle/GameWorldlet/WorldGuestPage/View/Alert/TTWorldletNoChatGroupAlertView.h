//
//  TTWorldletNoChatGroupAlertView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/11/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  没有群聊弹窗（人数达3人才可生成群聊 快去邀请好友吧）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletNoChatGroupAlertView : UIView

/// 提示文案
@property (nonatomic, copy) NSString *content;

/// 进入
@property (nonatomic, copy) void (^enterActionBlock)(void);
/// 继续逛逛
@property (nonatomic, copy) void (^browseActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
