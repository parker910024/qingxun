//
//  AnchorOrderPickerCell.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AnchorOrderPickerStyle) {//样式
    AnchorOrderPickerStylePrice,//价格
    AnchorOrderPickerStylePlayTime,//陪玩时长
    AnchorOrderPickerStyleType,//类型
    AnchorOrderPickerStyleEffectTime,//订单有效时长
};

@class AnchorOrderInfo;

@interface AnchorOrderPickerCell : UITableViewCell

/// cell样式
@property (nonatomic, assign) AnchorOrderPickerStyle style;

/// 订单模型
@property (nonatomic, strong) AnchorOrderInfo *orderInfo;

/// 完成输入
@property (nonatomic, copy) void (^completeInputHandler)(NSString *input);

/// 按钮事件
@property (nonatomic, copy) void (^buttonActionHandler)(void);

@end

NS_ASSUME_NONNULL_END
