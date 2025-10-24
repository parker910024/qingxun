//
//  TTHomeFamilyViewController.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//  家族

#import "BaseTableViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>

@interface TTHomeFamilyViewController : BaseTableViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);

@end
