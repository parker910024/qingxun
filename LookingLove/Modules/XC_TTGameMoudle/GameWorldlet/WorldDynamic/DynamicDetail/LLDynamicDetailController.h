//
//  LLDynamicDetailController.h
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/12/14.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

@class CTDynamicModel, CTCommentReplyModel, LittleWorldListItem, CTReplyModel,LLDynamicModel;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DynamicRefreshDataType) {
    DynamicRefreshDataTypeDelete = 0, // 删除
    DynamicRefreshDataTypeReload = 1, // 刷新
};

@interface LLDynamicDetailController : BaseUIViewController

///动态id
@property (nonatomic, assign) NSInteger dynamicId;
// 所在的小世界 id
@property (nonatomic, copy) NSString *worldId;
// 小世界uid
@property (nonatomic, copy) NSString *worldUid;
///是否弹出键盘
@property (nonatomic, assign) BOOL isShowKeyboard;
///动态更新回调
@property (nonatomic, copy) void (^dynamicChangeCallBack)(LLDynamicModel *newDynamic, DynamicRefreshDataType type);
///回复谁的评论  回复谁的回复 等待被删 模型
@property (nonatomic, strong , nullable) CTCommentReplyModel *commentModel;

///当前评论属于tabbleView的第几组
@property (nonatomic, assign) NSInteger changeSection;
// 判断是否是从小世界进来的动态
@property (nonatomic, assign) BOOL isWorldDynamic;

@end

NS_ASSUME_NONNULL_END
