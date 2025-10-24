//
//  LTDynamicDetailVC.h
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//  动态详情

#import "BaseUIViewController.h"
@class CTDynamicModel, CTCommentReplyModel, LittleWorldListItem, CTReplyModel;

NS_ASSUME_NONNULL_BEGIN

@interface LTDynamicDetailVC : BaseUIViewController
///动态id
@property (nonatomic, assign) NSInteger dynamicId;
// 所在的小世界 id
@property (nonatomic, copy) NSString *worldId;
// 所在的小世界资料
@property (nonatomic, strong) LittleWorldListItem *worldItem;
///是否弹出键盘
@property (nonatomic, assign) BOOL isShowKeyboard;
///动态更新回调
@property (nonatomic, copy) void (^dynamicChangeCallBack)(CTDynamicModel *newDynamic);
///回复谁的评论  回复谁的回复 等待被删 模型
@property (nonatomic, strong , nullable) CTCommentReplyModel *commentModel;

///当前评论属于tabbleView的第几组
@property (nonatomic, assign) NSInteger changeSection;

@end

NS_ASSUME_NONNULL_END
