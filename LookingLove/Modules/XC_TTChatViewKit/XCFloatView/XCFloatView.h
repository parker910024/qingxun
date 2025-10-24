//
//  XCFloatView.h
//  XCChatViewKit
//
//  Created by Macx on 2018/9/6.
//  Copyright © 2018年 KevinWang. All rights reserved.
//  悬浮球

#import <UIKit/UIKit.h>

@class XCFloatView;
@class RoomInfo;

typedef NS_ENUM(NSUInteger, XCSuspensionViewLeanType) {
    /** 仅可停留在左、右 */
    XCSuspensionViewLeanTypeHorizontal,
    /** 可停留在上、下、左、右 */
    XCSuspensionViewLeanTypeEachSide
};

@protocol XCFloatViewDelegate <NSObject>
/** 点击悬浮球的回调 */
- (void)floatViewDidClick:(XCFloatView *)floatView roomInfo:(RoomInfo *)roomInfo;
/** 关闭按钮点击的回调 */
- (void)floatView:(XCFloatView *)floatView didClickCloseButton:(UIButton *)btn;
@end

@interface XCFloatView : UIView
/** 代理 */
@property (nonatomic, weak) id<XCFloatViewDelegate> delegate;
/** 倚靠类型 default is ZYSuspensionViewLeanTypeHorizontal */
@property (nonatomic, assign) XCSuspensionViewLeanType leanType;


- (instancetype)initWithFrame:(CGRect)frame delegate:(id<XCFloatViewDelegate>)delegate;

+ (instancetype)shareFloatView;

/** 隐藏浮窗 */
- (void)hideFloatingView;

@end
