//
//  AnchorOrderAttributedStringMaker.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/29.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  主播订单富文本生成器

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AnchorOrderInfo;

@interface AnchorOrderAttributedStringMaker : NSObject

/// 根据订单初始化生成器
/// @param order 主播订单
- (instancetype)initWithOrder:(AnchorOrderInfo *)order;

/// 更新富文本
/// @param handler 更新回调
- (void)updateHandler:(void(^)(NSAttributedString *string))handler;

/// 点击交互
/// @param handler 点击回调
- (void)tapOrderHandler:(void(^)(void))handler;

/// 点击问号交互（调用此方法才显示问号）
/// @param handler 点击回调
- (void)tapMarkHandler:(void(^)(void))handler;

@end

NS_ASSUME_NONNULL_END
