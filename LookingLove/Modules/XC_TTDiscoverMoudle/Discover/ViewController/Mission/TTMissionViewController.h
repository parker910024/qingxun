//
//  TTMessionViewController.h
//  TTPlay
//
//  Created by lee on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^MissonCompletionHandler)(void);

@interface TTMissionViewController : BaseUIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) MissonCompletionHandler missonHandler;
/** 是否是成就任务 */
@property(nonatomic, assign) BOOL isAchievement;
/** 1 是每日任务 2 是成就任务 */
@property (nonatomic, assign) NSInteger type;

/**
 更新数据
 */
- (void)updateData;

@end
NS_ASSUME_NONNULL_END
