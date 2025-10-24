//
//  TTNobleSourceHandler.h
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NobleSourceInfo.h"
#import "SingleNobleInfo.h"
#import <YYAnimatedImageView.h>
#import "XCConst.h"

@interface TTNobleSourceHandler : NSObject


+ (void)handlerImageViewAnimation:(YYAnimatedImageView *)imageView urlString:(NSString *)urlString;

+ (void)handlerImageView:(UIImageView *)imageView  nobleInfo:(SingleNobleInfo *)nobleInfo;
+ (void)handlerImageView:(UIImageView *)imageView  soure:(id)source imageType:(ImageType)imageType;
+ (void)handlerImageView:(UIImageView *)imageView  soureInfo:(NobleSourceInfo*)sourceInfo imageType:(ImageType)imageType;

+ (void)handlerLayer:(CALayer *)layer nobleInfo:(SingleNobleInfo *)nobleInfo;
+ (void)handlerLayer:(CALayer *)layer soure:(id)source imageType:(ImageType)imageType;
+ (void)handlerLayer:(CALayer *)layer  soureInfo:(NobleSourceInfo*)sourceInfo imageType:(ImageType)imageType;

+ (void)handlerSpeakingAnimationView:(UIView *)animationView  soure:(id)source;

@end
