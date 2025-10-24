//
//  LLGameHomeContainerViewController.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

#import <TYAlertController/TYAlertController.h>
#import "TTPopup.h"

#import "TTCheckinAlertView.h"
#import "LLTeenagerModelAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLGameHomeContainerViewController : BaseUIViewController

@property (nonatomic, strong) TTCheckinAlertView *checkinView;//签到
@property (nonatomic, strong) LLTeenagerModelAlertView *teenagerView; // 青少年模式弹窗
- (void)reloadDataWhenLoadFail;
@end

NS_ASSUME_NONNULL_END
