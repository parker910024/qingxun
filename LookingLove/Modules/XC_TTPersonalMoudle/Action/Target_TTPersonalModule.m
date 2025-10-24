//
//  Target_TTPersonalModule.m
//  TuTu
//
//  Created by Macx on 2018/11/13.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "Target_TTPersonalModule.h"

#import "TTDressUpContainViewController.h"
#import "TTMineDressUpContainViewController.h"
#import "TTMineContainViewController.h"
#import "TTCodeRedViewController.h"
#import "TTRechargeViewController.h"
#import "TTCodeYellowViewController.h"
#import "TTGoldCoinViewController.h"
#import "TTBillListViewController.h"
#import "TTBindingPhoneViewController.h"
#import "TTBindingXCZViewController.h"
#import "TTRecommendContainViewController.h"
#import "TTSetPWViewController.h"
#import "TTPayPwdViewController.h"
#import "TTPersonEditViewController.h"
#import "TTFeedbackViewController.h"

#import "TTGuildGroupSessionViewController.h"
#import "TTGuildViewController.h"
#import "TTParentModelViewController.h"

// 轻寻 app
#import "LLPersonalViewController.h"
#import "LLMyCoinViewController.h"
#import "LLMyGiftViewController.h"
#import "LLRechargeViewController.h"

#import "UserInfo.h"
#import "ZXCInfo.h"
#import "XCMacros.h"

@implementation Target_TTPersonalModule
//我的页面
- (UIViewController *)Action_mineViewController {
    LLPersonalViewController *mineVc = [[LLPersonalViewController alloc] init];
    return mineVc;
}

- (UIViewController *)Action_personalViewController:(NSDictionary *)params {
    long long userid = [params[@"uid"] longLongValue];
    TTMineContainViewController *personal = [[TTMineContainViewController alloc] init];
    personal.userID = userid;
    if (params[@"style"]) {
        // 默认是 1， 查看他人主页
        personal.mineInfoStyle = [params[@"style"] integerValue];
    }
    return personal;
}

//充值
- (UIViewController *)Action_rechargeController {
    LLRechargeViewController *mineVc = [[LLRechargeViewController alloc] init];
    return mineVc;
}
//红包提现
- (UIViewController *)Action_redDrawalsViewController {
    TTCodeRedViewController *vc = [[TTCodeRedViewController alloc] init];
    vc.outputType = TTOutputViewTypexcRedColor;
    return vc;
    
}

- (UIViewController *)Action_BillListViewController:(NSDictionary *)params {
    NSNumber *typeObj = params[@"type"];
    TTBillListViewType type = typeObj.integerValue;
    
    TTBillListViewController *vc = [[TTBillListViewController alloc] init];
    vc.listViewType = type;
    return vc;
}

//钻石提现
- (UIViewController *)Action_drawalsViewController {
    TTCodeRedViewController *vc = [[TTCodeRedViewController alloc] init];
    vc.outputType = TTOutputViewTypexcCF;
    return vc;
    
}

- (UIViewController *)Action_diamondViewController {
    LLMyCoinViewController *vc = [[LLMyCoinViewController alloc] init];
    return vc;
}

- (UIViewController *)Action_goldCoinViewController {
    LLMyGiftViewController *vc = [[LLMyGiftViewController alloc] init];
    return vc;
}

//装扮商城
- (UIViewController *)Action_dressUpShopViewController:(NSDictionary *)params {
    int place = [params[@"place"] intValue];
    long long userid = [params[@"userID"] longLongValue];
    TTDressUpContainViewController *dressUpvc = [[TTDressUpContainViewController alloc] init];
    dressUpvc.userID = userid;
    dressUpvc.place = place;
    return dressUpvc;
}

//我的装扮
- (UIViewController *)Action_mineDressUpViewController:(NSDictionary *)params {
    int place = [params[@"place"] intValue];
    TTMineDressUpContainViewController *mineDressupVC = [[TTMineDressUpContainViewController alloc] init];
    mineDressupVC.place = place;
    return mineDressupVC;
}

