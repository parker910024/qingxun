//
//  TTMineMomentOperateView.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/26.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  操作视图-点赞、评论、分享、更多

#import <UIKit/UIKit.h>

#import "UserMoment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMineMomentOperateView : UIView

@property (nonatomic, strong) UserMoment *model;

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *moreButton;

#pragma mark - Public
/// 点赞动画
- (void)likeButtonAnimation;

@end

NS_ASSUME_NONNULL_END
