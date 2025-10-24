//
//  TTLaunchGuideView.h
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  首次启动增加新人引导页

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTLaunchGuideViewCompletion)(void);

@interface TTLaunchGuideView : UIView

/**
 隐藏最后一页的进入按钮，默认 NO
 */
@property (nonatomic, assign) BOOL hidenEnterButton;
/**
 隐藏 pageControl，默认 NO
 */
@property (nonatomic, assign) BOOL hidenPageControl;
/**
 允许最后一页整页响应点击退出引导，默认 NO
 @discussion 当 hidenEnterButton = YES，最后一页自动变为整页响应点击退出
 */
@property (nonatomic, assign) BOOL wholeFinalPageInteractionEnabled;
/**
 开启调试模式，每次启动 APP 显示启动页，默认 NO
 */
@property (nonatomic, assign) BOOL openDebugMode;

/**
 初始化启动引导页
 
 @param images 本地图片数组
 */
- (instancetype)initWithImages:(NSArray<NSString *> *)images;

/**
 显示启动引导页
 
 @param completion 退出引导页的回调，无需做引导页移除操作
 */
- (void)showWithCompletion:(nullable TTLaunchGuideViewCompletion)completion;

@end


NS_ASSUME_NONNULL_END
