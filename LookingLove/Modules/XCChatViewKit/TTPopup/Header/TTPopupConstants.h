//
//  TTPopupConstants.h
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Popup 组件通用回调
 */
typedef void(^TTPopupCompletionHandler)(void);

/**
 弹窗类型

 - TTPopupStyleAlert: Alert
 - TTPopupStyleActionSheet: ActionSheet
 */
typedef NS_ENUM(NSUInteger, TTPopupStyle) {
    TTPopupStyleAlert = 0,
    TTPopupStyleActionSheet
};

/**
 弹窗优先级

 - TTPopupPriorityNormal: 普通
 - TTPopupPriorityHigh: 高
 - TTPopupPriorityRequired: 必须
 */
typedef NS_ENUM(NSUInteger, TTPopupPriority) {
    TTPopupPriorityNormal = 0,
    TTPopupPriorityHigh,
    TTPopupPriorityRequired
};
