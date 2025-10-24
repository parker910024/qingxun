//
//  TTCarDressUpViewController.h
//  TuTu
//
//  Created by lee on 2018/11/19.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TTMineInfoEnumConst.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface TTCarDressUpViewController : BaseUIViewController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) TTMineInfoViewStyle mineInfoStyle;
@property (nonatomic, assign) long long userID;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
