//
//  HomeV5Category.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  游戏首页 v5 分类

#import "BaseObject.h"
#import "BannerInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeV5CategoryDetailListItem : BaseObject<NSCoding>
@property (nonatomic, copy) NSString *cid;//convert from id
/*
 * 更多菜单栏标签
 */
@property (nonatomic, copy) NSString *name;
/*
 * 更多菜单栏标签类型 1 是男神，2 是女神，3 是男神女神
 */
@property (nonatomic, copy) NSString *type;

@end

@interface HomeV5CategoryDetail : BaseObject

///接口规定此三字段的内容与 opts 数组是二选一的，当这三个字段有值表示：分类没有子类
@property (nonatomic, copy) NSString *tabId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;

///当数组有值表示：分类有子类，例如【合拍男神、合拍女神】
@property (nonatomic, strong) NSArray<HomeV5CategoryDetailListItem *> *opts;

@end

@interface HomeV5Category : BaseObject
/**
 功能入口
 */
@property (nonatomic, strong) NSArray<BannerInfo *> *firstPageBannerVos;

/**
 分类
 */
@property (nonatomic, strong) NSArray<HomeV5CategoryDetail *> *allVo;

#pragma mark qingxun project
/**
 轻寻顶部 banner
 */
@property (nonatomic, strong) NSArray<BannerInfo *> *topBanners;

@end

NS_ASSUME_NONNULL_END
