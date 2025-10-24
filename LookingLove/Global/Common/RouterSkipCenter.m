//
//  RouterSkipCenter.m
//  LookingLove
//
//  Created by apple on 2020/12/11.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "RouterSkipCenter.h"

#import "TTWKWebViewViewController.h"

#import "XCMediator+TTHomeMoudle.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"

#import "XCCurrentVCStackManager.h"

#import "UserCore.h"
#import "AuthCore.h"

@implementation RouterSkipCenter

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static RouterSkipCenter *sharedInstance;
    dispatch_once(&once, ^{
        if (sharedInstance == NULL) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

- (void)handleRouterType:(P2PInteractive_SkipType)routerType value:(id)routerValue {
    
    switch (routerType) {
        case P2PInteractive_SkipType_Room:
        {
            if (!routerValue) {
                return;
            }
            
            NSString *roomUid = [NSString stringWithFormat:@"%@", routerValue];
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:roomUid.userIDValue];
        }
            break;
        case P2PInteractive_SkipType_H5:
        {
            TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
            web.url = [NSURL URLWithString:routerValue];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:web animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Purse:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_goldCoinController];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Red:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_redDrawalsViewController];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Recharge:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Person:
        {
            if (!routerValue) {
                return;
            }
            
            NSString *uid = [NSString stringWithFormat:@"%@", routerValue];
            
            UIViewController *vc = [[XCMediator  sharedInstance] ttPersonalModule_personalViewController:uid.userIDValue];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Car:
        {
            if ([routerValue integerValue] == 0) {
                //商城- 座驾
                UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_DressUpShopViewControllerWithUid:0 index:0];
                [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
            } else {
                //我的装扮 - 座驾
                UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:0];
                [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case P2PInteractive_SkipType_Headwear:
        {
            if ([routerValue integerValue] == 0) {
                //商城-头饰
                UIViewController *vc = [[XCMediator  sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:0 index:1];
                [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
            } else {
                //我的装扮-头饰
                UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:1];
                [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case P2PInteractive_SkipType_Background:
        {
            if ([routerValue integerValue] == 0) {
                //商城-背景
                UIViewController *vc = [[XCMediator  sharedInstance] ttPersonalModule_DressUpShopViewControllerWithUid:0 index:2];
                [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
            } else {
                //我的装扮-背景
                UIViewController *vc = [[XCMediator sharedInstance]  ttPersonalModule_MyDressUpController:2];
                [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case P2PInteractive_SkipType_PublicChat:
        {
            UIViewController *vc = [[XCMediator sharedInstance] TTMessageMoudle_HeadLineViewContoller:1];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_BindingXCZAccount:
        {
            int bindXCZAccountType = 0;
            if ([routerValue integerValue] == 1) {
                bindXCZAccountType = 1;
            } else if ([routerValue integerValue] == 0) {
                bindXCZAccountType = 0;
            }
            
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_bindingXCZViewController:bindXCZAccountType userInfo:@{} zxcInfo:@{}];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_BindingPhoneNum:
        {
            UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
            // 此处任务是绑定 所以传入0
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_BindingPhoneController:0 userInfo:[info model2dictionary]];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Recommend:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_openMyRecommendCardViewController];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Checkin:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTCheckinViewController];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Mission:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_UpLoad_VoiceMatching:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTVoiceMatchingViewController];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_LittleWorld:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTWorldSquareViewController];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_LittleWorldGuestPage:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:routerValue isFromRoom:NO];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_LittleWorldPostDynamic:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_LLPostDynamicViewControllerWithRefresh:nil];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Nameplate:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:2];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
