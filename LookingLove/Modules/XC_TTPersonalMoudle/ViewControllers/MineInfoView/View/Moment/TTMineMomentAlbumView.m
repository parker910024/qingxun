//
//  TTMineMomentAlbumView.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/27.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMineMomentAlbumView.h"

#import <SDWebImage/UIImageView+WebCache.h>


#import "SDPhotoBrowser.h"
#import "CTDynamicModel.h"
#import "XCCurrentVCStackManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+QiNiu.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"
#import "XCConst.h"

//图片间距
#define ALBUM_IMAGE_INTERVAL 8

//背景容器宽度
#define bgWidth (KScreenWidth - 68 - 20)

@interface TTMineMomentAlbumView ()<SDPhotoBrowserDelegate>

@property (nonatomic, weak) SDPhotoBrowser *photoBrowser;

@end

@implementation TTMineMomentAlbumView

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    UIImageView *imageView = [self viewWithTag:index + 100];
    if (!imageView.image) {
        return [CTDynamicModel modelWithPictureImageBg];
    }
    return imageView.image;
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    UserMomentRes *model = self.imageUrls[index];
    NSURL *url = [NSURL URLWithString:model.resUrl];
    return url;
}

- (void)tapImageAction:(UITapGestureRecognizer *)tap {
    
    [[XCCurrentVCStackManager shareManager].getCurrentVC.view endEditing:YES];
    UIImageView *img = (UIImageView *)tap.view;
    NSInteger index = img.tag - 100;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc]init];
//    self.photoBrowser = browser;
    browser.sourceImagesContainerView = self;
    browser.delegate = self;
    browser.imageCount = self.imageUrls.count;
    browser.currentImageIndex = index;
    [browser show];
}

+ (CGFloat)getPictureViewHeightWithImageInfoList:(NSArray<UserMomentRes *> *)imageList {
    
    CGFloat bgViewHeight = 0;
    CGSize size = [self imageSize:imageList];

    if (imageList.count == 1) {
        bgViewHeight = size.height;
    } else if (imageList.count == 2) {
        bgViewHeight = size.height;
    } else {
        NSInteger rows = ceil(imageList.count / 3.0);
        bgViewHeight = size.width * rows + ALBUM_IMAGE_INTERVAL * (rows - 1);
    }
    
    return bgViewHeight;
}

/// 计算图片大小，区分一、二、三张
/// @param images 图片数组
+ (CGSize)imageSize:(NSArray<UserMomentRes *> *)images {
    
    CGSize size = CGSizeZero;
    
    if (images.count == 1) {
        UserMomentRes *res = [images firstObject];
        
        // 单张图片最大尺寸为屏幕的 0.68
        CGFloat singleWidth = bgWidth * 0.68;
        // 宽高比
        CGFloat widthAspectRatio = res.width / res.height;
        // 高宽比
        CGFloat heightAspectRatio = res.height / res.width;
        // 最大的比例
        CGFloat maxAspectRatio = 2.5f;
        
//        A. 当1≤x≤2.5，y≤1时，图片预览时宽度一致，且缩略图和原图比例一致。
//        B. 当x＞2.5，y≤1时，缩略图和原图比例发生改变，缩略图高度为h不变，宽度为2.5*h（即缩略图宽高比为2.5:1），缩略图居中显示，水平方向隐藏，两端显示不完整；
//        C.当x≤1，1≤y≤2.5时，图片预览时高度一致，且缩略图和原图比例一致。
//        D.当x≤1，y＞2.5时，缩略图和原图比例发生改变，缩略图宽度为w不变，高度为2.5*w（即缩略图高宽比为2.5:1），缩略图居中显示，垂直方向隐藏，两端显示不完整；
        
        // 宽大于长时
        if (widthAspectRatio > heightAspectRatio) {
            if (widthAspectRatio > maxAspectRatio) {
                // 宽高的比例大于 2.5 时
                size = CGSizeMake(singleWidth, singleWidth / maxAspectRatio);
            } else if (res.width > singleWidth) {
                // 比例不够2.5 但是宽度又比既定宽度要宽
                size = CGSizeMake(singleWidth, singleWidth * heightAspectRatio);
            }
        // 长大于宽时
        } else if (heightAspectRatio > widthAspectRatio) {
            if (heightAspectRatio > maxAspectRatio) {
                // 高宽的比例大于 2.5 时
                size = CGSizeMake(singleWidth / maxAspectRatio, singleWidth);
            } else if (res.height > singleWidth) {
                size = CGSizeMake(singleWidth * widthAspectRatio, singleWidth);
            }
        } else {
            // 普通情况下
            if (res.width > singleWidth) {
                CGFloat aspectRatio = res.height/res.width;
                size = CGSizeMake(singleWidth, singleWidth * aspectRatio);
            } else {
                size = CGSizeMake(res.width, res.height);
            }
        }
        
    } else if (images.count == 2) {
        CGFloat width = (bgWidth - ALBUM_IMAGE_INTERVAL) / 2.0;
        size = CGSizeMake(width, width);
    } else {
        CGFloat width = (bgWidth - (ALBUM_IMAGE_INTERVAL * 2)) / 3.0;
        size = CGSizeMake(width, width);
    }
    
    return size;
}

- (void)setImageUrls:(NSArray<UserMomentRes *> *)imageUrls {
    _imageUrls = imageUrls;
        
    CGSize size = [[self class] imageSize:imageUrls];
    ImageType type = ImageTypeUserLibaryDetail;

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [imageUrls enumerateObjectsUsingBlock:^(UserMomentRes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger col = idx % 3;
        NSInteger row = idx / 3;
        CGFloat x = size.width * col + ALBUM_IMAGE_INTERVAL * col;
        CGFloat y = size.height * row + ALBUM_IMAGE_INTERVAL * row;
        
        UIImageView *img = [[UIImageView alloc] init];
        img.tag = idx + 100;
        img.userInteractionEnabled = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.frame = CGRectMake(x, y, size.width, size.height);
        img.layer.cornerRadius = 8;
        img.layer.masksToBounds = YES;
        
        [img qn_setImageImageWithUrl:obj.resUrl placeholderImage:nil type:type];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
        [img addGestureRecognizer:tap];
        [self addSubview:img];
    }];
}

@end

