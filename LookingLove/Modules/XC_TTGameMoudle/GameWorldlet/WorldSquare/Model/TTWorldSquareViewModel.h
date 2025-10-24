//
//  TTWorldSquareViewModel.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LittleWorldSquare.h"

NS_ASSUME_NONNULL_BEGIN

@class BannerInfo;
@class LittleWorldSquare;

@interface TTWorldSquareViewModel : NSObject

/**
 banner 数据源
 */
@property (nonatomic, strong, readonly) NSArray<BannerInfo *> *bannerArray;

/**
 是否初始化世界广场接口数据模型
 */
@property (nonatomic, assign, readonly, getter=isDataModelInitailize) BOOL dataModelInitialize;

/**
 更新世界广场接口模型
 */
- (void)updateDataModel:(nullable LittleWorldSquare *)dataModel;

/**
 判断索引是否为 banner
 */
- (BOOL)isBannerIndexPath:(NSIndexPath *)indexPath;

/**
 判断 indexPath 是否为’发现新世界入口‘，我加入的第一个cell
 */
- (BOOL)isFindNewWorldEntrance:(NSIndexPath *)indexPath;

/**
 获取分组数量，banner + littleWorld.section
 */
- (NSInteger)numberOfSections;

/**
 获取分组行数
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/**
 根据索引获取分组模型
 */
- (LittleWorldSquareClassify *)classifyInfoForIndexPath:(NSIndexPath *)indexPath;

/**
 根据索引获取数据模型
 */
- (LittleWorldListItem *)dataForIndexPath:(NSIndexPath *)indexPath;

/**
 根据索引获取 cell 大小
 */
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END


