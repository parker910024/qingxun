//
//  RefreshFactory.h
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh.h>


@interface RefreshFactory : NSObject

+ (MJRefreshHeader *)headerRefreshWithTarget:(id)target refreshingAction:(SEL)action;
+ (MJRefreshFooter *)footerRefreshWithTarget:(id)target refreshingAction:(SEL)action;

+ (MJRefreshHeader *)headerRefreshWithTarget:(id)target refreshingAction:(SEL)action color:(UIColor *)color;
+ (MJRefreshFooter *)footerRefreshWithTarget:(id)target refreshingAction:(SEL)action color:(UIColor *)color;

@end
