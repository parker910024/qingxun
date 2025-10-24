//
//  TabBarItemModel.h
//  LookingLove
//
//  Created by lvjunhang on 2020/12/9.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarItemModel : NSObject
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@end

NS_ASSUME_NONNULL_END
