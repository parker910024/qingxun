//
//  LTOtherUserInfoController.h
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//  他人动态主页信息

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

@interface LTOtherUserInfoController : BaseUIViewController

///别人的uid
@property (nonatomic, copy) NSString *uid;
///来源控制器  聊天界面判断用
@property (nonatomic, weak) UIViewController *formVc;

/// 跳转到个人主页控制器
/// @param uid uid
/// @param uploadFlag uploadFlag
/// @param formVc 谁跳转的
+ (void)jumpToUserControllerWithUserUid:(NSString *)uid uploadFlag:(BOOL)uploadFlag formVc:(UIViewController *)formVc;
@end
