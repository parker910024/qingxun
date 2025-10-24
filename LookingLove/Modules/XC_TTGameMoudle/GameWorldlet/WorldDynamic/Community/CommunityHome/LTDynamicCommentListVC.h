//
//  XCHeartCommentViewController.h
//  UKiss
//
//  Created by apple on 2018/12/6.
//  Copyright © 2018 yizhuan. All rights reserved.
// 比心和评论

#import "BaseTableViewController.h"
#import "UserInfo.h"

typedef void(^praisePresenterBlock)(UserInfo *info);
@interface LTDynamicCommentListVC : BaseTableViewController
@property (nonatomic, assign) int type;//类型 0, 评论 1，点赞
@property (nonatomic, copy) praisePresenterBlock  praisePresenterBlock;//
@end
