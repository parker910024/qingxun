//
//  XCCommentTipTextCell.h
//  UKiss
//
//  Created by apple on 2018/12/8.
//  Copyright © 2018 yizhuan. All rights reserved.
//  提示长按删除cell

#import <UIKit/UIKit.h>
//第一次显示
static NSString *isNotFirstShowCommunityDetails = @"isNotFirstShowCommunityDetails";

@protocol XCCommentTipTextCellDelegate <NSObject>

- (void)deleteCommentTipTextCellCallBack;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XCCommentTipTextCell : UITableViewCell

@property (nonatomic, weak) id<XCCommentTipTextCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
