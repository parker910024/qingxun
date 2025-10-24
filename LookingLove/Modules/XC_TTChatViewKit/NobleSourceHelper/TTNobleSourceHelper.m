//
//  TTNobleSourceHelper.m
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTNobleSourceHelper.h"

//core
#import "NobleCore.h"

//tool
#import "UIImage+Utils.h"
#import "UIImageView+QiNiu.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CALayer+QiNiu.h"
#import <YYText/YYText.h>

//manager
#import "SpriteSheetImageManager.h"

@implementation TTNobleSourceHelper

+ (void)disposeImageView:(UIImageView *)imageView
              withSource:(id)source
               imageType:(ImageType)imageType {
    if (imageType == ImageTypeRoomChatBuble) {
        if ([source isKindOfClass:NSClassFromString(@"NSURL")]) {
            
        }else if ([source isKindOfClass:NSClassFromString(@"UIImage")]) {
            imageView.image = [self disposeBubbleImage:(UIImage *)source];
        }else if ([source isKindOfClass:NSClassFromString(@"NSString")]) {
            imageView.image = [self disposeBubbleImage:[GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source]];
        }else if ([source isKindOfClass:NSClassFromString(@"UIColor")]) {
//            UIImage *image = [UIImage image]
            imageView.image = [UIImage imageWithColor:(UIColor *)source];
        }
        return;
    }
    
    if ([source isKindOfClass:[NSURL class]]) {
        [imageView qn_setImageImageWithUrl:[(NSURL *)source absoluteString] placeholderImage:nil type:imageType];
    }else if ([source isKindOfClass:[UIImage class]]){
        imageView.image = (UIImage *)source;
    }else if ([source isKindOfClass:[NSString class]]){
        imageView.image = [GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source];
    }else if ([source isKindOfClass:[UIColor class]]){
        imageView.image = [UIImage imageWithColor:(UIColor *)source];
    }else {
        imageView.image = nil;
    }
}

+ (void)disposeImageViewWithLayer:(CALayer *)layer
              withSource:(id)source
               imageType:(ImageType)imageType {
    if (imageType == ImageTypeRoomChatBuble) {
        if ([source isKindOfClass:NSClassFromString(@"NSURL")]) {
            
        }else if ([source isKindOfClass:NSClassFromString(@"UIImage")]) {
            layer.contents = (__bridge id)[self disposeBubbleImage:(UIImage *)source].CGImage;
            
        }else if ([source isKindOfClass:NSClassFromString(@"NSString")]) {
            layer.contents = (__bridge id)[self disposeBubbleImage:[GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source]].CGImage;
        }else if ([source isKindOfClass:NSClassFromString(@"UIColor")]) {
            //            UIImage *image = [UIImage image]
            layer.contents = (__bridge id)[UIImage imageWithColor:(UIColor *)source].CGImage;
        }
        return;
    }
    
    if ([source isKindOfClass:[NSURL class]]) {
        [layer qn_setImageImageWithUrl:[(NSURL *)source absoluteString] placeholderImage:nil type:imageType];
    }else if ([source isKindOfClass:[UIImage class]]){
        layer.contents = (__bridge id)((UIImage *)source).CGImage;
    }else if ([source isKindOfClass:[NSString class]]){
        layer.contents = (__bridge id)[GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source].CGImage;
    }else if ([source isKindOfClass:[UIColor class]]){
        layer.contents = (__bridge id)[UIImage imageWithColor:(UIColor *)source].CGImage;
    }else {
        layer.contents = nil;
    }
}

+ (void)disposeImageViewAnimation:(YYAnimatedImageView *)imageView
                     sourceURLStr:(NSString *)sourceURLStr {
    if (sourceURLStr.length > 0) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:sourceURLStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            imageView.image = [SpriteSheetImageManager createSpriteSheet:image];
        }];
    }
}

+ (void)disposeImageView:(UIImageView *)imageView
         nobleSourceInfo:(NobleSourceInfo *)nobleSourceInfo
               imageType:(ImageType)imageType {
    if (imageType == ImageTypeRoomChatBuble && nobleSourceInfo.sourceType == NobleSourceTypeID) {
        imageView.image = [self disposeBubbleImage:(UIImage *)nobleSourceInfo.source];
        return;
    }
    
    switch (nobleSourceInfo.sourceType) {
        case NobleSourceTypeID:
        {
            imageView.image = (UIImage *)nobleSourceInfo.source;
        }
            break;
        case NobleSourceTypeURL:
        {
            [imageView qn_setImageImageWithUrl:[(NSURL *)nobleSourceInfo.source absoluteString] placeholderImage:nil type:imageType];
        }
            break;
        case NobleSourceTypeColor:
        {
            imageView.image = [UIImage imageWithColor:(UIColor *)nobleSourceInfo.source];
        }
            break;
    }
}

+ (void)disposeImageViewWithLayer:(CALayer *)layer
         nobleSourceInfo:(NobleSourceInfo *)nobleSourceInfo
               imageType:(ImageType)imageType {
    if (imageType == ImageTypeRoomChatBuble && nobleSourceInfo.sourceType == NobleSourceTypeID) {
        layer.contents = [self disposeBubbleImage:(UIImage *)nobleSourceInfo.source];
        return;
    }
    
    switch (nobleSourceInfo.sourceType) {
        case NobleSourceTypeID:
        {
            layer.contents = (UIImage *)nobleSourceInfo.source;
        }
            break;
        case NobleSourceTypeURL:
        {
            [layer qn_setImageImageWithUrl:[(NSURL *)nobleSourceInfo.source absoluteString] placeholderImage:nil type:imageType];
        }
            break;
        case NobleSourceTypeColor:
        {
            layer.contents = [UIImage imageWithColor:(UIColor *)nobleSourceInfo.source];
        }
            break;
    }
}

+ (UIImage *)disposeBubbleImage:(UIImage *)image {
    CGFloat topBottom = image.size.height * 0.5;
    CGFloat leftRight = image.size.width * 0.5;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(topBottom, leftRight, topBottom, leftRight);
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    return newImage;
}

//nobleBadge
+ (NSMutableAttributedString *)creatNobleBadge:(UserInfo *)userInfo size:(CGSize)size{
    
    return [self creatDynamicNobleBadge:userInfo.nobleUsers.badge size:size];
}

/// 动态页 贵族标识
/// @param badge 贵族标识
/// @param size 尺寸
+ (NSMutableAttributedString *)creatDynamicNobleBadge:(NSString *)badge size:(CGSize)size {
    
    CALayer *nobleBadgeImageView = [[CALayer alloc]init];
    nobleBadgeImageView.contentsGravity = kCAGravityResize;
    nobleBadgeImageView.contentsScale = [UIScreen mainScreen].scale;

    [self disposeImageViewWithLayer:nobleBadgeImageView withSource:badge imageType:ImageTypeUserLibaryDetail];
    
    nobleBadgeImageView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    NSMutableAttributedString * nobleImageString = [NSMutableAttributedString yy_attachmentStringWithContent:nobleBadgeImageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nobleBadgeImageView.frame.size.width, nobleBadgeImageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return nobleImageString;
}


@end
