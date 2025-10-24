//
//  TTHomeRecommendViewModel.h
//  TuTu
//
//  Created by lvjunhang on 2018/12/28.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTHomeRecommendSectionHeaderViewConfig;
@class TTHomeV4Data, TTHomeV4DetailData;

@interface TTHomeRecommendViewModel : NSObject

/**
 数据源 Array<TTHomeV4Data>
 */
@property (nonatomic, strong) NSArray<TTHomeV4Data *> *dataSourceArray;

/**
 更新热门推荐的数据源
 
 @param datas 数据源
 */
- (BOOL)updateHotRecommend:(NSArray<TTHomeV4DetailData *> *)datas;

/**
 获取分组数据源
 */
- (TTHomeV4Data *)dataAtSection:(NSInteger)section;

/**
 获取分组行数
 */
- (NSInteger)rowsAtSection:(NSInteger)section;

/**
 获取大房间列表
 
 @param datas 所有数据
 @param count 大房间的个数
 */
+ (NSArray<TTHomeV4DetailData *> *)bigRoomsFromDatas:(NSArray<TTHomeV4DetailData *> *)datas bigRoomCount:(NSUInteger)count;

/**
 获取小房间列表
 
 @param datas 所有数据
 */
+ (NSArray<TTHomeV4DetailData *> *)smallRoomsFromDatas:(NSArray<TTHomeV4DetailData *> *)datas bigRoomCount:(NSUInteger)count;

/**
 根据索引获取行高
 
 @param indexPath 索引
 @return 行高
 */
- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath;

/**
 根据索引获取分组头部高度
 
 @param section 索引
 @return 分组头部高度
 */
- (CGFloat)sectionHeaderHeightAtSection:(NSUInteger)section;

/**
 根据索引获取分组脚部高度
 
 @param section 类型
 @return 分组脚部高度
 */
- (CGFloat)sectionFooterHeightAtSection:(NSUInteger)section;

/**
 获取分组头部样式配置
 
 @param section 索引
 @return 分组头部样式配置
 */
- (TTHomeRecommendSectionHeaderViewConfig *)headerConfigAtSection:(NSUInteger)section;

@end

NS_ASSUME_NONNULL_END
