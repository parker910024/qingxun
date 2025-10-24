//
//  UIImageView+QiNiu.m
//  XChatFramework
//
//  Created by Mac on 2017/11/10.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "UIImageView+QiNiu.h"
#import <SDWebImage/UIImageView+WebCache.h>


#import "XCMacros.h"


@implementation UIImageView (QiNiu)

- (void)qn_setImageImageWithUrl:(NSString *)url
               placeholderImage:(NSString *)imageName
                           type:(ImageType)type
                  cornerRadious:(CGFloat)cornerRadious
                        success:(void (^)(UIImage *image))success {
    if (cornerRadious > 0) {
        cornerRadious = cornerRadious * 2;
    }
    if (type == ImageTypeRoomFace) {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:imageName.length > 0 ? [UIImage imageNamed:imageName] : nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (success) {
                success(image);
            }
        }];
        return;
    }
    
    if ((![url containsString:keyWithType(KeyType_QiNiuBaseURL, NO)] && ![url containsString:@"img.erbanyy.com"]) || type == ImageTypeUserLibaryDetail || type == ImageTypeRoomGift || type == ImageTypeUserRoomTag) {
        NSMutableString *string = [[NSMutableString alloc]initWithString:url.length >0 ? url : @""];
        if (projectType() == ProjectType_LookingLove ||
            projectType() == ProjectType_CeEr) {
            if (cornerRadious > 0) {
                if ([url containsString:@"?"]) {
                    [string appendString:[NSString stringWithFormat:@"&roundPic/radius/%.0f",cornerRadious]];
                }else {
                    if (url.length > 0) {
                        [string appendString:[NSString stringWithFormat:@"?roundPic/radius/%.0f",cornerRadious]];
                    }
                }
            }
            
        }
        
        [self sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:imageName.length > 0 ? [UIImage imageNamed:imageName] : nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (success) {
                success(image);
            }
        }];
        return;
    }
    
    NSMutableString *urlString = [NSMutableString stringWithString:url];
    
    NSString *configUrl = nil;
    switch (type) {
        case ImageTypeRoomBg:
        {
            configUrl = kImageTypeRoomBg;
        }
            break;
        case ImageTypeHomeBanner:
        {
            configUrl = kImageTypeHomeBanner;
        }
            break;
        case ImageTypeHomePageItem:
        {
            configUrl = kImageTypeHomePageItem;
        }
            break;
        case ImageTypeUserIcon:
        {
            configUrl = kImageTypeUserIcon;
        }
            break;
        case ImageTypeUserLibary:
        {
            configUrl = kImageTypeUserLibary;
        }
            break;
        case ImageTypeRoomMagic:
        {
            configUrl = kImageTypeUserLibary;
        }
            break;
        case ImageTypeFamilyHeaderBack:
        {
            configUrl = kImageTypeFamilyHeaderBack;
        }
            break;
        case ImageTypeUserCardBg:
        {
            configUrl = kImageTypeUserCardBg;
        }
            break;
        case ImageTypeCornerAvatar:
        {
            configUrl = kImageTypeCornerAvatar;
        }
            break;
        default:
            break;
    }
    if (configUrl) {
        
        if ([url containsString:@"?"]) {
            [urlString appendString:@"|"];
        }else{
            [urlString appendString:@"?"];
        }
        [urlString appendString:configUrl];
    }
    
    
    if (projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_CeEr) {
        if (cornerRadious > 0) {
            [urlString appendString:[NSString stringWithFormat:@"|roundPic/radius/%f",cornerRadious]];
        }
    }
    
    NSString *encodeStr = [self URLEncodedString:urlString];
    
    if (imageName.length > 0) {
        [self sd_setImageWithURL:[NSURL URLWithString:encodeStr] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (success) {
                success(image);
            }
        }];
    }else{
        [self sd_setImageWithURL:[NSURL URLWithString:encodeStr] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (success) {
                success(image);
            }
        }];
    }
}

- (void)qn_setImageImageWithUrl:(NSString *)url
               placeholderImage:(NSString *)imageName
                           type:(ImageType)type
                  cornerRadious:(CGFloat)cornerRadious {
    [self qn_setImageImageWithUrl:url placeholderImage:imageName type:type cornerRadious:cornerRadious success:nil];
}

- (void)qn_setImageImageWithUrl:(NSString *)url placeholderImage:(NSString *)imageName type:(ImageType)type{
    [self qn_setImageImageWithUrl:url placeholderImage:imageName type:type cornerRadious:0];
}

- (NSString *)URLEncodedString:(NSString *)string
{

    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)string,
                                                              NULL,
                                                              (CFStringRef)@"|",
                                                              kCFStringEncodingUTF8));

    return encodedString;
}

- (void)qn_setImageImageWithUrl:(NSString *)url placeholderImage:(NSString *)imageName type:(ImageType)type success:(void (^)(UIImage *image))success{

    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:imageName ? [UIImage imageNamed:imageName] : nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        success(image);
    }];
}

@end
