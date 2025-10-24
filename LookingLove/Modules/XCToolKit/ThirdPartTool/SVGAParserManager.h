//
//  SVGAParserManager.h
//  XChat
//
//  Created by 卫明何 on 2018/4/11.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVGA.h"

@interface SVGAParserManager : NSObject

- (void)loadSvgaWithURL:(NSURL *)url
        completionBlock:(void ( ^ _Nonnull )(SVGAVideoEntity * _Nullable videoItem))completionBlock
           failureBlock:(void ( ^ _Nullable)(NSError * _Nullable error))failureBlock;

@end
