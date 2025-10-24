//
//  LTDynamicCell.h
//  UKiss
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTDynamicCell;
@class CTCommentReplyModel;
@class CTDynamicModel;

typedef void(^refreshCellOpenUpBlock)(CTDynamicModel *dynamicModel);

static NSString *LTDynamicCellIdentifier = @"LTDynamicCell";

@protocol LTDynamicCellDelegate <NSObject>
@optional
///刷新当前cell
- (void)refreshMyVestDynamicCell:(LTDynamicCell *)cell;
///点赞/取消点赞
- (void)myVestDynamicCell:(LTDynamicCell *)cell clickLaudButtonCallBackWith:(BOOL)isLaud;
///点击评论
- (void)didClickCommentButtonWithMyVestDynamicCell:(LTDynamicCell *)cell;
// 点击分享
- (void)didClickShareButtonWithMyVestDynamicCell:(LTDynamicCell *)cell;
///点击声音气泡
- (void)myVestDynamicCell:(LTDynamicCell *)cell tapVoiceImageActionWithIsPlaying:(BOOL)isPlaying;
///点击头像、昵称
- (void)didClickUserActionWithUserUid:(NSString *)uid communityCell:(LTDynamicCell *)cell;
///点击视频
- (void)didClickVideoCell:(LTDynamicCell *)cell;
///举报删除动态
- (void)didClickMoreButtonDynamicCell:(LTDynamicCell *)cell;
///跳转到动态详情 coment有值回复某个人 没值就代表直接查看详情
- (void)jumpDynamicDetailsWithReplyComment:(CTCommentReplyModel*)comment communityCell:(LTDynamicCell *)cell;
///点击主播订单
- (void)didClickAnchorOrderDynamicCell:(LTDynamicCell *)cell;
///点击主播订单问号
- (void)didClickAnchorOrderMarkDynamicCell:(LTDynamicCell *)cell;
@end

@interface LTDynamicCell : UITableViewCell

///动态模型
@property (nonatomic, strong) CTDynamicModel *dynamicModel;

@property (nonatomic, weak) id<LTDynamicCellDelegate> delegate;
///是否是广场
@property (nonatomic, assign) BOOL isDetailVc;

//more
@property (nonatomic, strong, readonly) UIButton *moreBtn;

@property (nonatomic, copy) refreshCellOpenUpBlock refreshOpenUpHandler;

@property (nonatomic, copy) void (^albumEmptyAreaHandler)(void);//相册空白处

- (void)updateLikeButtonStatus;

@end
