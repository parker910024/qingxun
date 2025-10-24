//
//  UIImageView+YYWeb.h
//  CatASMR
//
//  Created by KevinWang on 2020/2/24.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (YYWeb)

- (void)asmr_setImageImageWithUrl:(NSString *)url placeholderImage:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
