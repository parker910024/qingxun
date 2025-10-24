//
//  TTHomeRecommendViewModel.m
//  TuTu
//
//  Created by lvjunhang on 2018/12/28.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTHomeRecommendViewModel.h"
#import "TTHomeRecommendSectionHeaderView.h"

#import "TTHomeRecommendBigRoomTVCell.h"
#import "TTHomeRecommendBannerCell.h"

#import "XCMacros.h"
#import "TTHomeV4Data.h"
#import "TTHomeV4DetailData.h"

///缓存高度
static NSMutableDictionary *cellHeightCaches;

@interface TTHomeRecommendViewModel ()

@end

@implementation TTHomeRecommendViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - public method
- (BOOL)updateHotRecommend:(NSArray<TTHomeV4DetailData *> *)datas {
    if (![datas isKindOfClass:NSArray.class]) {
        return NO;
    }
    
    if (datas == nil || datas.count == 0) {
        return NO;
    }
    
    for (TTHomeV4Data *data in self.dataSourceArray) {
        if (data.type == TTHomeV4DataTypeHot) {
            NSMutableArray *mData = data.data.mutableCopy;
            [mData addObjectsFromArray:datas];
            data.data = mData.copy;
            
            return YES;
        }
    }
    
    return NO;
}

/**
 获取分组数据源
 */
- (TTHomeV4Data *)dataAtSection:(NSInteger)section {
    if (section >= self.dataSourceArray.count) {
        NSAssert(NO, @"invalid issue");
        return nil;
    }
    
    TTHomeV4Data *data = self.dataSourceArray[section];
    return data;
}

/**
 获取分组行数，一行大房间+n个小房间
 */
- (NSInteger)rowsAtSection:(NSInteger)section {
    TTHomeV4Data *data = [self dataAtSection:section];
    if (data.type == TTHomeV4DataTypeBanner) {
        return 1;
    }
    
    NSUInteger bigCount = data.type == TTHomeV4DataTypeHot ? 3 : data.maxNum;
    NSArray *smallRooms = [TTHomeRecommendViewModel smallRoomsFromDatas:data.data bigRoomCount:bigCount];
    return 1 + smallRooms.count;
}

/**
 获取大房间列表
 
 @param datas 所有数据
 @param count 大房间的个数
 */
+ (NSArray<TTHomeV4DetailData *> *)bigRoomsFromDatas:(NSArray<TTHomeV4DetailData *> *)datas bigRoomCount:(NSUInteger)count {
    
    if (count == 0) {
        return @[];
    }
    
    if (datas == nil || datas.count == 0) {
        return @[];
    }
    
    NSMutableArray *mArray = @[].mutableCopy;
    [datas enumerateObjectsUsingBlock:^(TTHomeV4DetailData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [mArray addObject:obj];
        
        if (mArray.count >= count) {
            *stop = YES;
        }
    }];
    
    return mArray.copy;
}

/**
 获取小房间列表
 
 @param datas 所有数据
 */
+ (NSArray<TTHomeV4DetailData *> *)smallRoomsFromDatas:(NSArray<TTHomeV4DetailData *> *)datas bigRoomCount:(NSUInteger)count {
    
    if (datas == nil || datas.count == 0) {
        return @[];
    }
    
    NSArray *bigRooms = [self bigRoomsFromDatas:datas bigRoomCount:count];
    if (bigRooms.count < count) {
        return @[];
    }
    
    NSArray *smallRooms = [datas subarrayWithRange:NSMakeRange(bigRooms.count, datas.count-bigRooms.count)];
    
    return smallRooms;
}

- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath {
    
    TTHomeV4Data *data = [self dataAtSection:indexPath.section];
    if (data == nil) {
        return CGFLOAT_MIN;
    }
    
    NSString *cachedKey = [NSString stringWithFormat:@"section%ld-row%ld", indexPath.section, indexPath.row];
    NSNumber *cachedHeight = cellHeightCaches[cachedKey];

    if (cachedHeight) {
        return cachedHeight.floatValue;
    }
    
    if (cellHeightCaches == nil) {
        cellHeightCaches = [NSMutableDictionary dictionary];
    }
    
    CGFloat cellHeight = CGFLOAT_MIN;
    switch (data.type) {
        case TTHomeV4DataTypeCustom:
        case TTHomeV4DataTypeSuper:
        {
            if (indexPath.row == 0) {
                cellHeight = [self bigRoomCellHeightWithData:data];
            } else {
                cellHeight = [self smallRoomHeight];
            }
        }
            break;
        case TTHomeV4DataTypeHot:
        {
            if (indexPath.row == 0) {
                cellHeight = [self hotBigRoomHeightWithData:data];
            } else {
                cellHeight = [self smallRoomHeight];
            }
        }
            break;
        case TTHomeV4DataTypeBanner:
        {
            cellHeight = [self bannerCellHeightWithData:data];
        }
            break;
        default:
        {
            cellHeight = CGFLOAT_MIN;
        }
            break;
    }
    
    /// 加入缓存
    cellHeightCaches[cachedKey] = @(cellHeight);
    
    return cellHeight;
}

