//
//  TTDiscoverHeaderView.h
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDiscoverHeaderView : UIView<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * cycleView;
/** 配置bannders*/
- (void)configTTDiscoverHeaderView:(NSArray *)bannders;
@property (nonatomic, strong) NSArray * banners;
@property (nonatomic, weak) UIViewController * currentVC;
@end

NS_ASSUME_NONNULL_END
