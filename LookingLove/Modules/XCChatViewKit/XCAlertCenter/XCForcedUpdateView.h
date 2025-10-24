//
//  XCForcedUpdateView.h
//  XCChatViewKit
//
//  Created by Macx on 2018/8/28.
//  Copyright © 2018年 KevinWang. All rights reserved.
//  APP更新/强制更新的View

#import <UIKit/UIKit.h>

typedef void(^ForcedUpdateViewUpdateClickBlock)(void);
typedef void(^ForcedUpdateViewCloseClickBlock)(void);
@interface XCForcedUpdateView : UIView

/**
 haha 初始化APP更新/强制更新的View

 @param bgImage 背景图片
 @param title   标题
 @param descriptionText 更新描述文案
 @param isForced 是否是强制更新
 @return APP更新/强制更新的View
 */
- (instancetype)initWithBgImage:(UIImage *)bgImage
                          title:(NSString *)title
                descriptionText:(NSString *)descriptionText
                       isForced:(BOOL)isForced
                         update:(ForcedUpdateViewUpdateClickBlock)update
                          close:(ForcedUpdateViewCloseClickBlock)close;

/** 立即更新按钮点击的回调 */
@property (nonatomic, strong) ForcedUpdateViewUpdateClickBlock updateClickBlock;
/** 关闭点击的回调 */
@property (nonatomic, strong) ForcedUpdateViewCloseClickBlock closeClickBlock;


/**
 ms 使用 初始化APP更新/强制更新的View

 @param bgImage 背景
 @param updateBtnBGImage 立即升级按钮背景
 @param closeImage 关闭按钮图片
 @param descriptionText 升级描述
 @param isForced 是否强制
 @param update 立即升级点击回调
 @param close 关闭点击回调
 @return self
 */
- (instancetype)initMSWithBgImage:(UIImage *)bgImage
                 updateBtnBGImage:(UIImage *)updateBtnBGImage
                       closeImage:(UIImage *)closeImage
                  descriptionText:(NSString *)descriptionText
                         isForced:(BOOL)isForced
                           update:(ForcedUpdateViewUpdateClickBlock)update
                            close:(ForcedUpdateViewCloseClickBlock)close;

/**
 tt 使用 初始化APP更新/强制更新的View
 
 @param bgImage 背景
 @param updateBtnBGImage 立即升级按钮背景
 @param closeImage 关闭按钮图片
 @param descriptionText 升级描述
 @param isForced 是否强制
 @param update 立即升级点击回调
 @param close 关闭点击回调
 @return self
 */
- (instancetype)initTTWithBgImage:(UIImage *)bgImage
                 updateBtnBGImage:(UIImage *)updateBtnBGImage
                       closeImage:(UIImage *)closeImage
                  descriptionText:(NSString *)descriptionText
                         isForced:(BOOL)isForced
                           update:(ForcedUpdateViewUpdateClickBlock)update
                            close:(ForcedUpdateViewCloseClickBlock)close;
@end
