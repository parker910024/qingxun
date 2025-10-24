//
//  TTGameRoomContributionContainerView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  房间中房间榜视图展开时存放的容器

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomContributionContainerView : UIView

/**
 遮罩被点击时，事件回传
 */
@property (nonatomic, copy) void(^maskViewTapActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
