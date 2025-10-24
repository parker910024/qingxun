//
//  LLVoicePartyViewModel.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeV5CategoryRoom, BannerInfo;

@interface LLVoicePartyViewModel : NSObject

/**
 banner 数据源
 */
@property (nonatomic, strong) NSArray<BannerInfo *> *bannerArray;

/**
 更新房间列表
 
 @param rooms 新增房间
 */
- (void)updateRoomList:(NSArray<HomeV5CategoryRoom *> *)rooms;

/**
 重置清空房间列表
 */
- (void)resetRoomList;

/**
 获取分组行数，room.count + banner
 */
- (NSInteger)rowsAtSection:(NSInteger)section;

/**
 判断索引是否为 banner
 */
- (BOOL)isBannerIndexPath:(NSIndexPath *)indexPath;

/**
 根据索引获取用户信息，注意对 banner 插入的处理
 */
- (HomeV5CategoryRoom *)roomInfoForIndexPath:(NSIndexPath *)indexPath;

/**
 根据索引获取 cell 大小
 */
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
