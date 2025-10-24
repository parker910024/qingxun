//
//  TwiceRemindView.h
//  XChat
//
//  Created by 卫明何 on 2018/3/10.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TwiceRemindView : NSObject

/**
 二次确认弹框

 @param message 消息
 @param title 标题
 @param targetVc 目标控制器
 @param sureBlock 确认
 @param cancleBlock 取消
 */
+ (void)showTheTwiceRemindAlertWithMessage:(NSString *)message title:(NSString *)title targetVc:(UIViewController *)targetVc enter:(void(^)())sureBlock cancle:(void(^)())cancleBlock;

@end
