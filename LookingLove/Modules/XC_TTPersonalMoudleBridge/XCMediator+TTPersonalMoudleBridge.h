//
//  XCMediator+TTPersonalMoudleBridge.h
//  XC_TTPersonalMoudleBridge
//
//  Created by KevinWang on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCMediator.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCMediator (TTPersonalMoudleBridge)

/**
 兔兔 我的
 
 @return 我的页面
 */
- (UIViewController *)ttPersonalModule_MineView;


/**
 兔兔 个人主页
 
 @return 个人主页
 */
- (UIViewController *)ttPersonalModule_personalViewController:(long long)uid;



/**
 兔兔 充值
 
 @return 充值页面
 */
- (UIViewController *)ttPersonalModule_rechargeController;


/**
 兔兔 红包提现页面
 */
- (UIViewController *)ttPersonalModule_redDrawalsViewController;

/** 账单列表记录
 
 @param type 与 TTBillListViewType 枚举对应
 */
- (UIViewController *)ttPersonalModule_billListViewController:(NSUInteger)type;


/**
 兔兔 设置支付密码
 @param userInfo 提现资料字典，参考 userInfo
 @return 设置支付密码页面
 */
- (UIViewController *)ttPersonalModule_setPWViewController:(BOOL)isResetPay isPayment:(BOOL)isPayment userInfo:(NSDictionary *)userInfo;

/**
 兔兔 绑定提现账号
 @param bindXCZAccountType 绑定类型, 与 TTBindXCZAccountType 对应
 @param userInfo 用户资料字典，参考 UserInfo
 @param zxcInfo 提现资料字典，参考 ZXCInfo
 @return 绑定提现账号页面
 */
- (UIViewController *)ttPersonalModule_bindingXCZViewController:(int)bindXCZAccountType userInfo:(NSDictionary *)userInfo zxcInfo:(NSDictionary *)zxcInfo;

/**
 兔兔 推荐位
 
 @return 推荐位页面
 */- (UIViewController *)ttPersonalModule_openMyRecommendCardViewController;

/**
 兔兔 提现页面
 */
- (UIViewController *)ttPersonalModule_drawalsViewController;
/** 我的钻石 */
- (UIViewController *)ttPersonalModule_diamondViewController;
/** 我的金币 */
- (UIViewController *)ttPersonalModule_goldCoinController;
/**
 
 兔兔 装扮商城
 
 @param uid 用户uid
 @param index  0.头饰  1 座驾
 @return 装扮商城
 */
- (UIViewController *)ttPersonalModule_DressUpShopViewControllerWithUid:(long long)uid index:(int)index;


/**
 兔兔 我的装扮
 
 @param index  0. 头饰  1. 车库
 @return 我的装扮
 */
- (UIViewController *)ttPersonalModule_MyDressUpController:(int)index;

/**
 绑定手机界面
 
 - TTBindingPhoneNumTypeUndefined: 未知状态, 没有主动传入类型
 - TTBindingPhoneNumTypeNormal: 普通状态，首次绑定
 - TTBindingPhoneNumTypeEdit: 编辑状态，已绑定过
 - TTBindingPhoneNumTypeConfirm : 验证状态：验证已绑定的手机
 
 TTBindingPhoneNumTypeUndefined = -1,
 TTBindingPhoneNumTypeNormal = 0,
 TTBindingPhoneNumTypeEdit = 1,
 TTBindingPhoneNumTypeConfirm = 2,
 
 @param type 绑定类型
 @param userInfo 用户资料字典
 @return 绑定手机控制器
 */
- (UIViewController *)ttPersonalModule_BindingPhoneController:(int)type userInfo:(NSDictionary *)userInfo;

/**
 公会 群聊
 
 @param sessionId 云信id
 @return 群聊页面
 */
- (UIViewController *)ttPersonalModule_TTGuildGroupSessionViewControllerWithSessionId:(NSString *)sessionId;

/**
 公会 首页
 
 @return 公会首页控制器
 */
- (UIViewController *)ttPersonalModule_TTGuildViewController;

/**
 编辑个人资料
 
 @return 编辑个人资料控制器
 */
- (UIViewController *)ttPersonalModule_TTPersonEditViewController;

/// 青少年模式
- (UIViewController *)ttPersonalModule_TTParentModelViewController;

/// 反馈
- (UIViewController *)ttPersonalModule_TTFeedbackViewController;

/// 反馈
/// @param source 反馈来源，1-设置页，2-转盘活动，3-房间红包
- (UIViewController *)ttPersonalModule_TTFeedbackViewControllerWithSource:(NSInteger)source;

@end

NS_ASSUME_NONNULL_END
