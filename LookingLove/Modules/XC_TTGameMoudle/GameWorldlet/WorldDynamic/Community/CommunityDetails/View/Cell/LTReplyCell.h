//
//  LTReplyCell.h
//  LTChat
//
//  Created by apple on 2019/10/28.
//  Copyright © 2019 wujie. All rights reserved.
//  回复cell

#import <UIKit/UIKit.h>
#import "CTCommentReplyModel.h"
@class LTReplyCell, CTReplyModel;

static NSString *LTReplyCellIdentifier = @"LTReplyCellIdentifier";

@protocol LTReplyCellDelegate <NSObject>

///点击名称跳转到个人详情  
- (void)jumpReplyUserDetailsWithCell:(LTReplyCell *)cell userUid:(NSString *)uid;
///删除回复
- (void)deleteReplyWithReplyCell:(LTReplyCell *)cell;
// 举报回复
- (void)reportReplyWithReplyCell:(LTReplyCell *)cell;

@end

@interface LTReplyCell : UITableViewCell
///回复数据
@property (nonatomic, strong) CTReplyModel *replyModel;
///当前的indexpath  在replyModel后赋值
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<LTReplyCellDelegate> delegate;
/// 小世界归属人uid 
@property (nonatomic, copy) NSString *littleWorldOwerUid;
///显示删除
- (void)showMoreDeleteView;

@end

