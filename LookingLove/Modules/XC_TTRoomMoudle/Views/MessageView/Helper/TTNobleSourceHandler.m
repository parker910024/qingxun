//
//  TTNobleSourceHandler.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTNobleSourceHandler.h"
//t
#import "UIImage+Utils.h"
#import "UIImage+scaledToSize.h"
#import "CALayer+QiNiu.h"
#import "SpriteSheetImageManager.h"
#import <SDWebImage/UIImageView+WebCache.h>


#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
//core
#import "NobleCore.h"

/*
 NobleSourceTypeID = 1, //ids 本地资源
 NobleSourceTypeURL = 2, //url 网络资源
 NobleSourceTypeColor = 3, //colors 颜色
 */
@implementation TTNobleSourceHandler

+ (void)handlerImageViewAnimation:(YYAnimatedImageView *)imageView urlString:(NSString *)urlString {
    if (!urlString) {
        return;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    [imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        YYSpriteSheetImage *spriteImage = [SpriteSheetImageManager createSpriteSheet:image];
        imageView.image = spriteImage;
    }];
}

+ (void)handlerImageView:(UIImageView *)imageView  nobleInfo:(SingleNobleInfo *)nobleInfo{
    imageView.image = [UIImage imageWithColor:[self nobleNameByMessageBgColor:nobleInfo.level]];
}

+ (void)handlerImageView:(UIImageView *)imageView  soure:(id)source imageType:(ImageType)imageType{
    
    if (imageType == ImageTypeRoomChatBuble) {
        if ([source isKindOfClass:[NSURL class]]) {
            
        }else if ([source isKindOfClass:[UIImage class]]){
            UIImage *image = (UIImage *)source;
            UIImage *newImage = [self handleBubbleImage:image];
            imageView.image = newImage;
            
        }else if ([source isKindOfClass:[NSString class]]){
            UIImage *image = [GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source];
            UIImage *newImage = [self handleBubbleImage:image];
            imageView.image = newImage;
            
        }else if ([source isKindOfClass:[UIColor class]]){
            //            UIImage *image = [UIImage imageWithColor:(UIColor *)source];
        }
        
        return;
    }
    
    
    if ([source isKindOfClass:[NSURL class]]) {
        [imageView qn_setImageImageWithUrl:[(NSURL *)source absoluteString] placeholderImage:nil type:imageType];
    }else if ([source isKindOfClass:[UIImage class]]){
        imageView.image = (UIImage *)source;
    }else if ([source isKindOfClass:[NSString class]]){
        UIImage *image = [GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source];
        imageView.image = image;
    }else if ([source isKindOfClass:[UIColor class]]){
        imageView.image = [UIImage imageWithColor:(UIColor *)source];
    }
}

+ (void)handlerImageView:(UIImageView *)imageView  soureInfo:(NobleSourceInfo*)sourceInfo imageType:(ImageType)imageType{
    
    if (imageType == ImageTypeRoomChatBuble && sourceInfo.sourceType == NobleSourceTypeID) {
        
        UIImage *image = (UIImage *)sourceInfo.source;
        UIImage *newImage = [self handleBubbleImage:image];
        imageView.image = newImage;
        return;
    }
    
    switch (sourceInfo.sourceType) {
        case NobleSourceTypeID:
        {
            imageView.image = (UIImage *)sourceInfo.source;
        }
            break;
        case NobleSourceTypeURL:
        {
            [imageView qn_setImageImageWithUrl:[(NSURL *)sourceInfo.source absoluteString] placeholderImage:nil type:imageType];
        }
            break;
        case NobleSourceTypeColor:
        {
            imageView.image = [UIImage imageWithColor:(UIColor *)sourceInfo.source];
        }
            break;
    }
}

+ (void)handlerSpeakingAnimationView:(UIView *)animationView  soure:(id)source{
    if ([source isKindOfClass:[NSURL class]]) {
        
    }else if ([source isKindOfClass:[UIImage class]]){
        
    }else if ([source isKindOfClass:[NSString class]]){
        
    }else if ([source isKindOfClass:[UIColor class]]){
        
    }
}


