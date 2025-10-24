//
//  UIImageView+YYWeb.m
//  CatASMR
//
//  Created by KevinWang on 2020/2/24.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "UIImageView+YYWeb.h"
#import <YYWebImage/YYWebImage.h>

@implementation UIImageView (YYWeb)

- (void)asmr_setImageImageWithUrl:(NSString *)url placeholderImage:(NSString *)imageName {
    
    [self yy_setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:imageName]];
}

@end
