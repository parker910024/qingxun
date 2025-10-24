//
//  XCCommunityToolView.h
//  UKiss
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLDynamicModel;
//赞同
typedef NS_ENUM(NSUInteger, ToolViewActionType) {
    ToolViewActionTypeLike = 0, // 点赞
    ToolViewActionTypeComment = 1, // 评论
    ToolViewActionTypeShare = 2, // 分享
    ToolViewActionTypeMenu = 3, //菜单
};

typedef void(^ToolViewClickHandler)(ToolViewActionType type);

@protocol LTDynamicToolViewDelegate <NSObject>

///点击评论回调
- (void)communityToolClickCommentButtonCallBack;
///点击点赞/取消点赞 回调
- (void)communityToolClickLaudButtonCallBackWith:(BOOL)isLaud;
///点击了更多回调
- (void)communityToolClickMoreButtonCallBack;
// 点击了分享回调
- (void)communityToolClickShareButtonCallBack;
@end

NS_ASSUME_NONNULL_BEGIN

@interface LTDynamicToolView : UIView
@property (nonatomic, strong) LLDynamicModel *dynamicModel;
@property (nonatomic, weak) id<LTDynamicToolViewDelegate> delegate;
///是否是详情
@property (nonatomic, assign) BOOL isCommunityDetails;
@property (nonatomic, copy) ToolViewClickHandler clickHandler;
/// 点赞动画
- (void)likeButtonAnimation;
@end

NS_ASSUME_NONNULL_END
