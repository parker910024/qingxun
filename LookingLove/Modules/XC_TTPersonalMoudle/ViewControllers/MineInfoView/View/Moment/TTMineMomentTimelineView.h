//
//  TTMineMomentTimelineView.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/26.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  时间轴

#import <UIKit/UIKit.h>

#import "UserMoment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMineMomentTimelineView : UIView
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, assign) UserMomentType type;

@end

NS_ASSUME_NONNULL_END
