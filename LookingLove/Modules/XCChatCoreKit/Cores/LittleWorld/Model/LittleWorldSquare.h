//
//  LittleWorldSquare.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  世界广场

#import "BaseObject.h"
#import "BannerInfo.h"
#import "LittleWorldListModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LittleWorldSquareClassify;

@interface LittleWorldSquare : BaseObject
@property (nonatomic, strong) NSArray<BannerInfo *> *banners;
@property (nonatomic, strong) NSArray<LittleWorldSquareClassify *> *types;

@end

@interface LittleWorldSquareClassify : BaseObject
@property (nonatomic, copy) NSString *typeId;//convert from id
@property (nonatomic, copy) NSString *typeName;//小世界类型名
@property (nonatomic, strong) NSArray<LittleWorldListItem *> *worlds;

@end

NS_ASSUME_NONNULL_END
