//
//  TTAuthViewControllerCenter.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTAuthViewControllerCenter : NSObject
+ (instancetype)defaultCenter;

- (UIViewController *)toLogin;

/// 获取当前项目登录控制器所属类
- (Class)loginViewControllerClass;

@end
