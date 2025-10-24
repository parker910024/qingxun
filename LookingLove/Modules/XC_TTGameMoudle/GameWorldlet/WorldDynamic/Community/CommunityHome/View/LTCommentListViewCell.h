//
//  LTCommentListViewCell.h
//  UKiss
//
//  Created by apple on 2018/12/6.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeartCommentInfo.h"

NS_ASSUME_NONNULL_BEGIN
@class LTCommentListViewCell;

@protocol LTCommentListViewCellDelegate <NSObject>

- (void)onTapDynamic:(LTCommentListViewCell *)cell;
- (void)onTapAvart:(LTCommentListViewCell *)cell;
@end

@interface LTCommentListViewCell : UITableViewCell
//@property (nonatomic, assign) HeadMessageType type;//类型 0, 评论 1，点赞
@property (nonatomic,strong) HeartCommentInfo * info;
@property (nonatomic,weak) id<LTCommentListViewCellDelegate> delegate;

+ (CGFloat)cellHeight:(HeartCommentInfo*)info;

@end

NS_ASSUME_NONNULL_END