- (UIViewController *)Action_BindingPhoneController:(NSDictionary *)params {
    UserInfo *info = [UserInfo modelDictionary:[params objectForKey:@"userInfo"]];
    TTBindingPhoneNumType type = [[params objectForKey:@"type"] integerValue];
    
    TTBindingPhoneViewController *vc = [[TTBindingPhoneViewController alloc]init];
    vc.bindingPhoneNumType = type;
    vc.userInfo = info;
    return vc;
}
//公会 群聊
- (UIViewController *)Action_TTGuildGroupSessionViewController:(NSDictionary *)params {
    NIMSessionType type = NIMSessionTypeTeam;
    if (!params[@"NIMSessionType"]) {
        type = NIMSessionTypeTeam;
    } else {
        type = [params[@"NIMSessionType"] integerValue];
    }
    NIMSession *session = [NIMSession session:params[@"sessionId"] type:type];
    TTGuildGroupSessionViewController *vc = [[TTGuildGroupSessionViewController alloc] initWithSession:session];
    return vc;
}

//公会 首页
- (UIViewController *)Action_TTGuildViewController {
    TTGuildViewController *vc = [[TTGuildViewController alloc] init];
    return vc;
}

// 设置支付密码
- (UIViewController *)Action_TTSetPWViewController:(NSDictionary *)params {
    UserInfo *userInfo = [UserInfo modelDictionary:[params objectForKey:@"userInfo"]];
    BOOL isResetPay = [[params objectForKey:@"isResetPay"] boolValue];
    BOOL isPayment = [[params objectForKey:@"isPayment"] boolValue];

    if (isPayment && !isResetPay) {
        //首次设置支付密码
        TTPayPwdViewController *vc = [[TTPayPwdViewController alloc] init];
        return vc;
    }
    
    TTSetPWViewController *vc = [[TTSetPWViewController alloc]init];
    vc.info = userInfo;
    vc.isResetPay = isResetPay;
    vc.isPayment = isPayment;
    return vc;
}

// 推荐位
- (UIViewController *)Action_TTRecommendContainViewController {
    return [[TTRecommendContainViewController alloc] init];
}

// 绑定提现账号
- (UIViewController *)Action_TTBindingXCZViewController:(NSDictionary *)params {
    UserInfo *userInfo = [UserInfo modelDictionary:[params objectForKey:@"userInfo"]];
    ZXCInfo *zxcInfo = [ZXCInfo modelDictionary:[params objectForKey:@"zxcInfo"]];
    NSInteger type = [[params objectForKey:@"bindXCZAccountType"] integerValue];
    
    TTBindingXCZViewController *vc = [[TTBindingXCZViewController alloc]init];
    vc.userInfo = userInfo;
    vc.zxcInfo = zxcInfo;
    vc.bindXCZAccountType = type;
    return vc;
}

// 编辑个人资料
- (UIViewController *)Action_TTPersonEditViewController {
    TTPersonEditViewController *vc = [[TTPersonEditViewController alloc] init];
    return vc;
}

- (UIViewController *)Action_TTParentModelViewController {
    TTParentModelViewController *vc = [[TTParentModelViewController alloc] init];
    return vc;
}

- (UIViewController *)Action_TTFeedbackViewController {
    TTFeedbackViewController *vc = [[TTFeedbackViewController alloc] init];
    return vc;
}

/// 反馈
/// @param params @"source" 反馈来源，1-设置页，2-转盘活动，3-房间红包，其他值-未知来源
- (UIViewController *)Action_TTFeedbackViewControllerWithSource:(NSDictionary *)params {
    
    TTFeedbackViewController *vc = [[TTFeedbackViewController alloc] init];
    
    NSInteger source = [[params valueForKey:@"source"] integerValue];
    if (source == 1) {
        vc.souce = TTFeedbackSouceSetting;
    } else if (source == 2) {
        vc.souce = TTFeedbackSouceDraw;
    } else if (source == 3) {
        vc.souce = TTFeedbackSouceRoomRed;
    }
    
    return vc;
}

@end
