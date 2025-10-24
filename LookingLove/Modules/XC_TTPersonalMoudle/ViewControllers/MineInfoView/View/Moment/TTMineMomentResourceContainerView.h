//
//  TTMineMomentResourceContainerView.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/27.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  资源容器

#import <UIKit/UIKit.h>
#import "UserMoment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMineMomentResourceContainerView : UIView
@property (nonatomic, strong) UserMoment *model;

#pragma mark - Public
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
