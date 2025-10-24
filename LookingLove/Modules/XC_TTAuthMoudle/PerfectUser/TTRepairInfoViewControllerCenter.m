//
//  TTRepairInfoViewControllerCenter.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTRepairInfoViewControllerCenter.h"

#import "TTPerfectUserViewController.h"
#import "TTFullinUserViewController.h"

#import "UserCoreClient.h"
#import "UserCore.h"

#import "BaseNavigationController.h"
#import "XCCurrentVCStackManager.h"

@interface TTRepairInfoViewControllerCenter ()<UserCoreClient>

@end

@implementation TTRepairInfoViewControllerCenter
+ (instancetype)defaultCenter {
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AddCoreClient(UserCoreClient, self);
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)toComplete {
    if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:[TTFullinUserViewController class]]) {
        return;
    }
    BaseNavigationController * vc = [[BaseNavigationController alloc] initWithRootViewController:[[TTFullinUserViewController alloc] init]];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [[[XCCurrentVCStackManager shareManager] getCurrentVC] presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UserCoreClient
- (void)onCurrentUserInfoNeedComplete:(UserID)uid
{
    [self toComplete];
}
@end
