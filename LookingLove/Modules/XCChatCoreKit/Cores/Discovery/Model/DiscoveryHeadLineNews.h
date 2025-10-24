//
//  DiscoveryHeadLineNews.h
//  XCChatCoreKit
//
//  Created by lee on 2019/3/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiscoveryHeadLineNews : BaseObject

/// Headline头条模块-8 数据
@property (nonatomic, assign) NSInteger _id;//Convert from id
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *param;
@property (nonatomic, assign) NSInteger tipType;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger paramType;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger topLineType;

@end

NS_ASSUME_NONNULL_END