- (CGFloat)sectionHeaderHeightAtSection:(NSUInteger)section {
    
    TTHomeV4Data *data = [self dataAtSection:section];
    if (data == nil || data.data.count == 0) {
        return CGFLOAT_MIN;
    }
    
    CGFloat height = CGFLOAT_MIN;
    switch (data.type) {
        case TTHomeV4DataTypeBanner:
            height = CGFLOAT_MIN;
            break;
        case TTHomeV4DataTypeSuper:
        case TTHomeV4DataTypeHot:
        case TTHomeV4DataTypeCustom:
            height = 20;
            break;
        default:
            height = CGFLOAT_MIN;
            break;
    }
    
    return height;
}

- (CGFloat)sectionFooterHeightAtSection:(NSUInteger)section {
    
    TTHomeV4Data *data = [self dataAtSection:section];
    if (data == nil || data.data.count == 0) {
        return CGFLOAT_MIN;
    }
    
    CGFloat height = CGFLOAT_MIN;
    switch (data.type) {
        case TTHomeV4DataTypeBanner:
            height = 24;
            break;
        case TTHomeV4DataTypeHot:
            height = CGFLOAT_MIN;
            break;
        default: {
            NSArray *smallRooms = [TTHomeRecommendViewModel smallRoomsFromDatas:data.data bigRoomCount:data.maxNum];
            height = smallRooms.count > 0 ? 16 : 8;
        }
            break;
    }
    
    return height;
}

- (TTHomeRecommendSectionHeaderViewConfig *)headerConfigAtSection:(NSUInteger)section {
    
    TTHomeV4Data *data = [self dataAtSection:section];
    if (data == nil || data.data.count == 0) {
        return nil;
    }
    
    TTHomeRecommendSectionHeaderViewConfig *config = [[TTHomeRecommendSectionHeaderViewConfig alloc] init];
    config.title = data.title;
    
    return config;
}

#pragma mark - private method
#pragma mark Cell Height Calculate
- (CGFloat)bannerCellHeightWithData:(TTHomeV4Data *)data {
    if (data == nil) {
        return CGFLOAT_MIN;
    }
    
    BOOL isEmptyBanner = data.data.count == 0;
    if (isEmptyBanner) {
        return CGFLOAT_MIN;
    }
    
    CGFloat vertMargin = 8;//上下间距
    return vertMargin + (KScreenWidth - 15*2) * TTHomeRecommendBannerCellBannerAspectRatio;
}

/**
 其他的大房间 cell 高度（多行）
 */
- (CGFloat)bigRoomCellHeightWithData:(TTHomeV4Data *)data {
    if (data == nil || data.data.count == 0) {
        return CGFLOAT_MIN;
    }
    
    double lines = 0;
    if (data.data.count >= data.maxNum) {
        lines = ceil(data.maxNum/3.0);
    } else {
        lines = ceil(data.data.count/3.0);
    }
    
    CGFloat height = [self singleLineBigRoomHeight] * lines;
    CGFloat margin = TTHomeRecommendBigRoomTVCellTopMargin + TTHomeRecommendBigRoomTVCellBottomMargin;
    return height + margin;
}

/**
 热门的大房间 cell 高度（单行）
 */
- (CGFloat)hotBigRoomHeightWithData:(TTHomeV4Data *)data {
    if (data == nil || data.data.count == 0) {
        return CGFLOAT_MIN;
    }
    
    CGFloat height = [self singleLineBigRoomHeight];
    CGFloat margin = TTHomeRecommendBigRoomTVCellTopMargin + TTHomeRecommendBigRoomTVCellBottomMargin;
    return height + margin;
}

/// 一排的大房间高度，n排即 *n
- (CGFloat)singleLineBigRoomHeight {
    CGFloat width = (KScreenWidth - 15*2 - TTHomeRecommendBigRoomCVCellHoriInterval*2) / 3;
    CGFloat height = width + TTHomeRecommendBigRoomCVCellLabelHeight;
    return height;
}

/// 小房间高度
- (CGFloat)smallRoomHeight {
    return 76.0;
}

#pragma mark - Setter Getter
- (void)setDataSourceArray:(NSArray<TTHomeV4Data *> *)dataSourceArray {
    _dataSourceArray = dataSourceArray;
    
    ///重新模型赋值时清除缓存高度
    if (cellHeightCaches) {
        [cellHeightCaches removeAllObjects];
    }
}

@end
