//
//  LTDynamicCommentsView.h
//  LTChat
//
//  Created by apple on 2019/10/22.
//  Copyright © 2019 wujie. All rights reserved.
//  社区评论view

#import <UIKit/UIKit.h>
@class CTCommentReplyModel;
@class LTDynamicCommentsView;

@protocol LTDynamicCommentsViewDelegate <NSObject>

///跳转到动态详情 coment有值就是回复某个评论 没值就是直接查看详情
- (void)jumpDynamicDetailsWithReplyComment:(CTCommentReplyModel*)comment commentsView:(LTDynamicCommentsView *)commentsView;

///点击名称跳转到个人详情
- (void)jumpUserDetailsWithComment:(CTCommentReplyModel*)comment commentsView:(LTDynamicCommentsView *)commentsView;

@end


@interface LTDynamicCommentsView : UIView

@property (nonatomic, weak) id<LTDynamicCommentsViewDelegate> delegate;

///获取高度 评论总个数
- (CGFloat)getCacheHeightWithData:(NSArray *)commentVoList commentCount:(NSInteger)count;

@end
