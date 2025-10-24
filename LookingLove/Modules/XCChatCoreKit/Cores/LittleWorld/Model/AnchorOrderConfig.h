//
//  AnchorOrderConfig.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/4/27.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@class AnchorOrderConfigPrice, AnchorOrderConfigDuration;

@interface AnchorOrderConfig : BaseObject
@property (nonatomic, strong) NSArray<NSString *> *typeList;
@property (nonatomic, strong) NSArray<NSString *> *validTimeList;
@property (nonatomic, strong) AnchorOrderConfigPrice *price;
@property (nonatomic, strong) AnchorOrderConfigDuration *duration;
@end

@interface AnchorOrderConfigPrice : BaseObject
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;
@end

@interface AnchorOrderConfigDuration : BaseObject
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;
@end

NS_ASSUME_NONNULL_END
