//
//  TTUpGradeView.h
//  TuTu
//
//  Created by gzlx on 2018/11/24.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserUpGradeInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTUpGradeView : UIView
@property (nonatomic, strong) UIWindow * gradeWindow;

- (void)configttUpgradeView:(UserUpGradeInfo *)gradeInfor type:(UserUpgradeViewType)type;
@end

NS_ASSUME_NONNULL_END
