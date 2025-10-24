//
//  TTContactViewController.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/25.
//  Copyright © 2019 WJHD. All rights reserved.
//  联系人

#import "BaseUIViewController.h"
#import "ZJScrollPageView.h"
#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTContactViewController : BaseUIViewController
<
ZJScrollPageViewChildVcDelegate,
JXCategoryListContentViewDelegate
>


@end

NS_ASSUME_NONNULL_END
