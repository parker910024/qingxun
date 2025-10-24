//
//  UIImage+KeyFrameDecoder.m
//  XCChatViewKit
//
//  Created by KevinWang on 2019/3/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "UIImage+KeyFrameDecoder.h"

@implementation UIImage (KeyFrameDecoder)

- (nullable CGImageRef)xc_decodedCGImageRefCopy {
    CGImageRef imgRef = self.CGImage;
    if (!imgRef) {
        return NULL;
    }
    size_t imgWidth = CGImageGetWidth(imgRef);
    size_t imgHeight = CGImageGetHeight(imgRef);
    if (0 == imgWidth || 0 == imgHeight) {
        return NULL;
    }
    
    const size_t cBPC = 8;
    const size_t cBytesPR = 0;
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imgRef);
    BOOL hasAlpha = (kCGImageAlphaPremultipliedFirst == alphaInfo
                     || kCGImageAlphaPremultipliedLast == alphaInfo
                     || kCGImageAlphaFirst == alphaInfo
                     || kCGImageAlphaLast == alphaInfo);
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imgWidth,
                                                 imgHeight,
                                                 cBPC,
                                                 cBytesPR,
                                                 CGColorSpaceCreateDeviceRGB(),
                                                 bitmapInfo);
    if (context) {
        CGContextDrawImage(context,
                           CGRectMake(0, 0, imgWidth, imgHeight),
                           imgRef);
        imgRef = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        return imgRef;
    }
    return NULL;
}

@end
