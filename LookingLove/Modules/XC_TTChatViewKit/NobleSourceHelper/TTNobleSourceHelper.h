//
//  TTNobleSourceHelper.h
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
//动画
#import <YYImage/YYAnimatedImageView.h>
//贵族source
#import "NobleSourceInfo.h"
//const
#import "XCConst.h"

#import "UserCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTNobleSourceHelper : NSObject

/**
 展示贵族资源

 @param imageView imageView
 @param source may be NSURL,UIImage,NSString or UIColor
 @param imageType 图片类型
 */
+ (void)disposeImageView:(UIImageView *)imageView
              withSource:(id)source
               imageType:(ImageType)imageType;

/**
 处理精灵动画

 @param imageView 动画view
 @param sourceURLStr 精灵序列链接
 */
+ (void)disposeImageViewAnimation:(YYAnimatedImageView *)imageView
                     sourceURLStr:(NSString *)sourceURLStr;

/**
 处理贵族资源

 @param imageView 动画view
 @param nobleSourceInfo 贵族资源model
 @param imageType 图片类型
 */
+ (void)disposeImageView:(UIImageView *)imageView
         nobleSourceInfo:(NobleSourceInfo *)nobleSourceInfo
               imageType:(ImageType)imageType;

/**
 创建贵族勋章

 @param userInfo 用户资料
 @param size 大小
 @return 富文本
 */
+ (NSMutableAttributedString *)creatNobleBadge:(UserInfo *)userInfo
                                          size:(CGSize)size;

/// 动态页 贵族标识
/// @param badge 贵族标识
/// @param size 尺寸
+ (NSMutableAttributedString *)creatDynamicNobleBadge:(NSString *)badge size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
