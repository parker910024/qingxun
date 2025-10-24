//
//  LLDiscoverBannerTableViewCell.h
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/26.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface LLDiscoverBannerTableViewCell : UITableViewCell<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView * cycleView;
/** 配置bannders*/
- (void)configTTDiscoverHeaderView:(NSArray *)bannders;
@property (nonatomic, strong) NSArray * banners;
@property (nonatomic, weak) UIViewController * currentVC;
@end

NS_ASSUME_NONNULL_END
