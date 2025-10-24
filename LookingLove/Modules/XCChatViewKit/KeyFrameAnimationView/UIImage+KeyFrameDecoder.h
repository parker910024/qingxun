//
//  UIImage+KeyFrameDecoder.h
//  XCChatViewKit
//
//  Created by KevinWang on 2019/3/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KeyFrameDecoder)

- (nullable CGImageRef)xc_decodedCGImageRefCopy;

@end

NS_ASSUME_NONNULL_END
