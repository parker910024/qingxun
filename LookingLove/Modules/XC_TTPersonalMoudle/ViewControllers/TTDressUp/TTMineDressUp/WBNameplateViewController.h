//
//  WBNameplateViewController.h
//  WanBan
//
//  Created by ShenJun_Mac on 2020/9/4.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "UserCoreClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBNameplateViewController : BaseCollectionViewController<ZJScrollPageViewChildVcDelegate,UserCoreClient>

@end

NS_ASSUME_NONNULL_END
