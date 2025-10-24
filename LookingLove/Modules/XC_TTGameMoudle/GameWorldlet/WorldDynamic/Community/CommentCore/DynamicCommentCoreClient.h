//
//  CPBindCoreClient.h
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CTCommentReplyModel;
@protocol DynamicCommentCoreClient <NSObject>

@optional

/**请求动态评论列表*/
- (void)requestCommentListSuccess:(NSArray <CTCommentReplyModel *>*)modelList totalCount:(int)totalCount;
- (void)requestCommentListFailth:(NSString *)message;

/**评论接口*/
- (void)requestAddCommentSuccess:(CTCommentReplyModel *)commentModel;
- (void)requestAddCommentFailth:(NSString *)message;

/**删除自己的评论或自己的回复*/
- (void)requestDeleteCommentSuccessWithCommentId:(long)commentId Sender:(id)sender;
- (void)requestDeleteCommentFailth:(NSString *)message sender:(id)sender;

/**评论回复接口*/
- (void)requestReplyCommentSuccess:(CTCommentReplyModel *)commentModel;
- (void)requestReplyCommentFailth:(NSString *)message;

/**获取评论详情*/
- (void)requestCommentDetailsSuccess:(CTCommentReplyModel *)commentModel commentId:(long )commentId;
- (void)requestCommentDetailsFailth:(NSString *)message commentId:(long )commentId;;

/**请求回复列表*/
- (void)requestCommentReplyListSuccess:(NSArray <CTCommentReplyModel *>*)commentList totalCount:(int)totalCount;
- (void)requestCommentReplyListFailth:(NSString *)message;

/**举报成功*/
- (void)requestReportPushSuccessSender:(id)sender;
- (void)requestReportPushFailth:(NSString *)message sender:(id)sender;

/**获取举报的分类成功*/
- (void)requestReportGetTypeSuccessTypeList:(NSArray *)typeList Sender:(id)sender;
- (void)requestReportGetTypeFailth:(NSString *)message sender:(id)sender;
@end
