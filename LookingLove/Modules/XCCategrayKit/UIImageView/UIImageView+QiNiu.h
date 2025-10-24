//
//  UIImageView+QiNiu.h
//  XChatFramework
//
//  Created by Mac on 2017/11/10.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCConst.h"

@interface UIImageView (QiNiu)

/**
 下载图片

 @param url 图片url
 @param imageName 占位图图片名（本地）
 @param type 图片类型
 @param cornerRadious 圆角系数，如果是0则不切
 @param success 成功回调
 */
- (void)qn_setImageImageWithUrl:(NSString *)url
               placeholderImage:(NSString *)imageName
                           type:(ImageType)type
                  cornerRadious:(CGFloat)cornerRadious
                        success:(void (^)(UIImage *image))success;

/**
 下载图片

 @param url 图片url
 @param imageName 占位图图片名（本地）
 @param type 图片类型
 @param cornerRadious 圆角系数，如果是0则不切
 */
- (void)qn_setImageImageWithUrl:(NSString *)url placeholderImage:(NSString *)imageName type:(ImageType)type cornerRadious:(CGFloat)cornerRadious;

/**
 下载图片

 @param url 图片url
 @param imageName 占位图图片名（本地）
 @param type 图片类型
 */
- (void)qn_setImageImageWithUrl:(NSString *)url placeholderImage:(NSString *)imageName type:(ImageType)type;

/**
 下载图片

 @param url 图片url
 @param imageName 占位图图片名（本地）
 @param type 图片类型
 @param success 成功回调
 */
- (void)qn_setImageImageWithUrl:(NSString *)url placeholderImage:(NSString *)imageName type:(ImageType)type success:(void (^)(UIImage *image))success;

@end
