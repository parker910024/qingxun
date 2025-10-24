//
//  LTCommentCell.h
//  UKiss
//
//  Created by apple on 2018/12/7.
//  Copyright © 2018 yizhuan. All rights reserved.
//  社区首页评论cell

#import <UIKit/UIKit.h>
#import "M80AttributedLabel+NIMKit.h"
@class CTCommentReplyModel;
@class LTCommentCell;


@protocol LTCommentCellDelegate <NSObject>

@optional
///点击名称跳转到个人详情
- (void)jumpUserDetailsWithCell:(LTCommentCell *)cell;

@end

static NSString *LTCommentCellIdentifier = @"LTCommentCellIdentifier";

@interface LTCommentCell : UITableViewCell

//文本内容
@property (nonatomic, strong) M80AttributedLabel *contentLab;

@property (nonatomic, strong) CTCommentReplyModel *commentReplyModel;


@property (nonatomic, weak) id<LTCommentCellDelegate> delegate;


@end
