//
//  TTMineInfoBubbleView.h
//  TuTu
//
//  Created by lee on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTMineInfoBubbleClickHandler)(void);

@interface TTMineInfoBubbleView : UIView
/// 隐藏 lineView
@property (nonatomic, assign, getter=isLineHidden) BOOL lineHidden;
/// 个数
@property (nonatomic, copy) NSString *countNum;
/// icon 命名
@property (nonatomic, copy) NSString *iconName;
/// 初始化 传入数量 count 和 标题 text
- (instancetype)initWithText:(NSString *)text;

@property (nonatomic, copy) TTMineInfoBubbleClickHandler bubbleClickHandler;

@end

NS_ASSUME_NONNULL_END
