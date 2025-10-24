//
//  TTMineInfoViewController.h
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TTMineInfoEnumConst.h"
#import <JXPagingView/JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@class UserInfo;

@protocol TTMineInfoViewVCDelegate <NSObject>
// 个人信息发生变化，刷新头部视图
- (void)refreshTableViewHeaderWithUserInfo:(UserInfo *)info;

@end

@interface TTMineInfoViewController : BaseUIViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, assign) long long userID;
@property (nonatomic, assign) TTMineInfoViewStyle mineInfoStyle;

@property (nonatomic, weak) id<TTMineInfoViewVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
