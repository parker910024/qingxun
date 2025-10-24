//
//  LLForceUpdateView.h
//  XCChatViewKit
//
//  Created by fengshuo on 2019/7/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ForcedUpdateViewUpdateClickBlock)(void);
typedef void(^ForcedUpdateViewCloseClickBlock)(void);
@interface LLForceUpdateView : UIView

/**
 haha 初始化APP更新/强制更新的View
 
 @param bgImage 背景图片
 @param title   标题
 @param descriptionText 更新描述文案
 @param isForced 是否是强制更新
 @return APP更新/强制更新的View
 */
- (instancetype)initWithTitle:(NSString *)title
                descriptionText:(NSString *)descriptionText
                       isForced:(BOOL)isForced
                         update:(ForcedUpdateViewUpdateClickBlock)update
                          close:(ForcedUpdateViewCloseClickBlock)close;

/** 立即更新按钮点击的回调 */
@property (nonatomic, strong) ForcedUpdateViewUpdateClickBlock updateClickBlock;
/** 关闭点击的回调 */
@property (nonatomic, strong) ForcedUpdateViewCloseClickBlock closeClickBlock;


@end

NS_ASSUME_NONNULL_END
