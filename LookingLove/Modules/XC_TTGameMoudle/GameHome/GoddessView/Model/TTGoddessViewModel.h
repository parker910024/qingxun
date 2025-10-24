//
//  TTGoddessViewModel.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeV5Data, BannerInfo;

@interface TTGoddessViewModel : NSObject

/**
 banner 数据源
 */
@property (nonatomic, strong) NSArray<BannerInfo *> *bannerArray;

/**
 更新用户列表
 
 @param datas 新增用户数据
 */
- (void)updateDataList:(NSArray<HomeV5Data *> *)datas;

/**
 重置清空用户列表
 */
- (void)resetDataList;

/**
 获取分组行数，user.count + banner
 */
- (NSInteger)rowsAtSection:(NSInteger)section;

/**
 判断索引是否为 banner
 */
- (BOOL)isBannerIndexPath:(NSIndexPath *)indexPath;

/**
 根据索引获取用户信息，注意对 banner 插入的处理
 */
- (HomeV5Data *)userDataForIndexPath:(NSIndexPath *)indexPath;

/**
 根据索引获取行高
 */
- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath;

/**
 根据索引获取分组头部高度
 */
- (CGFloat)sectionHeaderHeightAtSection:(NSUInteger)section;

/**
 根据索引获取分组脚部高度
 */
- (CGFloat)sectionFooterHeightAtSection:(NSUInteger)section;

@end

NS_ASSUME_NONNULL_END

