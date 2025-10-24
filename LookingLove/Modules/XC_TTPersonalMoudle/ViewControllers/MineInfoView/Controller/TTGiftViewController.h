//
//  TTGiftViewController.h
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "TTMineInfoEnumConst.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface TTGiftViewController : BaseCollectionViewController<JXPagerViewListViewDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, assign) long long userID;
@property (nonatomic, assign) TTMineInfoViewStyle mineInfoStyle;
@end

NS_ASSUME_NONNULL_END
