//
//  LLVoicePartyViewController.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import <JXPagingView/JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLVoicePartyViewController : BaseCollectionViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, copy) NSString *tabId;
@end

NS_ASSUME_NONNULL_END
