//
//  TTCheckinReceiptAlertView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  签到礼物弹窗

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCheckinReceiptAlertView : UIView

@property (nonatomic, copy) void(^shareBlock)(void);

/**
 配置礼物名称

 @param giftName 礼物名称
 @param icon 图标
 */
- (void)configGift:(NSString *)giftName icon:(NSString *)icon;

/**
 配置金币数量

 @param coin 金币个数
 */
- (void)configCoin:(NSInteger)coin;

@end

NS_ASSUME_NONNULL_END
