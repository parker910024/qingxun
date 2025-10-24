//
//  LLVoicePartyViewModel.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLVoicePartyViewModel.h"

#import "TTVoicePartyBannerCell.h"

#import "XCMacros.h"
#import "HomeV5CategoryRoom.h"

///banner 默认索引，索引应不大于此值
static NSInteger kBannerDefaultIndex = 4;

///房间列数
static NSInteger kRoomCellColumn = 2;

///房间cell除了封面图片的额外高度
static CGFloat kRoomCellAdditionalHeight = 70.0f;

///房间cell之间间隔
static CGFloat kRoomCellInterval = 15.0f;

@interface LLVoicePartyViewModel ()

/**
 房间数据源
 */
@property (nonatomic, strong) NSMutableArray<HomeV5CategoryRoom *> *dataSourceArray;

@end

@implementation LLVoicePartyViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSourceArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public method
/**
 更新房间列表
 
 @param rooms 新增房间
 */
- (void)updateRoomList:(NSArray<HomeV5CategoryRoom *> *)rooms {
    if (!rooms || rooms.count == 0) {
        return;
    }
    
    [self.dataSourceArray addObjectsFromArray:rooms];
}

/**
 重置清空房间列表
 */
- (void)resetRoomList {
    [self.dataSourceArray removeAllObjects];
}

/**
 获取分组个数，room.count + banner
 @discussion 现在只有一个 section，暂时不用
 */
- (NSInteger)rowsAtSection:(NSInteger)section {
    
    NSInteger rows = self.dataSourceArray.count;
    
    //如果房间数为单数，补充为双数
    if (rows % 2 == 1) {
        rows += 1;
    }
    
    //计入 banner
    if (self.isExistBanner) {
        rows += 1;
    }
    return rows;
}

/**
 判断 indexPath 是否为 banner
 */
- (BOOL)isBannerIndexPath:(NSIndexPath *)indexPath {
    if (![self isExistBanner]) {
        return NO;
    }
    
    return [self bannerIndex] == indexPath.item;
}

/**
 根据索引获取房间信息，注意对 banner 插入的处理
 */
- (HomeV5CategoryRoom *)roomInfoForIndexPath:(NSIndexPath *)indexPath {
    
    HomeV5CategoryRoom *data = nil;
    
    BOOL noBanner = ![self isExistBanner];
    BOOL beforeBanner = [self bannerIndex] > indexPath.item;
    
    //map banner index
    if ([self bannerIndex] == indexPath.item) {
        return nil;
    }
    
    //no banner OR before banner
    if (noBanner || beforeBanner) {
        if (self.dataSourceArray.count > indexPath.item) {
            data = self.dataSourceArray[indexPath.item];
        }
        return data;
    }
    
    //after banner
    if (self.dataSourceArray.count > indexPath.item - 1) {
        data = self.dataSourceArray[indexPath.item - 1];
    }
    return data;
}

/**
 根据索引获取 cell 大小
 */
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isBannerIndexPath:indexPath]) {
        return [self bannerCellSize];
    }
    
    return [self roomCellSize];
}

#pragma mark - private method
/**
 banner大小
 */
- (CGSize)bannerCellSize {
    
    if (!self.isExistBanner) {
        return CGSizeZero;
    }
    
    CGFloat bannerWidth = (KScreenWidth - 15 * 2);
    CGFloat bannerHeight = bannerWidth * TTVoicePartyBannerCellBannerAspectRatio;
    return CGSizeMake(bannerWidth, bannerHeight + TTVoicePartyBannerCellBottomMargin);
}

/**
 房间大小
 */
- (CGSize)roomCellSize {
    CGFloat cellWidth = (KScreenWidth - 20 * 2 - kRoomCellInterval * (kRoomCellColumn - 1)) / kRoomCellColumn;
    return CGSizeMake(cellWidth, cellWidth + kRoomCellAdditionalHeight);
}

/**
 是否存在 banner
 */
- (BOOL)isExistBanner {
    return [self bannerIndex] != NSNotFound;
}

/**
 获取 banner 的索引，如果没有找到，返回 NSNotFound
 */
- (NSInteger)bannerIndex {
    
    NSInteger bannerIndex = NSNotFound;
    
    // no banner data, return
    if (self.bannerArray == nil || self.bannerArray.count == 0) {
        return bannerIndex;
    }
    
    NSInteger count = [self.dataSourceArray count];
    
    // no data, put at index 0
    if (count == 0) {
        return 0;
    }
    
    //如果房间数为单数，补充为双数
    if (count % 2 == 1) {
        count += 1;
    }
    
    // Pin at default index
    if (self.dataSourceArray.count >= kBannerDefaultIndex) {
        bannerIndex = kBannerDefaultIndex;
        return bannerIndex;
    }
    
    // Append after data source
    bannerIndex = count;
    return bannerIndex;
}

@end
