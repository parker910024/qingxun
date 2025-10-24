//
//  XCCurrentVCStackManager.h
//  XCBaseUIKit
//
//  Created by 卫明何 on 2018/8/9.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XCCurrentVCStackManager : NSObject

+ (instancetype)shareManager;

/**
 当前的导航控制器

 @return 导航控制器
 */
- (UINavigationController *)currentNavigationController;

/**
 当前最顶层控制器

 @return 当前最顶层控制器
 */
- (UIViewController *)getCurrentVC;


@end
