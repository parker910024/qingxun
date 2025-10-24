//
//  TTMineMomentCell.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/25.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserMoment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMineMomentCell : UITableViewCell

@property (nonatomic, strong) UserMoment *model;

@property (nonatomic, assign) BOOL hidenTimelineView;//是否隐藏时间线

@property (nonatomic, copy) void (^worldBlock)(void);//小世界名称事件
@property (nonatomic, copy) void (^likeBlock)(void);//点赞事件
@property (nonatomic, copy) void (^commentBlock)(void);//评论事件
@property (nonatomic, copy) void (^shareBlock)(void);//分享事件
@property (nonatomic, copy) void (^moreBlock)(void);//更多事件
@property (nonatomic, copy) void (^foldBlock)(void);//展开收起事件

@property (nonatomic, copy) void(^tapAnchorOrderHandler)(void);//点击主播订单交互

/// 更新点赞按钮状态
- (void)updateLikeButtonStatus;

@end

NS_ASSUME_NONNULL_END
