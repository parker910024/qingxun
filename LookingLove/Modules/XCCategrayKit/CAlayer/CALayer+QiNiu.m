//
//  CALayer+QiNiu.m
//  XCCategrayKit
//
//  Created by 卫明 on 2019/3/8.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "CALayer+QiNiu.h"

#import <CALayer+YYWebImage.h>

#import "XCMacros.h"

@implementation CALayer (QiNiu)

- (void)qn_setImageImageWithUrl:(NSString *)url
               placeholderImage:(nullable NSString *)imageName
                           type:(ImageType)type
                  cornerRadious:(CGFloat)cornerRadious
                        success:(void (^)(UIImage *image))success {
    if (cornerRadious > 0) {
        cornerRadious = cornerRadious * 2;
    }
    if (type == ImageTypeRoomFace) {
        [self yy_setImageWithURL:[NSURL URLWithString:url] placeholder:imageName.length > 0 ? [UIImage imageNamed:imageName] : nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (success) {
                success(image);
            }
        }];
        return;
    }
    
    if ((![url containsString:keyWithType(KeyType_QiNiuBaseURL, NO)] && ![url containsString:@"img.erbanyy.com"]) || type == ImageTypeUserLibaryDetail || type == ImageTypeRoomGift || type == ImageTypeUserRoomTag) {
        NSMutableString *string = [[NSMutableString alloc]initWithString:url.length >0 ? url : @""];
            if (projectType() == ProjectType_CeEr ||
                projectType() == ProjectType_LookingLove) {
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
        
        [self yy_setImageWithURL:[NSURL URLWithString:string] placeholder:imageName.length > 0 ? [UIImage imageNamed:imageName] : nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
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
        [self yy_setImageWithURL:[NSURL URLWithString:encodeStr] placeholder:[UIImage imageNamed:imageName] options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (success) {
                success(image);
            }
        }];
    }else{
        [self yy_setImageWithURL:[NSURL URLWithString:encodeStr] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (success) {
                success(image);
            }
        }];
    }
}

- (void)qn_setImageImageWithUrl:(NSString *)url
               placeholderImage:(nullable NSString *)imageName
                           type:(ImageType)type
                  cornerRadious:(CGFloat)cornerRadious {
    [self qn_setImageImageWithUrl:url placeholderImage:imageName type:type cornerRadious:cornerRadious success:nil];
}

- (void)qn_setImageImageWithUrl:(NSString *)url placeholderImage:(nullable NSString *)imageName type:(ImageType)type{
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

- (void)qn_setImageImageWithUrl:(NSString *)url placeholderImage:(nullable NSString *)imageName type:(ImageType)type success:(void (^)(UIImage *image))success{
    [self yy_setImageWithURL:[NSURL URLWithString:url] placeholder:imageName ? [UIImage imageNamed:imageName] : nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (success) {
            success(image);
        }
    }];
}


@end
