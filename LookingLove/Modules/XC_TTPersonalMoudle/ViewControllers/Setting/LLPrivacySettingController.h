//
//  LLPrivacySettingController.h
//  XC_TTPersonalMoudle
//
//  Created by Lee on 2019/12/23.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@class UserInfo;
@interface LLPrivacySettingController : BaseTableViewController
@property (nonatomic, strong) UserInfo *currentUserInfo;
@end

NS_ASSUME_NONNULL_END