#pragma mark - layer

+ (void)handlerLayer:(CALayer *)layer nobleInfo:(SingleNobleInfo *)nobleInfo {
    layer.contents = (__bridge id)[UIImage imageWithColor:[self nobleNameByMessageBgColor:nobleInfo.level]].CGImage;
}
+ (void)handlerLayer:(CALayer *)layer soure:(id)source imageType:(ImageType)imageType {
    if (imageType == ImageTypeRoomChatBuble) {
        if ([source isKindOfClass:[NSURL class]]) {
            
        }else if ([source isKindOfClass:[UIImage class]]){
            UIImage *image = (UIImage *)source;
            UIImage *newImage = [self handleBubbleImage:image];
            layer.contents = (__bridge id)newImage.CGImage;
            
        }else if ([source isKindOfClass:[NSString class]]){
            UIImage *image = [GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source];
            UIImage *newImage = [self handleBubbleImage:image];
            layer.contents = (__bridge id)newImage.CGImage;
            
        }else if ([source isKindOfClass:[UIColor class]]){
            //            UIImage *image = [UIImage imageWithColor:(UIColor *)source];
        }
        
        return;
    }
    
    
    if ([source isKindOfClass:[NSURL class]]) {
        [layer qn_setImageImageWithUrl:[(NSURL *)source absoluteString] placeholderImage:nil type:imageType];
    }else if ([source isKindOfClass:[UIImage class]]){
        layer.contents = (__bridge id)((UIImage *)source).CGImage;
    }else if ([source isKindOfClass:[NSString class]]){
        UIImage *image = [GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source];
        layer.contents = (__bridge id)image.CGImage;
    }else if ([source isKindOfClass:[UIColor class]]){
        layer.contents = (__bridge id)[UIImage imageWithColor:(UIColor *)source].CGImage;
    }
}
+ (void)handlerLayer:(CALayer *)layer  soureInfo:(NobleSourceInfo*)sourceInfo imageType:(ImageType)imageType {
    if (imageType == ImageTypeRoomChatBuble && sourceInfo.sourceType == NobleSourceTypeID) {
        
        UIImage *image = (UIImage *)sourceInfo.source;
        UIImage *newImage = [self handleBubbleImage:image];
        layer.contents = (__bridge id)newImage.CGImage;
        return;
    }
    
    switch (sourceInfo.sourceType) {
        case NobleSourceTypeID:
        {
            layer.contents = (__bridge id)((UIImage *)sourceInfo.source).CGImage;
        }
            break;
        case NobleSourceTypeURL:
        {
            [layer qn_setImageImageWithUrl:[(NSURL *)sourceInfo.source absoluteString] placeholderImage:nil type:imageType];
        }
            break;
        case NobleSourceTypeColor:
        {
            layer.contents = (__bridge id)[UIImage imageWithColor:(UIColor *)sourceInfo.source].CGImage;
        }
            break;
    }
}

#pragma mark - private method

+ (UIImage *)handleBubbleImage:(UIImage *)image{
    //适配文字只有一行到时候，cell被imageview撑大。
    //    image = [image scaleImageWithScale:26.0/image.size.height];
    //    image = [UIImage imageNamed:@"test3"];
    CGFloat top = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat right = image.size.width * 0.5;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImageResizingMode mode = UIImageResizingModeStretch;
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    return  newImage;
}

+ (UIColor *)nobleNameByMessageBgColor:(int)nobleLevel{
    NSString *nobleLevelString = [NSString stringWithFormat:@"%d",nobleLevel];
    NSDictionary *matchNobleName = @{@"0":[UIColor clearColor],
                                     @"1":[UIColor clearColor],
                                     @"2":[UIColor clearColor],
                                     @"3":[UIColor clearColor],
                                     @"4":UIColorRGBAlpha(0x00AEEE, 0.3),
                                     @"5":UIColorRGBAlpha(0x9562FC, 0.3),
                                     @"6":UIColorRGBAlpha(0xFF1413, 0.3),
                                     @"7":UIColorRGBAlpha(0xFFA201, 0.3)};
    return matchNobleName[nobleLevelString];
}

@end
