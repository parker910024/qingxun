//
//  Target_TTPersonalModule.h
//  TuTu
//
//  Created by Macx on 2018/11/13.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Target_TTPersonalModule : NSObject

// 我的页面
- (UIViewController *)Action_mineViewController;

// 个人主页
- (UIViewController *)Action_personalViewController:(NSDictionary *)params;

// 充值
- (UIViewController *)Action_rechargeController;

// 红包提前
- (UIViewController *)Action_redDrawalsViewController;

// 红包记录
- (UIViewController *)Action_BillListViewController:(NSDictionary *)params;

// 提现
- (UIViewController *)Action_drawalsViewController;

// 钻石
- (UIViewController *)Action_diamondViewController;

// 金币
- (UIViewController *)Action_goldCoinViewController;

// 装扮商城
- (UIViewController *)Action_dressUpShopViewController:(NSDictionary *)params;

// 我的装扮
- (UIViewController *)Action_mineDressUpViewController:(NSDictionary *)params;

// 绑定手机
- (UIViewController *)Action_BindingPhoneController:(NSDictionary *)params;

// 公会 群聊
- (UIViewController *)Action_TTGuildGroupSessionViewController:(NSDictionary *)params;

// 公会 首页
- (UIViewController *)Action_TTGuildViewController;

// 设置支付密码
- (UIViewController *)Action_TTSetPWViewController:(NSDictionary *)params;

// 推荐位
- (UIViewController *)Action_TTRecommendContainViewController;

// 绑定提现账号
- (UIViewController *)Action_TTBindingXCZViewController:(NSDictionary *)params;

// 编辑个人资料
- (UIViewController *)Action_TTPersonEditViewController;

// 青少年模式
- (UIViewController *)Action_TTParentModelViewController;

// 反馈
- (UIViewController *)Action_TTFeedbackViewController;

/// 反馈
/// @param params @"source" 反馈来源，1-设置页，2-转盘活动，3-房间红包，其他值-未知来源
- (UIViewController *)Action_TTFeedbackViewControllerWithSource:(NSDictionary *)params;

@end
