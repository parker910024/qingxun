//
//  TTGoddessViewModel.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/3.
//

#import "TTGoddessViewModel.h"

#import "TTGoddessBannerCell.h"

#import "XCMacros.h"
#import "HomeV5Data.h"

///banner 默认索引，索引应不大于此值
static NSInteger kBannerDefaultIndex = 3;

///用户信息高度
static CGFloat kUserCellHeight = 84.0f;

@interface TTGoddessViewModel ()

/**
 用户数据源
 */
@property (nonatomic, strong) NSMutableArray<HomeV5Data *> *dataSourceArray;

@end

@implementation TTGoddessViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSourceArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public method
/**
 更新用户列表
 
 @param datas 新增用户数据
 */
- (void)updateDataList:(NSArray<HomeV5Data *> *)datas {
    if (!datas || datas.count == 0) {
        return;
    }
    
    [self.dataSourceArray addObjectsFromArray:datas];
}

/**
 重置清空用户列表
 */
- (void)resetDataList {
    [self.dataSourceArray removeAllObjects];
}

/**
 获取分组行数，user.count + banner
 */
- (NSInteger)rowsAtSection:(NSInteger)section {

    NSInteger rows = self.dataSourceArray.count;
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
    
    return [self bannerIndex] == indexPath.row;
}

/**
 根据索引获取用户信息，注意对 banner 插入的处理
 */
- (HomeV5Data *)userDataForIndexPath:(NSIndexPath *)indexPath {
    
    HomeV5Data *data = nil;
    
    BOOL noBanner = ![self isExistBanner];
    BOOL beforeBanner = [self bannerIndex] > indexPath.row;
    
    //map banner index
    if ([self bannerIndex] == indexPath.row) {
        return nil;
    }
    
    //no banner OR before banner
    if (noBanner || beforeBanner) {
        if (self.dataSourceArray.count > indexPath.row) {
            data = self.dataSourceArray[indexPath.row];
        }
        return data;
    }
    
    //after banner
    if (self.dataSourceArray.count > indexPath.row - 1) {
        data = self.dataSourceArray[indexPath.row - 1];
    }
    return data;
}

- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath {
    
    // return banner height
    if ([self isBannerIndexPath:indexPath]) {
        return [self bannerCellHeight];
    }

    // return user height
    return kUserCellHeight;
}

- (CGFloat)sectionHeaderHeightAtSection:(NSUInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)sectionFooterHeightAtSection:(NSUInteger)section {
    return 8;
}

#pragma mark - private method
/**
 获取 banner 高度，如果没有找到索引，高度为 CGFLOAT_MIN
 */
- (CGFloat)bannerCellHeight {
    
    if (!self.isExistBanner) {
        return CGFLOAT_MIN;
    }
    
    CGFloat vertMargin = 8 * 2;//上下留白间距
    CGFloat bannerHeight = (KScreenWidth - 15 * 2) * TTGoddessBannerCellBannerAspectRatio;
    return vertMargin + bannerHeight;
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
    
    // Pin at default index
    if (self.dataSourceArray.count >= kBannerDefaultIndex) {
        bannerIndex = kBannerDefaultIndex;
        return bannerIndex;
    }
    
    // Append after data source
    bannerIndex = self.dataSourceArray.count;
    return bannerIndex;
}

@end

