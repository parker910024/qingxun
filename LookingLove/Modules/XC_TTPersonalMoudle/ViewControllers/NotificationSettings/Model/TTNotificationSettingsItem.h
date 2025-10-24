//
//  TTNotificationSettingsItem.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/12/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///通知设置类型
typedef NS_ENUM(NSInteger, TTNotificationSettingsItemType) {
    TTNotificationSettingsItemTypeSystem = 0,//系统消息
    TTNotificationSettingsItemTypeInteraction = 1,//互动消息
};

@interface TTNotificationSettingsItem : NSObject

/// 类型
@property (nonatomic, assign) TTNotificationSettingsItemType type;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 描述
@property (nonatomic, copy) NSString *desc;
/// 是否开启
@property (nonatomic, assign) BOOL notification;

@end

NS_ASSUME_NONNULL_END
