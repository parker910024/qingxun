//
//  TTDiscoverViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTDiscoverViewController : BaseCollectionViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);
@end

NS_ASSUME_NONNULL_END
