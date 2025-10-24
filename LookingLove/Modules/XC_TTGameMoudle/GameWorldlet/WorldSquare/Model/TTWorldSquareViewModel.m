//
//  TTWorldSquareViewModel.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldSquareViewModel.h"

#import "TTWorldSquareBannerCell.h"

#import "TTWorldletConst.h"

#import "HomeV5CategoryRoom.h"

#import "XCMacros.h"
#import "NSArray+Safe.h"

//列数
static NSInteger const kCellColumn = 3;
//cell除了封面图片的额外高度
static CGFloat const kCellAdditionalHeight = 68.0f;
//cell之间间隔
static CGFloat const kCellInterval = 8.0f;

@interface TTWorldSquareViewModel ()

/**
 世界广场接口数据模型
 */
@property (nonatomic, strong, readwrite) LittleWorldSquare *dataModel;

@end

@implementation TTWorldSquareViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - public method
/**
 更新世界广场接口模型
 */
- (void)updateDataModel:(nullable LittleWorldSquare *)dataModel {
    
    //’我加入的‘第一个位置插入假数据，发现新世界
    for (LittleWorldSquareClassify *classify in dataModel.types) {
        if ([classify.typeId isEqualToString:TTWorldletMyJoinedWorldTypeId]) {
            LittleWorldListItem *firstWorld = [classify.worlds firstObject];
            if (firstWorld.worldId != nil) {
                NSMutableArray *worlds = [classify.worlds mutableCopy];
                [worlds insertObject:[LittleWorldListItem new] atIndex:0];
                classify.worlds = [worlds copy];
                break;
            }
        }
    }
    
    self.dataModel = dataModel;
}

/**
 判断 indexPath 是否为 banner，规定第i一组为 banner，如果没有，设置高度为 0 隐藏
 */
- (BOOL)isBannerIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}

/**
 判断 indexPath 是否为’发现新世界入口‘，我加入的第一个cell
 */
- (BOOL)isFindNewWorldEntrance:(NSIndexPath *)indexPath {
    
    LittleWorldSquareClassify *classify = [self classifyInfoForIndexPath:indexPath];
    if (classify == nil) {
        return NO;
    }
    
    if ([classify.typeId isEqualToString:TTWorldletMyJoinedWorldTypeId]) {
        if (indexPath.item == 0) {
            return YES;
        }
    }
    
    return NO;
}

/**
 获取分组数量，banner + littleWorld.section
 */
- (NSInteger)numberOfSections {
    return self.dataModel.types.count + 1;
}

/**
 获取分组行数
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    
    //第一分组默认为 banner，如果没有 banner，设置其高度为 0，隐藏处理
    if (section == 0) {
        return 1;
    }
    
    LittleWorldSquareClassify *classify = [self classifyInfoForIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];

    NSInteger rows = [classify.worlds count];
    
    //如果小世界数量最后一排未满，用’虚位以待‘填充
//    if (rows % 3 == 1) {
//        rows += 2;
//    } else if (rows % 3 == 2) {
//        rows += 1;
//    }
    
    return rows;
}

/**
 根据索引获取分组模型
 */
- (LittleWorldSquareClassify *)classifyInfoForIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isBannerIndexPath:indexPath]) {
        NSAssert(NO, @"banner section, fetch data from self.bannerArray");
        return nil;
    }
    
    LittleWorldSquareClassify *data = [self.dataModel.types safeObjectAtIndex:indexPath.section-1];
    
    if (![data isKindOfClass:[LittleWorldSquareClassify class]]) {
        data = nil;
    }
    
    return data;
}

/**
 根据索引获取数据模型
 */
- (LittleWorldListItem *)dataForIndexPath:(NSIndexPath *)indexPath {
    
    LittleWorldSquareClassify *classify = [self classifyInfoForIndexPath:indexPath];
    if (classify == nil) {
        return nil;
    }
    
    LittleWorldListItem *data = [classify.worlds safeObjectAtIndex:indexPath.item];
    return data;
}

/**
 根据索引获取 cell 大小
 */
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isBannerIndexPath:indexPath]) {
        return [self bannerCellSize];
    }
    
    return [self worldCellSize];
}

#pragma mark - private method
/**
 banner大小
 */
- (CGSize)bannerCellSize {
    
    if (![self isExistBanner]) {
        // 不可设置为 CGSizeZero，或高度设置为 CGFLOAT_MIN
        // 否则出现显示不出来 bug
        return CGSizeMake(KScreenWidth - 15 * 2, 0.001);
    }
    
    CGFloat bannerWidth = (KScreenWidth - 15 * 2);
    CGFloat bannerHeight = bannerWidth * TTWorldSquareBannerCellBannerAspectRatio;
    CGFloat margin = TTWorldSquareBannerCellTopMargin + TTWorldSquareBannerCellBottomMargin;
    return CGSizeMake(bannerWidth, bannerHeight + margin);
}

/**
 小世界大小
 */
- (CGSize)worldCellSize {
    
    CGFloat cellWidth = (KScreenWidth - 10 * 2 - kCellInterval * (kCellColumn - 1)) / kCellColumn;
    CGFloat coverHoriMargin = 5;//封面图水平边距
    CGFloat coverTopMargin = 5;//顶部边距
    CGFloat cellHeight = cellWidth - coverHoriMargin*2 + coverTopMargin + kCellAdditionalHeight;
    
    return CGSizeMake(cellWidth, cellHeight);
}

/**
 是否存在 banner
 */
- (BOOL)isExistBanner {
    return [self.bannerArray count] > 0;
}

#pragma mark - Setter Getter
- (NSArray<BannerInfo *> *)bannerArray {
    return self.dataModel.banners ?: @[];
}

- (BOOL)isDataModelInitailize {
    return self.dataModel != nil;
}

@end


