//
//  XCBadNetworkAlertView.h
//  XCChatViewKit
//
//  Created by 卫明何 on 2018/9/11.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelClickBlock)(void);
typedef void(^ConfirmClickBlock)(void);

@interface XCBadNetworkAlertView : UIView

/** 确定按钮点击事件 */
@property (nonatomic, copy) ConfirmClickBlock confirmClickBlock;
/** 关闭按钮点击事件 */
@property (nonatomic, copy) CancelClickBlock closeClickBlock;

/**
 初始化方法

 @param frame frame大小
 @param title 标题
 @param desc 描述
 @param cancel 取消
 @param confirm 确定
 @return self XCBadNetworkAlertView
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)desc cancel:(CancelClickBlock)cancel confirm:(ConfirmClickBlock)confirm;

@end
