//
//  LTDetailCommentView.h
//  LTChat
//
//  Created by apple on 2019/10/24.
//  Copyright © 2019 wujie. All rights reserved.
//  动态详情头部view

#import <UIKit/UIKit.h>
@class LTDetailCommentView;
@class CTCommentReplyModel;

@protocol LTDetailCommentViewDelegate <NSObject>

@optional
///点击名称跳转到个人详情
- (void)jumpUserDetailsWithDetailCommentView:(LTDetailCommentView *)commentView;
///点击删除评论回调
- (void)deleteCommentWithDetailCommentView:(LTDetailCommentView *)commentView;
///回复某条评论
- (void)replyCommentActionWithDetailCommentView:(LTDetailCommentView *)commentView;
/// 举报某条评论
- (void)reportCommentWithDetailCommentView:(LTDetailCommentView *)commentView;
@end

@interface LTDetailCommentView : UIView

@property (nonatomic, weak) id<LTDetailCommentViewDelegate> delegate;
///评论数据
@property (nonatomic, strong) CTCommentReplyModel *commentReplyModel;

@property (nonatomic, copy) NSString *littleWorldOwerUid; // 小世界归属人uid

@end

