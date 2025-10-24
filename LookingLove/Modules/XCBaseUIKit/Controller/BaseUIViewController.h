//
//  BaseUIViewController.h
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseUIViewController : UIViewController

// 是否隐藏导航 默认是不隐藏的
@property(nonatomic,assign,getter=isHiddenNavBar) BOOL hiddenNavBar;
// 是否是导航栏的根控制器, 防止快速侧滑卡死
@property(nonatomic,assign,getter=isNavRootViewController) BOOL navRootViewController;
//是否已经有数据 当有数据加载失败的时候 不展示加载画面
@property(nonatomic,assign,getter=isHadData) BOOL hadData;
//状态动画的偏移
@property (nonatomic, assign) CGFloat stateViewOriginY;//

//在控制器上添加文字
- (void)addNavigationItemWithTitles:(NSArray *)titles titleColor:(UIColor *)color isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

//在控制器上添加图片
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

@end
