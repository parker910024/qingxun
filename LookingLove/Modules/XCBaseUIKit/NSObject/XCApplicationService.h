//
//  XCApplicationService.h
//  XCBaseUIKit
//
//  Created by KevinWang on 2018/9/7.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import <UIKit/UIKit.h>

//项目存在push到子控制器y跳转不过去 如果需要 MMDrawerController 第三方 请在对应项目导入
@class MMDrawerController;
@interface XCApplicationService : NSObject

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) MMDrawerController *drawController;

+ (instancetype)defaultService;

@end
